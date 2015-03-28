#coding=utf8

from setuptools import setup, Extension

setup(
    name='spp',
    version='0.0.6',
    author='hit9',
    author_email='hit9@icloud.com',
    description='My Simple Protocol Parser For Python,'
                ' Built For Speed',
    license='MIT',
    url='https://github.com/hit9/spp_py',
    ext_modules=[Extension('spp', [
        'src/c/hbuf.c',
        'src/c/spp.c',
        'src/spp.c',
    ], include_dirs=['src/c'])],
    include_package_data = True
)
