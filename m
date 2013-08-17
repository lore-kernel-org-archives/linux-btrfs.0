Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48299 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3HQEgb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 17 Aug 2013 00:36:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VAYFa-0002H9-5S
	for linux-btrfs@vger.kernel.org; Sat, 17 Aug 2013 06:36:30 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 06:36:30 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Aug 2013 06:36:30 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4 vol raid5 segfault on device delete
Date: Sat, 17 Aug 2013 04:36:12 +0000 (UTC)
Message-ID: <pan$a11a$1aa76c8c$8a111eb$1e88a99e@cox.net>
References: <CAPidFuhbjxYUqjLV_8tCCVX6aSNwZ1qJGCZvnSPx8cShGCrQvA@mail.gmail.
	com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Craig Johnson posted on Fri, 16 Aug 2013 11:50:59 -0500 as excerpted:

> I have a 4 device volume with raid5 - trying to remove one of the
> devices (plenty of free space) and I get an almost immediate segfault.
>  Scrub shows no errors, repair show space cache invalid but nothing
> else (I remounted with clear cache to be safe).  Lots of corrupt on bdev
> (for 3 out of 4 drives), but I have no file access issues that I know
> of.  Thanks!

Last I knew (kernel 3.10, where it was introduced, but I haven't seen any 
suggestion that 3.11 fixes all the problems yet), btrfs raid5/6 wasn't 
yet ready for anything like real use yet -- the all-OK code was there, 
but it couldn't yet cope with devices disappearing -- recreating the 
missing content from the checksums didn't yet work.

So "an almost immediate segfault" might be expected if you actually 
remove a device from a btrfs raid5/6, because only the all-OK code is 
actually there, it's writing the checksums but it isn't prepared to 
actually use them yet.

Btrfs raid0/1/10 should be usable, and /reasonably/ stable (for a 
filesystem still under development with bugs actively being fixed with 
each kernel release, that is), however (tho raid1 actually means two-way-
mirror, no matter the number of devices).

FWIW, I'm using btrfs raid1 here, but I have backups both to a second 
btrfs raid1 and to reiserfs (my previous filesystem and what I still use 
on "spinning rust, but it's not suitable for ssds, so I use btrfs on 
them), because btrfs IS still experimental.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

