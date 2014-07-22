Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751986AbaGVD05 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 23:26:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X9Qj7-0001Ie-9T
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 05:26:53 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 05:26:53 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 05:26:53 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ENOSPC errors during balance
Date: Tue, 22 Jul 2014 03:26:39 +0000 (UTC)
Message-ID: <pan$1a441$ab255f41$47b5d104$887b5db7@cox.net>
References: <20140719172605.445e8445@marcec>
	<39E33553-3073-483E-9A2A-088212B40D0B@colorremedies.com>
	<pan$c685d$4bb40507$f2be4604$15619074@cox.net>
	<20140720122233.4ef06751@marcec> <20140720134054.3cd6cef3@marcec>
	<20140720214440.398e7e68@marcec> <20140721152216.27d8a4c4@marcec>
	<20140722003057.0f3b89f0@marcec> <20140722013022.52b189ee@marcec>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Tue, 22 Jul 2014 01:30:22 +0200 as excerpted:

> And now that the background deletion of the old snapshots is done, the file
> system ended up at:
> 
> # btrfs filesystem df /run/media/marcec/MARCEC_BACKUP    
> Data, single: total=219.00GiB, used=140.13GiB
> System, DUP: total=32.00MiB, used=36.00KiB
> Metadata, DUP: total=4.50GiB, used=2.40GiB
> unknown, single: total=512.00MiB, used=0.00
> 
> I don't know how reliable du is for this, but I used it to estimate how much
> used data I should expect, and I get 138 GiB.  That means that the snapshots
> yield about 2 GiB "overhead", which is very reasonable, I think.  Obviously
> I'll be starting a full balance now.

FWIW, the balance should reduce the data total quite a bit, to 141-ish GiB
(might be 142 or 145, but it should definitely come down from 219 GiB),
because the spread between total and used is relatively high, now, and balance
is what's used to bring that back down.

Metadata total will probably come down a bit as well, to 3.00 GiB or so.

What's going on there is this:  Btrfs allocates and deallocates data and
metadata in two stages.  First it allocates chunks, 1 GiB in size for
data, 256 MiB in size for metadata, but because metadata is dup by default
it allocates two chunks so half a GiB at a time, there.  Then the actual
file data and metadata can be written into the pre-allocated chunks, filling
them up.  As they near full, more chunks will be allocated from the
unallocated pool as necessary.

But on file deletion, btrfs only automatically handles the file
data/metadata level; it doesn't (yet) automatically deallocate the chunks,
nor can it change the allocation from say a data chunk to a metadata chunk.
So when a chunk is allocated, it stays allocated.

That's the spread you see in btrfs filesystem df, between total and used,
for each chunk type.

The way to recover those allocated but unused chunks to the unallocated
pool, so they can be reallocated between data and metadata as necessary,
is with a balance.  That balance, therefore, should reduce the spread
seen in the above between total and used.

Meanwhile, btrfs filesystem df shows the spread between allocated and
used for each type, but what about unallocated?  Simple.  Btrfs
filesystem show lists total filesystem size as well as allocated
usage for each device.  (The total line is something else, I recommend
ignoring it as it's simply confusing.  Only pay attention to the
individual device lines.)

Thus, to get a proper picture of the space usage status on a btrfs
filesystem, you must have both the btrfs filesystem show and
btrfs filesystem df output for that filesystem, show to tell
you how much of the total space is chunk-allocated for each device,
df to tell you what those allocations are, and how much of the
chunk-allocated space is actually used, for each allocation type.

It's wise to keep track of the show output in particular, and
when the spread between used (allocated) and total for each
device gets low, under a few GiB, check btrfs fi df and see
what's using that space unnecessarily and then do a balance
to recover it, if possible.


-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

