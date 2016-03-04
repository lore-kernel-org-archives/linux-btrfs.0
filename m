Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scarab.smoula.net ([83.240.14.6]:46318 "EHLO scarab.smoula.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759977AbcCDVUQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Mar 2016 16:20:16 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by scarab.smoula.net (Postfix) with ESMTP id 1601145C9429
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Mar 2016 22:11:03 +0100 (CET)
Received: from scarab.smoula.net ([127.0.0.1])
	by localhost (scarab.smoula.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Qxdnq6SiuEnG for <linux-btrfs@vger.kernel.org>;
	Fri,  4 Mar 2016 22:11:00 +0100 (CET)
Received: from roundcube.smoula.net (localhost.localdomain [127.0.0.1])
	by scarab.smoula.net (Postfix) with ESMTPA id 3E88145C9414
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Mar 2016 22:11:00 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 04 Mar 2016 22:10:57 +0100
From: nexus@smoula.net
To: linux-btrfs@vger.kernel.org
Subject: ENOSPC while creating snapshot
Message-ID: <c2e396477401f3441bdc364456b399f4@smoula.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm encountering weird enospc problem while writing to filesystem and 
creating snapshot at a same time:

Steps to reproduce:

start writing data to filesystem:

# LC_ALL=C dd if=/dev/zero of=/foobar
dd: writing to '/foobar': No space left on device
3003803+0 records in
3003802+0 records out
1537946624 bytes (1.5 GB, 1.4 GiB) copied, 10.8072 s, 142 MB/s

in other terminal create read-only (or r/w - results are the same)
# btrfs sub snap -r / /.snap1
Create a readonly snapshot of '/' in '//.snap1'

while creating this snapshot, ENOSPC is produced.

Interesting is that I can reproduce this on some filesystems but not on 
others while all of available information are the same. There IS free 
space in data, metadata and global reserve.

I've tried balancing and defragmenting with no success. I've tried 
debugging by using enospc_debug but nothing is written to dmesg or any 
system log

Does anybody have a clue what may be the cause?

# uname -a
Linux interceptor 4.4.3-1-ARCH #1 SMP PREEMPT Fri Feb 26 15:09:29 CET 
2016 x86_64 GNU/Linux

# btrfs --version
btrfs-progs v4.4.1

# btrfs fi show
Label: none  uuid: 859dec5c-850c-4660-ad99-bc87456aa309
     Total devices 1 FS bytes used 116.72GiB
     devid    1 size 200.00GiB used 121.03GiB path 
/dev/mapper/vg0-btrfsroot

# btrfs fi df /
Data, single: total=117.00GiB, used=113.68GiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=4.00GiB, used=3.04GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

# dmesg | tail
[   15.618995] cfg80211:  DFS Master region: ETSI
[   15.618996] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp), (dfs_cac_time)
[   15.618998] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), 
(N/A, 2000 mBm), (N/A)
[   15.619000] cfg80211:   (5150000 KHz - 5250000 KHz @ 80000 KHz, 
200000 KHz AUTO), (N/A, 2301 mBm), (N/A)
[   15.619001] cfg80211:   (5250000 KHz - 5350000 KHz @ 80000 KHz, 
200000 KHz AUTO), (N/A, 2000 mBm), (0 s)
[   15.619002] cfg80211:   (5470000 KHz - 5725000 KHz @ 160000 KHz), 
(N/A, 2698 mBm), (0 s)
[   15.619003] cfg80211:   (57000000 KHz - 66000000 KHz @ 2160000 KHz), 
(N/A, 4000 mBm), (N/A)
[   15.792765] brcmsmac bcma0:1: brcms_ops_bss_info_changed: arp 
filtering: 1 addresses (implement)
[   20.411931] tun: Universal TUN/TAP device driver, 1.6
[   20.411938] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>

# mount | grep root
/dev/mapper/vg0-btrfsroot on / type btrfs 
(rw,noatime,nodatasum,nodatacow,ssd,discard,space_cache,enospc_debug,commit=900,subvolid=5,subvol=/)

Thanks for any insight!

Best regards,

Martin Mlynar
