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

{$METANODEURL} - The metachain observer API URL from where to fetch validator and shards statistics. e.g http://localhost:8081<br/><br/>
{$NSINT} - The check interval for the node status items. Use Zabbix interval format. e.g. 30s / 1m / 1d<br/><br/>
{$NSINTLIVE} - The check interval for the shard statistics live TPS items. Use Zabbix interval format.  e.g. 30s / 1m / 1d<br/><br/>
{$VSINT} - The check interval for the validator statistics items. Use Zabbix interval format. e.g. 30s / 1m / 1d<br/><br/>
{$HSINT} - The check interval for the heartbeat statistics items. Use Zabbix interval format. e.g. 30s / 1m / 1d<br/><br/>
{$NSEXP} - Node Status Cache expiry (seconds) - Controls for how many seconds to keep the node status data for the node_status check script. This should be one or two seconds less than {$NSINT}<br/><br/>
{$VSEXP} - Validator Statistics Cache expiry (seconds) - Controls for how many seconds to keep the validator statistics data for the validator_statistics check script. This should be one or two seconds less than {$VSINT}<br/><br/>
{$HSEXP} - Heartbeat Statistics Cache expiry (seconds) - Controls for how many seconds to keep the heartbeat statistics data for the heartbeat_statistics check script. This should be one or two seconds less than {$HSINT}<br/>

## Uninstalling
Run the uninstallation script:
```
./uninstall.pl
```
