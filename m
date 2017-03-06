Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50750 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752559AbdCFCss (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Mar 2017 21:48:48 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1ckihS-0003fS-6j
        for linux-btrfs@vger.kernel.org; Mon, 06 Mar 2017 03:48:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Why do BTRFS (still) forgets what device to write to?
Date: Mon, 6 Mar 2017 02:48:30 +0000 (UTC)
Message-ID: <pan$d2c87$a26a131$9fb7f6a5$779d82bc@cox.net>
References: <0fe88cf0-7c51-e2b1-e50a-33d141d1862c@dirtcellar.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

waxhead posted on Sun, 05 Mar 2017 17:26:36 +0100 as excerpted:

> I am doing some test on BTRFS with both data and metadata in raid1.
> 
> uname -a Linux daffy 4.9.0-1-amd64 #1 SMP Debian 4.9.6-3 (2017-01-28)
> x86_64 GNU/Linux
> 
> btrfs--version btrfs-progs v4.7.3
> 
> 
> 01. mkfs.btrfs /dev/sd[fgh]1 02. mount /dev/sdf1 /btrfs_test/
> 03. btrfs balance start -dconvert=raid1 /btrfs_test/
> 04. copied a lots of 3-4MB files to it (about 40GB)...
> 05. Started to compress some of the files to create one larger file...
> 06. Pulled the (sata) plug on one of the drives... (sdf1)
> 07. dmesg shows that the kernel is rejecting I/O to offline device +
> [sdf] killing request]
> 08. BTRS error (device sdf1) bdev /dev/sdf1 errs: wr 0, rd 1, flush 0,
> corrupt 0, gen 0 09. the previous line repeats - increasing rd count 10.
> Reconnecting the sdf1 drive again makes it show up as sdi1 11. btrfs fi
> sh /btrfs_test shows sd1 as the correct device id (1).
> 12. Yet dmesg shows tons of errors like this: BTRFS error (device sdf1)
> : bdev /dev/sdi1 errs wr 37182, rd 39851, flush 1, corrupt 0, gen 0....
> 13. and the above line repeats increasing wr, and rd errors.
> 14. BTRFS never seems to "get in tune again" while the filesystem is
> mounted.
> 
> The conclusion appears to be that the device ID is back again in the
> btrfs pool so why does btrfs still try to write to the wrong device (or
> does it?!).

The base problem is that btrfs doesn't (yet) have any concept of a device 
disconnecting and reconnecting "live", only after unmount/remount.

When a device drops out, btrfs will continue to attempt to write to it.  
Things will continue normally on all other devices, and only after some 
time will btrfs actually finally give up on the device.  (I /believe/ 
it's after the level of dirty memory exceeds some safety threshold, with 
the unwritten writes taking up a larger and larger part of dirty memory 
until something gives.  However, I'm not a dev just a user and list 
regular, and this is just my supposition filling in the blanks, so don't 
take it for gospel unless you get confirmation either directly from the 
code or from an actual dev.)

If the outage is short enough for the kernel to bring back the device as 
the same device node, great, btrfs can and does resume writing to it.  
However, once the outage is long enough that the kernel brings back the 
physical device as a different device node, yes, btrfs filesystem show 
will show the device back as its normal ID, but that information isn't 
properly communicated to the "live" still-mounted filesystem, and it 
continues to attempt writing to the old device node.

There's plans for, and even patches that introduce limited support for, 
live detection and automatic (re)integration of a new or reintroduced 
device, but those patches are in a longterm development project and last 
I read weren't even in a state where they even applied cleanly to current 
kernels, as they've not been kept current and have gone stale.

Of course it should be kept in mind that btrfs is still under heavy 
development, and while stabilizing, isn't considered, certainly not by 
its devs, to be anywhere near feature complete and stabilized, even, at 
times such as this, for features that are generally considered as 
reasonably stable and mature as btrfs itself is -- that is, still 
stabilizING, not yet fully stable and mature -- keep backups and be 
prepared to use them if you value your data, because you may indeed be 
calling on them!

