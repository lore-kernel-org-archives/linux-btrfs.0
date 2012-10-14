Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static-96-231-53-14.washdc.fios.verizon.net ([96.231.53.14]:55613
	"EHLO www.bluelavalamp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751603Ab2JNQS6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Oct 2012 12:18:58 -0400
Received: from zee.bluelavalamp.net (zee.bluelavalamp.net [10.0.0.2])
	by www.bluelavalamp.net (Postfix) with ESMTP id F317D3A716C
	for <linux-btrfs@vger.kernel.org>; Sun, 14 Oct 2012 12:11:30 -0400 (EDT)
Date: Sun, 14 Oct 2012 12:11:30 -0400
From: Kevin <kevin@bluelavalamp.net>
To: linux-btrfs@vger.kernel.org
Subject: segfault mounting btrfs after drive failure
Message-ID: <20121014121130.04710db1@zee.bluelavalamp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

	I have a btrfs filesystem that I can't mount after having a
drive failure.  It's made up of 10 drives (9 now that the one has
failed).  Right now I'm booting the system with the failed drive
disconnected, if I try to boot with the drive connected I get a
kernel OOPs during boot.  So with only 9 drives connected here's the
make-up:

./btrfs fi sh
Label: none  uuid: 07b2c489-3e9b-4a99-977d-3b877f75dc84
        Total devices 9 FS bytes used 5.57TB
        devid    8 size 1.82TB used 1.82TB path /dev/sdk1
        devid    7 size 1.36TB used 1.36TB path /dev/sdi1
        devid   10 size 1.36TB used 1.36TB path /dev/sdh1
        devid    6 size 1.82TB used 1.82TB path /dev/sdg1
        devid    5 size 1.82TB used 1.82TB path /dev/sdf1
        devid    9 size 1.36TB used 1.36TB path /dev/sde1
        devid    3 size 1.82TB used 1.82TB path /dev/sdd1
        devid    2 size 1.82TB used 1.82TB path /dev/sdc1
        devid    1 size 819.51GB used 819.51GB path /dev/sda3

Btrfs v0.20-rc1-37-g91d9eec


	I'm pretty certain I made the filesystem with RAID1 for
metadata and data, but since I can't mount the filesystem I can't
check.  Is there anyone to check and see?


	If I try to mount the filesystem I get this:

mount /dev/sdd1 /mnt
Segmentation fault
www:# 
Message from syslogd@www at Sun Oct 14 12:01:34 2012 ...
www kernel: Process mount (pid: 8573, ti=f35e2000 task=f355e3d0
task.ti=f35e2000)

Message from syslogd@www at Sun Oct 14 12:01:34 2012 ...
www kernel: Call Trace:

Message from syslogd@www at Sun Oct 14 12:01:34 2012 ...
www kernel: Stack:

Message from syslogd@www at Sun Oct 14 12:01:34 2012 ...
www kernel: Code: 97 8b 5d 10 8b 03 8b 53 04 c7 04 24 9c bc 5a c1 89
44 24 0c 8b 45 08 89 54 24 10 8b 55 0c 89 44 24 04 89 54 24 08 e8 0c
38 2a 00 <0f> 0b 0f 0b c7 45 18 01 00 00 00 c7 45 e4 00 00 00 00 e9
b5 fa

Message from syslogd@www at Sun Oct 14 12:01:34 2012 ...
www kernel: EIP: [<c1234d08>] __btrfs_map_block+0xa28/0xa50 SS:ESP
0068:f35e3b74



	If I try to mount in degraded mode I get this:

mount -o degraded /dev/sdd1 /mnt
Segmentation fault
www:# 
Message from syslogd@www at Sun Oct 14 12:04:02 2012 ...
www kernel: Process mount (pid: 4105, ti=f1608000 task=ecc43b50
task.ti=f1608000)

Message from syslogd@www at Sun Oct 14 12:04:02 2012 ...
www kernel: Stack:

Message from syslogd@www at Sun Oct 14 12:04:02 2012 ...
www kernel: Call Trace:

Message from syslogd@www at Sun Oct 14 12:04:02 2012 ...
www kernel: Code: 97 8b 5d 10 8b 03 8b 53 04 c7 04 24 9c bc 5a c1 89
44 24 0c 8b 45 08 89 54 24 10 8b 55 0c 89 44 24 04 89 54 24 08 e8 0c
38 2a 00 <0f> 0b 0f 0b c7 45 18 01 00 00 00 c7 45 e4 00 00 00 00 e9
b5 fa

Message from syslogd@www at Sun Oct 14 12:04:02 2012 ...
www kernel: EIP: [<c1234d08>] __btrfs_map_block+0xa28/0xa50 SS:ESP
0068:f1609b74



	And doing an fsck on the filesystem:

btrfsck /dev/sdd1
checksum verify failed on 17592485027840 wanted E22DE269 found 58
checksum verify failed on 17592485027840 wanted E22DE269 found 58
checksum verify failed on 17592485027840 wanted E22DE269 found 58
checksum verify failed on 17592485027840 wanted E22DE269 found 58
Csum didn't match
Couldn't read tree root
Critical roots corrupted, unable to fsck the FS



	Losing the data isn't the worst thing, it's mostly backup
data, but it's still 7TB of backup data that I'd like to try and
recover instead of having to copy over to a backup again.  Any
suggestions on how to get this filesystem back up and running again?


	Thanks,
	Kevin
