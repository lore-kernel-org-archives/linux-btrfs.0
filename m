Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:50609 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab3G1EQC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jul 2013 00:16:02 -0400
Received: by mail-wi0-f177.google.com with SMTP id hq12so1360367wib.10
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Jul 2013 21:16:00 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 28 Jul 2013 00:16:00 -0400
Message-ID: <CAJwq8q6T0jziOi37OPYbTxQdsnot3Ansm46sWyR26=bxjs0nJw@mail.gmail.com>
Subject: Metadata chunk fragmentation?
From: Jeremy Atkins <antrat@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 5 drive btrfs pool that seems to be getting slow

If i start/cancel a rebalance on metadata, it will take 15 to 20
minutes to do 1 chunk, then in dmesg i'll see this:

-mconvert=raid5
[Sat Jul 27 22:16:12 2013] btrfs: relocating block group 18228861403136 flags 20
[Sat Jul 27 22:31:53 2013] btrfs: found 86835 extents
-mconvert=raid1,soft
[Sat Jul 27 22:37:02 2013] btrfs: relocating block group
18230102917120 flags 132
[Sat Jul 27 22:58:16 2013] btrfs: found 88595 extents

My main question I wanted to know is, Should I even care about the
large number of extents, because when I converted all of the metadata
from raid10 to raid1, most of the chunks 100k+ extents. If i should
care, is there a way to defragment the actual chunks?

More info about my system:
kernel 3.9.9-301.fc19.x86_64
dual core 2.2ghz, 4gb ram

$ btrfs fi df /
Data, RAID10: total=3.41TB, used=3.10TB
System, RAID1: total=32.00MB, used=396.00KB
Metadata, RAID1: total=6.00GB, used=4.33GB

$ sudo btrfs fi sh
Label: 'btrfs_tank'  uuid: b0ad55e2-09e0-4658-8cab-d2e11ba03753
        Total devices 6 FS bytes used 3.10TB
        devid    8 size 1.36TB used 1.10TB path /dev/sde1
        devid    2 size 1.81TB used 1.50TB path /dev/sdd4
        devid    6 size 1.82TB used 1.56TB path /dev/sdc1
        devid    5 size 1.36TB used 1.11TB path /dev/sdb1
        devid    7 size 1.82TB used 1.56TB path /dev/sda1
        *** Some devices missing

The missing device... is a different cosmetic problem, happened a long
time ago when I had failing drive, added new drive. did did device
remove, rebooted after it finished and then it started saying
missing...
$ sudo btrfs dev delete missing /
$ dmesg |tail -n1
[1662429.066371] btrfs: no missing devices found to remove
