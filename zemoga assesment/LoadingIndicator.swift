
import MBProgressHUD
import UIKit

class LoadingIndicator {
  private let loadingView: MBProgressHUD

  init(title: String = "loading".localized()) {
    loadingView = MBProgressHUD(view: UIApplication.shared.windows.last!)
    loadingView.removeFromSuperViewOnHide = true
    loadingView.label.text = title
  }

  @discardableResult
  func show() -> LoadingIndicator {
    DispatchQueue.main.async {
      UIApplication.shared.windows.last?.addSubview(self.loadingView)
      self.loadingView.show(animated: true)
    }
    return self
  }

  func hide() {
    DispatchQueue.main.async {
      self.loadingView.hide(animated: true)
    }
  }
}
