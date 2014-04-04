snooze-deploy-localcluster
==========================

scripts to deploy snooze on a local machine

## Installation and Usage

Please refer to <http://snooze.inria.fr/documentation/deployment/> for the installation and usage documentation.


## If you can't wait

``` curl https://raw.githubusercontent.com/snoozesoftware/snooze-deploy-localcluster/master/webinstall.sh | sh ```

This method has been tested on 
* debian wheezy
* ubuntu 13.10
* ubuntu 13.04

### Troubleshootings

* on ubuntu 13.04, restart the dbus service seems required in order to make libvirtd daemon start listening on tcp.

## Development

* Fork the repository
* Make your bug fixes or feature additions by following our coding conventions (see the [snoozecheckstyle](https://github.com/snoozesoftware/snoozecheckstyle) repository)
* Send a pull request

## Copyright

Snooze is copyrighted by INRIA and released under the GPL v2 license (see LICENSE.txt for details). It is registered at the APP (Agence de Protection des Programmes)
under the number IDDN.FR.001.100033.000.S.P.2012.000.10000
