Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:43395 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751449Ab3GTFhi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Jul 2013 01:37:38 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 47D023C4D70
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jul 2013 07:37:34 +0200 (CEST)
Received: from localhost (cm-171-100-230-72.revip10.asianet.co.th [171.100.230.72])
	by mail.virtall.com (Postfix) with ESMTPSA id 78E463C4D1D
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Jul 2013 07:37:33 +0200 (CEST)
Date: Sat, 20 Jul 2013 13:37:26 +0800
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: linux-btrfs@vger.kernel.org
Subject: abysmal rm performance?
Message-ID: <20130720133726.7c2e1314@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using 3.10 with a btrfs filesystem with RAID-1 (on two drives),
with extended inode refs and skinny metadata extent refs enabled (-r
and -x options in btrfstune).

Server has 32 GB RAM.

Filesystem is mounted with noatime,compress-force=zlib mount options.


btrfs performs really, really poor when removing files.


Some examples - removing files for 10 seconds, repeated 10 times in a
row.
Each time, we measure how many files we removed, and amount of memory
we have to write to disk after rm operation ("Dirty"
from /proc/meminfo):

TIMEOUT=10s
sync
timeout $TIMEOUT rm -rfv trash_dir/ &>/tmp/rmout.log
wc -l /tmp/rmout.log
grep Dirty /proc/meminfo 


Removed files:    4319
Dirty:            211956 kB

Removed files:    3392
Dirty:            190764 kB

Removed files:    4011
Dirty:            174636 kB

Removed files:    5197
Dirty:            191500 kB

Removed files:    6395
Dirty:            202532 kB

Removed files:    4613
Dirty:            354764 kB

Removed files:    5469
Dirty:            170664 kB

Removed files:    4654
Dirty:            170876 kB

Removed files:    2245
Dirty:            152108 kB

Removed files:    2214
Dirty:            149848 kB


Compare it to ext4 - note "Dirty" is an order of magnitude lower for
ext4:

Removed files:      7346
Dirty:              4896 kB

Removed files:      11770
Dirty:              3536 kB

Removed files:      4266
Dirty:              80 kB

Removed files:      7541
Dirty:              4164 kB

Removed files:      8046
Dirty:              5428 kB

Removed files:      9630
Dirty:              5884 kB

Removed files:      14276
Dirty:              8384 kB

Removed files:      34234
Dirty:              10968 kB

Removed files:      10594
Dirty:              4348 kB

Removed files:      22672
Dirty:              4164 kB



File removal is actually quite fast until we reach around 350000 kB in
"Dirty" (this is with 32 GB RAM). Then, it's super slow.
Let's see what happens if we remove the files for 1 minute (above was
for just 10 secs):

btrfs:

Removed files:      18360
Dirty:              98276 kB

Removed files:      9913
Dirty:              60664 kB

Removed files:      10973
Dirty:              62284 kB

Removed files:      16606
Dirty:              275156 kB

Removed files:      13002
Dirty:              165844 kB

Removed files:      8349
Dirty:              178448 kB

Removed files:      20316
Dirty:              394912 kB

Removed files:      19109
Dirty:              321252 kB

Removed files:      22738
Dirty:              277964 kB

Removed files:      15288
Dirty:              41400 kB



ext4:

Removed files:      91714
Dirty:              7060 kB

Removed files:      79574
Dirty:              400 kB

Removed files:      105167
Dirty:              5384 kB

Removed files:      37123
Dirty:              25572 kB

Removed files:      94048
Dirty:              13708 kB

Removed files:      149079
Dirty:              48592 kB

Removed files:      136770
Dirty:              528 kB

Removed files:      169513
Dirty:              21024 kB

Removed files:      171877
Dirty:              1936 kB

Removed files:      95442
Dirty:              7780 kB



So it looks like removing files with btrfs needs much more metadata
updates?


-- 
Tomasz Chmielewski
http://wpkg.org
