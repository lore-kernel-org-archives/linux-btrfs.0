Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46183 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbbK0DLZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 22:11:25 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a29RO-0005UX-Vz
	for linux-btrfs@vger.kernel.org; Fri, 27 Nov 2015 04:11:19 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 04:11:18 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 04:11:18 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: implications of mixed mode
Date: Fri, 27 Nov 2015 03:11:15 +0000 (UTC)
Message-ID: <pan$d7271$6dfb6246$70339bd2$f62a4d8@cox.net>
References: <56579BD1.4030401@lukas-pirl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Lukas Pirl posted on Fri, 27 Nov 2015 12:54:57 +1300 as excerpted:

> Dear list,
> 
> if a larger RAID file system (say disk space of 8 TB in total) is
> created in mixed mode, what are the implications?
> 
> From reading the mailing list and the Wiki, I can think of the
> following:
> 
> + less hassle with "false positive" ENOSPC
> - data and metadata have to have the same replication level
>   forever (e.g. RAID 1)
> - higher fragmentation
>   (does this reduce with no(dir)atime?)
> -> more work for autodefrag
> 
> Is that roughly what is to be expected? Any implications on recovery
> etc.?

To the best of my knowledge that looks reasonably accurate.

My big hesitancy would be over that fact that very few will run or test 
mixed-mode at TB scale filesystem level, and where they do, it's likely 
to be in ordered to work around the current (but set to soon be 
eliminated) metadata-only (no data) dup mode limit on single-device, 
since in that regard mixed-mode is treated as metadata and dup mode is 
allowed.

So you're relatively more likely to run into rarely seen scaling issues 
and perhaps bugs that nobody else has ever run into as (relatively) 
nobody else runs mixed-mode on multi-terabyte-scale btrfs.  If you want 
to be the guinea pig and make it easier for others to try later on, after 
you've flushed out the worst bugs, that's definitely one way to do it.
=:^]

> In the specific case, the file system usage is as follows:
> * data spread over ~20 subvolumes
>   * snapshotted with various frequencies
>   * compression is used
> * mostly archive storage
>   * write once
>   * read infrequently
> * ~500GB of daily rsync'ed system backup

It's worth noting that rsync... seems to stress btrfs more than pretty 
much any other common single application.  It's extremely heavy access 
pattern just seems to trigger bugs that nothing else does, and while they 
do tend to get fixed, it really does seem to push btrfs to the limits, 
and there have been a /lot/ of rsync triggered btrfs bugs reported over 
the years.

Between the stresses of rsyncing half a TiB daily and the relatively 
untested quantity that is mixed-mode btrfs at multi-terabyte scales on 
multi-devices, there's a reasonably high chance that you /will/ be 
working with the devs on various bugs for awhile.  If you're willing to 
do it, great, somebody putting the filesystem thru those kinds of mixed-
mode paces at that scale is just the sort of thing we need to get 
coverage on that particular not yet well tested corner case, but don't 
expect it to be particularly stable for a couple kernel cycles anyway, 
and after that, you'll still be running a particularly rare corner-case 
that's likely to put new code thru its paces as well, so just be aware of 
the relatively stony path you're signing up to navigate, should you 
choose to go that route.

Meanwhile, assuming you're /not/ deliberately setting out to test a 
rarely tested corner-case with stress tests known to rather too 
frequently get the best of btrfs...

Why are you considering mixed-mode here?  At that size the ENOSPC hassles 
of unmixed-mode btrfs on say single-digit GiB and below really should be 
dwarfed into insignificance, particularly since btrfs since 3.17 or so 
deletes empty chunks instead of letting them build up to the point where 
they're a problem, so what possible reason, other than simply to test it 
and cover that corner-case, could justify mixed-mode at that sort of 
scale?

Unless of course, given that you didn't mention number of devices or 
individual device size, only the 8 TB total, you have in mind a raid of 
something like 1000 8-GB USB sticks, or the like, in which case mixed-
mode on the individual sticks might make some sense (well, to the extent 
that a 1000-device raid of /anything/ makes sense! =:^), given their 8-GB 
each size.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

