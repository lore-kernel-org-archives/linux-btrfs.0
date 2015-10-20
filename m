Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56502 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbbJTSyk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 14:54:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zoc3G-0007l6-QL
	for linux-btrfs@vger.kernel.org; Tue, 20 Oct 2015 20:54:26 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 20:54:26 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 20:54:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
Date: Tue, 20 Oct 2015 18:54:12 +0000 (UTC)
Message-ID: <pan$312c1$94a948da$df1250c5$4706911@cox.net>
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

james harvey posted on Tue, 20 Oct 2015 00:16:15 -0400 as excerpted:

> Background -----
> 
> My fileserver had a "bad event" last week.  Shut it down normally to add
> a new hard drive, and it would no longer post.  Tried about 50 times,
> doing the typical everything non-essential unplugged, trying 1 of 4
> memory modules at a time, and 1 of 2 processors at a time.  Got no
> where.
> 
> Inexpensive HP workstation, so purchased a used identical model
> (complete other than hard drives) on eBay.  Replacement arrived today.
> Posts fine.  Moved hard drives over (again, identical model, and Arch
> Linux not Windows) and it started giving "Watchdog detected hard LOCKUP"
> type errors I've never seen before.
> 
> Decided I'd diagnose which part in the original server was bad.  By
> sitting turned off for a week, it suddenly started posting just fine.
> But, with the hard drives back in it, I'm getting the same hard lockup
> errors.
> 
> An Arch ISO DVD runs stress testing perfectly.
> 
> Btrfs-specific -----
> 
> The current problem I'm having must be a bad hard drive or corrupted
> data.
> 
> 3 drive btrfs RAID1 (data and metadata.)  sda has 1GB of the 3GB of
> data, and 1GB of the 1GB of metadata.
> 
> sda appears to be going bad, with my low threshold of "going bad", and
> will be replaced ASAP.  It just developed 16 reallocated sectors, and
> has 40 current pending sectors.
> 
> I'm currently running a "btrfs scrub start -B -d -r /terra", which
> status on another term shows me has found 32 errors after running for an
> hour.
> 
> Question 1 - I'm expecting if I re-run the scrub without the read-only
> option, that it will detect from the checksum data which sector is
> correct, and re-write to the drive with bad sectors the data to a new
> sector.  Correct?

I actually ran a number of independent btrfs raid1 filesystems[1] on a 
pair of ssds, with one of the ssds slowly dying, with more and more 
reallocated sectors over time, for something like six months.[2]  SMART 
started with a 254 "cooked" value for reallocated sectors, immediately 
dropped to what was apparently the percentage still good (still rounding 
to 100) on first sector replace (according to raw value), and dropped to 
about 85 (again, %) during the continued usage time, with a threshold 
value of IIRC 36, so I never came close on that value, tho the raw-read-
error-rate value dropped into failing-now a couple times near the end, 
when I'd do scrubs and get dozens of reallocated sectors in just a few 
minutes, but it'd recover on reboot and report failing-in-the-past, and 
it wouldn't trip into failing mode unless I had the system off for awhile 
and then did a scrub of several of those independent btrfs in quick 
succession.

Anyway, yes, as long as the other copy is good, btrfs scrub does fix up 
the problems without much pain beyond the wait time (which was generally 
under a minute per btrfs, all under 50 gig each, on the ssds).

Tho I should mention: If btrfs returns any unverified errors, rerun the 
scrub again, and it'll likely fix more.  I'm not absolutely sure what 
these actually are in btrfs terms, but I took them to be places where 
metadata checksum errors occurred, where that metadata in turn had 
checksums of data and metadata further down (up?) the tree, closer to the 
data.  Only after those metadata blocks were scrubbed in an early pass, 
could a later pass actually verify their checksums and thus rely on the 
checksums they in turn contained, for metadata blocks closer to the data 
or for the data itself.  Sometimes I'd end up rerunning scrub a few times 
(never more that five, IIRC, however), almost always correcting less 
errors each time, tho it'd occasionally jump up a bit for one pass, 
before dropping again on the one after that.

But rerun scrubs returning unverified errors and you should eventually 
fix everything, assuming of course that the second copy is always valid.

Obviously this was rather easier for me, however, at under a minute per 
filesystem scrub run and generally under 15 minutes total for the 
multiple runs on multiple filesystems (tho I didn't always verify /all/ 
btrfs, only the ones I normally mounted), than it's going to be for you, 
at over an hour reported and still going.  At hours per run, it'll 
require some patience...