In that state, it's only to be expected that there will still be some 
incomplete features such as this, where manual intervention may be 
required that wouldn't be in more complete/stable/mature solutions.

Basically, it comes with the territory.

> The good thing here is that BTRFS does still work fine after a unmount
> and mount again. Running a scrub on the filesystem cleans up tons of
> errors , but no uncorrectable errors.

Correct.  An unmount will leave all that data unwritten to the device it 
still considers missing, so of course those checksums aren't going to 
match.  On remount, btrfs sees the device again, and should and AFAIK 
consistently does note the difference in commit generations, pulling from 
the updated device where they differ.  A scrub can then be used to bring 
the outdated device back in sync.

But be sure to do that scrub as soon as possible.  Should further 
instability continue to drop out devices, or further not entirely 
graceful unmounts/shutdowns occur, the damage may get worse and not be 
entirely repairable, certainly not with only a simple scrub.

> However it says total bytes scrubbed 94.21GB with 75 errors ... and
> further down it says corrected errors: 72, uncorrectable errors: 0 ,
> unverified errors: 0
> 
> Why 75 vs 72 errors?! did it correct all or not?

>From my own experience (and I actually deliberately ran btrfs raid1	 
with a failing device for awhile to test this sort of thing, btrfs' 
checksumming worked very well with scrub to fix things... as long as the 
remaining device didn't start to fail with its mirror copy at the same 
places, of course), I can quite confidently say it's fixing them all, as 
long as unverified errors are 0 and you don't have some other source of 
errors, say bad memory, introducing further problems including some that 
checksumming won't fix as the data's bad before it gets a checksum.

Of course you can rerun the scrub just to be sure, but here, the only 
times it found more errors was when unverified errors popped up.  
(Unverified errors are where an error at a higher level in the metadata 
kept lower metadata blocks as well as data blocks from being checksum-
verified.  Once the upper level errors were fixed, the lower level ones 
could then be tested.  Back when I was running with the gradually failing 
device, this required manual rerun of the scrub if unverified errors 
showed up.  I believe patches have been introduced since then that rerun 
the scrub on the unverified error blocks when necessary, once the upper 
level blocks have been corrected, thus making it possible to verify the 
lower level ones.  So as long as there's no uncorrectable errors, as 
there shouldn't be in raid1 unless both copies of a block end up failing 
checksum verification, there should now be no unverified errors either.  
Of course if both copies fail checksum verification, then there's going 
to be uncorrectable errors, and if they're at the higher metadata levels, 
there could then still be unverified errors as a result.)

What I believe is going on in such cases (72 vs. 75 errors), is some 
blocks will be counted twice as they have multiple references.  These 
will only be fixed once, but with that fix, will actually correct 
multiple errors due to the multiple times that block was referenced.

> I have recently lost 1x 5 device BTRFS filesystem as well as 2x 3 device
> BTRFS filesystems set up in RAID1 (both data and medata) by toying
> around with them. The 2x filesystems I lost was using all bad disks (all
> 3 of them) but the one mentioned here uses good (but old) 400GB drives
> just for the record.
> 
> By lost I mean that mount does not recognize the filesystem, but BTRFS
> fi sh does show that all devices are present. I did not make notes for
> those filesystems , but it appears that RAID1 is a bit fragile.
> 
> I don't need to recover anything. This is just a "toy system" for
> playing around with btrfs and doing some tests.

FWIW, I lost a couple some time ago, but none for over a year now, I 
believe.  However, I was lucky and was able to recover current data using 
btrfs restore.  (I had backups but they weren't entirely current.  Of 
course if you've read many of my posts you'll know I tend to strongly 
emphasize backups if the data is of value, and realize that I was in 
reality defining that data in the delta between the current and backed up 
versions as worth less than the time and trouble necessary to update the 
backup, so if I lost the data it would have been entirely my own weighed 
decision that lead to that loss, but btrfs restore was actually able to 
restore the data for me, so I didn't have to deal with the loss I was 
knowingly risking.  I don't count on restore working /every/ time, but if 
I need to try it, I can still be glad when it /does/ work. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

