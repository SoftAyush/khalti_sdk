<p align="center">
  <img src="https://raw.githubusercontent.com/khalti/checkout-sdk-flutter/main/assets/khalti_logo.png" height="120" alt="Khalti Logo" />
</p>

<h1 align="center">Khalti Payment Gateway for Flutter</h1>

<p align="center">
  <strong>An official-grade SDK for seamless payment integration in Nepal.</strong>
</p>

<p align="center">
<a href="https://pub.dev/packages/khalti_sdk"><img src="https://img.shields.io/pub/v/khalti_sdk.svg" alt="Pub"></a>
<a href="https://docs.khalti.com/"><img src="https://img.shields.io/badge/Khalti-Docs-blueviolet" alt="Khalti Docs"></a>
<a href="./LICENSE"><img src="https://img.shields.io/badge/License-BSD--3-informational" alt="BSD-3 License"></a>
<a href="https://github.com/SoftAyush/khalti_sdk/issues"><img src="https://img.shields.io/github/issues/issues/SoftAyush/khalti_sdk" alt="GitHub issues"></a>
</p>

---

## 🌟 Introduction

Khalti is the leading payment gateway, digital wallet, and API provider in Nepal. This SDK simplifies the integration process, allowing your Flutter app to accept payments through:

- **Khalti Wallet**
- **eBanking** (Partner Banks)
- **Mobile Banking**
- **SCT/VISA Cards**
- **connectIPS**

> [!NOTE]  
> This package is a cloned and enhanced version of the original [khalti_checkout_flutter](https://pub.dev/packages/khalti_checkout_flutter) and [khalti_checkout_core](https://pub.dev/packages/khalti_checkout_core) packages, unified into a single, easy-to-use SDK.

Developed with ❤️ by [**Ayush Timalsina**](https://ayushtimalsina.com.np).

---

## 📱 Supported Platforms

| Android | iOS |
| :---: | :---: |
| ✔️ | ✔️ |

---

## 🚀 Getting Started

### 1. Installation

Add `khalti_sdk` to your `pubspec.yaml`:

```yaml
dependencies:
  khalti_sdk: ^1.0.1
```

### 2. Platform Setup

No additional configuration is required for Android or iOS.

---

## 🛠️ Usage

### Initialize Khalti

It is recommended to initialize the `Khalti` object within your `initState`.

```dart
late final Future<Khalti> khalti;

@override
void initState() {
  super.initState();
  
  final payConfig = KhaltiPayConfig(
    publicKey: '__your_public_key__', 
    pidx: '__generated_pidx__', // Generate via server-side POST
    environment: Environment.prod,
  );

  khalti = Khalti.init(
    payConfig: payConfig,
    onPaymentResult: (result, khalti) {
      if (result.isSuccess) {
        log('Payment Success: ${result.payload?.transactionId}');
      } else {
        log('Payment Status: ${result.status}');
      }
      khalti.close(context);
    },
    onMessage: (khalti, {description, statusCode, event, needsPaymentConfirmation}) {
      log('Message: $description (Event: $event)');
      if (needsPaymentConfirmation == true) {
        khalti.verify();
      }
    },
    onReturn: () => log('Successfully redirected to return_url.'),
  );
}
```

### Launching the UI

```dart
ElevatedButton(
  onPressed: () async {
    final instance = await khalti;
    instance.open(context);
  },
  child: const Text('Pay with Khalti'),
)
```

---

## ⚙️ Configuration Details

### `KhaltiPayConfig`
- `publicKey`: Your live/test public key from the Khalti dashboard.
- `pidx`: Unique product identifier (generate this server-side).
- `environment`: `Environment.prod` or `Environment.dev`.

### `KhaltiEvent`
The `onMessage` callback provides events to help you handle different scenarios:
- `kpgDisposed`: User closed the payment page.
- `returnUrlLoadFailure`: Failed to load the return URL.
- `networkFailure`: General network issues.
- `paymentLookupFailure`: Error during status verification.

---

## 👨‍💻 Developed By

This SDK is maintained by **Ayush Timalsina**. 
- **Website**: [ayushtimalsina.com.np](https://ayushtimalsina.com.np)
<!-- - **GitHub**: [@ayush-t](https://github.com/ayush-t) -->

---

## 📄 License

This project is licensed under the **BSD 3-Clause License**. See the [LICENSE](./LICENSE) file for the full text.

<!-- ## 🤝 Support

**Merchant Team**: 9801165557 | merchant@khalti.com  
**Technical Support**: 9801856383 | techsupport@khalti.com  
**General Queries**: 9801165565 | merchantcare@khalti.com -->
