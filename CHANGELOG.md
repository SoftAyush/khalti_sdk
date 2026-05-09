## 1.0.0

* Initial release of unified Khalti SDK.
* Combined `khalti_checkout_flutter` and `khalti_checkout_core` functionality.
* Seamless integration with Khalti Payment Gateway using WebView.


## 1.0.1

* **Refined API**: Enhanced `PaymentResult` with `PaymentStatus` enum and helper methods (`isSuccess`, `isPending`, `isFailed`).
* **UX Improvements**: 
    * Updated WebView loader color to Khalti brand color (`#DC0019`).
    * Removed hardcoded AppBar background color, now uses theme default.
    * Loader now persists during the verification phase to prevent user confusion.
* **Stability**:
    * Added a 20-second timeout to payment verification API calls to prevent WebView freezes.
    * Ensured `onPaymentResult` is always called as a terminal callback, even on verification failure.
    * Intercepted navigation to `return_url` to prevent unnecessary merchant page loads within the SDK WebView.
* **Dependency Updates**: Updated `package_info_plus` and `device_info_plus` to latest stable versions.
