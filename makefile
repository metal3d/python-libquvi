# Run nose test cases for python-quvi.
# Copyright 2011 Tom Vincent <http://tlvince.com/contact/>

test_path=test

all: test

test:
	python2 setup.py build_ext --build-lib $(test_path)
	nosetests --stop --nocapture --where $(test_path)

.PHONY: all test
