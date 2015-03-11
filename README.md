Simple Protocol Parser
======================

*Actually, this is [ssdb](http://ssdb.io)'s network protocol, and I think it can
be used on other projects.*

- Nodejs Port: https://github.com/hit9/spp_node
- Lua Port: https://github.com/hit9/spp_lua


Support Py2.6+/3.3+ (Input `str` and out `str`, (the str means bytes in py2.x and unicode in py3.x)).

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

- parser.feed(str)
- parser.get()
- parser.clear()

License
-------

MIT (c) 2014, hit9 (Chao Wang).
