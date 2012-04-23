From: Jan Engelhardt <jengelh@medozas.de>
Subject: ENOSPC with more than 6 GB free
Date: Mon, 23 Apr 2012 15:51:44 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204042346200.11293@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I have here a Debian-based VM that was initially set up with a 2 GB 
btrfs. As the installlation of a new kernel-header failed, I updated the 
fs size to be 4, and later, 8 GB. However, the installation still runs 
into an ENOSPC error. Still I can create many (empty) files, so I am 
uncertain whether it really is due to lack of metadata space.

The test disk image is available at
  http://jengelh.medozas.de/files/testing-sda8G.img.xz [1.3 GB]
  (uncompressed size is 8589934592, so make sure the VM's /dev/sda is as big)
Root password is: wa
Command to trigger the problem after having obtained network connectivity:
  apt-get -f install

(The locale is nb_NO, you may want to change to en_US.)

== Log ==
# df /
Filesystem                                             1K-blocks    Used Available Use% Mounted on
/dev/disk/by-uuid/4ba1fa38-d62b-4940-9825-7e6cceb7fcc8   8231936 1281480   5981032  18% /

# btrfs fi df /
Data: total=1.57GB, used=1.13GB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=512.00MB, used=48.64MB

# apt-get -f install
Reading package lists... Done
Building dependency tree
Reading state information... Done
Correcting dependencies... Done
The following package was automatically installed and is no longer required:
  libboost-iostreams1.46.1
Use 'apt-get autoremove' to remove them.
The following extra packages will be installed:
  linux-headers-3.2.0-2-amd64
The following NEW packages will be installed:
  linux-headers-3.2.0-2-amd64
0 upgraded, 1 newly installed, 0 to remove and 111 not upgraded.
8 not fully installed or removed.
Need to get 0 B/571 kB of archives.
After this operation, 9162 kB of additional disk space will be used.
Do you want to continue [Y/n]? y
(Reading database ... 41592 files and directories currently installed.)
Unpacking linux-headers-3.2.0-2-amd64 (from .../linux-headers-3.2.0-2-amd64_3.2.12-1_amd64.deb) ...
dpkg: error processing /var/cache/apt/archives/linux-headers-3.2.0-2-amd64_3.2.12-1_amd64.deb (--unpack):
 unable to install new version of `/usr/src/linux-headers-3.2.0-2-amd64/include/config/usb/arch/has/xhci.h': No space left on device
configured to not write apport reports
                                      Errors were encountered while processing:
 /var/cache/apt/archives/linux-headers-3.2.0-2-amd64_3.2.12-1_amd64.deb
E: Sub-process /usr/bin/dpkg returned an error code (1)

