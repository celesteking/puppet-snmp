Puppet SNMP Module
==================

[![Build Status](https://secure.travis-ci.org/celesteking/puppet-snmp.png?branch=master)](http://travis-ci.org/celesteking/puppet-snmp)

*NOTE*: this is work in progress, it might not work.

Introduction
------------

This module manages the installation of the SNMP server, SNMP client, and SNMP
trap server.  It also can create a SNMPv3 user with authentication and privacy
passwords.

Actions:

* Installs the SNMP client package and configuration.
* Installs the SNMP daemon package, service, and configuration.
* Installs the SNMP trap daemon service and configuration.
* Creates a SNMPv3 user with authentication and encryption paswords.

OS Support:

* RedHat family  - tested on CentOS 5.8 and CentOS 6.2
* Fedora         - not yet supported
* SuSE family    - presently unsupported (patches welcome)
* Debian family  - initial Ubuntu suport (patches welcome)
* Solaris family - presently unsupported (patches welcome)

Class documentation is available via puppetdoc.

VACM support
------------
Module supports VACM management via the following defines that resemble correspondingly named directives:
* snmp::daemon::acl::view
* snmp::daemon::acl::group
* snmp::daemon::acl::com2sec
* snmp::daemon::acl::access

`snmp::daemon::acl::defaults` class is auto-included to define a special "fullro" USM user that has RO access to every OID.  

Examples
--------

    class { 'snmp': }

    class { 'snmp::daemon':
      ro_community => 'notpublic',
      ro_network   => '10.20.30.40/32',
      contact      => 'root@yourdomain.org',
      location     => 'Phoenix, AZ',
    }

    class { 'snmp::trapd':
      ro_community => 'public',
    }

    snmp::snmpv3_user { 'myuser':
      authpass => '1234auth',
      privpass => '5678priv',
    }


