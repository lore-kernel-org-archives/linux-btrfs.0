Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:36821 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbcELRtR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 May 2016 13:49:17 -0400
Received: by mail-pf0-f169.google.com with SMTP id c189so34244645pfb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 12 May 2016 10:49:17 -0700 (PDT)
Message-ID: <1463075341.3636.56.camel@clone1.com>
Subject: Re: BTRFS Data at Rest File Corruption
From: "Richard A. Lochner" <lochner@clone1.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Thu, 12 May 2016 12:49:01 -0500
In-Reply-To: <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
References: <CACTfMoQmco=yBP+e8tn0MoTVZsMauw0_=N1yc42NVNM9Krqv7A@mail.gmail.com>
	 <97b8a0bd-3707-c7d6-4138-c8fe81937b72@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin,

I rebooted the computer and reran the scrub to no avail.  The error is
consistent.

The reason I brought this question to the mailing list is because it
seemed like a situation that might be of interest to the developers.
 Perhaps, there might be a way to "defend" against this type of
corruption.

I suspected, and I still suspect that the error occurred upon a
metadata update that corrupted the checksum for the file, probably due
to silent memory corruption.  If the checksum was silently corrupted,
it would be simply written to both drives causing this type of error.

With that in mind, I proved (see below) that the data blocks match on
both mirrors.  This I expected since the data blocks should not have
been touched as the the file has not been written.

This is the sequence of events as I see them that I think might be of
interest to the developers.

1. A block containing a checksum for the file was read into memory.
The block read would have been checksummed, so the checksum for the
file must have been good at that moment.

2. The checksum block was the altered in memory (perhaps to add or
change a value).

3. A new checksum would then have been calculated for the checksum
block.

4. The checksum block would have been written to both mirrors.

Presumably, in the case that I am experiencing, an undetected memory
error must have occurred after 1 and before step 3 was completed.

I wonder if there is a way to correct or detect that situation.  

As I stated previously, the machine on which this occurred does not
have ECC memory, however, I would not think that the majority of users
running btrfs do either.  If it has happened to me, it likely has
happened to others.

Rick Lochner

btrfs dmesg(s):

[16510.334020] BTRFS warning (device sdb1): checksum error at logical
3037444042752 on dev /dev/sdb1, sector 4988789496, root 259, inode
1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
[16510.334043] BTRFS error (device sdb1): bdev /dev/sdb1 errs: wr 0, rd
0, flush 0, corrupt 5, gen 0
[16510.345662] BTRFS error (device sdb1): unable to fixup (regular)
error at logical 3037444042752 on dev /dev/sdb1

[17606.978439] BTRFS warning (device sdb1): checksum error at logical
3037444042752 on dev /dev/sdc1, sector 4988750584, root 259, inode
1437377, offset 75754369024, length 4096, links 1 (path: Rick/sda4.img)
[17606.978460] BTRFS error (device sdb1): bdev /dev/sdc1 errs: wr 0, rd
13, flush 0, corrupt 4, gen 0
[17606.989497] BTRFS error (device sdb1): unable to fixup (regular)
error at logical 3037444042752 on dev /dev/sdc1

How I compared the data blocks:

#btrfs-map-logical -l 3037444042752  /dev/sdc1
mirror 1 logical 3037444042752 physical 2554240299008 device /dev/sdc1
mirror 1 logical 3037444046848 physical 2554240303104 device /dev/sdc1
mirror 2 logical 3037444042752 physical 2554260221952 device /dev/sdb1
mirror 2 logical 3037444046848 physical 2554260226048 device /dev/sdb1

#dd if=/dev/sdc1 bs=1 skip=2554240299008 count=4096 of=c1
4096+0 records in
4096+0 records out
4096 bytes (4.1 kB) copied, 0.0292201 s, 140 kB/s

#dd if=/dev/sdc1 bs=1 skip=2554240303104 count=4096 of=c2
4096+0 records in
4096+0 records out
4096 bytes (4.1 kB) copied, 0.0142381 s, 288 kB/s

#dd if=/dev/sdb1 bs=1 skip=2554260221952 count=4096 of=b1
4096+0 records in
4096+0 records out
4096 bytes (4.1 kB) copied, 0.0293211 s, 140 kB/s

#dd if=/dev/sdb1 bs=1 skip=2554260226048 count=4096 of=b2
4096+0 records in
4096+0 records out
4096 bytes (4.1 kB) copied, 0.0151947 s, 270 kB/s

#diff b1 c1
#diff b2 c2

