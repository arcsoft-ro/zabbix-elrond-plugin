#!/usr/bin/perl -w

system("./uninstall.pl skip-restart");
print("\n");
system("./install.pl");