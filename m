Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:32871 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcEOSoW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 May 2016 14:44:22 -0400
Received: by mail-pa0-f52.google.com with SMTP id xk12so57505395pac.0
        for <linux-btrfs@vger.kernel.org>; Sun, 15 May 2016 11:44:16 -0700 (PDT)
Message-ID: <1463337834.4626.14.camel@clone1.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: "Richard A. Lochner" <lochner@clone1.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Sun, 15 May 2016 13:43:54 -0500
In-Reply-To: <CAJCQCtSNwpaPs6jWFxzoHdUFJUyUZFjX6vocYf7RCWc=f_n5Hg@mail.gmail.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
	 <1463075341.3636.56.camel@clone1.com>
	 <CAJCQCtSSbv5dAC-uBN9RnYKKRMtr04KmLZVzhvAh7=Xq3ej7dQ@mail.gmail.com>
	 <1463114957.3636.140.camel@clone1.com>
	 <CAJCQCtSNwpaPs6jWFxzoHdUFJUyUZFjX6vocYf7RCWc=f_n5Hg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

I have some interesting news.  In the process of trying to prepare some
clean logs for you, a new error showed up in my scrub.  It is another
very large file (500+ GB) that has been "at rest" for at least 5 months
(it has a timestamp of 1/4/15, but was actually copied around
December).  In this case, I do have the original file on a freenas zfs
volume.  

The file has one bad data block (4096 bytes).  The data in the bad
block matches on both btrfs mirrors, and it matches to the data on zfs.

This proves to me that the error is in the metadata.

There is clearly something with my hardware that is allowing metadata
corruption to happen, albeit relatively infrequently (3 times in 6
months).

In any event, the commands I ran and the associated log entries folow.

Rick Lochner

# mount /dev/sdb1 /mnt

# ls -l /mnt/backup/Rick/sda4.img
-rw-r--r--. 1 root root 75959197696 Dec 27 10:36
/mnt/backup/Rick/sda4.img

# ls -l /mnt/backup/freenas/Backups/Rick/crw2k3s1_share.img
-rwxrwxr-x. 1 1556 1999 536870912000 Jan  4  2015
/mnt/backup/freenas/Backups/Rick/crw2k3s1_share.img

# dd if=/mnt/backup/Rick/sda4.img of=/dev/null
dd: error reading ‘/mnt/backup/Rick/sda4.img’: Input/output error
147957752+0 records in
147957752+0 records out
75754369024 bytes (76 GB) copied, 610.88 s, 124 MB/s

# btrfs scrub start /mnt

# btrfs scrub status /mnt
scrub status for d397ff55-e5c8-4d31-966e-d65694997451
	scrub started at Sun May 15 06:07:37 2016 and finished after
04:49:54
	total bytes scrubbed: 4.64TiB with 3 errors
	error details: csum=3
	corrected errors: 0, uncorrectable errors: 3, unverified
errors: 0

# btrfs fi sh /mnt
Label: 'raid_pool'  uuid: d397ff55-e5c8-4d31-966e-d65694997451
	Total devices 2 FS bytes used 2.32TiB
	devid    1 size 3.00TiB used 2.32TiB path /dev/sdb1
	devid    2 size 3.00TiB used 2.32TiB path /dev/sdc1

The log contained the following messages (the first four from the
mount, the next five from the dd, the last three from the scrub):

[ 2451.050107] BTRFS info (device sdc1): disk space caching is enabled
[ 2451.050112] BTRFS: has skinny extents
[ 2451.157276] BTRFS info (device sdc1): bdev /dev/sdc1 errs: wr 0, rd
13, flush 0, corrupt 4, gen 0
[ 2451.157284] BTRFS info (device sdc1): bdev /dev/sdb1 errs: wr 0, rd
0, flush 0, corrupt 5, gen 0

[ 3118.415249] BTRFS warning (device sdc1): csum failed ino 1437377 off
75754369024 csum 1689728329 expected csum 2165338402
[ 3118.481373] BTRFS warning (device sdc1): csum failed ino 1437377 off
75754369024 csum 1689728329 expected csum 2165338402
[ 3118.490322] BTRFS warning (device sdc1): csum failed ino 1437377 off
75754369024 csum 1689728329 expected csum 2165338402
[ 3118.497292] BTRFS warning (device sdc1): csum failed ino 1437377 off
75754369024 csum 1689728329 expected csum 2165338402
[ 3118.497465] BTRFS warning (device sdc1): csum failed ino 1437377 off
75754369024 csum 1689728329 expected csum 2165338402

