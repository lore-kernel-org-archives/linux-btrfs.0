Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:50478 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbcLXJhc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Dec 2016 04:37:32 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cKilT-0004ux-Su
        for linux-btrfs@vger.kernel.org; Sat, 24 Dec 2016 10:37:19 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2041 repair_io_failure
 (v4.8.11)
Date: Sat, 24 Dec 2016 09:37:12 +0000 (UTC)
Message-ID: <pan$32d3$c1252fb4$635d3287$d238a362@cox.net>
References: <CAOE4rSz5zeQYcGU3saZOk9HHb53NOwVF_vZV6m_UgQLftr9efQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dāvis Mosāns posted on Sat, 24 Dec 2016 04:22:24 +0200 as excerpted:

> On two disk RAID1 btrfs partition one disk went offline, other was still
> writing, then kernel paniced.

[snip btrfs fi usage as not needed for this reply]

> Now kernel panics every time after some time when accessing that
> partition.


Have you done a scrub on the filesystem since the event that offlined one 
of the two component devices?  If not, please do so ASAP.  Expect some 
repairs.

As for the continued panics, I'm not a dev (just a list regular and btrfs 
raid1 user affected by this myself) so can't read enough of that bug-dump 
to know if this is the bug or not, but do you use btrfs compression, 
either via the compress mount option or via later compression using 
defrag with the appropriate commandline option?

Because there is a known and AFAIK not yet fixed problem that only 
affects people using compression, and that would only show up with raid1/
raid10/dup modes as with single/raid0, the affected data would simply 
fail checksum and be gone (not sure about raid56, but that has its own 
even worse problems), so it hasn't gotten the priority those of us that 
do use compression on raid1 believe it deserves.

The problem is that while in theory btrfs on raid1 should try the other 
mirror if the copy it's reading fails checksum, and while it does just 
that for uncompressed data, with compression, it seems to do that at 
first, but if it has to deal with too many such first-mirror errors at 
once, it will kernel panic.

And a scenario where one device goes offline while the other continues 
writing, tends to trigger this quite easily, as there's often enough 
difference between the two mirrors, in files that will tend to be 
accessed again after mount, to trigger this compression-only panic.

But in my experience, if you can keep whatever else from accessing the 
filesystem long enough for a scrub to do its job, it has always corrected 
the problem here, and then I and my normal applications can go about 
their business without triggering further kernel panics.

The problem is that sometimes the affected filesystems are used by boot 
services, so I have to boot to systemd emergency or rescue mode (I forgot 
which, whichever one does the mounts but doesn't start normal services) 
and do the scrub from there, because if I try to boot normally, the 
starting services read enough affected files from the filesystem to 
trigger the panic before I get a chance to do the scrub.

Luckily I'm on ssd, with relatively small independent btrfs on their own 
partitions and / mounted read-only unless I'm actually updating the 
system, so / itself doesn't tend to be affected, and /home and /var/log, 
which do tend to be affected, are relatively small, and take less than a 
minute to scrub.  So here at least, booting to emergency/rescue mode to 
do the scrub isn't too disruptive.  Were it a multi-terabyte btrfs on 
spinning rust, as yours appears to be, the scrub would take far longer, 
and I'd possibly be sitting and waiting for hours for it to finish so I 
could get on with the boot.  Were that the case here, I think I'd pretty 
quickly either divide up into much smaller filesystems in ordered to 
allow me to finish the scrubs on boot-critical data more quickly (as I 
was already doing, long before btrfs), or decide to use some other 
filesystem for at least the boot-critical stuff.

Or of course, now that I know that it apparently only affects people 
using compression, I'd turn that off and rewrite at least the boot-
critical stuff to decompress it, so as not to be affected.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

