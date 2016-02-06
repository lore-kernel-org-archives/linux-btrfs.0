Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49941 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbcBFInL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Feb 2016 03:43:11 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aRyST-0007aJ-HE
	for linux-btrfs@vger.kernel.org; Sat, 06 Feb 2016 09:43:09 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 09:43:09 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Feb 2016 09:43:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS RAM requirements, RAID 6 stability/write holes and
 expansion questions
Date: Sat, 6 Feb 2016 08:43:03 +0000 (UTC)
Message-ID: <pan$ce3b3$68b46c86$49ef689d$3d714f96@cox.net>
References: <CAKr9ZMFwxZ01gw7SAyFReOfXFb=hVzUXNgYoGcUc2xzLuo+9mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mackenzie Meyer posted on Fri, 05 Feb 2016 14:36:33 -0500 as excerpted:

> Hello,
> 
> I've tried checking around on google but can't find information
> regarding the RAM requirements of BTRFS and most of the topics on
> stability seem quite old.
> 
> So first would be memory requirements, my goal is to use deduplication
> and compression. Approximately how many GB of RAM per TB of storage
> would be recommended?

The inline dedup patches are just reaching maturity and mainlining right 
now, and aren't in a release yet.  Dedup's not my use-case so I've not 
been following it /too/ closely, but briefly, as it's shaping up there's 
going to be two backends available, an on-device backend that will be a 
bit slower but should be more efficient at deduping, and an in-memory 
backend that will be fast but less efficient.  Dedup memory usage is 
configurable, however, with a rather low default of (IIRC) some MiB, 
certainly nothing like GiB, unless of course you configure it that way 
(which you may wish to if you have the memory and choose the memory-based 
backend).

The memory issue is thus neither dedup nor compression (which is on-the-
fly and uses very little additional memory).

Instead, btrfs memory issues tend to be scaling related, specifically, 
related to the number of subvolumes/snapshots, and to whether you have 
quotas activated.

I'm actually not sure what the current quota status is as of 4.4 and the 
in-development 4.5, but definitely, previous to that, quotas simply were 
not stable and had known-broken corner-cases as well as serious scaling 
issues, so the recommendation has been, you either need them or you 
don't: if you need them, use a filesystem where quotas are mature and 
stable; if not, use btrfs but leave quotas disabled as they have 
definitely caused many a user serious headaches as they simply didn't 
work well.  Unless of course you're specifically working with the devs to 
test current quota code, reporting results and potentially running 
debugging patches to get more info when there's problems, in which case 
go right ahead, as you're one of the folks that's helping to eventually 
make the feature stable and workable enough to actually depend on.

Btrfs snapshots/subvolumes are of course a relatively more stable btrfs 
feature and are regularly used by many.  But there remain scaling issues 
there as well, such that the recommended total filesystem cap on number 
of subvolumes (including snapshots, which are a special kind of subvolume 
that simply happens to share most of its data with other subvolumes) is 
no more than 1000-3000.  The number of snapshots of individual 
subvolumes, meanwhile, should be kept to 250 or so, which is actually 
pretty reasonable even if you're starting with for instance half-hourly 
auto-snapshotting (using snapper or the like), as long as a reasonable 
snapshot thinning schedule is followed as well.

(As I've posted several times, starting with half-hourly snapshots, 
thinning to hourly after say 12 hours, 2-hourly after 48 hours, daily 
after a week, and weekly after perhaps 13 weeks (a quarter), then keeping 
the remaining weeklys for another year, so 15 months of snapshots total, 
after which if you haven't backed up to other media you obviously aren't 
worried too much about losing the data anyway, you're still reasonably 
close to 250-300 snapshots per subvolume, thus allowing snapshotting of 
up to eight subvolumes on a similar program while still staying within 
the filesystem cap of 2000 or so snapshots/subvolumes.)

Because with btrfs snapshotting being so easy, what we too often see if 
people aren't warned about it, are people with 100K snapshots or the 
like.  And during normal runtime, other than perhaps some slowdown due to 
fragmentation, etc, even that works deceptively well.

