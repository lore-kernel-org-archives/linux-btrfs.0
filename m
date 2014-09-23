Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.galliera.it ([62.101.86.54]:44594 "EHLO smtp.galliera.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133AbaIWMUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 08:20:05 -0400
Received: from galliera.it (simoman.ceed [10.0.6.66])
	by smtp.galliera.it (Postfix) with ESMTP id 223A230F19CC
	for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 14:10:59 +0200 (CEST)
Date: Tue, 23 Sep 2014 14:06:41 +0200
From: Simone Ferretti <simone@galliera.it>
To: Majordomo@vger.kernel.org
Subject: mount problem
Message-ID: <20140923120641.GA27624@galliera.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

we're testing BTRFS on our Debian server.  After a lot of operations
simulating a RAID1 failure, every time I mount my BTRFS RAID1 volume
the kernel logs these messages:

[73894.436173] BTRFS: bdev /dev/etherd/e30.20 errs: wr 33036, rd 0, flush 0, corrupt 2806, gen 0
[73894.436181] BTRFS: bdev /dev/etherd/e60.28 errs: wr 244165, rd 0, flush 0, corrupt 1, gen 4

Everything seems to work nice but I'm courious to know what these
messages mean (in particular what do "gen" and "corrupt" mean?).

# uname -a
Linux dub 3.16-2-amd64 #1 SMP Debian 3.16.3-2 (2014-09-20) x86_64 GNU/Linux

# btrfs --version
Btrfs v3.16

# btrfs fi show
Label: 'btrfs_multiappliance'  uuid: 3452ffdd-c09b-43dd-9adb-cffde8518a72
        Total devices 2 FS bytes used 20.03GiB
        devid    1 size 1.82TiB used 24.03GiB path /dev/etherd/e30.20
        devid    2 size 3.64TiB used 24.03GiB path /dev/etherd/e60.28

# btrfs fi df /media/multiapp
Data, RAID1: total=22.00GiB, used=20.01GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=2.00GiB, used=21.23MiB
unknown, single: total=16.00MiB, used=0.00

# dmesg
[82932.655078] BTRFS info (device etherd/e30.20): disk space caching is enabled
[82932.678380] BTRFS: bdev /dev/etherd/e30.20 errs: wr 33036, rd 0, flush 0, corrupt 2806, gen 0
[82932.678388] BTRFS: bdev /dev/etherd/e60.28 errs: wr 244165, rd 0, flush 0, corrupt 1, gen 4


-- 
Thanks in advance,
Simone Ferretti
