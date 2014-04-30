Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:53111 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaD3D35 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 23:29:57 -0400
Received: from athena.localnet (unknown [10.10.10.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 81BD220901
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Apr 2014 13:29:50 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Reply-To: russell@coker.com.au
Subject: corrected read errors and error counts in 3.14
Date: Wed, 30 Apr 2014 13:29:49 +1000
Message-ID: <9854809.Zt0QUGBWD4@russell.coker.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've got a system running the Debian kernel package of 3.14.1.  It uses BTRFS 
for root and for a backup device.  It seems that the backup device (a 2TB SATA 
disk in a USB enclosure) is failing and I'm getting a lot of messages saying 
"BTRFS: read error corrected".

I guess that it's all metadata that's affected by the read errors - which isn't 
surprising as an rsync backup without the -c option doesn't read much file 
data.

So far dmesg reports that there are 50 read errors corrected, so well done 
BTRFS for doing that (although the non-dup data is probably trashed).  But the 
command "btrfs device stats /mnt/backup" reports that there are only 2 
"read_io_errs".  What's going on here?  Does it only update the stats when the 
filesystem is unmounted or something?

I'll probably partition the disk into two equal size partitions and keep using 
it for backups.  That might not be so useful for backups (I also use good 
disks for backing up data) but should be good for testing BTRFS.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

