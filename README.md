# zabbix-elrond-plugin
Zabbix monitoring plugin for the Elrond Nodes.

This Zabbix custom plugin and template will provide you automatic discovery for your Elrond nodes, monitoring some of the most important items, adding a few triggers and graphs configuration.

## Prerequisites
1. Zabbix Server
2. Zabbix Agent needs to be installed on your machines hosting the Elrond nodes
3. Perl on the node machines

## Installing

1. Clone or download the files in this repo
2. Install perl if you don't have it already:
```
  apt install perl
```
3. Run the installation script on the node machines:
```
./install.pl
```
4. Import the zabbix-server-elrond-template.xml into your Zabbix Server

## Configuration
After importing the template into the Zabbix server, adapt the items, triggers, graphs to your needs from the Discovery Rules template section.

## Uninstalling
Run the uninstallation script:
```
./uninstall.pl
```
