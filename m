Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.zeus06.de ([194.117.254.36]:38334 "EHLO mail.zeus06.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbbKYLnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 06:43:14 -0500
To: linux-btrfs@vger.kernel.org
From: Mario <dev@kicherer.org>
Subject: Imbalanced RAID1 with three unequal disks
Message-ID: <56559D40.9050305@kicherer.org>
Date: Wed, 25 Nov 2015 12:36:32 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi,

I pushed a subvolume using send/receive to an 8 TB disk, added
two 4 TB disks and started a balance with conversion to RAID1.

Afterwards, I got the following:

   Total devices 3 FS bytes used 5.40TiB
   devid    1 size 7.28TiB used 4.54TiB path /dev/mapper/yellow4
   devid    2 size 3.64TiB used 3.17TiB path /dev/mapper/yellow1
   devid    3 size 3.64TiB used 3.17TiB path /dev/mapper/yellow2

   Btrfs v3.17
   Data, RAID1: total=5.43TiB, used=5.39TiB
   System, RAID1: total=64.00MiB, used=800.00KiB
   Metadata, RAID1: total=14.00GiB, used=5.55GiB
   GlobalReserve, single: total=512.00MiB, used=0.00B

In my understanding, the data isn't properly balanced and I
only get around 5.9TB of usable space. As suggested in #btrfs,
I started a second balance without filters and got this:

   Total devices 3 FS bytes used 5.40TiB
   devid    1 size 7.28TiB used 5.41TiB path /dev/mapper/yellow4
   devid    2 size 3.64TiB used 2.71TiB path /dev/mapper/yellow1
   devid    3 size 3.64TiB used 2.71TiB path /dev/mapper/yellow2

   Data, RAID1: total=5.41TiB, used=5.39TiB
   System, RAID1: total=32.00MiB, used=784.00KiB
   Metadata, RAID1: total=7.00GiB, used=5.54GiB
   GlobalReserve, single: total=512.00MiB, used=0.00B

   /dev/mapper/yellow4  7,3T    5,4T  969G   86% /mnt/yellow

Now, I get 6.3TB of usable space but, in my understand, I should
get around 7.28 TB or am I missing something here? Also, a second
balance shouldn't change the data distribution, right?

I'm using kernel v4.3 with a patch [1] from kernel bugzilla [2] for
the 8 TB SMR drive. The send/receive of a 5 TB subvolume worked
flawlessly with the patch. Without, I got a lot of errors in dmesg
within the first 200GB of transferred data. The OS is a x86_64
Ubuntu 15.04.

Thank you!
Mario

[1] 
http://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=bugzilla-93581&id=7c4fbd50bfece00abf529bc96ac989dd2bb83ca4
[2] https://bugzilla.kernel.org/show_bug.cgi?id=93581
