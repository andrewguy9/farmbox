#!/bin/bash

apt-get -y install git
apt-get -y install puppet
git clone https://github.com/andrewguy9/farmbox.git
cd farmbox
puppet apply  --modulepath=. ./farmbox.pp
