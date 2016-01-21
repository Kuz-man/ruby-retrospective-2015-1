def convert_to_bgn(amount, currency)
  hash = {bgn: 1, usd: 1.7408, eur: 1.9557, gbp: 2.6415}
  (amount*hash[currency]).round(2)
end

def compare_prices(price_a, currency_a, price_b, currency_b)
  convert_to_bgn(price_a, currency_a) - convert_to_bgn(price_b, currency_b)
end