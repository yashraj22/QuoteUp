import 'package:http/http.dart' as http;

void fetchData() async {
  var url =
      "https://andruxnet-random-famous-quotes.p.rapidapi.com/?cat=famous&count=10";
  var headers = {
    'x-rapidapi-key': "592c903de4b05d38a42e9e3e",
    'x-rapidapi-host': "andruxnet-random-famous-quotes.p.rapidapi.com"
  };
  var res = await http.get(Uri.parse(url), headers: headers);
  print(res.body);
}

void main() {
  fetchData();
}
