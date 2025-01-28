import UIKit

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let topInset: CGFloat
    let bottomInset: CGFloat
    let cellSpacing: CGFloat
    let lineSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, topInset: CGFloat, bottomInset: CGFloat , cellSpacing: CGFloat, lineSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.cellSpacing = cellSpacing
        self.lineSpacing = lineSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}

enum Weekday: Int, CaseIterable, Codable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var fullname: String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        return calendar.weekdaySymbols[self.rawValue].capitalized
    }
    
    var shortname: String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru_RU")
        return calendar.shortWeekdaySymbols[self.rawValue].capitalized
    }
}

final class TrackersViewController: UIViewController {
    
    private let sectionParams = GeometricParams(cellCount: 2,
                                                leftInset: 16,
                                                rightInset: 16,
                                                topInset: 12,
                                                bottomInset: 16,
                                                cellSpacing: 9,
                                                lineSpacing: 0
    )
    
    private var trackerCategoryStore: TrackerCategoryStore?
    private var trackerRecordStore: TrackerRecordStore?
    
    private var completedTrackers: [TrackerRecord] = []
    
    private var categories: [TrackerCategory] = []
    private var filteredCategories: [TrackerCategory] = []
    private var searchFilteredCategories: [TrackerCategory] = []
    private var categoriesToPresent: [TrackerCategory] {
        if searchController.searchBar.text?.isEmpty == true {
            return filteredCategories
        } else {
            return searchFilteredCategories
        }
    }
    
