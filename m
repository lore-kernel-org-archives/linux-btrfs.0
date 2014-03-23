Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55886 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaCWPZ0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 11:25:26 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:38927 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WRkGz-0000DB-Se by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 08:25:25 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WRkGz-0000Qe-2G
	for linux-btrfs@vger.kernel.org; Sun, 23 Mar 2014 08:25:17 -0700
Date: Sun, 23 Mar 2014 08:25:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Message-ID: <20140323152516.GJ12833@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: btrfs-tools missing "btrfs device delete devid=x path" ?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm still doing some testing so that I can write some howto.

I got that far after a rebalance (mmmh, that took 2 days with little
data, and unfortunately 5 deadlocks and reboots.

polgara:/mnt/btrfs_backupcopy# btrfs fi show
Label: backupcopy  uuid: eed9b55c-1d5a-40bf-a032-1be6980648e1
        Total devices 11 FS bytes used 114.35GiB
        devid    1 size 465.76GiB used 32.14GiB path /dev/dm-0
        devid    2 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdd1
        devid    3 size 465.75GiB used 0.00 path  <----  drive is freed up now.
        devid    4 size 465.76GiB used 32.14GiB path /dev/dm-2
        devid    5 size 465.76GiB used 32.14GiB path /dev/dm-3
        devid    6 size 465.76GiB used 32.14GiB path /dev/dm-4
        devid    7 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdi1
        devid    8 size 465.76GiB used 32.14GiB path /dev/dm-6
        devid    9 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdk1
        devid    10 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sdl1
        devid    11 size 465.76GiB used 32.14GiB path /dev/mapper/crypt_sde1
Btrfs v3.12

What's the syntax for removing a drive that isn't there?

I'm looking for something like
polgara:/mnt/btrfs_backupcopy# btrfs device delete devid=3 .
ERROR: error removing the device 'devid=3' - No such file or directory

Until I can remove it, not surprisingly, even though device 3 is now
unused, I still need to mount degraded:

polgara:~# mount -v -t btrfs -o compress=zlib,space_cache,noatime LABEL=backupcopy /mnt/btrfs_backupcopy
mount: wrong fs type, bad option, bad superblock on /dev/mapper/crypt_sde1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

[28865.527656] BTRFS: open devid=3 failed
[29777.507022] BTRFS: device label backupcopy devid 11 transid 5137 /dev/mapper/crypt_sde1
[29777.558874] BTRFS info (device dm-9): disk space caching is enabled
[29777.566997] BTRFS: failed to read chunk tree on dm-9
[29777.612041] BTRFS: open_ctree failed

polgara:~# mount -v -t btrfs -o compress=zlib,space_cache,noatime,degraded LABEL=backupcopy /mnt/btrfs_backupcopy
/dev/mapper/crypt_sde1 on /mnt/btrfs_backupcopy type btrfs (rw,noatime,compress=zlib,space_cache,degraded)
polgara:~# 

This works.

I think if I get that last step working, I will have succcessfully removed a raid5
drive, added a new drive, rebalanced existing data on it, and removed the old one.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
