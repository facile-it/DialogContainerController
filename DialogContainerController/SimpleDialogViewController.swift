import UIKit

public final class SimpleDialogViewController: UIViewController {
    
    private let setup: Setup
    private let geometry: Geometry
    private let style: Style
    private let onAction: (Action) -> ()
    public init(setup: Setup, geometry: Geometry, style: Style, onAction: @escaping (Action) -> ()) {
        self.setup = setup
        self.geometry = geometry
        self.style = style
        self.onAction = onAction
        super.init(nibName: "SimpleDialogViewController", bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = style.backgroundColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = geometry.cornersRadius
        view.widthAnchor.constraint(equalToConstant: geometry.fixedWidth).isActive = true
        view.setContentHuggingPriority(.required, for: .vertical)
    }
    
    @IBOutlet public weak var topImageView: UIImageView! {
        didSet {
            topImageView.image = setup.image
            topImageView.isVisible = setup.isImageVisible
        }
    }
    
    @IBOutlet public weak var topImageViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            topImageViewHeightConstraint.constant = geometry.imageHeight
            topImageViewHeightConstraint.isActive = setup.isImageVisible
        }
    }
    
    @IBOutlet public weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = setup.title
            titleLabel.font = style.titleFont
            titleLabel.textColor = style.titleColor
        }
    }
    
    @IBOutlet public weak var messageLabel: UILabel! {
        didSet {
            messageLabel.text = setup.message
            messageLabel.font = style.messageFont
            messageLabel.textColor = style.messageColor
        }
    }
    
    @IBOutlet public weak var messageLabelContainer: UIView! {
        didSet {
            messageLabelContainer.isVisible = setup.isMessageLabelVisible
        }
    }
    
    @IBOutlet public var messageLabelConstraints: [NSLayoutConstraint]! {
        didSet {
            messageLabelConstraints.forEach {
                $0.isActive = setup.isMessageLabelVisible
            }
        }
    }
    
    @IBOutlet public weak var buttonsContainerView: UIView! {
        didSet {
            buttonsContainerView.backgroundColor = style.buttonsContainerColor
            buttonsContainerView.isVisible = setup.buttonsConfiguration.areButtonsVisible
        }
    }
    
    @IBOutlet public weak var buttonsStackView: UIStackView! {
        didSet {
            buttonsStackView.distribution = .fillEqually
            buttonsStackView.alignment = .fill
            buttonsStackView.spacing = 1
        }
    }
    
    @IBOutlet public weak var buttonsContainerViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            buttonsContainerViewHeightConstraint.constant = geometry.buttonsHeight
        }
    }

    @IBOutlet public var buttonsStackViewConstraints: [NSLayoutConstraint]! {
        didSet {
            buttonsStackViewConstraints.forEach {
                $0.isActive = setup.buttonsConfiguration.areButtonsVisible
            }
        }
    }
    
    @IBOutlet public weak var cancelButton: UIButton! {
        didSet {
            cancelButton.adjustsImageWhenHighlighted = false
            
            cancelButton.setAttributedTitle(
                setup.buttonsConfiguration.cancelButtonTitle.map { title in
                    NSAttributedString(
                        string: title,
                        attributes: [
                            .font: style.cancelButtonFont,
                            .foregroundColor: style.cancelButtonTextColor
                        ]
                    )
                },
                for: .normal)
            
            cancelButton.setBackgroundImage(.solidColor(style.cancelButtonBackgroundColor), for: .normal)
            
            cancelButton.isVisible = setup.buttonsConfiguration.isCancelButtonVisible
        }
    }
    
    @IBOutlet public weak var confirmButton: UIButton! {
        didSet {
            confirmButton.adjustsImageWhenHighlighted = false

            confirmButton.setAttributedTitle(
                setup.buttonsConfiguration.confirmButtonTitle.map { title in
                    NSAttributedString(
                        string: title,
                        attributes: [
                            .font: style.confirmButtonFont,
                            .foregroundColor: style.confirmButtonTextColor
                        ]
                    )
                },
                for: .normal)

            confirmButton.setBackgroundImage(.solidColor(style.confirmButtonBackgroundColor), for: .normal)
            
            confirmButton.isVisible = setup.buttonsConfiguration.isConfirmButtonVisible
        }
    }
    
    @IBAction public func didTapCancel(_ sender: UIButton) {
        onAction(.cancel)
    }
    
    @IBAction public func didTapConfirm(_ sender: UIButton) {
        onAction(.confirm)
    }
    
    public enum Action {
        case cancel
        case confirm
    }

    public struct Setup {
        public let title: String
        public let message: String?
        public let image: UIImage?
        public let buttonsConfiguration: ButtonsConfiguration
        
        public init(
            title: String,
            message: String?,
            image: UIImage?,
            buttonsConfiguration: ButtonsConfiguration)
        {
            self.title = title
            self.message = message
            self.image = image
            self.buttonsConfiguration = buttonsConfiguration
        }
    }
    
    public enum ButtonsConfiguration {
        case noButtons
        case confirm(String)
        case cancelAndConfirm(String, String)
    }
    
    public struct Geometry {
        public var fixedWidth: CGFloat
        public var cornersRadius: CGFloat
        public var imageHeight: CGFloat
        public var buttonsHeight: CGFloat
        
        public init(
            fixedWidth: CGFloat,
            cornersRadius: CGFloat,
            imageHeight: CGFloat,
            buttonsHeight: CGFloat)
        {
            self.fixedWidth = fixedWidth
            self.cornersRadius = cornersRadius
            self.imageHeight = imageHeight
            self.buttonsHeight = buttonsHeight
        }
        
        public static let `default` = Geometry(
            fixedWidth: 270,
            cornersRadius: 10,
            imageHeight: 132,
            buttonsHeight: 44)
    }
    
    public struct Style {
        public var backgroundColor: UIColor
        public var titleFont: UIFont
        public var titleColor: UIColor
        public var messageFont: UIFont
        public var messageColor: UIColor
        public var buttonsContainerColor: UIColor
        public var cancelButtonFont: UIFont
        public var cancelButtonTextColor: UIColor
        public var cancelButtonBackgroundColor: UIColor
        public var confirmButtonFont: UIFont
        public var confirmButtonTextColor: UIColor
        public var confirmButtonBackgroundColor: UIColor

        public init(
            backgroundColor: UIColor,
            titleFont: UIFont,
            titleColor: UIColor,
            messageFont: UIFont,
            messageColor: UIColor,
            buttonsContainerColor: UIColor,
            cancelButtonFont: UIFont,
            cancelButtonTextColor: UIColor,
            cancelButtonBackgroundColor: UIColor,
            confirmButtonFont: UIFont,
            confirmButtonTextColor: UIColor,
            confirmButtonBackgroundColor: UIColor)
        {
            self.backgroundColor = backgroundColor
            self.titleFont = titleFont
            self.titleColor = titleColor
            self.messageFont = messageFont
            self.messageColor = messageColor
            self.buttonsContainerColor = buttonsContainerColor
            self.cancelButtonFont = cancelButtonFont
            self.cancelButtonTextColor = cancelButtonTextColor
            self.cancelButtonBackgroundColor = cancelButtonBackgroundColor
            self.confirmButtonFont = confirmButtonFont
            self.confirmButtonTextColor = confirmButtonTextColor
            self.confirmButtonBackgroundColor = confirmButtonBackgroundColor
        }
        
        public static let `default` = Style(
            backgroundColor: .white,
            titleFont: .systemFont(ofSize: 17, weight: .bold),
            titleColor: .black,
            messageFont: .systemFont(ofSize: 17, weight: .regular),
            messageColor: .black,
            buttonsContainerColor: UIColor(white: 0.95, alpha: 1),
            cancelButtonFont: .systemFont(ofSize: 15, weight: .bold),
            cancelButtonTextColor: .blue,
            cancelButtonBackgroundColor: .white,
            confirmButtonFont: .systemFont(ofSize: 15, weight: .regular),
            confirmButtonTextColor: .blue,
            confirmButtonBackgroundColor: .white)
    }
}