Where the _problem_ occurs, however, is when you try to actually do 
filesystem maintenance on that monster!  Both btrfs balance and btrfs 
check slow down *dramatically*, to the point of practical unworkability, 
somewhere in the double-digit-K (tens of thousands) snapshots range.  
With 3000 it's noticeably slower than with only 1000, but while slow, 
it's still _usable_.  Which is why the 1000-3000 range.  Depending on 
people's pain point vs snapshotting needs, 1000 snapshots shouldn't be 
much of a problem yet, but might not be enough for people with more than 
3-4 subvolumes they want to keep snapshotted, while 3000 snapshots will 
already be hitting the pain point for many, but may be needed and still 
just fast enough to be tolerably usable given the tradeoff, for people 
with many subvolumes they want to keep snapshotted.

And based on reports, btrfs check with tens of thousands of snapshots is 
where memory usage goes thru the roof as well.  I'm not actually sure 
about balance in terms of memory usage, tho it's definitely much slower 
with that many snapshots.

It can also be noted that the problem affects snapshot deletion (unlike 
snapshot creation which is effectively instantaneous, thus making it 
deceptively easy for the unaware to get in such a hole with hundreds of 
thousands of them, if they're doing scheduled snapshots but don't have a 
snapshot thinning schedule setup as well) as well, since btrfs has to go 
thru and sort out which other snapshots reference the same extents and 
either delete the extents or simply reduce the reference count 
accordingly, and if there's 100K snapshots to process, that can be 
expected to take awhile.

Meanwhile, that's the problem for quotas as well, as they apparently at 
least double the problem compared to snapshots without quotas.  And 
because at least until very recently (current status unknown) they've 
actually been broken and not reliable anyway, it simply hasn't been worth 
the hassle, thus the "just turn them off, or if you actually need them, 
use a filesystem where they're actually stable and reliable, not btrfs as 
that's anything but the case here" recommendation.

> RAID 6 write holes?
> The BTRFS wiki states that parity might be inconsistent after a crash.
> That said, the wiki page for RAID 5/6 doesn't look like it has much
> recent information on there. Has this issue been addressed and if not,
> are there plans to address the RAID write hole issue? What would be a
> recommended workaround to resolve inconsistent parity, should an
> unexpected power down happen during write operations?

My own use-case is raid1 (preferably N-way-mirroring raid1 like mdraid, 
but with btrfs runtime checksum verification, except that N-way-mirroring 
is still to come, with current btrfs being pair-mirroring only, 
unfortunately, so pair-mirroring I must be satisfied with, for now), so 
while I've followed the raid56 situation with academic interest, it's not 
personal interest so my detail knowledge is a bit more limited for raid56.

So I don't know for sure what the btrfs-specific status is on the raid56 
write hole.  What I _do_ know is that raid5 and 6 in general are known to 
have a write hole, that applies to parity-raid, in general.  Various 
specific implementations try to do various things to limit damage, but as 
it's a limitation of parity-raid technology in general, there's a limit 
to the degree the hole _CAN_ be worked around or plugged.  Certainly it's 
possible, but many implementations don't consider the complexity and 
performance tradeoffs to be worth it, vs. the risk for their target use-
case(s).

