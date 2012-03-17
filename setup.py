from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [Extension("quvi", ["src/quvi.pyx"], libraries=['quvi'])]

setup(
  name = 'Quvi',
  author = 'Patrice FERLET',
  author_email = "metal3d@gmail.com",
  url="https://github.com/metal3d/python-libquvi",
  description="libquvi wrapper module",
  license="LGPLv2.1+",
  version="0.0.1-b1",
  cmdclass = {'build_ext': build_ext},
  ext_modules = ext_modules,
  long_description = "".join(open('README.rst').readlines()),

  classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU Library or Lesser General Public License (LGPL)',
        'Operating System :: POSIX :: Linux',
        'Programming Language :: Cython',
        'Topic :: Internet',
        'Topic :: Multimedia :: Video',
  ]
)
