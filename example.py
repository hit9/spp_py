# coding=utf8

from spp import Parser

parser = Parser()

parser.feed('2\nok\n\n')
parser.feed('4\nbody\n\n')
parser.feed('4\nnext\n\n')
parser.feed('4\nbody\n\n')

while 1:
    res = parser.get()
    if res is not None:
        print res
    else:
        break
