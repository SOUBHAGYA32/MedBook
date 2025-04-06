//
//  HomeScreenViewController.swift
//  MedBook
//
//  Created by Soubhagya on 04/04/25.
//

import UIKit
import Kingfisher
import UIScrollView_InfiniteScroll
import NVActivityIndicatorView
import Toast_Swift

class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var homeHeaderLabel: UILabel!
    
    //Serach Bar
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBarImageView: UIImageView!
    @IBOutlet weak var searchBarTextField: UITextField!
    
    //Sort By
    @IBOutlet weak var sortByView: UIView!
    @IBOutlet weak var sortByTitleLabel: UILabel!
    @IBOutlet weak var sortByStackView: UIStackView!
    @IBOutlet weak var titleSortButton: UIButton!
    @IBOutlet weak var averageSortButton: UIButton!
    @IBOutlet weak var hitsSortByButton: UIButton!
    
    //Table View
    @IBOutlet weak var resultTableView: UITableView!
    
    //Properties
    private var selectedSortTag: Int = -1
    private var isSortByShow: Bool = false
    private let viewModel = HomeViewModel()
    private let authViewModel = AuthViewModel()
    private var searchTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = setNavigation()
        self.navigationItem.rightBarButtonItem = createProfileBarButton()
        self.initialSetup()
        self.setupDismissKeyboardGesture()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        ProgressIndicator.shared.setProgressIndicator(view: self.view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func createProfileBarButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        let profileImage = UIImage(systemName: "delete.left.fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(profileImage, for: .normal)
        button.tintColor = .red
        button.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    func setNavigation() -> UIBarButtonItem {
        let containerView = UIStackView()
        containerView.axis = .horizontal
        containerView.spacing = 6
        containerView.alignment = .center
        
        // Book
        let imageView = UIImageView(image: UIImage(systemName: "book"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "MedBook"
        titleLabel.font = .poppinsBold(ofSize: 22)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        containerView.addArrangedSubview(imageView)
        containerView.addArrangedSubview(titleLabel)
        
        return UIBarButtonItem(customView: containerView)
    }
    
    private func initialSetup() {
        self.homeHeaderLabel.text = "Which topic interests you today?"
        self.homeHeaderLabel.numberOfLines = 0
        self.homeHeaderLabel.font = .poppinsSemiBold(ofSize: 18)
        self.homeHeaderLabel.textColor = .black

        self.searchBarView.backgroundColor = UIColor(hex: "#F1F4FF")
        self.searchBarView.layer.cornerRadius = 5
        self.searchBarView.clipsToBounds = true

        self.searchBarImageView.tintColor = .black

        self.searchBarTextField.backgroundColor = .clear
        self.searchBarTextField.placeholder = "Search for books"
        self.searchBarTextField.tintColor = .blue
        self.searchBarTextField.font = .poppinsRegular(ofSize: 14)
        self.searchBarTextField.textColor = .black
        self.searchBarTextField.clearButtonMode = .whileEditing
        self.searchBarTextField.delegate = self
        
        self.sortByView.backgroundColor = .clear
        self.sortByTitleLabel.text = "Sort By :"
        self.sortByTitleLabel.textColor = .black
        self.sortByTitleLabel.font = .poppinsSemiBold(ofSize: 14)
        self.updateSortButtonStyles(selectedButton: nil)
        self.sortByView.isHidden = !isSortByShow
        
        //Table View
        self.resultTableView.delegate = self
        self.resultTableView.dataSource = self
        self.resultTableView.backgroundColor = .clear
        self.resultTableView.estimatedRowHeight = 44
        self.resultTableView.showsVerticalScrollIndicator = false
        self.resultTableView.showsHorizontalScrollIndicator = false
        self.resultTableView.tableFooterView?.isHidden = true
        self.resultTableView.tableFooterView = UIView()
        self.resultTableView.separatorColor = UIColor.clear
        let nib = UINib(nibName: "BookDetailsTableViewCell", bundle: nil)
        self.resultTableView.register(nib, forCellReuseIdentifier: "BookDetailsTableViewCell")
        if #available(iOS 15.0, *) {
          self.resultTableView.sectionHeaderTopPadding = 0
          self.resultTableView.sectionFooterHeight = 0
        }
    }
    
    @objc func profileButtonTapped() {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.authViewModel.logoutUser { success in
                if success {
                    self.view.makeToast("Logout successful.")
                    let landingScreenVc = LandingScreenViewController()
                    if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
                       let window = sceneDelegate.window {
                        window.rootViewController = UINavigationController(rootViewController: landingScreenVc)
                        window.makeKeyAndVisible()
                    }
                }
            }
        }))
        self.present(alert, animated: true)
    }
    
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        if selectedSortTag == sender.tag {
            selectedSortTag = -1
            updateSortButtonStyles(selectedButton: nil)
            viewModel.resetSorting()
        } else {
            selectedSortTag = sender.tag
            updateSortButtonStyles(selectedButton: sender)
            viewModel.sortBooks(by: sender.tag)
        }
        self.resultTableView.reloadData()
    }
    
    private func updateSortButtonStyles(selectedButton: UIButton?) {
        let buttons = [self.titleSortButton, self.averageSortButton, self.hitsSortByButton]
        for button in buttons {
            if button == selectedButton {
                button?.backgroundColor = UIColor.blue
                button?.setTitleColor(.white, for: .normal)
                button?.layer.cornerRadius = 8
                button?.layer.borderWidth = 0
            } else {
                button?.backgroundColor = UIColor.clear
                button?.setTitleColor(.black, for: .normal)
                button?.layer.cornerRadius = 8
                button?.layer.borderColor = UIColor.lightGray.cgColor
                button?.layer.borderWidth = 1
            }
        }
    }
    
    @objc func startSearch(){
        if let text = self.searchBarTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text.isEmpty {
            self.reloadTableData()
            return
        }
        
        if let searchText = self.searchBarTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !searchText.isEmpty {
            self.viewModel.resetAndFetchBooks()
            ProgressIndicator.shared.show()
            let indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            indicatorView.type = .circleStrokeSpin
            indicatorView.tintColor = .blue
            indicatorView.color = .blue
            indicatorView.startAnimating()
            self.resultTableView.infiniteScrollIndicatorView = indicatorView
            self.resultTableView.infiniteScrollIndicatorView?.backgroundColor = UIColor.clear
            self.resultTableView.infiniteScrollIndicatorMargin = 40
            self.resultTableView.infiniteScrollTriggerOffset = 500
            self.resultTableView.addInfiniteScroll { [weak self] tableView in
                guard let self = self else { return }
                self.viewModel.fetchBooks(query: self.searchBarTextField.text ?? "") { success in
                    DispatchQueue.main.async {
                        tableView.finishInfiniteScroll()
                        if success {
                            self.sortByView.isHidden = false
                            ProgressIndicator.shared.hide()
                            self.resultTableView.reloadData()
                        }
                    }
                }
            }
            self.resultTableView.beginInfiniteScroll(false)
        }
    }
    
    func reloadTableData(){
        self.resultTableView.reloadData()
        self.sortByView.isHidden = true
        self.viewModel.resetAndFetchBooks()
        self.resultTableView.removeInfiniteScroll()
    }
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsTableViewCell", for: indexPath) as? BookDetailsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        let bookData = self.viewModel.searchBooks[indexPath.row]
        // Load image using Kingfisher
        if let coverId = bookData.cover_i {
            let imageUrl = URL(string: "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg")
            cell.bookCoverImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
            cell.bookCoverImageView.contentMode = .scaleAspectFill
        } else {
            cell.bookCoverImageView.image = UIImage(named: "placeholder")
            cell.bookCoverImageView.contentMode = .scaleAspectFill
        }
        
        cell.bookTitleLabel.text = bookData.title ?? "No Title"
        //Rate
        if let rating = bookData.ratings_average {
            cell.bookRatingLabel.text = String(format: "⭐️ %.1f", Double(rating))
        } else {
            cell.bookRatingLabel.text = "N/A"
        }
        cell.bookReadingLabel.text = bookData.ratings_count != nil ? "\(bookData.ratings_count!) Reads" : "N/A"
        
        //Auther
        if let authors = bookData.author_name, !authors.isEmpty {
            if authors.count == 1 {
                cell.bookDescriptionLabel.text = authors.first
            } else {
                let first = authors[0]
                let second = authors[1]
                cell.bookDescriptionLabel.text = "Auther: \(first), \(second.prefix(2)).."
            }
        } else {
            cell.bookDescriptionLabel.text = "Unknown Author"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let book = viewModel.searchBooks[indexPath.row]
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUserEmail) ?? ""
        let isBookmarked = viewModel.isBookBookmarked(book, userEmail: userEmail)
        
        //If bookmarked already no action
        guard !isBookmarked else {
            return nil
        }
        
        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.viewModel.bookmark(book: book, userEmail: userEmail)
            self.view.makeToast("Book bookmarked successfully.")
            completionHandler(true)
        }
        
        bookmarkAction.backgroundColor = .white
        bookmarkAction.image = renderBookmarkButtonImage(isFilled: isBookmarked)
        return UISwipeActionsConfiguration(actions: [bookmarkAction])
    }
    
    func renderBookmarkButtonImage(isFilled: Bool) -> UIImage? {
        let image = UIImage(systemName: "bookmark")?
            .withTintColor(.textColor, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        return image
    }
}

extension HomeScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.clear
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), searchText.count >= 3 {
            
            // Invalidate previous timer
            if let timer = self.searchTimer {
                timer.invalidate()
                self.searchTimer = nil
            }
            
            self.viewModel.resetAndFetchBooks()
            self.searchTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.startSearch), userInfo: nil, repeats: false)
            
        } else {
            self.viewModel.resetAndFetchBooks()
            self.reloadTableData()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.backgroundColor = UIColor.clear
    }
}
