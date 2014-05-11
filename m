Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 27-32-84-95.static.tpgi.com.au ([27.32.84.95]:40803 "EHLO
	array.commandict.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752038AbaEKICs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 May 2014 04:02:48 -0400
Received: from array.commandict.com.au (localhost [127.0.0.1])
	by array.commandict.com.au (Postfix) with ESMTP id D4B5B93E
	for <linux-btrfs@vger.kernel.org>; Sun, 11 May 2014 17:53:41 +1000 (EST)
Received: (from brett@localhost)
	by array.commandict.com.au (8.14.8/8.14.8/Submit) id s4B7reS4024218
	for linux-btrfs@vger.kernel.org; Sun, 11 May 2014 17:53:40 +1000
Date: Sun, 11 May 2014 17:53:40 +1000
From: brett.king@commandict.com.au
To: linux-btrfs@vger.kernel.org
Subject: RAID10 across different sized disks shows data layout as single
 not RAID10
Message-ID: <536f2c84.B0TBIV79nRteuoU7%brett.king@commandict.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I created a RAID10 array of 4x 4TB disks and later added another 4x 3TB disks, expecting the result to be the same level of fault tolerance however with simply more capacity. Recently I noticed the output of 'btrfs fi df' lists the Data layout as 'single' and not RAID10 per my initial mkfs.btrfs -d raid10 -m raid10 /dev/... command.

Is this single data layout due to the overall inconsistent disk size used ? e.g. it can no longer fully stripe across all disks hence simply concatenates the subsequent smaller disks and displays this as an overall 'single' Data layout.

I require fault tolerance hence ultimately want to know if I actually do have a RAID10 data layout, else should try perhaps a 'btrfs fi balance start -dconvert=raid10 /export' (assuming enough free space exists).

I also noticed there are 2x System layouts shown, which leads me to think perhaps the first disks (4x4TB) are laid out as RAID10 for Data however the subsequent disks (4x3TB) are simply concatenated, giving me hopefully a limited level of fault tolerance for now.

[root@array ~]# uname -a
Linux array.commandict.com.au 3.14.2-200.fc20.x86_64 #1 SMP Mon Apr 28 14:40:57 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
[root@array ~]# btrfs --version
Btrfs v3.12
[root@array ~]# btrfs fi show
Label: export  uuid: 22c7663a-93ca-40a6-9491-26abaa62b924
        Total devices 8 FS bytes used 12.66TiB
        devid    1 size 3.64TiB used 2.12TiB path /dev/sda
        devid    2 size 3.64TiB used 2.12TiB path /dev/sde
        devid    3 size 3.64TiB used 2.12TiB path /dev/sdi
        devid    4 size 3.64TiB used 2.12TiB path /dev/sdg
        devid    5 size 2.73TiB used 1.21TiB path /dev/sdb
        devid    6 size 2.73TiB used 1.21TiB path /dev/sdf
        devid    7 size 2.73TiB used 1.21TiB path /dev/sdh
        devid    8 size 2.73TiB used 1.21TiB path /dev/sdj

Btrfs v3.12
[root@array ~]# btrfs fi df /export
Data, single: total=13.25TiB, used=12.65TiB
System, RAID10: total=64.00MiB, used=1.41MiB
System, single: total=4.00MiB, used=0.00
Metadata, RAID10: total=19.00GiB, used=16.47GiB
[root@array ~]#

Thanks in advance,
Brett.
