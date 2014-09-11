Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42620 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaIKLKt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 07:10:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XS2Gx-0008WN-Hp
	for linux-btrfs@vger.kernel.org; Thu, 11 Sep 2014 13:10:43 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 13:10:43 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 13:10:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is it necessary to balance a btrfs raid1 array?
Date: Thu, 11 Sep 2014 11:10:32 +0000 (UTC)
Message-ID: <pan$adf48$e9cbe46e$6e0e0ee7$acdeaa9a@cox.net>
References: <541043B8.7010601@barrowhillfarm.org.uk>
	<54109BCD.5000106@inwind.it> <lurrju$n90$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bob Williams posted on Thu, 11 Sep 2014 10:56:14 +0100 as excerpted:

> So if a RAID1/two disk system uses the disks symmetrically, why did my
> balance command take 22 hours? That's what puzzles me, as my
> understanding of RAID1 is that the disk use *is* symmetrical.

What you're missing is what balance actually /does/.

Balance will take every chunk it sees, data or metadata (with metadata 
including system as well), and rewrite it to a new location.  In simplest 
conception that's /all/ it does.

So your 22 hours was the time it took to rewrite-shift, effectively, the 
entire filesystem, one chunk at a time, from one location to another.

Now it so happens that in the process balance does a bunch of other stuff 
too, like combine partially empty blocks of the same type during the 
rewrite, filling them up such that the rewritten version likely takes 
fewer chunks than the original, thus having the effect of freeing the 
extra chunks back to unallocated space that's now again free to be used 
for data or metadata instead of tied up in chunks that are one or the 
other but can't be switched.

And after adding/deleting devices, that rewrite process balances out 
usage between devices.

And with the convert option (used with -d or -m, below) that rewrite can 
be used to convert the rewritten chunks to some other raid layout than 
the original.

And with the -d and -m options (along with -s), you can limit the chunks 
balance looks at to data or metadata (the latter including system as 
well, -s) instead of all chunks.

And with the usage option (along with -d or -m, above), you can limit the 
chunks looked at to those under a particular percentage fill, thus 
allowing to do the chunk consolidation more efficiently without taking 
time to do ALL chunks of that type as it would otherwise do.

But bottom line, balance is a chunk rewriter, and you told it to rewrite 
everything on the filesystem, so that's exactly what it did.  And with 
nearly a TB of data on spinning rust, that took awhile, about 22 hours 
"awhile"!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

