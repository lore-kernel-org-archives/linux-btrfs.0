Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw4a.wadns.net ([196.220.39.46]:61967 "EHLO fw4a.wadns.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932903AbaLBThQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Dec 2014 14:37:16 -0500
Message-ID: <547E117A.1050904@swiftspirit.co.za>
Date: Tue, 02 Dec 2014 21:22:34 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>
Subject: Another "No space left" balance failure with plenty of space available
References: <E1XvWMF-0000AJ-VQ@watricky.valid.co.za>
In-Reply-To: <E1XvWMF-0000AJ-VQ@watricky.valid.co.za>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey, guys

This is on my ArchLinux desktop. Current values as follows and the exact 
error is currently reproducible. Let me know if you want me to run any 
tests/etc. I've made an image (76MB) and can send the link to interested 
parties.

I have come across this once before in the last few weeks. The 
workaround at that time was to run multiple balances with incrementing 
-musage and -dusage values. Whether or not that was a real, imaginary, 
or temporary fix is another story. I have backups but the issue doesn't 
yet appear to cause any symptoms other than these errors.

The drive is a second-hand 60GB Intel 330 recycled from a decommissioned 
server. The mkfs was run on Nov 4th before I started a migration from 
spinning rust. According to my pacman logs btrfs-progs was on 3.17-1 and 
kernel was 3.17.1-1

root ~ $ uname -a
Linux watricky.invalid.co.za 3.17.4-1-ARCH #1 SMP PREEMPT Fri Nov 21 
21:14:42 CET 2014 x86_64 GNU/Linux
root ~ $ btrfs fi show /
Label: 'arch-btrfs-root'  uuid: 782a0edc-1848-42ea-91cb-de8334f0c248
     Total devices 1 FS bytes used 17.44GiB
     devid    1 size 40.00GiB used 20.31GiB path /dev/sdc1

Btrfs v3.17.2
root ~ $ btrfs fi df /
Data, single: total=18.00GiB, used=16.72GiB
System, DUP: total=32.00MiB, used=16.00KiB
Metadata, DUP: total=1.12GiB, used=738.67MiB
GlobalReserve, single: total=256.00MiB, used=0.00B

Relevant kernel lines:
root ~ $ journalctl -k | grep ^Dec\ 01\ 21\:
Dec 01 21:10:01 watricky.invalid.co.za kernel: BTRFS info (device sdc1): 
relocating block group 46166704128 flags 36
Dec 01 21:10:03 watricky.invalid.co.za kernel: BTRFS info (device sdc1): 
found 2194 extents
Dec 01 21:10:03 watricky.invalid.co.za kernel: BTRFS info (device sdc1): 
relocating block group 45059407872 flags 34
Dec 01 21:10:03 watricky.invalid.co.za kernel: BTRFS info (device sdc1): 
found 1 extents
Dec 01 21:10:03 watricky.invalid.co.za kernel: BTRFS info (device sdc1): 
1 enospc errors during balance


-------- Original Message --------
Subject: 	Cron <root@watricky> /usr/bin/btrfs balance start -musage=90 / 
2>&1 > /dev/null
Date: 	Mon, 01 Dec 2014 21:10:03 +0200
From: 	(Cron Daemon) <root@watricky.valid.co.za>
To: 	brendan@swiftspirit.co.za



ERROR: error during balancing '/' - No space left on device
There may be more info in syslog - try dmesg | tail



