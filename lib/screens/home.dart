import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController desc = TextEditingController();
  final TextEditingController amount = TextEditingController();

  late Razorpay _razorPay;

  @override
  void initState() {
    super.initState();
    initializeRazorPay();
  }

  void initializeRazorPay() {
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  }

  void launchRazorPay() {
    int amountPay = int.parse(amount.text) * 100;

    var options = {
      'key': 'rzp_test_gTeTVyss8y5SVC',
      'amount': "$amountPay",
      'name': name.text,
      'description': desc.text,
      'prefill': {'contact': phone.text, 'email': email.text}
    };

    try {
      _razorPay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("Payment Failed");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed");

    print("${response.code} \n${response.message}");
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Sucessfull");

    print(
        "${response.orderId} \n${response.paymentId} \n${response.signature}");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              textField(size, "Name", false, name),
              textField(size, "Phone no", false, phone),
              textField(size, "Email", false, email),
              textField(size, "Description", false, desc),
              textField(size, "Amount", false, amount),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  width: size.width / 1.1,
                  height: size.height / 22,
                  child: ElevatedButton(
                    onPressed: () {
                      launchRazorPay();
                    },
                    child: Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(Size size, String text, bool isNumerical,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: Container(
        height: size.height / 15,
        width: size.width / 1.1,
        child: TextField(
          controller: controller,
          keyboardType: isNumerical ? TextInputType.number : null,
          decoration: InputDecoration(
            hintText: text,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