I had absolutely zero scrub failures here, because as I said my second 
ssd was (and remains) absolutely solid).

> Question 2 - Before having ran the scrub, booting off the raid with bad
> sectors, would btrfs "on the fly" recognize it was getting bad sector
> data with the checksum being off, and checking the other drives?  Or, is
> it expected that I could get a bad sector read in a critical piece of
> operating system and/or kernel, which could be causing my lockup issues?

"With the checksums being off" is unfortunately ambiguous.

Do you mean with the nodatasum mount option and/or nocow set, so btrfs 
wasn't checksumming, or do you mean (as I assume you do) with the 
checksums on, but simply failing to verify due to the hardware errors?

If you mean the first... if there's no checksum to verify, as would be 
the case with nocow files since that turns of checksumming as well... 
then btrfs, as most other filesystems, simply returns whatever it gets 
from the hardware, because it doesn't have checksums to verify it 
against.  But no checksum stored normally only applies to data (and a few 
misc things like the free-space-cache, accounting for the non-zero no-
checksums numbers you may see even if you haven't turned off cow or 
checksumming on anything); metadata is always checksummed.

If you mean the second, "off" actually meaning "on but failing to 
verify", as I suspect you do, then yes, btrfs should always reach for the 
second copy when it finds the first one invalid.

But tho I'm a user not a dev and thus haven't actually checked the source 
code itself, my believe here is with Russ and disagrees with Austin, as 
based on what I've read both on the wiki and seen here previously, btrfs 
runtime (that is, not during scrub) actually repairs the problem on-
hardware as well, from that second copy, not just fetching it for use 
without the repair, the distinction between normal runtime error 
detection and scrub thus being that scrub systematically checks 
everything, while normal runtime on most systems will only check the 
stuff it reads in normal usage, thus getting the stuff that's regularly 
used, but not the stuff that's only stored and never read.

*WARNING*:  From my experience at least, at least on initial mount, btrfs 
isn't particularly robust when the number of read errors on one device 
start to go up dramatically.  Despite never seeing an error in scrub that 
it couldn't fix, twice I had enough reads fail on a mount that the mount 
itself failed and I couldn't mount successfully despite repeated 
attempts.  In both cases, I was able to use btrfs restore to restore the 
contents of the filesystem to some other place (as it happens, the 
reiserfs on spinning rust I use for my media filesystem, since being for 
big media files, that had enough space to recover the as I said above 
reasonably small btrfs into), and ultimate recreating the filesystem 
using mkfs.btrfs.

But given that despite not being able to mount, neither SMART nor dmesg 
ever mentioned anything about the "good" device having errors, I'm left 
to conclude that btrfs itself ultimately crashed on attempt to mount the 
filesystem, even tho only the one copy was bad.  After a couple of those 
events I started scrubbing much more frequently, thus fixing the errors 
while btrfs could still mount the filesystem and /let/ me run a scrub.  
It was actually those more frequent scrubs that quickly became the hassle 
and lead me to give up on the device.  If btrfs had been able to fall 
back to the second/valid copy even in that case, as it really should have 
done, then I would have very possibly waited quite a bit longer to 
replace the dying device.

So on that one I'd say to be sure, get confirmation either directly from 
the code (if you can read it) or from a dev who has actually looked at it 
and is basing his post on that, tho I still /believe/ btrfs still runtime-
corrects checksumming issues actually on-device, if there's a validating 
second copy it can use to do so.

