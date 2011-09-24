from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [Extension("quvi", ["src/quvi.pyx"], libraries=['quvi'])]

setup(
  name = 'Quvi',
  cmdclass = {'build_ext': build_ext},
  ext_modules = ext_modules
)