So while I don't know the btrfs specifics, other than that btrfs raid56 
modes do, like most other raid56 implementations, have a write hole to 
worry about, I do know that the problem is a general parity-raid problem, 
not btrfs-specific (tho due to btrfs' per-chunk raid vs. the more usual 
per-device raid, it is indeed quite likely that the effect of the write 
hole on btrfs is different, and may be much more likely to trigger 
problems... I simply don't know further detail in that area).

> RAID 6 stability?
> Any articles I've tried looking for online seem to be from early 2014,
> I can't find anything recent discussing the stability of RAID 5 or 6.
> Are there or have there recently been any data corruption bugs which
> impact RAID 6?

Back when btrfs raid56 mode was first nominally complete in kernel 3.19, 
about a year ago, I warned people not to consider it at all stable until 
at _least_ a year, five kernel cycles, after initial nominal completion.  
Turns out I was right, and there were several pretty serious bugs in 
raid56 mode for 3.19, 4.0 and into the early 4.1 cycle (tho I believe the 
fixes were in well before 4.1 release).

I also suggested that a further stability-recommendation requirement, 
from my point of view anyway, was at least two full kernel cycles without 
serious raid56 bugs.  Thus, while 4.4 does complete the year, the 
question now becomes one of whether there have been any serious raid56 
bugs since the last "blocker-level" bug was fixed in early 4.1.

Keeping in mind that following filesystem failure reports on the lists of 
even so-called "stable" filesystems like ext4 certainly isn't for the 
faint of heart, because there you only see the problems not the tens to 
hundreds of thousands of "no problem" installs...

I'd honestly call it an open question.

There have certainly been a couple reports of failure to recover from 
device loss as expected into 4.3 at least, but I don't know if they've 
actually been traced to raid56 mode problems, or if they're unrelated 
bugs, or maybe simply related to that previously discussed write hole...

Personally, if I had to call it right now, I'd say treat raid56 as 
borderline stable, definitely not yet to the stability level of the rest 
of btrfs in general, but also reasonably obviously beyond the initial 
"teething problems" bugs, as there's reports of bugs that _could_ be 
raid56 related, but to my knowledge at least, there's been nothing 
definitely pinned to raid56 bugs since the last blocker-level bugs were 
fixed in 4.1.

If there's time, I'd definitely prefer to give it another couple kernel 
cycles, to 4.6 or so, after which 4.4 as an LTS kernel will get 4.6's bug-
fix backports, so assuming no big raid56 bugs show up by then, once it 
gets those backports I'd probably consider 4.4-LTS as btrfs raid56 stable 
as 4.6.

So 4.4 should be healthily developing toward btrfs raid56 stable, but I'd 
still not consider raid56 mode as stable as the rest of btrfs until 4.6 
or so, that of course assuming no bad raid56 bugs appear in the mean time.


There *IS* one known caveat at this point, however.  Raid56 parity 
rebuild or balance to more/fewer devices can be ***VERY*** slow at this 
point -- but isn't for everyone.  We have multiple reports and at least 
one independent test confirmation of those reports to that effect.  We're 
talking 2 MiB/sec slow... One guy doing a raid6 reshape from 10 devices 
to 12 indicated 3% completion in three days, 1%/day so ~ 100 days to 
complete, tho he was able to continue using the filesystem for other 
things, with longer IO times, of course, while it was happening.

Again, not everyone is seeing it, but it's common enough that there's 
probably something going on there that we don't know about yet, that 
needs fixed.

FWIW, here's a gmane-archive link to the most informative recent thread 
on the problem:

http://comments.gmane.org/gmane.comp.file-systems.btrfs/52469


Tho something just occurred to me... I wonder if the problem might 
actually be the snapshots and/or quota scaling issues discussed above.  
That scaling issue is definitely one entirely unrelated to raid56 mode 
problem that we already know about, and if they have quotas and 100K or 
so snapshots, it'd pretty well explain things, because that's /exactly/ 
the sort of maintenance-time problems triggered with too many snapshots 
and/or fewer but also active quotas.

> Would you consider RAID 6 safe/stable enough for production use?
> 
> Do you still strongly recommend backups, or has stability reached a
> point where backups aren't as critical? I'm thinking from a data
> consistency standpoint, not a hardware failure standpoint.

This actually could be your show-stopper, but not for the reason you 
think.

On this list, btrfs _in_ _general_ is still considered "stabilizING, not 
yet fully stable and mature, and not yet ready for 'production use.'"  
Let me emphasize that.  It's *not* just raid56 mode, which is as 
explained above not yet as stable as btrfs in general, but ALL OF BTRFS 
that is not yet considered fully stable, not yet ready for production 
usage, and *DEFINITELY* backups recommended!

In fact, I've actually developed a bit of a reputation on this list for 
drumming this point home in various levels of detail, depending on how 
detailed I feel like being:

The sysadmin's first rule of backups states that for any level of backup 
and the corresponding risk factor of having to use it, your data is 
either worth the hassle and resources necessary to do that (additional?) 
level of backup, or it's not.  Absolutely trivial data, internet cache, 
on Linux, probably the local packages cache, etc, is either easily 
redownloaded/recreated, or simply not worth worrying about at all, and is 
thus likely not worth even a single level of backup.  OTOH, extremely 
valuable data may be worth 101 levels of backup or more, some offsite in 
multiple locations to protect against disaster outages, etc, because the 
data is simply valuable enough that even given the extremely small risk 
of losing or finding bad all 100 previous levels of backup at the same 
time, it's still worth that 101 level (more?) of backup, just in case.

That's for *ANY* filesystem, including the most mature and stable ones.  
Put in simpler form, if you don't even have a single level of backup, you 
are by your actions, defining that data as of trivial value at best, 
since the risk of having to actually use that primary backup isn't 
trivial at all, even on the most stable and mature filesystem on proven 
stable hardware.

Of course with btrfs itself being still stabilizing, not yet fully stable 
and mature, the risk factor of actually having to use that backup is 
higher, high enough that arguably, you consider the working copy a throw-
away copy, and the first level of backup your actual primary copy, such 
that a second level of backup can actually be considered your first level 
of backup.

And of course as I said, btrfs raid56 mode, while developing in a healthy 
way with no known show-stoppers for a couple kernels, still isn't yet 
what I'd call quite as stable as btrfs in general, so that ups the risk 
factor yet again.

So seriously, either have that backup made _before_ you need it, or be 
glad when you lose the data that after all you only lost the trivial 
stuff, because your actions defined the time and resources saved by NOT 
doing the backup to be worth more than the data you were risking losing, 
and you saved it even if you did lose the data, which means you really 
CAN still be happy, because you really DID save what your actions defined 
as most important to you. =:^)

