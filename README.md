# TodoList

## Test

```bash
$ iex -S mix

$ curl -d "" \
"http://localhost:5454/add_entry?list=bob&date=2018-12-19&title=Dentist"
OK

$ curl "http://localhost:5454/entries?list=bob&date=2018-12-19"
2018-12-19 Dentist
```
