import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khalti_sdk_example/secret_config.dart';
import 'package:khalti_sdk/khalti_sdk.dart';

void main() {
  runApp(
    const MaterialApp(
      home: KhaltiSDKDemo(),
    ),
  );
}

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  late final Future<Khalti?> khalti;

  String pidx = '';

  PaymentResult? paymentResult;

  @override
  void initState() {
    super.initState();
    khalti = _initializeKhalti();
  }

  Future<Khalti?> _initializeKhalti() async {
    try {
      final response = await http.post(
        Uri.parse('${Secret.apiBaseUrl}/payments/khalti'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "amount": 1300,
          "purchase_order_id": "test12",
          "purchase_order_name": "khalti Test",
          "customer_info": {
            "name": "Khalti Bahadur",
            "email": "example@gmail.com",
            "phone": "9876543210"
          }
        }),
      );
      debugPrint(' ******* Api Response: ******  ${jsonDecode(response.body)}');
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        setState(() {
          pidx = data['pidx'];
        });

        final payConfig = KhaltiPayConfig(
          publicKey: Secret.publicKey,
          pidx: pidx,
          environment: Environment.dev,
        );

        return Khalti.init(
          enableDebugging: true,
          payConfig: payConfig,
          onPaymentResult: (PaymentResult result, khalti) {
            if (result.isSuccess) {
              log('Payment Success: ${result.payload?.transactionId}');
            } else {
              log('Payment Failed/Pending: ${result.status}');
            }
            setState(() {
              paymentResult = result;
            });
            khalti.close(context);
          },
          onMessage: (
            khalti, {
            description,
            statusCode,
            event,
            needsPaymentConfirmation,
          }) async {
            log(
              'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
            );
            khalti.close(context);
          },
          onReturn: () => log(' ********** Successfully redirected to return_url.'),
        );
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: khalti,
          initialData: null,
          builder: (context, snapshot) {
            final khaltiSnapshot = snapshot.data;
            if (khaltiSnapshot == null) {
              return const CircularProgressIndicator.adaptive();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/demo.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 120),
                const Text(
                  'Rs. 1300',
                  style: TextStyle(fontSize: 25),
                ),
                const Text('1 day fee'),
                OutlinedButton(
                  onPressed: () => khaltiSnapshot.open(context),
                  child: const Text('Pay with Khalti'),
                ),
                const SizedBox(height: 120),
                paymentResult == null
                    ? Text(
                        'pidx: $pidx',
                        style: const TextStyle(fontSize: 15),
                      )
                    : Column(
                        children: [
                          Text(
                            'pidx: ${paymentResult!.payload?.pidx}',
                          ),
                          Text('Status: ${paymentResult!.status.name}'),
                          Text(
                            'Amount Paid: ${paymentResult!.payload?.totalAmount}',
                          ),
                          Text(
                            'Transaction ID: ${paymentResult!.payload?.transactionId}',
                          ),
                        ],
                      ),
                const SizedBox(height: 120),
                const Text(
                  'This is a demo application developed by some merchant.',
                  style: TextStyle(fontSize: 12),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
