#!/usr/bin/env python2
# Copyright 2011 Tom Vincent <http://tlvince.com/contact/>

import quvi

"""Nose test cases for python-quvi."""

def testInvalidURL():
    """Test a non-supported URL."""
    q = quvi.Quvi()
    try:
        q.parse("http://google.com")
    except quvi.QuviError:
        assert True

def testValidURL():
    """Test a known-supported URL."""
    q = quvi.Quvi()
    q.parse("http://www.youtube.com/watch?v=0gzA6Xzbh1k")

    expected = "youtube"
    actual = q.get_properties()["hostid"]

    assert actual == expected
