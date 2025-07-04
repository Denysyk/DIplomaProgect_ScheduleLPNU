//
//  TeacherExamScheduleViewController.swift
//  ScheduleLPNU
//
//  Created by Denys Brativnyk on 01.05.2025.
//


import UIKit

class TeacherExamScheduleViewController: UIViewController {
    
    // UI елементи
    private var teacherTextField: UITextField!
    private var downloadButton: UIButton!
    
    // Labels для тематизації
    private var teacherLabel: UILabel!
    
    // Додаємо прапорець для відстеження стану переходу
    private var isTransitioning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCustomTitleView()
        setupThemeObserver()
        applyTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTransitioning = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupThemeObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(themeDidChange),
            name: ThemeManager.themeChangedNotification,
            object: nil
        )
    }
    
    @objc private func themeDidChange() {
        applyTheme()
    }
    
    private func applyTheme() {
        let theme = ThemeManager.shared
        
        // Background
        view.backgroundColor = theme.backgroundColor
        
        // Navigation
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: theme.accentColor,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        navigationController?.navigationBar.tintColor = theme.accentColor
        
        // Update title view
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.textColor = theme.accentColor
        }
        
        // Labels
        teacherLabel?.textColor = theme.accentColor
        
        // Text field
        teacherTextField?.backgroundColor = theme.cardBackgroundColor
        teacherTextField?.textColor = theme.textColor
        teacherTextField?.layer.borderColor = theme.separatorColor.cgColor
        
        // Update placeholder
        if let placeholder = teacherTextField?.placeholder {
            teacherTextField?.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSAttributedString.Key.foregroundColor: theme.secondaryTextColor]
            )
        }
        
        // Update search icon
        if let leftView = teacherTextField?.leftView {
            for subview in leftView.subviews {
                if let imageView = subview as? UIImageView {
                    imageView.tintColor = theme.secondaryTextColor
                }
            }
        }
        
        // Download button
        downloadButton?.backgroundColor = theme.accentColor
    }
    
    private func setupUI() {
        createTeacherTextField()
        createDownloadButton()
    }
    
    private func createTeacherTextField() {
        teacherTextField = UITextField()
        teacherTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Стиль
        teacherTextField.layer.cornerRadius = 12
        teacherTextField.layer.borderWidth = 1
        teacherTextField.placeholder = "Введіть ім'я викладача"
        teacherTextField.font = UIFont.systemFont(ofSize: 17)
        
        // Іконка пошуку зліва
        let searchIcon = UIImageView(frame: CGRect(x: 12, y: 7, width: 20, height: 20))
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        searchIcon.contentMode = .scaleAspectFit
        
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 34))
        iconContainerView.addSubview(searchIcon)
        teacherTextField.leftView = iconContainerView
        teacherTextField.leftViewMode = .always
        
        // Правий padding
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 34))
        teacherTextField.rightView = rightPaddingView
        teacherTextField.rightViewMode = .always
        
        view.addSubview(teacherTextField)
    }
    
    private func createDownloadButton() {
        downloadButton = UIButton(type: .system)
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Стиль
        downloadButton.setTitleColor(.white, for: .normal)
        downloadButton.layer.cornerRadius = 12
        downloadButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        // Легка тінь
        downloadButton.layer.shadowColor = UIColor.black.cgColor
        downloadButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        downloadButton.layer.shadowOpacity = 0.1
        downloadButton.layer.shadowRadius = 4
        
        // Текст
        downloadButton.setTitle("Завантажити", for: .normal)
        
        // Дія
        downloadButton.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        
        view.addSubview(downloadButton)
    }
    
    private func setupConstraints() {
        // Лейбл "Викладач"
        teacherLabel = UILabel()
        teacherLabel.text = "Викладач"
        teacherLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        teacherLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(teacherLabel)
        
        NSLayoutConstraint.activate([
            // Лейбл викладача - висота 21
            teacherLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            teacherLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            teacherLabel.heightAnchor.constraint(equalToConstant: 21),
            
            // Текстове поле викладача - висота 34, відстань 8 від лейбла
            teacherTextField.topAnchor.constraint(equalTo: teacherLabel.bottomAnchor, constant: 8),
            teacherTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            teacherTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            teacherTextField.heightAnchor.constraint(equalToConstant: 34),
            
            // Кнопка завантаження - висота 50, відстань 20 від текстового поля
            downloadButton.topAnchor.constraint(equalTo: teacherTextField.bottomAnchor, constant: 20),
            downloadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            downloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            downloadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupCustomTitleView() {
        let title = "РОЗКЛАД ЕКЗАМЕНІВ ДЛЯ ВИКЛАДАЧІВ"
        let labelWidth: CGFloat = 200
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 50))
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.preferredMaxLayoutWidth = labelWidth
        titleLabel.sizeToFit()
        
        var frame = titleLabel.frame
        frame.size.width = labelWidth
        titleLabel.frame = frame
        
        self.navigationItem.titleView = titleLabel
    }
    
    // MARK: - Дії кнопок
    @objc private func downloadButtonTapped() {
        guard !isTransitioning else { return }
        
        // Анімація кнопки
        UIView.animate(withDuration: 0.1, animations: {
            self.downloadButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.downloadButton.transform = CGAffineTransform.identity
            } completion: { _ in
                self.validateAndNavigate()
            }
        }
    }
    
    private func validateAndNavigate() {
        guard !isTransitioning else { return }
        
        guard let teacherText = teacherTextField.text, !teacherText.isEmpty else {
            showAlert(title: "Помилка", message: "Введіть ПІБ викладача повністю")
            return
        }
        
        isTransitioning = true
        
        // Програмна навігація або segue
        navigateToResults()
    }
    
    private func navigateToResults() {
        // Якщо у вас є segue:
        // performSegue(withIdentifier: "showTeacherExamResult", sender: self)
        
        // Або програмна навігація:
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let resultVC = storyboard.instantiateViewController(withIdentifier: "ResultTeacherExamScheduleViewController") as? ResultTeacherExamScheduleViewController {
            resultVC.teacherName = teacherTextField.text ?? ""
            navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.view.tintColor = ThemeManager.shared.accentColor
        alert.addAction(UIAlertAction(title: "ОК", style: .default))
        present(alert, animated: true)
    }
}
