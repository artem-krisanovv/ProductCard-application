import UIKit

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private var isSortAscending = true
    private let viewModel = ViewModel()
    private var searchHistoryViewBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        historyTableView.dataSource = self
        historyTableView.delegate = self
        searchTextField.delegate = self
        setupUI()
        bindViewModel()
        addTargetToSortButton()
    }
    
    // MARK: - UI Elements
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .black
        textField.tintColor = .gray
        textField.backgroundColor = .systemGray5
        textField.layer.cornerRadius = 25
        textField.placeholder = "Search"
        
        let leftContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 50))
        let rightContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let iconImageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 30))
        
        iconImageView.image = UIImage(systemName: "magnifyingglass")
        iconImageView.contentMode = .scaleAspectFit
        leftContainer.addSubview(iconImageView)
        textField.leftView = leftContainer
        textField.rightView = rightContainer
        textField.rightViewMode = .always
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let sortButton = FilterSortButton(
        title: "Sort",
        iconName: "arrow.up.arrow.down",
        style: .sort
    )
    
    private let filterButton = FilterSortButton(
        title: "Filter",
        iconName: "line.3.horizontal.decrease",
        style: .filter(count: 2)
    )
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 172, height: 189)
        layout.minimumLineSpacing = 12
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identifier)
        return collectionView
    }()
    
    private let searchHistoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TableCell.self, forCellReuseIdentifier: TableCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
}

// MARK: - Setup UI

extension ViewController {
    private func setupUI() {
        view.backgroundColor = .white
        [searchTextField, sortButton, filterButton, collectionView, searchHistoryView, historyTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        searchHistoryView.isHidden = true
        historyTableView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupConstraints()
        
    }
    
    private func setupConstraints() {
        searchHistoryViewBottomConstraint = searchHistoryView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        let maxRows = min(viewModel.searchHistory.count, 5)
        let rowHeight: CGFloat = 80
        let tableHeight = CGFloat(maxRows) * rowHeight
        
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            sortButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            sortButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sortButton.heightAnchor.constraint(equalToConstant: 36),
            sortButton.widthAnchor.constraint(equalToConstant: 100),
            
            filterButton.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            filterButton.heightAnchor.constraint(equalToConstant: 36),
            filterButton.widthAnchor.constraint(equalToConstant: 100),
            
            collectionView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 32),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchHistoryView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            searchHistoryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchHistoryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchHistoryViewBottomConstraint,
            
            historyTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            historyTableView.leadingAnchor.constraint(equalTo: searchHistoryView.leadingAnchor, constant: 16),
            historyTableView.trailingAnchor.constraint(equalTo: searchHistoryView.trailingAnchor, constant: -16),
            historyTableView.heightAnchor.constraint(equalToConstant: tableHeight)
        ])
        
    }
}

// MARK: - Collection Delegate

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identifier, for: indexPath) as! CollectionCell
        cell.configure(with: viewModel.data[indexPath.item])
        return cell
    }
    
}

// MARK: - Table Delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCell.identifier, for: indexPath) as! TableCell
        cell.configure(with: viewModel.searchHistory[indexPath.row])
        cell.onDelete = { [weak self] in
            self?.deleteHistoryItem(at: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Searches"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedQuery = viewModel.searchHistory[indexPath.row]
        searchTextField.text = selectedQuery
        
        viewModel.filterProducts(with: selectedQuery, forceFilter: true)
        
        hideSearchHistory()
        searchTextField.resignFirstResponder()
    }
    private func deleteHistoryItem(at indexPath: IndexPath) {
        guard indexPath.row < viewModel.searchHistory.count else { return }
        
        viewModel.searchHistory.remove(at: indexPath.row)
        
        if viewModel.searchHistory.isEmpty {
            hideSearchHistory()
        } else {
            historyTableView.reloadData()
        }
    }
}

// MARK: - TextField Delegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        showSearchHistory()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        
        if newText.count >= 3 {
            viewModel.filterProducts(with: newText)
        } else if newText.isEmpty {
            viewModel.showAllProducts()
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchText = textField.text, !searchText.isEmpty else { return true }
        
        viewModel.addToSearchHistory(searchText)
        viewModel.filterProducts(with: searchText)
        
        hideSearchHistory()
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        hideSearchHistory()
    }
}

// MARK: - Gesture Delegate

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: historyTableView) == true {
            return false
        }
        return true
    }
}


// MARK: - Sort Method

extension ViewController {
    @objc private func sortButtonTapped(_ sender: UIButton) {
        let order: ViewModel.Sort = isSortAscending ? .priceAsc : .priceDesc
        viewModel.sort(by: order)
        isSortAscending.toggle()
    }
    
    func addTargetToSortButton() {
        sortButton.addTarget(self, action: #selector(sortButtonTapped(_:)), for: .touchUpInside)
    }
}

// MARK: - KeyBoard and TextField Methods

extension ViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        let keyboardHeight = keyboardFrame.height
        
        searchHistoryViewBottomConstraint.constant = -keyboardHeight
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        searchHistoryViewBottomConstraint.constant = 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        searchTextField.resignFirstResponder()
        hideSearchHistory()
    }
    
    private func showSearchHistory() {
        searchHistoryView.isHidden = false
        historyTableView.isHidden = false
        historyTableView.reloadData()
    }
    
    private func hideSearchHistory() {
        searchHistoryView.isHidden = true
        historyTableView.isHidden = true
    }
}

// MARK: - Bind ViewModel

extension ViewController {
    private func bindViewModel() {
        viewModel.onUpdate = {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.collectionView.reloadData()
            }
        }
    }
}

