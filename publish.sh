#!/bin/bash
if [[ $EUID -ne 0 ]]; then echo 'You must be root!' ; exit 1 ; fi

echo -e '\ntodo: publish to PPA repo\n'