    private var currentDate = Date()
    private lazy var placeHolderView = UIView()
    private lazy var placeHolderImageView = UIImageView()
    private lazy var placeHolderLabel = UILabel()
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private lazy var datePicker = UIDatePicker()
    private lazy var trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var calendar = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .trackerWhite
        calendar.firstWeekday = 2
        calendar.locale = Locale(identifier: "ru_RU")
        setupNavigationItemBackButton()
        setupNavigationItem()
        setupPlaceHolderView()
        setupTrackersCollectionView()
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            trackerCategoryStore = TrackerCategoryStore(context: context)
            trackerRecordStore = TrackerRecordStore(context: context)
        }
        
        completedTrackers = trackerRecordStore?.completedTrackers ?? []
        categories = trackerCategoryStore?.categories ?? []
        trackerCategoryStore?.delegate = self
        
        updateFilters(date: currentDate, searchText: searchController.searchBar.text ?? "")
        updatePlaceHolderViewVisibility()
    }
    
    
    private func setupNavigationItem() {
        navigationItem.title = NSLocalizedString("trackers", comment: "")
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.modalPresentationStyle = .formSheet
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = NSLocalizedString("placeholder.searchbar", comment: "")
        searchController.searchBar.setValue(NSLocalizedString("cancel", comment: ""), forKey: "cancelButtonText")
        searchController.searchBar.searchTextField.clearButtonMode = .never
        searchController.searchBar.delegate = self
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.widthAnchor.constraint(equalToConstant: 97).isActive = true
    }
    
    
    private func filterCategorybyDate(categories: [TrackerCategory], by date: Date) -> [TrackerCategory] {
        let weekday = calendar.component(.weekday, from: date) - 1
        
        let filteredCategories = categories
            .filter { category in
                category.trackers.contains { tracker in
                    tracker.schedule.contains(where: {$0.rawValue == weekday}) || tracker.schedule.isEmpty
                }
            }
        
        let filteredTrackersinCategories = filteredCategories.map { category in
            let trackers = category.trackers.filter { tracker in
                tracker.schedule.contains(where: {$0.rawValue == weekday})
                || isNonregularTrackerNotComplete(tracker)
                || isNonregularTrackerComplete(tracker, at: date)
            }.sorted { tracker1, tracker2 in
                tracker1.title < tracker2.title
            }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        let resultCategories = filteredTrackersinCategories.filter({$0.trackers.isEmpty == false})
        
        return resultCategories
    }
    
    private func filterCategorybyTitle(categories: [TrackerCategory], by substring: String) -> [TrackerCategory] {
        let filteredCategories = categories
            .filter { category in
                category.trackers.contains { tracker in
                    tracker.title.lowercased().contains(substring.lowercased())
                }
            }
        
        let filteredTrackersinCategories = filteredCategories.map { category in
            let trackers = category.trackers.filter { tracker in
                tracker.title.lowercased().contains(substring.lowercased())
            }.sorted { tracker1, tracker2 in
                tracker1.title < tracker2.title
            }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
        
        let resultCategories = filteredTrackersinCategories.filter({$0.trackers.isEmpty == false})
        
        return resultCategories
    }
    
    private func isNonregularTrackerComplete(_ tracker: Tracker,at date: Date) -> Bool {
        return tracker.schedule.isEmpty && completedTrackers.contains(where: {$0.id == tracker.id && calendar.isDate($0.date, inSameDayAs: date)})
    }
    
    private func isNonregularTrackerNotComplete(_ tracker: Tracker) -> Bool {
        return tracker.schedule.isEmpty && !completedTrackers.contains(where: {$0.id == tracker.id})
    }
    
    private func updatePlaceHolderViewVisibility() {
        trackersCollectionView.isHidden = categoriesToPresent.isEmpty
        placeHolderView.isHidden = !categoriesToPresent.isEmpty
    }
    
    private func updateFilters(date: Date, searchText: String) {
        filteredCategories = filterCategorybyDate(categories: categories, by: date)
        searchFilteredCategories = filterCategorybyTitle(categories: filteredCategories, by: searchText)
    }
    
    private func setupPlaceHolderView() {
        let placeHolderImage = UIImage(resource: .placeHolderLogo)
        placeHolderImageView.image = placeHolderImage
        
        placeHolderLabel.text = NSLocalizedString("placeholder.noTrackers", comment: "")
        placeHolderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeHolderLabel.textAlignment = .center
        
        placeHolderView.isHidden = false
        
        view.addSubview(placeHolderView)
        placeHolderView.addSubview(placeHolderImageView)
        placeHolderView.addSubview(placeHolderLabel)
        
        placeHolderImageView.translatesAutoresizingMaskIntoConstraints = false
        placeHolderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeHolderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeHolderView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeHolderView.topAnchor.constraint(equalTo: placeHolderImageView.topAnchor),
            placeHolderView.bottomAnchor.constraint(equalTo: placeHolderLabel.bottomAnchor),
            placeHolderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            placeHolderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            placeHolderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeHolderImageView.centerXAnchor.constraint(equalTo: placeHolderView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeHolderLabel.topAnchor.constraint(equalTo: placeHolderImageView.bottomAnchor, constant: 8),
            placeHolderLabel.leadingAnchor.constraint(equalTo: placeHolderView.leadingAnchor),
            placeHolderLabel.trailingAnchor.constraint(equalTo: placeHolderView.trailingAnchor)
        ])
    }
    
    private func setupNavigationItemBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(resource: .plus),
                                         style: .plain,
                                         target: self,
                                         action: #selector(didTapAddTrackerButton))
        backButton.tintColor = UIColor(resource: .trackerBlack)
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func setupTrackersCollectionView() {
        trackersCollectionView.register(TrackersCollectionViewCell.self, forCellWithReuseIdentifier: TrackersCollectionViewCell.identifier)
        trackersCollectionView.register(TrackersCollectionSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TrackersCollectionSupplementaryView.identifier)
        
        trackersCollectionView.isHidden = true
        
        trackersCollectionView.dataSource = self
        trackersCollectionView.delegate = self
        
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    @objc
    private func didTapAddTrackerButton() {
        let trackerTypeSelectionViewController = TrackerTypeSelectionViewController()
        trackerTypeSelectionViewController.delegate = self
        let addEventNavigationontroller = UINavigationController(rootViewController: trackerTypeSelectionViewController)
        navigationController?.present(addEventNavigationontroller, animated: true)
        addEventNavigationontroller.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        currentDate = selectedDate
        
        updateFilters(date: currentDate, searchText: searchController.searchBar.text ?? "")
        trackersCollectionView.reloadData()
        updatePlaceHolderViewVisibility()
        
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        searchFilteredCategories = filterCategorybyTitle(categories: filteredCategories, by: text)
        trackersCollectionView.reloadData()
        updatePlaceHolderViewVisibility()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesToPresent[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackersCollectionViewCell.identifier, for: indexPath) as? TrackersCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.tracker = categoriesToPresent[indexPath.section].trackers[indexPath.row]
        cell.isChecked = completedTrackers.contains(where: {$0.id == cell.tracker?.id && calendar.isDate($0.date, inSameDayAs: currentDate)})
        cell.checkCounter = completedTrackers.count(where: {$0.id == cell.tracker?.id})
        cell.date = currentDate
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = TrackersCollectionSupplementaryView.identifier
        default:
            id = ""
        }
        
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? TrackersCollectionSupplementaryView
        else {
            return UICollectionReusableView()
        }
        
        view.categoryTitle = categoriesToPresent[indexPath.section].title
        return view
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categoriesToPresent.count
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionParams.paddingWidth
        let cellWidth =  availableWidth / CGFloat(sectionParams.cellCount)
        
        return CGSize(width: cellWidth,
                      height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionParams.topInset, left: sectionParams.leftInset, bottom: sectionParams.bottomInset, right: sectionParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionParams.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }
}

extension TrackersViewController: TrackerTypeSelectionViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ category: String) {
        if categories.map({$0.title}).contains(category) == false {
            let newCategory = TrackerCategory(title: category, trackers: [tracker])
            categories.append(newCategory)
            try? trackerCategoryStore?.addNewTrackerCategory(newCategory)
        }
        
