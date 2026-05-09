import 'dart:async';

import 'package:khalti_sdk/khalti_sdk.dart';

/// The default timeout duration for payment verification API calls.
const _kVerificationTimeout = Duration(seconds: 20);

/// Helper function that handles exception when verify api is called.
///
/// Wraps the [caller] with a timeout of [_kVerificationTimeout] to prevent
/// the webview from freezing indefinitely if the API is unresponsive.
///
/// On success, [onPaymentResult] is called with the result.
/// On failure (timeout, HTTP error, or exception), [onPaymentResult] is
/// still called with a null payload so the consumer always receives a
/// terminal callback. [onMessage] is also called with the error details.
Future<void> handlePaymentVerificationException({
  required Future<PaymentPayload> Function() caller,
  required OnPaymentResult onPaymentResult,
  required OnMessage onMessage,
  required Khalti khalti,
}) async {
  try {
    final result = await caller().timeout(_kVerificationTimeout);
    return onPaymentResult(
      PaymentResult(payload: result),
      khalti,
    );
  } on TimeoutException {
    onMessage(
      description:
          'Payment verification timed out. Please check your payment status.',
      event: KhaltiEvent.networkFailure,
      needsPaymentConfirmation: true,
      khalti,
    );
    return onPaymentResult(
      const PaymentResult(payload: null),
      khalti,
    );
  } on ExceptionHttpResponse catch (e) {
    onMessage(
      statusCode: e.statusCode,
      description: e.detail,
      event: KhaltiEvent.networkFailure,
      needsPaymentConfirmation: true,
      khalti,
    );
    return onPaymentResult(
      const PaymentResult(payload: null),
      khalti,
    );
  } on FailureHttpResponse catch (e) {
    onMessage(
      statusCode: e.statusCode,
      description: e.data,
      event: KhaltiEvent.paymentLookupFailure,
      needsPaymentConfirmation: false,
      khalti,
    );
    return onPaymentResult(
      const PaymentResult(payload: null),
      khalti,
    );
  }
}

/// Helper function that handles exception when detail fetching api is called.
Future<PaymentDetailModel> handleFetchDetailException({
  required Future<PaymentDetailModel> Function() caller,
  required OnPaymentResult onPaymentResult,
  required OnMessage onMessage,
  required Khalti khalti,
}) async {
  try {
    final result = await caller();
    return result;
  } on ExceptionHttpResponse catch (e) {
    onMessage(
      statusCode: e.statusCode,
      description: e.detail,
      event: KhaltiEvent.networkFailure,
      needsPaymentConfirmation: true,
      khalti,
    );
    return PaymentDetailModel.empty();
  } on FailureHttpResponse catch (e) {
    onMessage(
      statusCode: e.statusCode,
      description: e.data,
      event: KhaltiEvent.returnUrlLoadFailure,
      needsPaymentConfirmation: false,
      khalti,
    );
    return PaymentDetailModel.empty();
  }
}
