Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55756 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab3HCIeU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Aug 2013 04:34:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V5XI1-0000RH-CJ
	for linux-btrfs@vger.kernel.org; Sat, 03 Aug 2013 10:34:17 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 10:34:17 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Aug 2013 10:34:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is the checkpoint interval adjustable?
Date: Sat, 3 Aug 2013 08:33:57 +0000 (UTC)
Message-ID: <pan$bb1b3$f11dc027$bb4a49a5$8dbad40@cox.net>
References: <20130802205842.157580@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mike Audia posted on Fri, 02 Aug 2013 16:58:42 -0400 as excerpted:

>> From: David Sterba There were a few requests to tune the interval. This
>> finally made me to finish the patch and will send it in a second.
> 
> Thank you, David and to others who kindly replied to my post.  I will
> try your patch rather than modifying the code
> 
>> > >  Are there any unforeseen and effects of doing this?  Thank you
>> > >  for
>> > > the consideration.
>> >
>> > I don't *think* that there should be. One way of looking at it is
>> > that both 30 and 300 seconds are an *eternity* for cpu, memory, and
>> > storage.
>> > Any trouble that you could get in to in 300 seconds some other
>> > machine could trivially get in to in 30 with beefier hardware.
>>
>> That's a good point and lowers my worries a bit, though it would be
>> interesting to see in what way a beefy machine blows with 300 seconds
>> set.
> 
> I have my system booting to a BTRFS root partition.  Let's say I'm using
> a value of 300 for my checkpoint interval.  Does this mean that if I do
> a TON of filesystem writes (say I update my system which pulls down a
> bunch of system file updates for example), and I copy over several gigs
> of data from a backup, all _between_ checkpoints and for some reason, my
> system freezes forcing me to ungracefully restart... is EVERYTHING since
> the last checkpoint is lost?

When I tried btrfs on faulty hardware a bit over a year ago, yes.  And 
yes, that's the way a btree filesystem such as btrfs generally works, 
too, because when a change happens, it recurses up the tree until finally 
the master node is updated.  Until the master node is updated, the old 
master node remains effective.

During the time between the first change and the master node update, 
additional changes may occur, making the final master node update and 
likely several below it more "efficient", since that single write now 
covers more than a single change.  However, if the system bellys up in 
the meantime, that means you lose everything since the last master node 
update.

Here's my experience from last year.  I had some failing hardware, which 
turned out to be the mobo, but before I ultimately figured out the 
problem, I thought it was the disks.  Thus, I bought a new one and 
attempted to replace what I thought was a failing one, copying everything 
over, and thinking I'd try the new to me btrfs while I was at it.

But what was really happening hardware-wise was that my then 8-year-old 
mobo had some capacitors going bad (I found several bulging and others 
burst when I finally figured out it was the mobo).  That was triggering 
intermittent I/O errors that I had (wrongly) attributed to the disks 
dying, thus the replacement attempt.  The symptom was SATA retries, 
downgrading the speed and retrying again, and eventually timing out and 
resetting the SATA interface.  Only sometimes the whole system would 
lockup before a successful reset, or it would timeout and reset enough 
times that I'd give up and do a full system reset.  The one thing I /did/ 
notice was that if I kept things cold enough (by the time I was done I 
had the AC turned down so far I was sitting here in a full winter jacket, 
long underwear, and a knit hat... in a Phoenix summer with temps of 
40-45C/100-115F outside!!), the system would work better, so that's what 
I was trying to do.

It was in this environment that I was attempting to copy all my old data 
from what I /thought/ was a failing disc drive (or drives, I was running 
md/raid1 for most of the system), initially blaming the copy failures on 
what I thought was the failing drive(s), until I had enough data on the 
new drive to try disconnecting the old drives and copying data around on 
the new drive.  When that acted up with the old drives entirely 
disconnected, I realized it wasn't the drives after all, and eventually 
found the problem.

But meanwhile, when I'd have to reset, what I'd find is that on btrfs, 
the whole tree I had been trying to copy over, and that I /thought/ had 
mostly copied fine, was gone.

Or worse, part of the metadata had copied, the filesystem tree or at 
least part of it, and was still there after a reboot, but all or most of 
the files were zeroed out!!  At least if nothing at all copied I knew 
right away where I was at.  With the zeroed out files, I'd have to figure 
out how much actual data had copied and remained on the new drive, and 
where it had gone from saving everything to only saving the metadata, 
with the actual files zeroed out.  Then I could delete them and try again.

