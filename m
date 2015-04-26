Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:59130 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbbDZPUc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Apr 2015 11:20:32 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:48576 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtps
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1YmOLo-0004KB-GV
	for <linux-btrfs@vger.kernel.org>; Sun, 26 Apr 2015 08:20:11 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <marc@merlins.org>)
	id 1YmOLn-0007Cj-RC
	for linux-btrfs@vger.kernel.org; Sun, 26 Apr 2015 08:20:07 -0700
Date: Sun, 26 Apr 2015 08:20:07 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20150426152007.GA27173@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: raid0 needs mounting alternate device every boot? open_ctree failed
 (3.19.5)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is the weirdest thing:
gargamel:/var/log# mount /dev/mapper/raid0d2 /mnt/btrfs_space
mount: wrong fs type, bad option, bad superblock on /dev/mapper/raid0d2,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so
[  835.718898] BTRFS info (device dm-5): disk space caching is enabled
[  835.778580] BTRFS: failed to read the system array on dm-5
[  835.819223] BTRFS: open_ctree failed

gargamel:/var/log# mount /dev/mapper/raid0d1 /mnt/btrfs_space
[  847.047607] BTRFS: device label btrfs_space devid 1 transid 40929 /dev/mapper/raid0d1
[  847.073955] BTRFS info (device dm-4): disk space caching is enabled

The previous boot, I had to mount raid0d2 because raid0d1 didn't work.

Label: 'btrfs_space'  uuid: 01334b81-c0db-4e80-92e4-cac4da867651
        Total devices 2 FS bytes used 401.54GiB
        devid    1 size 836.13GiB used 295.02GiB path /dev/mapper/raid0d1
        devid    2 size 836.13GiB used 295.01GiB path /dev/mapper/raid0d2

Data, RAID0: total=580.00GiB, used=398.22GiB
System, RAID1: total=8.00MiB, used=64.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=5.00GiB, used=3.08GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

Those are 2 crypted disks which are already decrypted by the time I try
to mount them, I just don't understand why btrfs fails if I mount
one device but works with the other one, or the other way around.

Any idea what could be causing this?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
