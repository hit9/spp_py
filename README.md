Simple Protocol Parser
======================

*Actually, this is [ssdb](http://ssdb.io)'s network protocol, and I think it can
be used on other projects.*

Protocol
--------

```
Packet := Block+ '\n'
Block  := Size '\n' Data '\n'
Size   := literal_integer
Data   := string_bytes
```

For example:

```
3
set
3
key
3
val

```

Install
--------

```
pip install spp
```

Usage
-----

```python
from spp import Parser

parser = Parser()
parser.feed('2\nok\n\n')

while 1:
    res = parser.get()
    if res is not None:
        print (res)  # => ['ok']
    else:
        break
```

API Ref
-------

- parser.feed(string/unicode)
- parser.get()
- parser.clear()

License
-------

MIT (c) 2014, hit9 (Chao Wang).