[11353.723860] BTRFS warning (device sdc1): checksum error at logical
1279007596544 on dev /dev/sdc1, sector 2498022800, root 259, inode
3715, offset 271 776 030 720, length 4096, links 1 (path:
freenas/Backups/Rick/crw2k3s1_share.img)
[11353.723884] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr 0, rd
13, flush 0, corrupt 5, gen 0
[11353.734409] BTRFS error (device sdc1): unable to fixup (regular)
error at logical 1279007596544 on dev /dev/sdc1

[19446.539490] BTRFS warning (device sdc1): checksum error at logical
3037444042752 on dev /dev/sdb1, sector 4988789496, root 259, inode
1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
[19446.539503] BTRFS error (device sdc1): bdev /dev/sdb1 errs: wr 0, rd
0, flush 0, corrupt 6, gen 0
[19446.544776] BTRFS error (device sdc1): unable to fixup (regular)
error at logical 3037444042752 on dev /dev/sdb1

[20570.969126] BTRFS warning (device sdc1): checksum error at logical
3037444042752 on dev /dev/sdc1, sector 4988750584, root 259, inode
1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
[20570.969147] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr 0, rd
13, flush 0, corrupt 6, gen 0
[20570.983318] BTRFS error (device sdc1): unable to fixup (regular)
error at logical 3037444042752 on dev /dev/sdc1

On Fri, 2016-05-13 at 11:46 -0600, Chris Murphy wrote:
> On Thu, May 12, 2016 at 10:49 PM, Richard A. Lochner <lochner@clone1.
> com> wrote:
> 
> > 
> > My apologies, they were from different boots.  After the dd, I get
> > these:
> > 
> > [109479.550836] BTRFS warning (device sdb1): csum failed ino
> > 1437377
> > off 75754369024 csum 1689728329 expected csum 2165338402
> > [109479.596626] BTRFS warning (device sdb1): csum failed ino
> > 1437377
> > off 75754369024 csum 1689728329 expected csum 2165338402
> > [109479.601969] BTRFS warning (device sdb1): csum failed ino
> > 1437377
> > off 75754369024 csum 1689728329 expected csum 2165338402
> > [109479.602189] BTRFS warning (device sdb1): csum failed ino
> > 1437377
> > off 75754369024 csum 1689728329 expected csum 2165338402
> > [109479.602323] BTRFS warning (device sdb1): csum failed ino
> > 1437377
> > off 75754369024 csum 1689728329 expected csum 2165338402
> That's it? Only errors from sdb1? And this time no attempt to fix it?
> 
> Normally when there is failure to match data checksums stored in
> metadata to the newly computed data checksums as the blocks are read
> there's an attempt to read the mismatching blocks from another
> stripe.
> I don't see that this is being attempted.
> 
> 
> > 
> > > 
> > > 
> > > Also what do you get for these for each device:
> > > 
> > > smartctl scterc -l /dev/sdX
> > > cat /sys/block/sdX/device/timeout
> > > 
> > # smartctl -l scterc  /dev/sdb
> > sartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.4.8-300.fc23.x86_64]
> > (local build)
> > Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmont
> > ools
> > .org
> > 
> > SCT Error Recovery Control:
> >            Read:     70 (7.0 seconds)
> >           Write:     70 (7.0 seconds)
> > 
> > # smartctl -l scterc  /dev/sdc
> > smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.4.8-300.fc23.x86_64]
> > (local build)
> > Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmont
> > ools
> > .org
> > 
> > SCT Error Recovery Control:
> >            Read:     70 (7.0 seconds)
> >           Write:     70 (7.0 seconds)
> > 
> > # cat /sys/block/sdb/device/timeout
> > 30
> > # cat /sys/block/sdc/device/timeout
> > 30
> > > 
> > > 
> That's appropriate. So at least any failures have a chance of being
> fixed before the command timer does a reset on the bus.
> 
> 
