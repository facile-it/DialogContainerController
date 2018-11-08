import UIKit

public protocol Dismissing {
    var shouldDismiss: Bool { get }
}

public final class DialogContainerController: UIViewController {
    
    @IBOutlet public weak var backgroundContainerView: UIView! {
        didSet {
            backgroundContainerView.isOpaque = false
            backgroundContainerView.backgroundColor = .clear
        }
    }
    
    @IBOutlet public weak var backgroundView: UIView! {
        didSet {
            presentationSetup.background.setup(in: backgroundView)
        }
    }
    
    @IBOutlet public weak var contentView: UIView! {
        didSet {
            addChild(contentViewController)
            contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubviewConstrainedToSameBounds(contentViewController.view)
            contentViewController.didMove(toParent: self)
            
            contentView.isOpaque = false
            contentView.backgroundColor = .clear
            presentationSetup.shadow.add(to: contentView)
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.isOpaque = false
        view.backgroundColor = .clear
    }
    
    private let contentViewController: UIViewController
    private let presentationSetup: PresentationSetup
    public init(contentViewController: UIViewController, presentationSetup: PresentationSetup) {
        self.contentViewController = contentViewController
        self.presentationSetup = presentationSetup
        
        super.init(nibName: "DialogContainerController", bundle: nil)
        
        modalTransitionStyle = presentationSetup.modalTransitionStyle
        modalPresentationStyle = presentationSetup.modalPresentationStyle
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public struct InteractionSetup<Action> where Action: Dismissing {
        public var getContentViewController: (@escaping (Action) -> ()) -> UIViewController
        public var handleAction: ((Action) -> ())?
        public var onPresentCompletion: (() -> ())?
        public var onDismissCompletion: (() -> ())?
        
        public init(
            getContentViewController: @escaping (@escaping (Action) -> ()) -> UIViewController,
            handleAction: ((Action) -> ())? = nil,
            onPresentCompletion: (() -> ())? = nil,
            onDismissCompletion: (() -> ())? = nil)
        {
            self.getContentViewController = getContentViewController
            self.handleAction = handleAction
            self.onPresentCompletion = onPresentCompletion
            self.onDismissCompletion = onDismissCompletion
        }
    }
    
    public struct PresentationSetup {
        public var animated: Bool
        public var modalTransitionStyle: UIModalTransitionStyle
        public var modalPresentationStyle: UIModalPresentationStyle
        public var background: Background
        public var shadow: Shadow
        
        public init(
            animated: Bool,
            modalTransitionStyle: UIModalTransitionStyle,
            modalPresentationStyle: UIModalPresentationStyle,
            background: Background,
            shadow: Shadow)
        {
            self.animated = animated
            self.modalTransitionStyle = modalTransitionStyle
            self.modalPresentationStyle = modalPresentationStyle
            self.background = background
            self.shadow = shadow
        }
        
        public static let `default` = PresentationSetup(
            animated: true,
            modalTransitionStyle: .crossDissolve,
            modalPresentationStyle: .overFullScreen,
            background: .default,
            shadow: .default)
        
        public struct Background {
            public var color: UIColor
            
            public init(color: UIColor) {
                self.color = color
            }
            
            public static let `default` = Background(
                color: UIColor.black.withAlphaComponent(0.2)
            )

            public static let hidden = Background(
                color: UIColor.clear
            )
        }
        
        public struct Shadow {
            public var radius: Double
            public var opacity: Double
            public var color: UIColor
            public var offset: CGSize
            
            public init(
                radius: Double,
                opacity: Double,
                color: UIColor,
                offset: CGSize)
            {
                self.radius = radius
                self.opacity = opacity
                self.color = color
                self.offset = offset
            }
            
            public static let `default` = Shadow(
                radius: 2,
                opacity: 0.2,
                color: .black,
                offset: CGSize(width: 0, height: 2))
            
            public static let hidden = Shadow(
                radius: 0,
                opacity: 0,
                color: .clear,
                offset: CGSize(width: 0, height: 0))
        }
    }
}

extension UIViewController {
    public func presentInDialogContainerController<Action>(
        withInteractionSetup interactionSetup: DialogContainerController.InteractionSetup<Action>,
        presentationSetup: DialogContainerController.PresentationSetup = .default)
    {
        present(
            DialogContainerController(
                contentViewController: interactionSetup.getContentViewController { [weak self] action in
                    interactionSetup.handleAction?(action)
                    
                    if action.shouldDismiss {
                        self?.dismiss(
                            animated: presentationSetup.animated,
                            completion: interactionSetup.onDismissCompletion)
                    }
                },
                presentationSetup: presentationSetup),
            animated: presentationSetup.animated,
            completion: interactionSetup.onPresentCompletion)
    }
}

// MARK: - PRIVATE

extension DialogContainerController.PresentationSetup.Background {
    fileprivate func setup(in view: UIView) {
        view.isOpaque = false
        view.backgroundColor = color
    }
}

extension DialogContainerController.PresentationSetup.Shadow {
    fileprivate func add(to view: UIView) {
        view.clipsToBounds = false
        view.layer.masksToBounds = false
        view.layer.shadowRadius = CGFloat(radius)
        view.layer.shadowOpacity = Float(opacity)
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOffset = offset
    }
}
