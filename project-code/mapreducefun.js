
{
  "views": {
    "qualityTotal": {
      "map": "function(doc) {
  if (doc.quality >5) {
    emit(doc. quality, 1);
  }
}",
      "reduce": "function(keys, values, rereduce) {
  return sum(values);
}"
    }
  }
}