And if you don't like the way that sounds, seriously, do NOT consider 
raid56 mode at this time, and really, you should be reconsidering even 
thinking about btrfs at all, because you need stability in your 
filesystem that btrfs simply isn't ready to provide, yet.  (Tho I do 
wonder if the ext4, or for that matter, pretty much any other filesystem 
devs, would consider their filesystem _that_ stable, to be ready to 
handle those who aren't willing to make backups, who then blame the 
filesystem instead of their priority-defining actions when data is 
inevitably lost -- because on ANY filesystem and hardware, it's not if, 
it's when, that being the whole reason behind the sysadmin's first rule 
of backups and those multiple levels of backup in the first place.)

> I plan to start with a small array and add disks over time. That said,
> currently I have mostly 2TB disks and some 3TB disks. If I replace all
> 2TB disks with 3TB disks, would BTRFS then start utilizing the full 3TB
> capacity of each disk, or would I need to destroy and rebuild my array
> to benefit from the larger disks?

With raid6, btrfs needs four devices to allocate new raid6 chunks.  
Additional devices with space available simply increase the width of the 
stripe and (to a limit) the size of the chunk.  Allocation is is width-
first, using all devices with space available.

So with a mix of 2TB and 3TB devices, btrfs raid6 would allocate across 
all devices until the 2TB devices are full, after which, as long as there 
are still at least four 3TB devices available with their remaining free 
space, it'll continue to allocate additional chunks to just them.

When you add devices, they will of course have much more space available 
than the others.  So btrfs will start allocating to them too, but will 
still allocate from the old devices as well until they are entirely out 
of room.  As such, unless a balance is done to reallocate existing 
chunks, if you add one device at a time, you may come to a point where 
there's no longer unallocated space on older devices, only on new 
devices, and there's not at least four of them, so btrfs will be unable 
to allocate additional raid6 chunks, and the space on the odd new devices 
will be unusable in raid6 mode at least until you add more devices so 
there's unallocated free space on at least four of them again.

You can of course do a rebalance after adding new devices so existing 
stripes are rewritten broader, over the new devices as well (and 
similarly, btrfs device remove will trigger a reshape-rebalance to narrow 
the stripes and put the data that was on that removed device elsewhere) 
but as mentioned above, at least right now, some people are finding that 
operation to be *extremely* slow.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

