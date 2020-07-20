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

{$METANODEURL} - The metachain observer API URL from where to fetch validator statistics (should point to /validator/statistics API endpoint) e.g http://localhost:8081/validator/statistics<br/><br/>
{$METAURL} - The metachain observer API URL from where to fetch shards statistics (should point to /node/statistics API endpoint)  e.g http://localhost:8081/node/statistics<br/><br/>
{$NSINT} - The check interval for the node status items. This is in the zabbix interval format. e.g. 30s / 1m / 1d<br/><br/>
{$NSINTLIVE} - The check interval for the shard statistics live TPS items. This is in the zabbix interval format.  e.g. 30s / 1m / 1d<br/><br/>
{$VSINT} - The check interval for the validator statistics items. This is in the zabbix interval format. e.g. 30s / 1m / 1d<br/><br/>
{$NSEXP} - Node Status Cache expiry (seconds) - Controls for how many seconds to keep the node status data for the node_status check script. This should be one or two seconds less than {$NSINT}<br/><br/>
{$VSEXP} - Validator Statistics Cache1 expiry (seconds) - Controls for how many seconds to keep the validator statistics data for the validator_statistics check script. This should be one or two seconds less than {$VSINT}<br/>

## Uninstalling
Run the uninstallation script:
```
./uninstall.pl
```
