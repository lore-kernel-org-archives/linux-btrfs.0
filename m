Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab2JKH2b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 03:28:31 -0400
Date: Thu, 11 Oct 2012 08:28:21 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        David Sterba <dave@jikos.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121011072821.GA4605@rhmail.home.annexia.org>
References: <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
 <20121009000051.GA12735@shiny>
 <20121009072002.GJ24071@rhmail.home.annexia.org>
 <20121009073357.GB13692@rhmail.home.annexia.org>
 <20121009090012.GJ4405@twin.jikos.cz>
 <20121010123808.GA31317@shiny>
 <20121010193853.GV24071@rhmail.home.annexia.org>
 <20121010194113.GA687@shiny>
 <20121010194641.GW24071@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121010194641.GW24071@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well the bad news is that the bug happened again overnight, even
though we were definitely using btrfs-progs with the 6eba90029 patch
added, _and_ it was doing a sync + fsync between the mkfs and the
mount.

Here is the log:

modprobe btrfs
[   15.716610] Btrfs loaded
grep ^[[:space:]]*btrfs$ /proc/filesystems
mkfs.btrfs /dev/sda1 /dev/sdb1

[   16.656467] device fsid fb238b09-83b9-4b18-9545-d1fae8f5d489 devid 1 transid 1 /dev/sda1
[   16.657467] device fsid fb238b09-83b9-4b18-9545-d1fae8f5d489 devid 1 transid 1 /dev/sda1
[   17.227381] device fsid fb238b09-83b9-4b18-9545-d1fae8f5d489 devid 2 transid 3 /dev/sdb1
fsync /dev/sda
fsync /dev/sdb
fsync /dev/sdc
fsync /dev/sdd
libguestfs: recv_from_daemon: 40 bytes: 20 00 f5 f5 | 00 00 00 04 | 00 00 01 3d | 00 00 00 01 | 00 12 34 04 | ...
libguestfs: trace: mkfs_btrfs = 0
libguestfs: trace: mount "/dev/sda1" "/"
libguestfs: send_to_daemon: 68 bytes: 00 00 00 40 | 20 00 f5 f5 | 00 00 00 04 | 00 00 00 01 | 00 00 00 00 | ...
guestfsd: main_loop: proc 317 (mkfs_btrfs) took 2.22 seconds
guestfsd: main_loop: new request, len 0x40
mount -o  /dev/sda1 /sysroot/
[   17.512337] device fsid fb238b09-83b9-4b18-9545-d1fae8f5d489 devid 1 transid 4 /dev/sda1
[   17.758300] device fsid fb238b09-83b9-4b18-9545-d1fae8f5d489 devid 2 transid 4 /dev/sdb1
[   17.857285] device fsid fb238b09-83b9-4b18-9545-d1fae8f5d489 devid 1 transid 4 /dev/sda1
[   17.893279] device fsid fb238b09-83b9-4b18-9545-d1fae8f5d489 devid 1 transid 4 /dev/sda1
[   17.909277] btrfs: disk space caching is enabled
[   17.943272] btrfs bad tree block start 0 135168
[   17.955270] btrfs: open_ctree failed
mount: wrong fs type, bad option, bad superblock on /dev/sda1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
guestfsd: error: /dev/sda1 on / (options: ''): mount: wrong fs type, bad option, bad superblock on /dev/sda1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
libguestfs: recv_from_daemon: 284 bytes: 20 00 f5 f5 | 00 00 00 04 | 00 00 00 01 | 00 00 00 01 | 00 12 34 05 | ...
libguestfs: trace: mount = -1 (error)

http://kojipkgs.fedoraproject.org//work/tasks/9775/4579775/build.log

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
