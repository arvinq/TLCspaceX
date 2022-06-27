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
    
    lazy var missionNameLabel: SubHeaderLabel = {
        let label = SubHeaderLabel(fontSize: FontSize.subHeader, fontColor: .secondaryLabel)
        label.setImageAndText(usingImage: SFSymbol.alphabet!, andText: Title.missionName)
        return label
    }()
    
    lazy var launchDateLabel: SubHeaderLabel = {
        let label = SubHeaderLabel(fontSize: FontSize.subHeader, fontColor: .secondaryLabel)
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
    
    lazy var filterButton: TLCButton = {
        let button = TLCButton(title: Title.filterButton, backgroundColor: .systemGray)
        button.addTarget(self, action: #selector(filterButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var selectedFilterButton: UIButton = { return UIButton() }()
    
    lazy var separatorView: TLCSeparatorView = {
        let separatorView = TLCSeparatorView()
        return separatorView
    }()
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(image: SFSymbol.close, style: .done, target: self, action: #selector(closePressed))
        return barButtonItem
    }()
    
    lazy var applyButton: TLCButton = {
        let button = TLCButton(title: Title.applyButton, backgroundColor: .systemGray)
        button.addTarget(self, action: #selector(applyPressed), for: .touchUpInside)
        return button
    }()
    
    var filterOptionsDatasource: [String] = ["All", "Success", "Failure"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        setupView()
        setupConstraints()
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
        
        view.addSubview(separatorView)
        view.addSubview(applyButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            sortLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin),
            sortLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Space.adjacent),
            
            sortStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            sortStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            sortStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sortStackView.topAnchor.constraint(equalTo: sortLabel.bottomAnchor, constant: Space.adjacent),
            
            //first separator view
            separatorView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Size.separatorHeight),
            separatorView.topAnchor.constraint(equalTo: sortStackView.bottomAnchor, constant: Space.adjacent),
            
            //filter caption
            filterLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Space.margin),
            filterLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: Space.adjacent),
            
            filterButton.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: Space.adjacent),
            filterButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            applyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            applyButton.heightAnchor.constraint(equalToConstant: Size.buttonHeight),
            applyButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            applyButton.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: Space.adjacent * 5)
        ])
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
        print("apply")
    }
    
    private func showFilterTableView() {
        let buttonFrame = filterButton.frame
        
        // setup and reload
        filterTableView.frame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y + buttonFrame.height, width: buttonFrame.width, height: 0)
        self.view.addSubview(filterTableView)
        filterTableView.layer.cornerRadius = Space.cornerRadius
        filterTableView.reloadData()
        
        // animate
        UIView.animate(withDuration: Animation.duration) {
            self.filterTableView.frame = CGRect(x: buttonFrame.origin.x, y: buttonFrame.origin.y + buttonFrame.height + 5, width: buttonFrame.width, height: CGFloat(self.filterOptionsDatasource.count * 50))
        }
    }
    
    private func hideFilterTableView() {
        let buttonFrame = filterButton.frame
        
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
        cell.optionLabel.text = filterOptionsDatasource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterButton.setTitle(self.filterOptionsDatasource[indexPath.row], for: .normal)
        hideFilterTableView()
    }
}
