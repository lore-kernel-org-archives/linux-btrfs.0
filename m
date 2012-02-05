From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Sun, 5 Feb 2012 05:02:47 +0000 (UTC)
Message-ID: <pan.2012.02.05.05.02.46@cox.net>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx>
	<fgdov8-ord.ln1@hurikhan.ath.cx> <51epv8-2qu.ln1@hurikhan.ath.cx>
	<pan.2012.02.02.11.19.06@cox.net> <mkirv8-uns.ln1@hurikhan.ath.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Kai Krakow posted on Fri, 03 Feb 2012 00:25:51 +0100 as excerpted:

> Duncan <1i5t5.duncan@cox.net> schrieb:
> 
>> I had hoped someone else better qualified would answer, and they may
>> still do so, but in the meantime, a couple notes...
> 
> Still I think you gained good insight by reading all those posts. I'm
> using btrfs for a few weeks now and it is pretty solid since 3.2. I've
> been reading the list a few weeks before starting btrfs but only looked
> at articles about corruption and data loss. I started using btrfs when
> rescue tools became available and the most annoying corruption bugs had
> been fixed.
> But I've been hit by corruption and freezes a few times so I decided to
> have that big usb3 disk which I rsync every now and then using snapshots
> for rollback.

Agreed on the insight from reading, and good to read that it has been 
pretty solid for you since 3.2

What I seem to be seeing is that the normal single-disk/dual-metadata 
setup seems to be reasonable, a few weird reports here and there 
including the ENOSPC stuff, but nothing huge.

But my primary interest is raid1 both data and metadata, more than two-
copies (3-4), and > 2-copy just doesn't appear to be available yet (but 
see the article linked below, which says 3.4 timeframe).  Even the two-
copy setup looks like it still has major problems, including a recent 
thread reporting an inability to allocate further chunks when in degraded 
mode, so as soon as currently in-use chunks get full (maybe a gig or so 
instead of 20 in that test), ENOSPC.

So I think I'll wait another kernel cycle or two... but now that I'm 
here, I'm going to continue tracking the list, so I'll be ready to go 
when the time comes.

>> 1) "phantom ENOSPC bug"

> On my first thought this was my suspicion, too. But otoh there was no
> ENOSPC message, neither in dmesg nor in rsync. Rsync just froze, I was
> able to kill it and my script continued to create a snapshot afterwards
> and unmount. I tried to mount again after btrfsck, it worked fine, I
> unmounted, system hung. I rebooted, scrubbed my two-disk array, no
> problems, I mounted the backup disk again, rsync'ed it, went fine,
> unmounted. But btrfsck still shows the same errors for this disk. *sigh

Good point.  It looks similar to the ENOSPC bug, but without the ENOSPC.

But keep in mind that they're apparently simply throttling as a near-term 
workaround and haven't fully traced the bug, yet.  Given the otherwise 
similar trigger and symptoms, your reported problem could thus be a 
variant of the same bug, that happened to freeze rsync instead of erroring 
out with ENOSPC.  If so, when they do finally nail that one, it could 
well either nail yours or at least make it easier to trace, as well.


> I think btrfs should try to fix such corruptions online while using it.
> From what I've learned here this is the long-term target and a working
> btrfsck should just be a helper tool. And the reason for the long
> delayed btrfsck is that Chris wants to have proper online fixing in
> place first.

I had seen articles pointing out that the mount-time and online fixing 
tools were indeed taking up some of the slack, but this is the first time 
I've seen it claimed as a major strategy, vs. the problems they've been 
seeing simply being easy enough to fix online once they track them down 
sufficiently to fix them at all, online or off.  However, it does make a 
lot of sense to do what you can online, and until the last couple weeks I 
could have easily missed that it was deliberate since I wasn't following 
btrfs closely enough to be sure to catch it before that, so it well may 
/be/ a deliberate strategy.  I believe you're correct.

> At least I can tell this corruption was introduced by bad logic in the
> kernel, and not by some crash. The usb3 disk is solely mounted for the
> purpose of rsync'ing and unmounted all the other times.

That's a good point, as well.

>> 2) Just a couple days ago I read an article that claimed Oracle has a
>> Feb 16 deadline for a working btrfsck as that's the deadline for
>> getting it in their next shipping Unbreakable Linux release.  I won't
>> claim to know if the article is correct or not, but if so, a reasonably
>> working btrfsck should be available within two weeks. =:^)  Of course
>> it may continue to improve after that...
> 
> Sounds good. I wonder if Chris could tell anything on that point. ;-)
> 
>> Meanwhile, there's a tool already available that should allow
>> retrieving the undamaged data off of unmountable filesystems, at least,
>> and there's another tool that allows rollback to an earlier root node
>> if necessary

> The tools are btrfs-rescue and btrfs-repair from Josef's btrfs-progs
> available from github.

Thanks.  

> But if you could provide a link for the Feb 16 deadline I'd be eager to
> read the article.

It was a couple days before I could go looking, thus the delay in this 
post, and it might be Feb 14 not 16, but...

The basis seems to be Chris Mason's talk at SCALE 10x LA, so there should 
be independent coverage on various Linux new sites.  Here's the one I 
googled up first (using the Feb 16 date, that at least here appears to be 
Feb 14, which might explain why I had trouble googling it).  Phoronix.

http://www.phoronix.com/scan.php?page=news_item&px=MTA0ODU

That might have been the one I read, originally.  (I subscribe to
lxer.com 's feed, which covers Linux and Android stories from around the 
net, including phoronix, and would have clicked that if it had come up, 
but don't remember for sure whether that was it or if there was another.)

There's a bit more tech detail, including the new tidbit about multiple-
mirroring that I mentioned above, in a different article.

http://www.phoronix.com/scan.php?page=news_item&px=MTA0Njk

I had discovered much to my dismay that so-called btrfs-raid1 only does 
dual-copy, not full raid1 to an arbitrary number of copies.  My current 
disks are old enough that I really don't want to risk two-copy-only, 
especially since I'm currently running 4-spindle md/raid1 for most of my 
system so I already have the disks.  I originally installed md/raid6 for 
most of my data, thus the quad-spindle, but after running it for awhile, 
decided raid-1 fit my needs better.  If I'd have known about raid5/6 at 
purchase and setup time what I know now, I'd have probably gone 2-spindle 
raid1 then, with a third as a hot-spare, and saved myself the money on 
the 4th one.  The two-way would have been fine for current btrfs, but 
given that I'm running 4-way raid1 now and the disks are about mid-life 
operating hours, according to SMART, I simply don't want to risk 
switching to two-way-only mirroring, only to then have both mirrors of 
after all aging disks die at once.

So I've been debating whether btrfs DUAL mode (dual metadata on the same 
device, single data) on 4-way md/raid1s would be better, or btrfs-raid1s 
(two-way-mirrored data and metadata both, since two-way is all that's 
possible ATM) layered on pairs of 2-way md/raids would be better.  The 
latter would play to btrfs' ability to recover data from a different 
mirror when necessary.  But I already run a dozen md/raids on partitions 
across the same four physical devices, and that would double it to two-
dozen.  At some point it's no longer a workable solution...

But if triple-way mirroring (and one assumes N-way mirroring can't be far 
behind that if it's not what was meant) will show up in 3.4 or 3.5, as 
that article suggests, and with the writing-fsck being out for awhile by 
then if it's coming out later this month, that might well be my upgrade 
time.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

