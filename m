From: Chris Mason <chris.mason@oracle.com>
Subject: Btrfs v0.15 released
Date: Thu, 29 May 2008 11:48:46 -0400
Message-ID: <200805291148.46203.chris.mason@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

Btrfs v0.15 is now available for download.  The major feature added over v0.14 
is the ability to remove devices online, and improved handling of IO failures 
during reads and writes.  v0.15 does not include any disk format changes over 
v0.14.

You can find btrfs download information and documentation at:

http://btrfs.wiki.kernel.org/

Another highlight is the clone file data ioctl from Sage Weil, which can be 
used to make a COW copy of a single file.  btrfs-progs includes a new command 
called bcp which can be used to run COW copies on single files or directory 
trees.

Summary of fixes since v0.14

* 2.6.26-rc compile fixes (Mingming Cao)
* Fixes for IO stalls and high CPU usage during huge streaming writes (thanks 
to Eric Whitney for testing these on 14TB files)
* Online device removal and degraded mounts
* Fixes to the online extent relocation and balancing code
* Deal with devices disappearing after initial btrfsctl -a scan
* Transparently correct IO errors on raid1 and raid10 by using the other 
mirror.
* Detect misplaced btree writes by checking generation numbers during reads
* Fix nodatacow to more accurately detect snapshots
* Compile fixes for Apparmor kernels (Jeff Mahoney)
* Clone file data ioctl (Sage Weil)
* Fixes and optimizations for 2.6.18 enterprise kernels

-chris
