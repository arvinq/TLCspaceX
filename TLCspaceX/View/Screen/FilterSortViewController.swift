//
// Copyright © 2022 arvinq. All rights reserved.
//
	

import UIKit

class FilterSortViewController: UIViewController {
    
    // sort group
    lazy var sortLabel: HeaderLabel = {
        let label = HeaderLabel(fontSize: FontSize.header, text: Title.sort)
        return label
    }()
    
    lazy var sortStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var missionNameLabel: DetailLabel = {
        let label = DetailLabel(fontSize: FontSize.subHeader, fontColor: .tertiaryLabel)
        label.setImageAndText(usingImage: SFSymbol.alphabet!, andText: Title.missionName)
        return label
    }()
    
    lazy var launchDateLabel: DetailLabel = {
        let label = DetailLabel(fontSize: FontSize.subHeader, fontColor: .tertiaryLabel)
        label.setImageAndText(usingImage: SFSymbol.calendar!, andText: Title.launchDate)
        return label
    }()
        
    // filter group
    lazy var filterLabel: HeaderLabel = {
        let label = HeaderLabel(fontSize: FontSize.header, text: Title.filter)
        return label
    }()
    
    lazy var filterTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OptionTableViewCell.self, forCellReuseIdentifier: OptionTableViewCell.reuseId)
        tableView.tableFooterView = UIView(frame: .zero)
        return tableView
    }()
    
    lazy var overlayView: UIView = {
        let view = UIView(frame: view.bounds)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.label, for: .normal)
        button.setTitle(Title.filterButton, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = CGFloat(2.0)
        button.layer.cornerRadius = Space.cornerRadius
        button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var selectedFilterButton: UIButton = { return UIButton() }()
    
    lazy var startSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var midSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    lazy var endSeparatorView: TLCSeparatorView = { return TLCSeparatorView() }()
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: SFSymbol.close, style: .done, target: self, action: #selector(closePressed))
        return barButtonItem
    }()
    
    lazy var applyButton: TLCButton = {
        let button = TLCButton(title: Title.applyButton, backgroundColor: .systemGray)
        button.addTarget(self, action: #selector(applyPressed), for: .touchUpInside)
        return button
    }()
    
    var viewModelManager: ViewModelManager?
    
    var filterOptionsDatasource: [MissionStatus] = [.all, .success, .fail, .null]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupView()
        setupConstraints()
        setupGestureRecognizers()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = Title.sortAndFilter
        navigationItem.setLeftBarButton(closeBarButtonItem, animated: true)
        
        view.addSubview(sortLabel)
        view.addSubview(sortStackView)
        sortStackView.addArrangedSubview(missionNameLabel)
        sortStackView.addArrangedSubview(launchDateLabel)
        
        view.addSubview(filterLabel)
        view.addSubview(filterButton)
        
        view.addSubview(startSeparatorView)
        view.addSubview(midSeparatorView)
        view.addSubview(endSeparatorView)
        view.addSubview(applyButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //first separator view
            startSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            startSeparatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            startSeparatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            sortLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin),
            sortLabel.topAnchor.constraint(equalTo: startSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            sortStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            sortStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            sortStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sortStackView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: Space.adjacent),
            
            //mid separator view
            midSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            midSeparatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            midSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            midSeparatorView.topAnchor.constraint(equalTo: sortStackView.bottomAnchor, constant: Space.adjacent),
            
            //filter caption
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin),
            filterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterLabel.topAnchor.constraint(equalTo: midSeparatorView.bottomAnchor, constant: Space.adjacent),
            
            filterButton.topAnchor.constraint(equalTo: midSeparatorView.bottomAnchor, constant: Space.adjacent),
            filterButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            //end separator view
            endSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            endSeparatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            endSeparatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            endSeparatorView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: Space.adjacent),
            
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            applyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            applyButton.topAnchor.constraint(equalTo: endSeparatorView.bottomAnchor, constant: Space.adjacent * 2)
        ])
    }
    
    /**
     * Sets up the gesture recognizer for the sort labels. Each of the sorting labels correspond to a sort descriptor
     */
    private func setupGestureRecognizers() {
        let missionNameGesture = SorterTapGestureRecognizer(target: self, action: #selector(sorterLabelTapped(_:)))
        missionNameGesture.sortDescriptor = .missionName
        missionNameLabel.addGestureRecognizer(missionNameGesture)
        
        let launchDateGesture = SorterTapGestureRecognizer(target: self, action: #selector(sorterLabelTapped(_:)))
        launchDateGesture.sortDescriptor = .launchDate
        launchDateLabel.addGestureRecognizer(launchDateGesture)
        
        let hideFilterGesture = UITapGestureRecognizer(target: self, action: #selector(hideFilterTableView))
        overlayView.addGestureRecognizer(hideFilterGesture)
    }
    
    @objc
    private func sorterLabelTapped(_ sender: SorterTapGestureRecognizer) {
        // reset back all of the sorting label's text color
        [missionNameLabel, launchDateLabel].forEach {
            $0?.textColor = .tertiaryLabel
        }
        
        // after resetting back the colors, apply a different color on the selected sort label
        guard let selectedLabel = sender.view as? UILabel else { return }
        selectedLabel.textColor = .label
        
        viewModelManager?.sortDescriptor = sender.sortDescriptor ?? .launchDate
    }
    
    @objc
    private func closePressed() {
        dismiss(animated: true)
    }
    
    @objc
    private func filterButtonPressed() {
        showFilterTableView()
    }
    
    @objc
    private func applyPressed() {
        dismiss(animated: true) {
            NotificationCenter.default.post(.init(name: .TLCApplyFilterAndSort))
        }
    }
    
    private func showFilterTableView() {
        let buttonFrame = filterButton.frame
        
        // setup and reload
        filterTableView.frame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y + buttonFrame.height, width: buttonFrame.width, height: 0)
        self.view.addSubview(overlayView)
        self.view.addSubview(filterTableView)
        
        filterTableView.layer.cornerRadius = Space.cornerRadius
        filterTableView.reloadData()
        
        // animate
        UIView.animate(withDuration: Animation.duration) {
            self.filterTableView.frame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y + buttonFrame.height + 5, width: buttonFrame.width, height: CGFloat(self.filterOptionsDatasource.count * 50))
        }
    }
    
    @objc
    private func hideFilterTableView() {
        let buttonFrame = filterButton.frame
        self.overlayView.removeFromSuperview()
        
        UIView.animate(withDuration: Animation.duration) {
            self.filterTableView.frame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y + buttonFrame.height, width: buttonFrame.width, height: 0)
        }
    }

}

extension FilterSortViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptionsDatasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionTableViewCell.reuseId, for: indexPath) as! OptionTableViewCell
        cell.optionLabel.text = filterOptionsDatasource[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFilter = self.filterOptionsDatasource[indexPath.row]
        filterButton.setTitle(selectedFilter.rawValue, for: .normal)
        hideFilterTableView()
        viewModelManager?.setFilteredLaunchList(for: selectedFilter)
    }
}
