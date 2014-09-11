Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59608 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976AbaIKTcQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 15:32:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XSA6C-0000Z2-35
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 21:32:08 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 21:32:08 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 21:32:08 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: how long should "btrfs device delete missing ..."  take?
Date: Thu, 11 Sep 2014 19:31:56 +0000 (UTC)
Message-ID: <pan$2d5ba$86c3ebd8$b81abab$13e892ea@cox.net>
References: <84a98bc5f667c04ca74ff77b56f537d9@admin.virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Thu, 11 Sep 2014 17:22:15 +0200 as excerpted:

> After a disk died and was replaced, "btrfs device delete missing" is 
> taking more than 10 days on an otherwise idle server:
> 
> # btrfs fi show /home
> Label: none  uuid: 84d087aa-3a32-46da-844f-a233237cf04f
>          Total devices 3 FS bytes used 362.44GiB
>          devid    2 size 1.71TiB used 365.03GiB path /dev/sdb4
>          devid    3 size 1.71TiB used 58.00GiB path /dev/sda4
>          *** Some devices missing
> 
> Btrfs v3.16
> 
> So far, it has copied 58 GB out of 365 GB - and it took 10 days. At this 
> speed, the whole operation will take 2-3 months (assuming that the only 
> healthy disk doesn't die in the meantime).
> Is this expected time for btrfs RAID-1?

Device delete definitely takes time.  For the sub-GiB usage shown above,
10 days for 50 GiB out of 350+ does seem excessive, but there are extreme
cases where it isn't entirely out of line.  See below.

> There are no errors in dmesg/smart, performance of both disks is fine:

> # btrfs sub list /home | wc -l
> 260

> I've tried running this on the latest 3.16.x kernel earlier, but since 
> the progress was so slow, rebooted after about a week to see if the 
> latest RC will be any faster.

The good thing is that once a block group is copied over, it should be
fine and won't need re-copied if the process is stopped over a reboot
and restarted on a new kernel, etc.

The bad thing is that if I'm interpreting your report correctly, that
likely means 7+10=17 days for that 58 gig. =:^(

Questions:

* Presumably most of those 260 subvolumes are snapshots, correct?
What was your snapshotting schedule and did you have old snapshot
cleanup-deletion scheduled as well?

* Do you run with autodefrag or was the system otherwise regularly
defragged?

* Do you have large (GiB plus) database or virtual machine image files
on that filesystem?  If so, had you properly set the NOCOW file
attribute (chattr +C) on them and were they on dedicated subvolumes?


200+ snapshots is somewhat high and could be part of the issue, tho
it's nothing like the extremes (thousands) we've seen posted in the
past.  Were it me, I'd have tried deleting as many as possible before
the device delete missing, in ordered to simplify the process and
eliminate as much "extra" data as possible.

The real issue is going to be fragmentation, on spinning-rust drives.
Run filefrag on some of your gig-plus files that get written to
frequently (vm-images and database files are the classic cases) and
see how many extents are reported.  (Tho note that filefrag doesn't
understand btrfs compression and won't be accurate in that case, and
also that due to the btrfs data chunk size of 1 GiB, that's the
maximum extent size, so multi-gig files will typically be two extents
more than the number of gigs, filling up the current chunk,
N whole-gig chunks, the file tail.)  The nocow file attribute (which
must be set while the file is zero-sized to be effective, see
discussion elsewhere) can help with that, but snapshotting an
actively being rewritten nocow file more or less defeats the
purpose of nocow, since the snapshot locks in place the existing
data and the first rewrite to a block must then be cowed anyway.
But putting those files on dedicated subvolumes and then not
snapshotting those subvolumes is a workaround.


I wouldn't try defragging now, but it might be worthwhile to stop the
device delete (rebooting to do so since I don't think there's a cancel)
and delete as many snapshots as possible.  That should help matters.
Additionally, if you have recent backups of highly fragmented files
such as the VM-images and DBs I mentioned, you might consider simply
deleting them, thus eliminating that fragment processing from the
device delete.  I don't know that making a backup now would go much
faster than the device delete, however, so I don't know whether to
recommend that or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

