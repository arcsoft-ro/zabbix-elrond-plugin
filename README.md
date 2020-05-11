# zabbix-elrond-plugin
Zabbix monitoring plugin for the Elrond Nodes.

This Zabbix custom plugin and template will provide you automatic discovery for your Elrond nodes, monitoring some of the most important items, adding a few triggers and graphs configuration.

## Prerequisites
1. Zabbix Server
2. Zabbix Agent needs to be installed on your machines hosting the Elrond nodes
3. Perl on the node machines

## Installing and upgrading

1. Clone or download the files in this repo
2. Install perl if you don't have it already:
```
  apt install perl
```
3. Change dir to the plugin folder and run the installation script on the node machines:
```
./install.pl
```
4. Import the zabbix-server-elrond-template.xml into your Zabbix Server

If you want to upgrade from a previous version, run:
```
./upgrade.pl
```


## Configuration
After importing the template into the Zabbix server, adapt the items, triggers, graphs to your needs from the Discovery Rules template section.

### Template Macros

{$DEXP} - Discovery Cache expiry (seconds) - Controls for how many seconds to keep the node data that contains the node name in cache.<br/>
{$METANODEURL} - The URL from where to fetch node statistics.<br/>
{$NSEXP} - Node Status Cache expiry (seconds) - Controls for how many seconds to keep the node status data for the node_status check script.<br/>
{$VSEXP1} - Validator Statistics Cache1 expiry (seconds) - Controls for how many seconds to keep the validator statistics data for the validator_statistics check script.<br/>
{$VSEXP1} - Validator Statistics Cache2 expiry (seconds) - Controls for how many seconds to keep the node status data for the validator_statistics check script.<br/>

## Uninstalling
Run the uninstallation script:
```
./uninstall.pl
```
