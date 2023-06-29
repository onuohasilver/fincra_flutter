import 'package:js/js_util.dart' as js;

String buildFincraHtml(
        String name,
        String amount,
        String email,
        String publicKey,
        String feeBearer,
        String phoneNumber,
        String currency,
        Map metaData) =>
    '''
<html>
  <head>
    <meta charset="UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Fincra checkout</title>
    <script src="https://unpkg.com/@fincra-engineering/checkout@latest/dist/inline.min.js"></script>
  </head>
  <body
    onload="setupFincraConnect()"

    style="
      border-radius: 20px;
      background-color: #fff;
      height: 100vh;
      overflow: hidden;
    "
  >

    <script type="text/javascript">

        window.onload = setupFincraConnect;

        function setupFincraConnect() {
          Fincra.initialize({
            key: "$publicKey",
            amount: $amount,
            currency: "$currency",
            feeBearer: "$feeBearer",
            customer: {
                name: "$name",
                email: "$email",
                phoneNumber: "$phoneNumber",
            },
            customerReference: "123123+123123",
            metadata: $mapToJSObj(metaData),
            onClose: function () {
              sendMessage({"event": "checkout.closed"});
            },
            onSuccess: function (data) {
                sendMessage({"event": "checkout.success", "data": data})
            },
          });
          function sendMessage(message) {
            if (window.FincraClientInterface && window.FincraClientInterface.postMessage) {
                FincraClientInterface.postMessage(JSON.stringify(message));
            }
          }
        }
    </script>
  </body>
</html>

''';

Object mapToJSObj(Map<dynamic, dynamic> a) {
  var object = js.newObject();
  a.forEach((k, v) {
    var key = k;
    var value = v;
    js.setProperty(object, key, value);
  });
  return object;
}