extension SimpleDialogViewController.Action: Dismissing {
    public var shouldDismiss: Bool {
        return true
    }
}

// MARK: - PRIVATE

extension SimpleDialogViewController.Setup {
    fileprivate var isMessageLabelVisible: Bool {
        return message != nil
    }
    
    fileprivate var isImageVisible: Bool {
        return image != nil
    }
}

extension SimpleDialogViewController.ButtonsConfiguration {
    fileprivate var areButtonsVisible: Bool {
        switch self {
        case .noButtons:
            return false
        case .confirm, .cancelAndConfirm:
            return true
        }
    }
    
    fileprivate var isCancelButtonVisible: Bool {
        switch self {
        case .noButtons, .confirm:
            return false
        case .cancelAndConfirm:
            return true
        }
    }
    
    fileprivate var cancelButtonTitle: String? {
        switch self {
        case .noButtons, .confirm:
            return nil
        case .cancelAndConfirm(let value, _):
            return value
        }
    }

    fileprivate var isConfirmButtonVisible: Bool {
        switch self {
        case .noButtons:
            return false
        case .confirm, .cancelAndConfirm:
            return true
        }
    }
    
    fileprivate var confirmButtonTitle: String? {
        switch self {
        case .noButtons:
            return nil
        case .confirm(let value):
            return value
        case .cancelAndConfirm(_, let value):
            return value
        }
    }
}