> 
On Wed, 2016-05-11 at 15:26 -0400, Austin S. Hemmelgarn wrote:
On 2016-05-11 14:36, Richard Lochner wrote:
> > 
> > Hello,
> > 
> > I have encountered a data corruption error with BTRFS which may or
> > may
> > not be of interest to your developers.
> > 
> > The problem is that an unmodified file on a RAID-1 volume that had
> > been scrubbed successfully is now corrupt.  The details follow.
> > 
> > The volume was formatted as btrfs with raid1 data and raid1
> > metadata
> > on two new 4T hard drives (WD Data Center Re WD4000FYYZ) .
> > 
> > A large binary file was copied to the volume (~76 GB) on December
> > 27,
> > 2015.  Soon after copying the file, a btrfs scrub was run. There
> > were
> > no errors.  Multiple scrubs have also been run over the past
> > several
> > months.
> > 
> > Recently, a scrub returned an unrecoverable error on that file.
> > Again, the file has not been modified since it was originally
> > copied
> > and has the time stamp from December.  Furthermore, SMART tests
> > (long)
> > for both drives do not indicate any errors (Current_Pending_Sector
> > or
> > otherwise).
> > 
> > I should note that the system does not have ECC memory.
> > 
> > It would be interesting to me to know if:
> > 
> > a) The primary and secondary data blocks match (I suspect they do),
> > and
> > b) The primary and secondary checksums for the block match (I
> > suspect
> > they do as well)
> Do you mean if they're both incorrect?  Because that's the only case 
> that scrub should return an un-correctable error is if neither block 
> appears correct.
> 
> In general, based on what you've said, there are four possibilities:
> 1. Both of your disks happened to have an undetectable error at 
> equivalent locations.  While not likely, this is still
> possible.  It's 
> important to note that while hard disks have internal ECC, ECC
> doesn't 
> inherently catch everything, so it's fully possible (although really 
> rare) to have a sector go bad and the disk not notice.
> 2. Some other part of your hardware has issues.  What I would check,
> in 
> order are:
> 	1. Internal cables (you would probably be surprised how many
> times I've 
> seen people have disk issues that were really caused by a bad data
> cable)
> 	2. RAM
> 	3. PSU (if you don't have a spare and don't have a multimeter
> or power 
> supply tester, move this one to the bottom of the list)
> 	4. CPU
> 	5. Storage controller
> 	6. Motherboard
>     If you want advice on testing anything, let me know.
> 3. It's caused by a transient error, and may or may not be fixable. 
> Computers have internal EMI shielding (or have metal cases) for a 
> reason, but this still doesn't protect from everything (cosmic 
> background radiation exists even in shielded enclosures).
> 4. You've found a bug in BTRFS or the kernel itself.  I seriously
> doubt 
> this, as you're setup appears to be pretty much as trivial as
> possible 
> for a BTRFS raid1 filesystem, and you don't appear to be doing
> anything 
> other than storing data (if fact, if you actually found a bug in
> BTRFS 
> in such well tested code under such a trivial use case, you deserve
> a 
> commendation).
> 
> The first thing I would do is make sure that the scrub fails 
> consistently.  I've had cases on systems which had been on for
> multiple 
> months where a scrub failed, I rebooted, and then the scrub
> succeeded. 
> If you still get the error after a reboot, check if everything other 
> than the error counts is the same, if it isn't, then it's probably
> an 
> issue with your hardware (although probably not the disk).
> > 
> > 
> > Unfortunately, I do not have the skills to do such a verification.
> > 
> > If you have any thoughts or suggestions, I would be most
> > interested.
> > I was hoping that I could trust the integrity of "data at rest" in
> > a
> > RAID-1 setting under BTRFS, but this appears not to be the case.
> It probably isn't BTRFS.  This is one of the most tested code paths
> in 
> BTRFS (the only ones more tested are single device), and you don't 
> appear to be using anything else between BTRFS and the disks, so
> there's 
> not much that can go wrong.  Keep in mind that unlike other
> filesystems 
> on top of hardware or software RAID, BTRFS actually notices that
> things 
> are wrong and has some idea which things are wrong (although it
> can't 
> tell the difference between a corrupted checksum and a corrupted
> block 
> of data).
> > 
> > 
> > Thank you,
> > 
> > R. Lochner
> > 
> > #uname -a
> > Linux vmh001.clone1.com 4.4.6-300.fc23.x86_64 #1 SMP Wed Mar 16
> > 22:10:37 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
> > 
> > # btrfs --version
> > btrfs-progs v4.4.1
> > 
> > # btrfs fi show
> > Label: 'raid_pool'  uuid: d397ff55-e5c8-4d31-966e-d65694997451
> >     Total devices 2 FS bytes used 2.32TiB
> >     devid    1 size 3.00TiB used 2.32TiB path /dev/sdb1
> >     devid    2 size 3.00TiB used 2.32TiB path /dev/sdc1
> > 
> > # btrfs fi df /mnt
> > Data, RAID1: total=2.32TiB, used=2.31TiB
> > System, RAID1: total=40.00MiB, used=384.00KiB
> > Metadata, RAID1: total=7.00GiB, used=5.42GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> > 
> > Dmesg:
> > 
> > [2027323.705035] BTRFS warning (device sdc1): checksum error at
> > logical 3037444042752 on dev /dev/sdc1, sector 4988750584, root
> > 259,
> > inode 1437377, offset 75754369024, length 4096, links 1 (path:
> > Rick/sda4.img)
> > [2027323.705056] BTRFS error (device sdc1): bdev /dev/sdc1 errs: wr
> > 0,
> > rd 13, flush 0, corrupt 3, gen 0
> > [2027323.718869] BTRFS error (device sdc1): unable to fixup
> > (regular)
> > error at logical 3037444042752 on dev /dev/sdc1
> > 
> > ls:
> > 
> > #ls -l /mnt/backup/Rick/sda4.img
> > -rw-r--r--. 1 root root 75959197696 Dec 27 10:36
> > /mnt/backup/Rick/sda4.img
