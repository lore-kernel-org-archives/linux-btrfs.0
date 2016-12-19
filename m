Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i4.italiaonline.it ([212.48.25.213]:54251 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933595AbcLSSzd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 13:55:33 -0500
From: Giuseppe Della Bianca <bepi@adria.it>
To: Xin Zhou <xin.zhou@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
Date: Mon, 19 Dec 2016 19:55:17 +0100
Message-ID: <1843121.XhPNI7cFmJ@exnet.gdb.it>
In-Reply-To: <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>
References: <1479730155.5832e3eb3fde8@webmail.adria.it> <9712851.I7FUyRd5GC@exnet.gdb.it> <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

a concrete example


SNAPSHOT

/dev/nvme0n1p2 on /tmp/tmp.X3vU6dLLVI type btrfs (rw,relatime,ssd,space_cache,subvolid=5,subvol=/)

btrfsManage SNAPSHOT /

(2016-12-19 19:44:00) Start btrfsManage
. . . Start managing SNAPSHOT ' / ' filesystem ' root ' snapshot

In ' btrfssnapshot ' latest source snapshot ' root-2016-12-18_15:10:01.40 '
. . . date ' 2016-12-18_15:10:01 ' number ' 40 '

Creation ' root-2016-12-19_19:44:00.part ' snapshot from ' root ' subvolume
. . . Create a readonly snapshot of '/tmp/tmp.X3vU6dLLVI/root' in '/tmp/tmp.X3vU6dLLVI/btrfssnapshot/root/root-2016-12-19_19:44:00.part'

Renaming ' root-2016-12-19_19:44:00.part ' into ' root-2016-12-19_19:44:00.41 ' snapshot

Source snapshot list of ' root ' subvolume
. . . btrfssnapshot/root/root-2016-08-28-12-35-01.1
]zac[
. . . btrfssnapshot/root/root-2016-12-19_19:44:00.41

(2016-12-19 19:44:05) End btrfsManage
. . . End managing SNAPSHOT ' / ' filesystem ' root ' snapshot
CORRECTLY



SEND e RECEIVE

/dev/nvme0n1p2 on /tmp/tmp.o78czE0Bo6 type btrfs (rw,relatime,ssd,space_cache,subvolid=5,subvol=/)
/dev/sda2 on /tmp/tmp.XcwqQCKq09 type btrfs (rw,relatime,space_cache,subvolid=5,subvol=/)

btrfsManage SEND / /dev/sda2

(2016-12-19 19:47:24) Start btrfsManage
. . . Start managing SEND ' / ' filesystem ' root ' snapshot in ' /dev/sda2 '

Sending ' root-2016-12-19_19:44:00.41 ' source snapshot to ' btrfsreceive ' subvolume
. . . btrfs send -p /tmp/tmp.o78czE0Bo6/btrfssnapshot/root/root-2016-12-18_15:10:01.40 /tmp/tmp.o78czE0Bo6/btrfssnapshot/root/root-2016-12-19_19:44:00.41 | btrfs receive /tmp/tmp.XcwqQCKq09/btrfsreceive/root/.part/
. . . At subvol /tmp/tmp.o78czE0Bo6/btrfssnapshot/root/root-2016-12-19_19:44:00.41
. . . At snapshot root-2016-12-19_19:44:00.41

Creation ' root-2016-12-19_19:44:00.41 ' snapshot from ' .part/root-2016-12-19_19:44:00.41 ' subvolume
. . . Create a readonly snapshot of '/tmp/tmp.XcwqQCKq09/btrfsreceive/root/.part/root-2016-12-19_19:44:00.41' in '/tmp/tmp.XcwqQCKq09/btrfsreceive/root/root-2016-12-19_19:44:00.41'
. . . Delete subvolume (commit): '/tmp/tmp.XcwqQCKq09/btrfsreceive/root/.part/root-2016-12-19_19:44:00.41'

Snapshot list in ' /dev/sda2 ' device
. . . btrfsreceive/data_backup/data_backup-2016-12-17_12:07:00.1
. . . btrfsreceive/data_storage/data_storage-2016-12-10_17:05:51.1
. . . btrfsreceive/root/root-2016-08-28-12-35-01.1
]zac[
. . . btrfsreceive/root/root-2016-12-19_19:44:00.41

(2016-12-19 19:48:37) End btrfsManage
. . . End managing SEND ' / ' filesystem ' root ' snapshot in ' /dev/sda2 '
CORRECTLY



> Hi Giuseppe,
> 
> Would you like to tell some details about:
> 1. the XYZ snapshot was taken from which subvolume
> 2. where the base (initial) snapshot is stored
> 3. The 3 partitions receives the same snapshot, are they in the same btrfs
> configuration and subvol structure?
> 
> Also, would you send the link reports "two files unreadable error" post
> mentioned in step 2? Hope can see the message and figure out if the issue
> first comes from sender or receiver side.
> 
> Thanks,
> Xin
>  
> 

