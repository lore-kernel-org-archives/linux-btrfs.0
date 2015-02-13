Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45288 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbbBMCih (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Feb 2015 21:38:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YM69L-0007kH-5n
	for linux-btrfs@vger.kernel.org; Fri, 13 Feb 2015 03:38:35 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 03:38:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Feb 2015 03:38:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS RAID-1 leaf size change scenario
Date: Fri, 13 Feb 2015 02:38:30 +0000 (UTC)
Message-ID: <pan$79b87$bd73274f$12e14047$da846321@cox.net>
References: <11865500.KaKfdqacBs@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Thu, 12 Feb 2015 14:26:09 +0100 as excerpted:

> I have a BTRFS RAID-1 FS made from 2x 2TB SATA mechanical drives.
> 
> It was created a while ago, with defaults by the time of 4K leaf sizes.
> 
> It also contains *lots* of subvols and snapshots.
> 
> It has become very slow over time, and I know that BTRFS performs better
> with the new 16K leaf sizes.

I agree with everything Chris Murphy said and were it me, would do the 
migration as he suggested.  Here I'll focus on another aspect, and 
reemphasize one he mentioned, as well.

1) Focus: Snapshots

Btrfs makes it deceivingly easy to make snapshots, since due to COW they 
can be created at very close to zero cost.  Unfortunately, that ease of 
creation belies the much more complicated snapshot maintenance and 
deletion costs, and often people create and keep around far more 
snapshots than is healthy for an optimally functioning btrfs.

Basically, anything over say 500 snapshots on a btrfs is going to start 
bogging it down, and more than around 250-ish snapshots of any single 
subvolume should be entirely unnecessary.  Unfortunately, due to the 
deceptive ease of creation, some people even take per-minute snapshots 
and fail to thin them down well over time, thus ending up with thousands 
to hundreds of thousands of snapshots, particularly if they're 
snapshotting multiple subvolumes at that extreme per-minute frequency.  A 
filesystem in this condition is going to be a nightmare to do any 
reasonable maintenance (like a rebalance to add/remove/replace devices, 
or a defrag of more than a few files) on at all, and even regular 
operations will likely slow down due to fragmentation, etc.

Given your starred-emphasis "*lots*" of snapshots, I strongly suspect 
this to be one of the big reasons for your slowdowns, far more so than 
the 4k nodesize, tho that won't help.  OTOH, if your characterization of 
*lots* was actually less than this, snapshotting probably isn't such a 
big problem after all and you can skip to the reemphasis point, below.

Unfortunately, at this point it may not be reasonable to recover from the 
situation on the existing filesystem, as doing the necessary thinning 
down of those snapshots could take nigh eternity (well, days per 
snapshot, "not reasonable" if you're dealing with anything near the 
thousands of snapshots I suspect) due to all that overhead.

But regardless of whether you can fix the existing btrfs, at least once 
you start over with a new one, try to better manage your snapshotting 
practices and I suspect the filesystem won't slow down as fast as this 
one did, while if you don't, I strongly suspect the newer 16k nodesizes 
aren't going to make that much difference and you'll get the same sort of 
slowdowns over time as you're dealing with now.

Here's the base argument concerning snapshot thinning management.  
Suppose you're doing hourly snapshots, and not doing any thinning.  
Suppose that a year later, you find you need a version of a file from a 
year ago, and go to retrieve it from one of those snapshots.  So you go 
to mount a year-old snapshot and you have to pick one.  Is it *REALLY* 
going to matter, a year on, with no reason to access it since, what exact 
hour it was?  How are you even going to /know/ what exact hour to pick?

A year on, practicality suggests you'll simply pick one out of the 24 for 
the day and call it good.  But is even that level of precision 
necessary?  A year on, might a single snapshot for the week, or for the 
month, or even the quarter, be sufficient?  Chances are it will be, and 
if the one you pick is too new or too old, you can simply pick one newer 
or one older and be done with it.

Similarly, per-minute snapshots?  In the extreme case, maybe for a half 
our or hour.  Then thin them down to say 10 minute snapshots, and to half 
hour snapshots after four or six hours (depending on whether you're 
basing on an 8-hour workday or a 24-hour day), then to hourly after a 
day, four or six hourly after three days, and daily after a week.

But in practice, per-minute snapshots are seldom necessary at all, and 
could be problems for maintenance if they end up taking more than a 
minute to delete.  Ten minute, possibly, more likely half-hour or hourly 
is fine.

