Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54704 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455AbaFYKsy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 06:48:54 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wzkl2-0003lX-B8
	for linux-btrfs@vger.kernel.org; Wed, 25 Jun 2014 12:48:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 12:48:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 12:48:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs data dup on single device?
Date: Wed, 25 Jun 2014 10:48:39 +0000 (UTC)
Message-ID: <pan$c5967$4ea98378$c31afa6b$2019842@cox.net>
References: <CACQTm-go5jGan9kP-dVq7Oi4b+AGWuFkb0Nudc2i9V1SG-oc3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniel Landstedt posted on Wed, 25 Jun 2014 09:25:57 +0200 as excerpted:

> Will it be possible to use DUP for data as well as for metadata on a
> single device?

See Hugo's answer for the general case.  I've learned a lot from him. =:^)

While I believe and as he says the general answer is no, there are a 
couple ways around that, which he doesn't mention.  Tho as he warns, 
you'll see a performance drop as a result.

1) Btrfs has what's called mixed-bg (block group) mode, which combines 
data and metadata in the same chunks instead of creating separate chunks 
for data and metadata.  Mixed-mode was designed for the small btrfs use-
case and is the default on btrfs of 1 GiB or under, but can be specified 
on larger btrfs as well.  The fact that mixed mode allows dup data is a 
side effect of the fact that mixed-mode chunks are shared data/metadata, 
but in this case it's a useful side effect. =:^)

Tho mixed-mode does come with a performance cost, some people recommend 
using it on btrfs upto 32-64 GiB (and perhaps upto 128 MiB) anyway, 
because it /does/ eliminate data-vs-metadata allocation issues that tend 
to be worse on such small filesystems.  Of course you can specify it on 
larger btrfs as well, but my understanding is that the performance spread 
between mixed and normal mode isn't as noticeable on small filesystems, 
but on filesystems above 100 GiB or so the performance loss is more 
noticeable.

Mixed-mode chunk size is (like metadata chunks in normal mode) 256 MiB.  
(FWIW data chunks are 1 GiB in normal mode.)

Mixed-mode must be specified at mkfs.btrfs time, using the -M/--mixed 
option, and if you specify replication mode at the same time instead of 
simply taking the default, you'll need to specify both -m/--metadata and
-d/--data replication mode as the same thing.  Mixed-vs-separate data/
metadata is configured separately from replication mode, so it's possible 
to configure mixed single mode or mixed dup mode on a single device, and 
of course mixed mode with the various raid modes on multiple device 
filesystems.  

For your case, the mkfs.btrfs would be invoked with:

--mixed --data dup --metadata dup

2) The other way to do it would be to create two separate partitions, 
presumably the same size, on the same physical device, and treat them as 
if they were two separate devices.  This would allow you to configure 
btrfs for multi-device raid1 mode.  Of course you could do the same with 
raid0 mode or with more partitions, raid5, raid6, or raid10 modes, but 
that would needlessly complicate things to no purpose.

But there /is/ a narrow purpose to dual-device raid1 mode, where both 
"devices" are partitions on the same physical device -- precisely the one 
under discussion here, data replication on a single (physical) device.

Unlike the mixed-mode above, that would give you split data/metadata mode 
on a single (physical) device, with full 1 GiB size data chunks.

On spinning rust media this would arguably be incrementally more 
reliable, since it would force the two copies to separate parts of the 
physical media, a good thing if one portion of the media happens to be 
weaker than the rest.  However, seek costs would be measurably higher, so 
performance would likely be measurably lower.

On SSD, the FTL layer relocates blocks at will anyway, so there's less 
benefit to single-physical-device raid1 mode there.  But at the same time 
there's zero seek cost, so writes should take exactly 2X penalty 
(compared to single device single mode) since you're doing 2X the 
writing, while reads should be essentially 0 penalty, since (as long as 
the checksums verify) btrfs will read only one copy effectively at random.

Of course the 2X data costs will half effective filesystem capacity in 
either case, same as with mixed-mode.

** That *DOES* assume that your SSD doesn't do internal compression/
deduplication, of course.  Some SSD firmware (sandforce based firmware is 
the commonly known case) does do compression/deduplication, in which case 
either dup mode or raid1 mode won't get you the desired redundancy since 
the firmware will likely be deduping down to a single copy anyway.  But 
not all SSD firmware operates this way.  Point of fact, my SSDs have as a 
bullet-point feature that they do NOT do deduplication, etc, selling this 
as more reliable performance, the same performance all the time, no 
matter the data written.  So on SSDs do your research. =:^)

The mkfs.btrfs would be invoked with:

--data raid1 --metadata raid1

Unfortunately, at present raid1 mode still only creates two copies of 
each chunk even if there's more than two devices, so partitioning up the 
physical device into additional partitions simply to feed more "devices" 
to mkfs.btrfs won't get you additional copies, only more complexity and 
less control over where those copies go.

> And if so, am I going to be able to specify more than 1 copy of the
> data?

I assume by "1 copy" you meant two copies, working copy plus single 
backup copy.

As Hugo says, you get precisely two copies.  However, they can't really 
be considered working and backup; it's simply two equal copies, with both 
chunks written and whichever one is handy read and verified, with the 
other one being a fallback if the checksum doesn't validate on the first 
one read.

> Storage is pretty cheap now, and to have multiple copies in btrfs is
> something that I think could be used a lot. I know I will use multiple
> copies of my data if made possible.

As Hugo, I feel compelled to ask what your use-case is.

I'm a strong booster of the N-way-mirroring feature not yet available, 
because I find the 3-device/3-way-mirroring case compelling, particularly 
given btrfs data integrity features.

And there's certainly a case to be made for two-way-redundancy on a 
single device, for the same reasons.

But there's little practical use-case for 3-plus-copies on the same 
physical device, because the performance costs are simply too high to 
justify on a single physical device with its corresponding single-device 
risk of failure.

IMO, if the use-case calls for three or more copies (working plus two) of 
the data, it equally well justifies placing it on separate physical 
devices, thereby protecting against all but one of the physical devices 
failing as well.

OTOH, perhaps there's a use-case I'm simply not seeing...

> Is it something that might be available when RAID1 gets N mirrors
> instead of just 1 mirror?

In theory, and at least with N-way partitioning, yes.  However, I'm not 
sure that they'll enable N-way-data-dup in the single-device-btrfs case, 
for the same reasons they don't enable simple two-way data-dup mode now.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

