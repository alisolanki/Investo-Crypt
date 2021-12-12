class CryptoModel {
  final String id, name, ticker, logoUrl;
  final double priceInUSD, weight;
  final Map<String, Map<String, double>> highLowData;
  CryptoModel({
    required this.id,
    required this.name,
    required this.ticker,
    required this.logoUrl,
    required this.highLowData,
    required this.priceInUSD,
    required this.weight,
  });
}
