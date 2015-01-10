#coding=utf8

from setuptools import setup, Extension

setup(
    name="spp",
    ext_modules=[Extension('spp', [
        'src/c/hbuf.c',
        'src/c/spp.c',
        'src/spp.c',
    ], include_dirs=['src/c'])]
)
