# Khalti SDK Example

A comprehensive example project demonstrating how to integrate the Khalti Payment Gateway into a Flutter application using the `khalti_sdk` package.

## Features

- Dynamic `pidx` generation via server-side integration.
- Seamless payment flow with Khalti.
- Handling of payment results (Success, Failure, Cancellation).
- Easy configuration for Development and Production environments.

## Getting Started

### Prerequisites

- Flutter SDK: `^3.4.0`
- A Khalti Merchant account to get your `Public Key`.
- A backend server to initiate payment and provide a `pidx`.

### Configuration

1. **Secret Config**: Ensure your Public Key is set in `lib/secret_config.dart`.
   ```dart
   class Secret {
     static const String publicKey = 'your_public_key_here';
   }
   ```

2. **Backend URL**: Update the API endpoint in `lib/main.dart` to point to your `pidx` generation service.
   ```dart
   Uri.parse('http://localhost:3000/payments/khalti')
   ```

### Running the Example

```bash
flutter pub get
flutter run
```

## Test Credentials

Use the following credentials in the **Sandbox** environment to test the integration.

| Field | Value |
| :--- | :--- |
| **Test Khalti IDs** | `9800000000`, `9800000001`, `9800000002`, `9800000003`, `9800000004`, `9800000005` |
| **Test MPIN** | `1111` |
| **Test OTP** | `987654` |

## Resources

- [Khalti Developer Documentation](https://docs.khalti.com/)
- [Khalti SDK on pub.dev](https://pub.dev/packages/khalti_sdk)
- [Flutter Documentation](https://docs.flutter.dev/)

---
Developed by [Merchant Name/Your Company]
