//
//  BookMarkViewController.swift
//  MedBook
//
//  Created by Soubhagya on 05/04/25.
//

import UIKit
import Kingfisher
import UIScrollView_InfiniteScroll
import NVActivityIndicatorView
import Toast_Swift
import CoreData

class BookMarkViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //Table View
    @IBOutlet weak var bookmarkTableView: UITableView!
    
    //Properties
    private var bookMarksBooks: [BookEntity] = [BookEntity]()
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundColor
        self.view.backgroundColor = .backgroundColor
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = setNavigation()
        self.initialSetup()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        ProgressIndicator.shared.setProgressIndicator(view: self.view)
        self.getBookMarkData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setNavigation() -> UIBarButtonItem {
        let containerView = UIStackView()
        containerView.axis = .horizontal
        containerView.spacing = 6
        containerView.alignment = .center
        
        // Book
        let imageView = UIImageView(image: UIImage(systemName: "bookmark.fill"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // Title
        let titleLabel = UILabel()
        titleLabel.text = "Bookmarks"
        titleLabel.font = .poppinsBold(ofSize: 22)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .left
        
        containerView.addArrangedSubview(imageView)
        containerView.addArrangedSubview(titleLabel)
        
        return UIBarButtonItem(customView: containerView)
    }
    
    private func initialSetup(){
        //Table View
        self.bookmarkTableView.delegate = self
        self.bookmarkTableView.dataSource = self
        self.bookmarkTableView.backgroundColor = .clear
        self.bookmarkTableView.estimatedRowHeight = 44
        self.bookmarkTableView.showsVerticalScrollIndicator = false
        self.bookmarkTableView.showsHorizontalScrollIndicator = false
        self.bookmarkTableView.tableFooterView?.isHidden = true
        self.bookmarkTableView.tableFooterView = UIView()
        self.bookmarkTableView.separatorColor = UIColor.clear
        let nib = UINib(nibName: "BookDetailsTableViewCell", bundle: nil)
        self.bookmarkTableView.register(nib, forCellReuseIdentifier: "BookDetailsTableViewCell")
        if #available(iOS 15.0, *) {
            self.bookmarkTableView.sectionHeaderTopPadding = 0
            self.bookmarkTableView.sectionFooterHeight = 0
        }
    }
    
    func getBookMarkData(){
        //Getting the Books from CORE DATA
        if let currentUserEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUserEmail) {
            let bookmarkedBooks = self.viewModel.getBookmarkedBooks(for: currentUserEmail)
            print("Bookmarked books count: \(bookmarkedBooks.count)")
            self.bookMarksBooks = bookmarkedBooks
            self.bookmarkTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bookMarksBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookDetailsTableViewCell", for: indexPath) as? BookDetailsTableViewCell else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        let bookData = self.bookMarksBooks[indexPath.row]
        cell.bookTitleLabel.text = bookData.title ?? "No Title"
        cell.bookRatingLabel.text = bookData.ratingsAverage > 0 ? String(format: "⭐️ %.1f", bookData.ratingsAverage) : "N/A"
        cell.bookReadingLabel.text = "\(bookData.ratingsCount) Reads"
        
        //Authers
        if let authors = bookData.authorName as? [String], !authors.isEmpty {
            if authors.count == 1 {
                cell.bookDescriptionLabel.text = authors.first
            } else {
                let first = authors[0]
                let second = authors[1]
                cell.bookDescriptionLabel.text = "Author: \(first), \(second.prefix(2)).."
            }
        } else {
            cell.bookDescriptionLabel.text = "Unknown Author"
        }
        
        // Cover Image
        if bookData.coverId > 0 {
            let imageUrl = URL(string: "https://covers.openlibrary.org/b/id/\(bookData.coverId)-M.jpg")
            cell.bookCoverImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"))
            cell.bookCoverImageView.contentMode = .scaleAspectFill
        } else {
            cell.bookCoverImageView.image = UIImage(named: "placeholder")
            cell.bookCoverImageView.contentMode = .scaleAspectFill
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bookEntity = self.bookMarksBooks[indexPath.row]
        let userEmail = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUserEmail) ?? ""
        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
            self.viewModel.removeBookmark(book: bookEntity, userEmail: userEmail)
            self.view.makeToast("Book removed from bookmarks successfully.")
            self.getBookMarkData()
            completionHandler(true)
        }
        
        bookmarkAction.backgroundColor = .white
        bookmarkAction.image = renderBookmarkButtonImage()
        return UISwipeActionsConfiguration(actions: [bookmarkAction])
    }
    
    func renderBookmarkButtonImage() -> UIImage? {
        let image = UIImage(systemName: "bookmark.fill")?
            .withTintColor(.textColor, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        return image
    }
}
