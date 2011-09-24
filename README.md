# Python Quvi

This is a first attempt to wrap libquvi into python.

## How it is made ?

This is based on Cython. The main functions are defined into cpython.pxd file and Quvi class is developped into quvi.pyx file.
Compilation is made with Cython using the simple command:

    python setup.py build_ext

You can also compile .so file in you current directory

	python setup.py build_ext --inplace

To install library on system, you may use as root or by sudo:

    python setup.py install

Remember you can use ``virtual_env`` to try quvi without impact on your system:

    mkdir /tmp/py-virt
    virtual_env /tmp/py-virt
    source /tmp/py-virt/bin/activate
    setup python.py install

This will install quvi into a virtual environnement. To deactivate virtual environnment:

    deactivate

in a terminal.

## Why ?

Because Quvi command line is really nice and I wanted to get youtube, dailymotion, vimeo... movies information into my python project. Calling "quvi" command line may be use, but to have a real library implementation is the better way to have good performances. 

Using Cython is pretty cool

## What's next ?

For now, You can only get title and media url. I will continue to develop this library to handle other properties that are already bundled into C library (author, date, time,...) 

If you want to develop with me, fork the project on GitHub, then process some merge request :)

