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

{$METANODEURL} and {$METAURL} - The URL from where to fetch node statistics.<br/>
{$NSEXP} - Node Status Cache expiry (seconds) - Controls for how many seconds to keep the node status data for the node_status check script.<br/>
{$NSINT} - Node Status check interval - Controls the check frequency for the node status items<br/>
{$NSINTLIVE} - Node Status live data check interval - Controls the check frequency for the node status items that fetch live data, e.g. TPS<br/>
{$VSEXP} - Validator Statistics Cache expiry (seconds) - Controls for how many seconds to keep the validator statistics data for the validator_statistics check script.<br/>
{$VSINT} - Validator Statistics check interval - Controls the check frequency for the node status items<br/>

## Uninstalling
Run the uninstallation script:
```
./uninstall.pl
```
