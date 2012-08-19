Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:60243 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2HSOIW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Aug 2012 10:08:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail1.trendhosting.net (Postfix) with ESMTP id 3382C150F4
	for <linux-btrfs@vger.kernel.org>; Sun, 19 Aug 2012 15:58:20 +0100 (BST)
Received: from mail1.trendhosting.net ([127.0.0.1])
	by localhost (thp003.trendhosting.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id ZVgyBlCFLmIm for <linux-btrfs@vger.kernel.org>;
	Sun, 19 Aug 2012 15:58:17 +0100 (BST)
Message-ID: <5030F351.6030807@pocock.com.au>
Date: Sun, 19 Aug 2012 14:08:17 +0000
From: Daniel Pocock <daniel@pocock.com.au>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: fail to mount after first reboot
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



I created a 1TB RAID1.  So far it is just for testing, no important data
on there.


After a reboot, I tried to mount it again

# mount /dev/mapper/vg00-btrfsvol0_0 /mnt/btrfs0
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/vg00-btrfsvol0_0,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

I checked dmesg:

[17216.145092] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 1
transid 34 /dev/mapper/vg00-btrfsvol0_0
[17216.145639] btrfs: disk space caching is enabled
[17216.146987] btrfs: failed to read the system array on dm-100
[17216.147556] btrfs: open_ctree failed


Then I did btrfsck - it reported no errors, but mounted OK:

# btrfsck /dev/mapper/vg00-btrfsvol0_0
checking extents
checking fs roots
checking root refs
found 26848493568 bytes used err is 0
total csum bytes: 26170252
total tree bytes: 48517120
total fs tree bytes: 5492736
btree space waste bytes: 14307930
file data blocks allocated: 26799976448
 referenced 26799976448
Btrfs Btrfs v0.19
# mount /dev/mapper/vg00-btrfsvol0_0 /mnt/btrfs0
#


I checked dmesg again, these are the messages from the second mount:

[17299.180600] device fsid 928b939f-7f9d-4095-b1ba-e35c5f1277bf devid 1
transid 37928 /dev/dm-96
[17299.204475] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 2
transid 34 /dev/dm-99
[17299.204658] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 1
transid 34 /dev/dm-100
[17299.288317] device fsid 928b939f-7f9d-4095-b1ba-e35c5f1277bf devid 1
transid 37928 /dev/dm-96
[17299.289024] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 2
transid 34 /dev/dm-99
[17299.289150] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 1
transid 34 /dev/dm-100
[17310.978518] device fsid c959d4a5-0713-4685-b572-8a679ec37e20 devid 1
transid 34 /dev/mapper/vg00-btrfsvol0_0
[17310.993882] btrfs: disk space caching is enabled


Can anyone comment on this?


Also, df is reporting double the actual RAID1 volume size, and double
the amount of data stored in this filesystem:

# df -lh .
Filesystem                    Size  Used Avail Use% Mounted on
/dev/mapper/vg00-btrfsvol0_0  1.9T   51G  1.8T   3% /mnt/btrfs0

I would expect to see Size=1T, Used=25G

# strace -v -e trace=statfs df -lh /mnt/btrfs0
statfs("/mnt/btrfs0", {f_type=0x9123683e, f_bsize=4096,
f_blocks=488374272, f_bfree=475264720, f_bavail=474749786, f_files=0,
f_ffree=0, f_fsid={2083217090, -1714407264}, f_namelen=255,
f_frsize=4096}) = 0
Filesystem                    Size  Used Avail Use% Mounted on
/dev/mapper/vg00-btrfsvol0_0  1.9T   51G  1.8T   3% /mnt/btrfs0