        else if let index = categories.firstIndex(where: {$0.title == category}) {
            var trackers: [Tracker] = categories[index].trackers
            trackers.append(tracker)
            let newCategory = TrackerCategory(title: categories[index].title, trackers: trackers)
            categories[index] = newCategory
            try? trackerCategoryStore?.updateExistCategory(trackerCategoryTitle: category, tracker: tracker)
        }
    }
}

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func createTrackerRecord(_ id: UUID, _ trackerDate: Date) {
        if completedTrackers.contains(where: {$0.id == id && calendar.isDate($0.date, inSameDayAs: trackerDate)}) {
            completedTrackers.removeAll(where: {$0.id == id && calendar.isDate($0.date, inSameDayAs: trackerDate)})
            try? trackerRecordStore?.removeTrackerRecord(TrackerRecord(id: id, date: trackerDate))
        } else {
            completedTrackers.append(TrackerRecord(id: id, date: trackerDate))
            try? trackerRecordStore?.addNewTrackerRecord(TrackerRecord(id: id, date: trackerDate))
            
        }
        updateFilters(date: currentDate, searchText: searchController.searchBar.text ?? "")
        trackersCollectionView.reloadData()
        updatePlaceHolderViewVisibility()
    }
}

extension TrackersViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func storeDidUpdate(_ store: TrackerCategoryStore) {
        categories = store.categories
        updateFilters(date: currentDate, searchText: searchController.searchBar.text ?? "")
        updatePlaceHolderViewVisibility()
        trackersCollectionView.reloadData()
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
          guard let cell = collectionView.cellForItem(at: indexPath) as? TrackersCollectionViewCell else {
              return nil
          }
          
          let topContainerFrame = cell.convert(cell.cardView.frame, to: collectionView)
          guard topContainerFrame.contains(point) else {
              return nil
          }
          
          return UIContextMenuConfiguration(
              identifier: "\(indexPath.section)-\(indexPath.item)" as NSString,
              previewProvider: nil
          ) { _ in
              let tracker = self.filteredCategories[indexPath.section].trackers[indexPath.item]
              return self.makeContextMenu(for: tracker)
          }
      }
    
    private func makeContextMenu(for tracker: Tracker) -> UIMenu {
        let pinAction = UIAction(
            title: tracker.isPinned ? "Открепить" : "Закрепить"
        ) { _ in
            self.togglePin(for: tracker)
        }
        let editAction = UIAction(
            title: "Редактировать"
        ) { _ in
            self.editTracker(tracker)
        }
        
        let deleteAction = UIAction(
            title: "Удалить",
            attributes: .destructive
        ) { _ in
            self.deleteTracker(tracker)
        }
        
        return UIMenu(title: "", children: [pinAction, editAction, deleteAction])
    }
    
    private func togglePin(for tracker: Tracker) {
        
    }
    
    private func editTracker(_ tracker: Tracker) {

    }
    
    private func deleteTracker(_ tracker: Tracker) {

    }
}
