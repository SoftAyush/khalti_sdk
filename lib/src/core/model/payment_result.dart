import 'package:equatable/equatable.dart';

/// The various states of a payment.
enum PaymentStatus {
  /// The payment is successfully completed.
  completed,

  /// The payment is pending.
  pending,

  /// The payment has failed.
  failed,

  /// The payment has been initiated but not completed.
  initiated,

  /// The payment has been refunded.
  refunded,

  /// The payment has expired.
  expired,

  /// The status of the payment is unknown.
  unknown;

  /// Helper to convert string status to [PaymentStatus] enum.
  static PaymentStatus fromString(String? status) {
    return switch (status?.toLowerCase()) {
      'completed' => PaymentStatus.completed,
      'pending' => PaymentStatus.pending,
      'failed' => PaymentStatus.failed,
      'initiated' => PaymentStatus.initiated,
      'refunded' => PaymentStatus.refunded,
      'expired' => PaymentStatus.expired,
      _ => PaymentStatus.unknown,
    };
  }
}

/// The result after making either a successful or unsuccessful payment.
class PaymentResult extends Equatable {
  /// Constructor for [PaymentResult].
  ///
  /// The result after making either a successful or unsuccessful payment.
  const PaymentResult({
    this.payload,
  });

  /// Payload regarding the product purchased.
  final PaymentPayload? payload;

  /// Returns the [PaymentStatus] of the payment.
  PaymentStatus get status => PaymentStatus.fromString(payload?.status);

  /// Returns true if the payment is successfully completed.
  bool get isSuccess => status == PaymentStatus.completed;

  /// Returns true if the payment is pending.
  bool get isPending => status == PaymentStatus.pending;

  /// Returns true if the payment has failed.
  bool get isFailed => status == PaymentStatus.failed;

  @override
  List<Object?> get props => [payload];

  @override
  bool get stringify => true;
}

/// Response model for payment verification lookup.
class PaymentPayload extends Equatable {
  /// Default constructor for [PaymentPayload].
  const PaymentPayload({
    this.pidx,
    this.totalAmount = 0,
    required this.status,
    required this.transactionId,
    this.fee = 0,
    this.refunded = false,
    this.purchaseOrderId,
    this.purchaseOrderName,
    this.extraMerchantParams,
  });

  /// The product idx for the associated payment.
  final String? pidx;

  /// Total Amount associated with the payment made.
  final int totalAmount;

  /// The transaction status for the payment made.
  ///
  /// Can be: Completed, Pending, Failed, Initiated, Refunded or Expired
  final String? status;

  /// Unique transaction id.
  final String? transactionId;

  /// The service charge for the payment.
  final int fee;

  /// Denotes if refund was made in case of any failure.
  final bool refunded;

  /// The id associated with the purchased item.
  final String? purchaseOrderId;

  /// The name associated with the purchased item.
  final String? purchaseOrderName;

  /// Extra information associated with the merchant making the payment.
  final Map<String, dynamic>? extraMerchantParams;

  @override
  List<Object?> get props {
    return [
      pidx,
      totalAmount,
      status,
      transactionId,
      fee,
      refunded,
      purchaseOrderId,
      purchaseOrderName,
      extraMerchantParams,
    ];
  }

  /// Factory to create [PaymentPayload] instance from [map].
  factory PaymentPayload.fromJson(Map<String, dynamic> map) {
    return PaymentPayload(
      pidx: map['pidx'] as String?,
      totalAmount: map['total_amount'] as int? ?? 0,
      status: map['status'] as String?,
      transactionId: map['transaction_id'] as String?,
      fee: map['fee'] as int? ?? 0,
      refunded: map['refunded'] as bool? ?? false,
      purchaseOrderId: map['purchase_order_id'] as String?,
      purchaseOrderName: map['purchase_order_name'] as String?,
      extraMerchantParams: map['extra_merchant_params'] as Map<String, dynamic>?,
    );
  }
}
