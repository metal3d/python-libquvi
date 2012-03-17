===========
Python Quvi
===========

This is a first attempt to wrap libquvi into python.

-----------------
How it is made ?
-----------------

This is based on Cython. The main functions are defined into cpython.pxd file and Quvi class is developed into quvi.pyx file.
Compilation is made with Cython using the simple command::

    python setup.py build_ext

You can also compile .so file in you current directory::

	python setup.py build_ext --inplace

To install library on system, you may use as root or by sudo::

    python setup.py install

Remember you can use ``virtualenv`` to try quvi without impact on your system::

    mkdir /tmp/py-virt
    virtualenv /tmp/py-virt
    source /tmp/py-virt/bin/activate
    setup python.py install

This will install quvi into a virtual environment. To deactivate virtual environment, in the same terminal session::

    deactivate

-----
Usage
-----

After having compiled quvi, you can use it as a python module. Module defines a class named ``Quvi``. This is a simple usage::

    import quvi

    #instance:
    q = quvi.Quvi()
    q.parse("http://a.youtube.url")
    print q.get_properties()

You will see a dict definition that have severals information given by libquvi.

It's possible to use ``multiprocessing`` module or ``threads`` module to handle several instances. See this example::

    import quvi
    from multiprocessing import Process

    #this function will be called in thread
    def getInfo(url):
        q = quvi.Quvi()
        q.parse(url)
        print q.get_properties()

    #urls to parse
    url = "http://www.youtube.com/watch?v=..."
    url2 = "http://www.youtube.com/watch?v=..."

    #processes list
    processes = []
    processes.append( Process(target=getInfo, args=(url,)) )
    processes.append( Process(target=getInfo, args=(url2,)) )

    #start and join threads
    [p.start() for p in processes]
    [p.join() for p in processes]

    print "done"

Both url will be handle in a thread. So this will be about twice quicker than parsing each url one by one.

Another usecase would be to get the properties of the best format available::

    from quvi import Quvi

    def get_properties_best_quality(url):
        q = Quvi()

        url = "http://www.youtube.com/watch?v=0gzA6Xzbh1k"
        if q.is_supported(url):
            formats = q.get_formats(url)
            best_format = formats[-1]
            q.set_format(best_format)
            q.parse(url)
            properties = q.get_properties()
            return properties
        return none

And downloading the video::

    def get_video(filename, url):
        properties = get_properties_best_quality(url)
        if properties is not None:
            to_dl = properties["mediaurl"]
            filename += properties["filesuffix"]
            urlretrieve(to_dl, filename)


-------------------------
Why this python library ?
-------------------------

Because Quvi command line is really nice and I wanted to get youtube, dailymotion, vimeo (etc...) movies information into my python project. Calling "quvi" command line may be used, but having a real library implementation is the best way to have good performances.

Using Cython is pretty cool

-----------------
What's next ?
-----------------

For now, you can only get media information from a page you ask to parse. I will continue to develop this library to improved and use properties provided by C library (version, nextmediaurl...)

If you want to develop with me, fork the project on GitHub, then process some merge request :)

