Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:49863 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751359AbcLTRnQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Dec 2016 12:43:16 -0500
MIME-Version: 1.0
Message-ID: <trinity-f5b0b96e-286c-4485-a02e-1f96bca7a906-1482255789582@3capp-mailcom-bs06>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: "Giuseppe Della Bianca" <bepi@adria.it>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system
 during the snapshot receive
Content-Type: text/plain; charset=UTF-8
Date: Tue, 20 Dec 2016 18:43:09 +0100
In-Reply-To: <1843121.XhPNI7cFmJ@exnet.gdb.it>
References: <1479730155.5832e3eb3fde8@webmail.adria.it>
 <9712851.I7FUyRd5GC@exnet.gdb.it>
 <trinity-46cbb3e7-b072-4e9a-a504-e67b58cc9c9c-1482096970056@3capp-mailcom-bs08>,
 <1843121.XhPNI7cFmJ@exnet.gdb.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

The system seems running some customized scripts continuously backup data from a NVME drive to HDDs.
If the 3 HDDs backup storage are same in btrfs config, and the there is a bug in btrfs code,
they all suppose to fail after the same operation sequence.

Otherwise, probably one of the HDDs might have issue, or there is a bug in layer below btrfs.

For the customize script, it might be helpful to check the file system consistency after each transfer.
That might be useful to figure out which step generates a corruption, and if there is error propagations.

Regards,
Xin
 
 

Sent: Monday, December 19, 2016 at 10:55 AM
From: "Giuseppe Della Bianca" <bepi@adria.it>
To: "Xin Zhou" <xin.zhou@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [CORRUPTION FILESYSTEM] Corrupted and unrecoverable file system during the snapshot receive
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
 