So say we start with half hour snapshots, 24-hours/day, but thinning down 
to hourly after four hours and to four-hourly after a day, for a week.  
That's:

8*half-hourly, 24-4=20*hourly, 7-1=6*6=36-4-hourly = 8+20+36 =
64 snapshots in a week.

Now, keep daily snapshots for three additional weeks = 64+21 =
85 snapshots in four weeks.

And keep weekly snapshots to fill out the half-year (26 weeks)
26-4 = 22 weeks, 22*7=154, 154+85 = 239 snapshots in a half a year.

Now after half a year, if the data is any value at all, it will have been 
backed up elsewhere.  If you like, to avoid having to dig up those 
backups, you can keep quarterly snapshots for... pretty much the life of 
the filesystem or hardware, it'll only add four snapshots a year beyond 
the 239 for nearest half-year.  Or delete snapshots beyond a quarter or a 
half year and rely on the off-filesystem backups, allowing btrfs to 
finally free the space tied up in the oldest and thus presumably most 
changed copies of the files in question.

As the above demonstrates, even at originally half-hourly snapshots, a 
reasonable thinning program keeps snapshots per subvolume to 200-300.

And if you can get by with say 4X per day (6-hourly on a 24-hour day) 
snapshots and keep only two days of that, thinning to 2X per day for a 
week, then daily for another week and weekly out to six months, that's:

2-days of 4X-daily = 8, 5 days of 2X = 10, 7 dailies, 24 weeklies =
8+10+7+24 = 49 snapshots to six months, starting with 6-hourly.

Now say two of the half-hourly snapshotted subvolumes and five of the 6-
hourly snapshotted subvolumes.  Rounding up for easier math and to allow 
for a few quarterly snapshots, we're now at 2*250=500 at the higher 
frequency, 5*60=300 at the lower frequency, 800 total for the filesystem.

800 snapshots for the filesystem is a bit high, but it's manageable, and 
**WELL** better than the tens or hundreds of thousands of snapshots that 
some are trying to handle.  Obviously, if you can reasonably manage only 
one subvolume at the higher snapshot frequency, or if you can reduce 
snapshot frequency to daily or even not snapshot at all or only perhaps 
weekly for some of those subvolumes, total snapshots will go down 
accordingly.

Bottom line, if you're dealing with much over a thousand snapshots per 
filesystem, seriously reconsider your snapshotting strategy as you're 
probably doing it wrong.  If possible, keep it to a few hundred.  
Filesystem management and even general usage should be far better as a 
result.

Again, while it might be too late to reasonably recover from a bad 
snapshotting strategy on the existing filesystem, as deleting all those 
old snapshots now may take far longer than is reasonable (tho you could 
try it and /see/ how long deleting a snapshot takes), at least try to 
manage things better when you setup the new filesystem.

2) Reemphasis: Versions.

Restating what CM said, old btrfs versions are buggy btrfs versions.  
Btrfs is still new enough and not yet stable and mature enough that 
running current versions really does lower the risk to your data, as old 
versions are known buggy versions, and running them is effectively 
playing Russian Roulette with your data -- you might get away with it for 
awhile, but play the odds long enough and eventually you'll get shot.

More specifically, at operational runtime, it's the kernel that's most 
vital, as userspace basically only tells the kernel what to do at a high 
level, and the kernel actually executes the lower level code to do it.  
So older kernels risk runtime damage on existing filesystems due to bugs 
that have long since been found and fixed in newer kernel versions.

However, in offline mode, such as when trying to repair an unmounted 
filesystem using btrfs check, or when using btrfs-restore to try to 
recover un-backed-up data from an unmountable filesystem before trying to 
repair it, btrfs-progs userspace becomes vital, as it's actually touching 
the filesystem then, without the kernel's direct involvement.

So a current kernel is most vital for btrfs at runtime, while a current 
btrfs-progs userspace is most vital if something screwed up and you're 
trying to fix it or recover what you can before blowing the existing 
filesystem away to start over.

Meanwhile, beyond data corruption bugs, one of the big focuses recently 
has been operation scaling.  If you have thousands of snapshots as I 
suspect, it's very possible that the latest 3.18 or 3.19 kernel will 
actually let you work with them in a reasonable timeframe, while a 3.16 
vintage kernel will take so long it's impractical to do anything with 
them at all.  I'd certainly try it, at least, before giving up on doing 
anything practical with that old filesystem, unless of course you decide 
to simply bite the bullet and start over with a new filesystem and new 
devices, and only access the old one long enough to get current data and 
possibly a few selected snapshots off of it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