> Question 3 - Probably doesn't matter, but how can I see which files (or
> metadata to files) the 40 current bad sectors are in?  (On extX,
> I'd use tune2fs and debugfs to be able to see this information.)

Here, a read-only scrub seemed to print the path to the bad file -- when 
there was one, sometimes it was a metadata block and thus not 
specifically identifiable.  Writable scrubs seemed to print the info 
sometimes but not always.  I'm actually confused as to why, but I did 
specifically observe btrfs scrub printing path names in read-only mode, 
that it didn't always appear to print in the scrub output.  I didn't look 
extremely carefully, however, or compare the outputs side-by-side, so 
maybe I just missed it in the writable/fix-it mode output. 

> I do have hourly snapshots, from when it was properly running, so once
> I'm that far in the process, I can also compare the most recent
> snapshots, and see if there's any changes that happened to files that
> shouldn't have.

Hourly snapshots:

Note that btrfs has significant scaling issues with snapshots, etc, when 
the number reaches into the tens of thousands.  If you're doing such 
scheduled snapshots (and not already doing scheduled thinning), the 
strong recommendation is to schedule reasonable snapshot thinning as well.

Think about it.  If you need to retrieve something from a snapshot a year 
ago, are you going to really know or care what specific hour it was?  
Unlikely.  You'll almost certainly be just fine finding correct day, and 
a year out, you'll very possibly be just fine with weekly, monthly or 
even quarterly, and if they haven't been thinned all those many many 
hourly snapshots will simply make it harder to efficiently find and use 
one you actually need amongst all the "noise".

So do hourly snapshots for say six hours (6, plus upto 6 more before the 
thin drops 5 of them, so 12 max), then thin to six-hourly.  Keep your 
four-a-day-six-hourly snapshots for a couple days (8-12, plus the 6-12 
for the last six hours, upto 24 total), and thin to 2-a-day-12-hourly.  
Keep those for a week and thin to daily (12-26, upto 50 total), and those 
for another week (6-13, upto 63) before dropping to weekly.  That's two 
weeks of snapshots so far.  Keep the weekly snapshots out to a quarter 
(13 weeks so 11 more, plus another 13 before thinning, 11-24, upto 87 
total).

At a quarter, you really should be thinking about proper non-snapshot 
full data backup, if you haven't before now, after which you can drop the 
older snapshots, thereby freeing extents that only the old snapshots were 
still referencing.  But you'll want to keep a quarter's snapshots at all 
times so will continue to accumulate another 13 weeks of snapshots before 
you drop the quarter back.  That's a total of 100 snapshots, max.

At 100 snapshots per subvolume, you can have 10 subvolume's worth before 
hitting 1000 snapshots on the filesystem.  A target of under 1000 
snapshots per filesystem should keep scaling issues due to those 
snapshots to a minimum.

If the 100 snapshots per subvolume snapshot thinning program I suggested 
above is too strict for you, try to keep it to say 250 per subvolume 
anyway, which would give you 8 subvolume's worth at the 2000 snapshot per 
filesystem target.  I would definitely try to keep it below that, because 
between there and 10k the scaling issues take larger and larger bites out 
of your btrfs maintenance command (check, balance) efficiency, and the 
time to complete those commands will go up drastically.  At 100k, the 
time for maintenance can be weeks, so it's generally easier to just kill 
it and restore from backup, if indeed your pain threshold hasn't already 
been reached at 10k.

Hopefully it's not already a problem for you... 365 days @ 24 hours per 
day is already ~8700 snaps, so it could be if you've been running it a 
year and haven't thinned, even if there's just the single subvolume being 
snapshotted.

Similarly, BTW, with btrfs quotas, except that btrfs quotas are still 
broken anyway, so unless you're actively working with the devs to test/
trace/fix them, either you need quota features and thus should be using a 
filesystem more stable and mature than btrfs where they work reliably, or 
you don't, so you can run btrfs while keeping quotas off.  That'll 
dramatically reduce the overhead/tracking work btrfs has to do right 
there, eliminating both that overhead and any brokenness related to btrfs 
quota bugs in one whack.

---
[1] A number of independent btrfs... on a pair of ssds, with the ssds 
partitioned up identically and multiple independent small btrfs, each on 
its own set of parallel partitions on the two ssds.  Multiple independent 
btrfs instead of subvolumes or similar on a single filesystem, because I 
don't want all my data eggs in the same single filesystem basket, such 
that if that single filesystem goes down, everything goes with it.

[2] Why continue to run a known-dying ssd for six months?  Simple.  The 
other ssd of the pair never had a single reallocated sector or 
indications of any other problems the entire time, and btrfs' 
checksumming and data integrity features, along with backups, gave me a 
chance to actually play with the dying ssd for a few months without 
risking real data loss.  And I had never had that opportunity before and 
was curious to see how the problem would develop over time, plus it gave 
me some real useful experience with btrfs raid1 scrubs and recoveries.  
So I took the opportunity that presented itself.   =:^)

Eventually, however, I was scrubbing and correcting significant errors 
after every shutdown of hours and/or after every major system update, and 
by then the novelty had worn off, so I eventually just gave up and did 
the btrfs replace to another ssd I had as a spare the entire time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