My previous filesystem (and the one I returned to for a year after I gave 
up on btrfs for the time being, I'm back on btrfs, with new SSDs, now) 
was reiserfs.  It has actually been *IMPRESSIVELY* reliable for me, even 
thru various hardware failure, at least since the reiserfs data=ordered 
by default mode was introduced back in kernel 2.6.6 or some such.  (As it 
turns out, it was the same Chris Mason working on that after Hans Reiser 
and Namesys basically abandoned reiserfs in favor of working on reiser4, 
that's behind btrfs now, so he knows his filesystems!)

What I found is that with properly tuned vm.dirty_* as explained in my 
earlier post, or with repeatedly hitting the magic-SRQ emergency sync 
hotkey (alt-srq-s), reiserfs had a chance to lose *ONLY* the data that 
hadn't yet been synced, while btrfs would tend to either entirely lose or 
zero out the files for entire freshly copied trees, since the start of 
the copy operation, EVEN WHEN I HAD BEEN EMERGENCY SYNCING EVERY FEW 
SECONDS AS THE COPY PROGRESSED!!

Obviously, then, btrfs simply wasn't going to work with my at the time 
bad hardware, certainly not for the massive data transfers I was trying 
to do, since with btrfs after a crash I had lost pretty much all of the 
current copy I had been doing, while reiserfs would reliably actually 
sync when I hit the emergency sync sequence, so after a crash I'd lose 
ONLY the few files since the last sync a few seconds before.  Thus, even 
with failing hardware I could make reasonable progress with the copy when 
the destination was reiserfs, where with btrfs, in most cases I was back 
at square one, as if I'd never done that copy at all, or worse yet, with 
a bunch of zeroed out files where the metadata was retained but not the 
actual data.

So I switched back to reiserfs for a year, and only tried btrfs again 
from a couple months ago now, when I upgraded to SSD and thus had both 
brand new and much faster hardware to worth with, AND needed a filesystem 
more suited to SSD than reiserfs.  (I had found reiserfs MUCH better and 
more robust for my needs than ext3/4 back on spinning rust, and didn't 
really want to go ext4 on SSD either, tho I probably would have without 
btrfs where it is now.)

In that year btrfs has GREATLY matured as well, and to be honest I'm not 
sure whether its btrfs increased maturity and stability over that year or 
the fact that I'm on actually GOOD hardware now that makes the btrfs 
experience so much better for me now, but regardless, btrfs IS still 
experimental, and even when that label comes off, I expect it'll take 
quite some time to reach the stability of current reiserfs, just as it 
took time for reiserfs to reach that.  But of course btrfs is far more 
flexible than reiserfs as well, both SSD-wise and in general.  Still, in 
a crash and DEFINITELY in the failing hardware scenario, I'd definitely 
put a lot more trust in reiserfs than in btrfs, and I expect it'll be 
that way for some time to come.

> Upon a reboot, will BTRFS just mount up to
> the last good checkpoiint automatically or will I have a broken system
> and need to add the `-o recovery` option while I mount it manualy from a
> chroot?

In general btrfs should simply mount the last checkpoint automatically.  
And with a recently created filesystem I think it'll do pretty good at 
that.  However, btrfs IS still experimental, and particularly with older 
filesystems that have had a lot of use before some of the recent bugfixes, 
that's not always a given, and recovery (or restore from backups, which 
given btrfs experimental status, are even MORE important than they'd be 
on a filesystem considered stable, basically, consider all your data on 
btrfs as "throw away" if it comes to it -- keep your primary copy as well 
as its backups on something other than btrfs at least until that 
experimental label comes off) is occasionally necessary.

> Another naive question: if I shutdown the system between checkpoints,
> systemd should umount my partitions.  Does the syncing of cached data
> occur after the graceful umount?

As is normally the case on Linux, once the graceful umounts (or remount-
read-onlys) have fully happened, you should be good to go.  Syncing 
should be completed before the umount (or remount read-only) is 
completed, so you should be safe after that.

There have however been a few bugs, to my knowledge now all fixed, where 
the umount wouldn't complete (livelock), and even a few where it would 
appear to complete but the filesystem was continuing to do stuff in the 
background, such that shutting it down before that was complete would 
result in corruption.  AFAIK a shutdown after initiating a btrfs balance, 
before it completed, used to be one such situation, but btrfs now 
properly suspends the balance and quiesces the filesystem before umount, 
resuming it at remount read/write.  On a slow multi-terabyte "spinning 
rust" filesystem, a full balance can take quite some time (hours to tens 
of hours), so not being able to properly gracefully suspend that balance 
for umount and resume after a remount was a BIG problem, now fixed, as I 
said.  But the caveat about btrfs' experimental/developmental status 
remains -- there ARE still bugs being found and fixed; choose a fully 
stable filesystem, not the still experimental btrfs, if you're not 
willing to keep backups and consider everything you put on btrfs for the 
time being subject to potential loss if the worst should happen.

And of course as the wiki[1] recommends, if you do choose to run btrfs, 
keep current on your kernels, as they really ARE fixing bugs in real-
time, and if you're running a kernel older than the latest Linus stable 
series, you *ARE* going to be missing bugfixes that just /might/ save you 
from serious btrfs problems.

---
[1] Btrfs wiki: https://btrfs.wiki.kernel.org/

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

