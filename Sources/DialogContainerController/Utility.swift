import UIKit

extension UIView {
    var isVisible: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
    
    func addSubview(_ subview: UIView, constrainedInInsets insets: UIEdgeInsets) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        subview.leftAnchor.constraint(equalTo: leftAnchor, constant: insets.left).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subview.rightAnchor.constraint(equalTo: rightAnchor, constant: -insets.right).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).isActive = true
    }
    
    func addSubviewConstrainedToSameBounds(_ subview: UIView) {
        addSubview(subview, constrainedInInsets: .zero)
    }
}

extension UIColor {
    static func with8Bit(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: alpha)
    }
}

@available(iOS 10.0, *)
extension UIImage {
    static func solidColor(_ color: UIColor) -> UIImage {
        let size = CGSize(width: 3, height: 3)
        let capInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        
        return UIGraphicsImageRenderer(size: size)
            .image { rendererContext in
                color.setFill()
                rendererContext.fill(CGRect(origin: .zero, size: size))
            }
            .resizableImage(withCapInsets: capInsets)
    }    
}
