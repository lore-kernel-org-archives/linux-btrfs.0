Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39594 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3LQFDN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 00:03:13 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsmoJ-00067Z-QN
	for linux-btrfs@vger.kernel.org; Tue, 17 Dec 2013 06:03:11 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 06:03:11 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 06:03:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs balance on single device
Date: Tue, 17 Dec 2013 05:02:50 +0000 (UTC)
Message-ID: <pan$34452$58560aba$13c70980$94d45a77@cox.net>
References: <CAAeznTpG6A7ygKg1AUx_pAMs_SNwG4a4C5gHPeT+HcKRsD+TWA@mail.gmail.com>
	<20131215202456.GA11281@carfax.org.uk>
	<CAAeznTryb7kyuvEyBFniv-UtGCQwdNtZMhpxm=-2MtKZSOj9Tw@mail.gmail.com>
	<pan$138cb$448d68e$2d9dcb10$fc6a898a@cox.net>
	<CAAeznTrY21CTSsXf=jXVRneCcntqAkd+QiToNq3=0nT6O_e=Sw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Leonidas Spyropoulos posted on Mon, 16 Dec 2013 23:22:54 +0000 as
excerpted:

> I assume there's performance degragation from having all the chunks
> allocated in a volume. Is there a recomendation on how often once should
> run the balance operation? If on the other hand no performance is
> decreased from having all the chunks allocated why not allocate them on
> the start (creation of filesystem / mount - not sure which is
> appropriate).

I don't know that there's performance degradation, but it'd be a loss of 
flexibility, for sure.

Unallocated space can be allocated to either data or metadata chunks as 
the need arises.  Set them all up at the beginning and you're locking 
yourself into a particular ratio that's likely to be wrong -- you'll 
likely run out of one while you have whole empty chunks of the other one 
just sitting there, useless!

Additionally, while currently btrfs has a single allocation policy in 
effect at a given moment, it's possible to convert between single and dup 
metadata on a single device, and once multiple devices are involved, 
there's the various raid choices for both data and metadata, as well as 
single/dup modes.  If the allocation policy has changed, it's possible 
for some chunks to be allocated using one policy, while others are 
allocated using a different policy, and while it's not supported yet, the 
roadmap calls for per-subvolume allocation policy as well, and once that 
occurs, how that free space will be allocated will depend on which 
subvolume its allocated to and the allocation policy for that subvolume 
at the time.

Pre-allocate all chunks and you lose that flexibility entirely.

Finally, a balance is used to rewrite chunks, consolidating partially 
used chunks into one where possible, and reallocating based on current 
allocation policy.  But in ordered for a balance to work, there must be 
at least enough unallocated space for it to allocate at least one new 
chunk in ordered to transfer the content of one old chunk at a time to 
the new one.  Allocate all your chunks at the beginning, and balance 
won't have that free space available in ordered to allocate a new one and 
do those rewrites, thus locking out your ability to consolidate partially 
used chunks for better efficiency as well as possible conversion. =:^(


As for how often to run balance, that depends entirely on your use-case.  
On spinning-rust, balancing a large multi-terabyte filesystem can take 
hours or even days, so it's not something you'd probably want to do so 
often.  On SSDs and with smaller filesystems, the time will of course be 
shorter (a balance on my largest btrfs here, 24 gig on fast SSD, only 
takes about five minutes, with my smaller filesystems completing a 
balance in a few seconds to a couple minutes), so much so that running a 
balance is trivial in terms of time, but of course SSDs are limited write-
cycle, and needlessly rebalancing costs write-cycles.

Meanwhile, a nearly full filesystem will have most or all its chunks 
allocated, and they're not automatically deallocated.  It's thus a good 
idea to run a balance after deleting a lot of files, thus freeing up the 
allocations and returning the space to the flexible-use unallocated 
pool.  And a balance is the method used to re-balance (thus the name) 
allocations between devices after adding or removing devices, and to 
convert between single/dup/raidN modes if your allocation policy changes.

Generally, in the absence of a conversion or device add/remove run, I run 
a balance whenever btrfs fi df shows a multi-chunk difference between 
what's allocated and what's actually used, again, based on a metadata 
chunk size of a quarter GiB (tho btrfs defaults to DUP mode on a single 
device so it'll allocate two at once), with a data chunk size of 1 GiB.  
But if I ran much larger btrfs with hundreds of gigs free, I'd probably 
wait until I was down to a few gigs free to run the balance, since it'd 
likely be a multi-hour or even multi-day process on spinning rust, and on 
SSD it'd be faster, but would as I said unnecessarily use up limited 
write-cycles.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

