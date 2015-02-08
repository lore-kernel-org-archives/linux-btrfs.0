Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f44.google.com ([209.85.213.44]:57213 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758909AbbBHWng (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 17:43:36 -0500
Received: by mail-yh0-f44.google.com with SMTP id f73so3008147yha.3
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 14:43:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
References: <CANcfdL0x_LTSnyL1FP8vVV4=MaFrewT4pd0MZgu3qzxOviXDgg@mail.gmail.com>
	<CAJCQCtT+8+02KkYOcRUOhscj3AP0av8PpNmsK526hvJY=3ucRw@mail.gmail.com>
	<CANcfdL0twe-pi4f1ZVNG=m82gQTKc5QL3pcodY6diJ6uLj2Q9A@mail.gmail.com>
Date: Sun, 8 Feb 2015 15:43:35 -0700
Message-ID: <CAJCQCtSJ+kgxKb-gGnuOCFEVBsr2UP0aUWg_M60Ts_OQaSL8oQ@mail.gmail.com>
Subject: Re: Replacing a (or two?) failed drive(s) in RAID-1 btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: constantine <costas.magnuse@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 8, 2015 at 2:06 PM, constantine <costas.magnuse@gmail.com> wrote:

> [   78.039253] BTRFS info (device sdc1): disk space caching is enabled
> [   78.056020] BTRFS: failed to read chunk tree on sdc1
> [   78.091062] BTRFS: open_ctree failed
> [   84.729944] BTRFS info (device sdc1): allowing degraded mounts
> [   84.729950] BTRFS info (device sdc1): disk space caching is enabled
> [   84.754301] BTRFS warning (device sdc1): devid 2 missing
> [   84.856408] BTRFS: bdev (null) errs: wr 13, rd 0, flush 0, corrupt 63, gen 5
> [   84.856415] BTRFS: bdev /dev/sdc1 errs: wr 1176932, rd 99072, flush
> 5946, corrupt 2178961, gen 7557
> [   84.856419] BTRFS: bdev /dev/sdd1 errs: wr 0, rd 0, flush 0,
> corrupt 17, gen 0
> [   84.856425] BTRFS: bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
> corrupt 60, gen 0
> [   84.856428] BTRFS: bdev /dev/sdg1 errs: wr 0, rd 0, flush 0,
> corrupt 57, gen 0

You had problems with sdc for a long time.  It's reporting millions of
corrupt events. This is cumulative, not just on this mount. So likely
Btrfs was trying to fix them before the device failure. If sdc is not
pristine, with a device failure, you basically have a partially lost
array because Btrfs raid1 tolerates a single device failure. With a 2
device failure which is what you have now, there will be some amount
of data loss.

Confusing is that sdd1, sdi1, sdg1 have gen 0 and also have
corruptions reported, just not anywhere near as many as sdc1. So I
don't know what problems you have with your hardware, but they're not
restricted to just one or two drives. Generation 0 makes no sense to
me.


> [  117.535217] BTRFS info (device sdc1): relocating block group
> 10792241987584 flags 17
> [  133.386996] BTRFS info (device sdc1): csum failed ino 257 off
> 541310976 csum 4144645530 expected csum 4144645376
> [  133.413795] BTRFS info (device sdc1): csum failed ino 257 off
> 541310976 csum 4144645530 expected csum 4144645376
> [  133.423884] BTRFS info (device sdc1): csum failed ino 257 off
> 541310976 csum 4144645530 expected csum 4144645376

So sdc1 still has problems, despite the scrubs, the problems with it
are persistent. Without historical kernel messages for a scrub prior
to the device failure, we can only speculate whether those scrubs were
repairing things correctly and now the reads are bad (read failures);
or if the original scrubs didn't actually fix the problem on sdc
(write failures).



> [  303.627547] BTRFS info (device sdc1): relocating block group
> 10792241987584 flags 17
> [  308.604231] BTRFS info (device sdc1): csum failed ino 258 off
> 541310976 csum 4144645530 expected csum 4144645376
> [  308.631229] BTRFS info (device sdc1): csum failed ino 258 off
> 541310976 csum 4144645530 expected csum 4144645376
> [  308.641205] BTRFS info (device sdc1): csum failed ino 258 off
> 541310976 csum 4144645530 expected csum 4144645376
> [ 1240.379575] BTRFS info (device sdc1): relocating block group
> 10792241987584 flags 17
> [ 1247.867399] BTRFS info (device sdc1): csum failed ino 259 off
> 541310976 csum 4144645530 expected csum 4144645376
> [ 1247.894211] BTRFS info (device sdc1): csum failed ino 259 off
> 541310976 csum 4144645530 expected csum 4144645376
> [ 1247.904300] BTRFS info (device sdc1): csum failed ino 259 off
> 541310976 csum 4144645530 expected csum 4144645376

More sdc1 errors.

For each drive, what do you get for:

smartctl -l scterc /dev/sdX
cat /sys/block/sdX/device/timeout

Basically you're in data recovery mode if you don't have a current
backup. If you have a current backup, give up on this volume, get rid
of the bad hardware after requalifying all the hardware you intend to
use in a new volume.

If you don't have a current backup, make one now. Just make sure you
don't overwrite any previous backup data in case you need it. Any
files that don't pass checksum will not be copied, these will be
recorded in dmesg. If you have those files backedup, you're done with
this volume.

If not, first upgrade to btrfs-progs 3.18.2, then do btrfs check
--repair --init-csum-tree to delete and recreate the csum tree, and
then doing another incremental. Be clear with labeling these
incremental backups. Later you can diff them, and if any files don't
match between them, manually inspect to find out which one is the good
one. I'd say 50/50 chance the init-csum-tree won't work because it
looks like sdc1 always produces bad data. It's entirely possible the
repair goes badly, and the filesystem becomes read-only at which point
no more changes will be possible. To get files off that fail csum
(again, they're listed in dmesg), you'll have to use btrfs restore on
the unmount volume to extract them. This may be tedious.




-- 
Chris Murphy
