//
//  ViewController.swift
//  StackExchangeApı
//
//  Created by rasim rifat erken on 14.09.2022.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UIScrollViewDelegate   {
    
    @IBOutlet weak var tableView: UITableView!
    
    var page = 1
    
    let movieListModel = MoviesListViewModel()
    
    let detailListModel = DetailListViewModel()
    
    let questionViewModel = QuestionViewModel()
    
    let answerViewModel = AnswerViewModel()
    
    var questionData = [QuestionItemsData]()
//
    var answerData = [GetAnsweredItemsData]()
    
    var filtered = [QuestionItemsData]()
    
    var offlineFiltered = [Questions]()
    
    var offlineQuestion = [Questions]()
    
    var offlineAnswers = [Answers]()
    
    let status = Reach().connectionStatus()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupSearchController()

        switch status {
        case .unknown, .offline:
            movieListModel.a { dict in
                self.offlineQuestion.append(dict)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            detailListModel.a { dict in
                self.offlineAnswers.append(dict)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        case .online(.wwan), .online(.wiFi):

            saveQuestion {
                print("savedQuestions")
                CoreDataQuestion.sharedInstance.saveDataOf(questions: self.questionData)
            }
            saveAnswers {
                print("savedAnswers")
                CoreDataAnswer.sharedInstance.saveDataOf(answers: self.answerData)
            }
            
//            CoreDataQuestion.sharedInstance.saveDataOf(questions: self.questionData)
//            CoreDataAnswer.sharedInstance.saveDataOf(answers: self.answerData)
        }
    }
    
    func saveQuestion(completion:@escaping () -> Void) {
        questionViewModel.getALLData(page: page) { [weak self] (result) in
            switch result {
            case .success(let listOf):
                self?.questionData.append(contentsOf: listOf.items)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                completion()
            case .failure(let error):
                self?.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                print("Error processing json data: \(error)")
            }
        }
    }
    func saveAnswers(completion:@escaping () -> Void) {
        answerViewModel.getALLData(page: page) { [weak self] (result) in
            switch result {
            case .success(let listOf):
                self?.answerData = listOf.items
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                completion()
            case .failure(let error):
                self?.showAlertWith(title: "Could Not Connect!", message: "Please check your internet connection \n or try again later")
                print("Error processing json data: \(error)")
            }
        }
    }
    
    func notitication() {
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.networkStatusChanged(_:)), name: Notification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let status = userInfo["Status"] as! String
            print(status)
        }
    }
    
    func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Schools"
        searchController.searchBar.tintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true

    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filtered = (questionData.filter({( questions : QuestionItemsData) -> Bool in
            return questions.title!.lowercased().contains(searchText.lowercased())
        }))
        
        tableView.reloadData()
        
    }
    
    func filterContentForSearchTextOffline(_ searchText: String, scope: String = "All") {
        offlineFiltered = (offlineQuestion.filter({( questions : Questions) -> Bool in
            return questions.questionTitle!.lowercased().contains(searchText.lowercased())
            
        }))
        
        tableView.reloadData()
        
    }
    
    func updataSearch() {
        switch status{
            
        case .unknown, .offline:
            filterContentForSearchTextOffline(searchController.searchBar.text!)
        case .online(.wwan), .online(.wiFi):
            filterContentForSearchText(searchController.searchBar.text!)
        }
    }

    func createSpinnerFooter() -> UIView {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footer.center
        footer.addSubview(spinner)
        spinner.startAnimating()
        return footer
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - scrollView.frame.size.height) {
            
            switch status {
            case .unknown, .offline:
                print("")
            case .online(.wwan), .online(.wiFi):
                if isFiltering() {
                    print("FilteredScroll")
                } else {
                    self.tableView.tableFooterView = createSpinnerFooter()
                    page += 1
                    
                    saveQuestion {
                        print("scrollQuestionSaved")
                        CoreDataQuestion.sharedInstance.saveDataOf(questions: self.questionData)
                    }
                    
                    saveAnswers {
                        print("scrollAnswersSaved")
                        CoreDataAnswer.sharedInstance.saveDataOf(answers: self.answerData)
                    }
//                    CoreDataQuestion.sharedInstance.saveDataOf(questions: questionData)
//                    CoreDataAnswer.sharedInstance.saveDataOf(answers: answerData)
                    
                }
            }
        }
    }
}

extension MainViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch status {
        case .unknown, .offline:
            if isFiltering() {
                return offlineFiltered.count
            } else {
                return offlineQuestion.count
            }
        case .online(.wwan), .online(.wiFi):
            if isFiltering() {
                return filtered.count
            } else {
                return questionData.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionDetailCell", for: indexPath) as? QuestionsTableCell else {return UITableViewCell()}
        let questionsItems: QuestionItemsData?
        let objectCoreData:Questions?

        
        let url : String
        let date : String
        let reputation : String
        let name : String
        let title : String
        
        
        switch status {
        case .unknown, .offline:
            if isFiltering() {
                objectCoreData = offlineFiltered[indexPath.row]
            } else {
                objectCoreData = offlineQuestion[indexPath.row]
            }
            url = objectCoreData?.profileImage ?? ""
            date = objectCoreData?.date ?? ""
            name = objectCoreData?.name ?? ""
            title = objectCoreData?.questionTitle ?? ""
            reputation = objectCoreData?.reputation ?? ""
        case .online(.wwan), .online(.wiFi):
            if isFiltering() {
                questionsItems = filtered[indexPath.row]
            } else {
                questionsItems = questionData[indexPath.row]
            }
            url = questionsItems?.owner?.profileImage ?? ""
            guard let fakeDate = questionsItems?.creationDate else {return cell}
            date = String(fakeDate)
            name = questionsItems?.owner?.displayName ?? ""
            title = questionsItems?.title ?? ""
            guard let fakeReputation = questionsItems?.owner?.reputation else {return cell}
            reputation = String(fakeReputation)
        }
        
        cell.setUpReputation(reputation)
        cell.setAskedOnDate(date)
        cell.setUpOwnerName(title)
        cell.setUpQuestionTitle(name)
        cell.setupCellPhoto(withVehiclePhoto: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let board = UIStoryboard(name: "Main", bundle: nil)
        let detailsVC = board.instantiateViewController(withIdentifier: "AnswerSegue") as! DetailViewController
        
        

        let questionsItems: QuestionItemsData?
        var sendItems = [GetAnsweredItemsData]()
        var sendItemsOffline = [Answers]()
        var questionSendData = Questions()
        
        
        switch status {
        case .unknown, .offline:
            if isFiltering() {
                questionSendData = offlineFiltered[indexPath.row]
            } else {
                questionSendData = offlineQuestion[indexPath.row]
            }
    
            
            
            for i in offlineAnswers{
                if i.answerNo == questionSendData.questionID {
                    sendItemsOffline.append(i)
                }
                
            }
            
            detailsVC.detailOfflineData = sendItemsOffline
        case .online(.wwan), .online(.wiFi):
            if isFiltering() {
                questionsItems = filtered[indexPath.row]
            } else {
                questionsItems = questionData[indexPath.row]
            }
            
            for i in answerData {
                if i.questionID == questionsItems?.questionID {
                    sendItems.append(i)
                }
            }
            detailsVC.detailAnswerData = sendItems
        }

        detailsVC.modalPresentationStyle = .fullScreen

        present(detailsVC, animated: true)

    }
}

extension MainViewController: UISearchResultsUpdating {
    
    
    func updateSearchResults(for searchController: UISearchController) {
        updataSearch()
    }
}




