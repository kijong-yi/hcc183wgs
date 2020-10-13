#!/bin/bash


/usr/bin/python asdf
echo $@
qload <<__SHELL__
/usr/bin/python asdf
2=a
echo $2
__SHELL__
qfire

