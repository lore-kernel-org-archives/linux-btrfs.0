Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56519 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbaITF7H (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 01:59:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XVDhI-0006Vd-VI
	for linux-btrfs@vger.kernel.org; Sat, 20 Sep 2014 07:59:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 07:59:04 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 07:59:04 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Performance Issues
Date: Sat, 20 Sep 2014 05:58:52 +0000 (UTC)
Message-ID: <pan$9d45b$35a57b34$29d0d2ef$8358244@cox.net>
References: <1411129114.1811.7.camel@zarniwoop.blob>
	<541C464F.3030600@fb.com> <1411145469.1601.2.camel@zarniwoop.blob>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rob Spanton posted on Fri, 19 Sep 2014 17:51:09 +0100 as excerpted:

> The evolution problem has been improved: the sqlite db that it was using
> had over 18000 fragments, so I got evolution to recreate that file with
> nocow set.  It now takes "only" 30s to load my mail rather than 80s,
> which is better...
> 
> On Fri, 2014-09-19 at 11:05 -0400, Josef Bacik wrote:
>> Weird, I get the exact opposite performance.  Anyway it's probably
>> because of your file layouts, try defragging your git dir and see if
>> that helps.  Thanks,
> 
> Defragging has improved matters a bit: it now takes 26s (was 46s) to run
> git status.  Still not amazing, but at the moment I have no evidence to
> suggest that it's not something to do with the machine's hardware.  If I
> get time over the weekend I'll dig out an external hard disk and try a
> couple of benchmarks with that.

[Replying via mail and list both, as requested.]

If you're snapshotting those nocow files, be aware (if you aren't 
already) that nocow, snapshots and defrag (all on the same files) don't 
work all that well together...

First let's deal with snapshots of nocow files.

What does a snapshot do?  It locks in place the existing version of a 
file, both logically, so you can get at that version of it via the 
snapshot even after changes have been made, and physically, it locks 
existing extents where they are.  With normal cow files this is fine, 
since any changes would cause the changed block to be written elsewhere, 
freeing the now replaced block if there's nothing holding it in place.  A 
snapshot simply keeps a reference to the existing extent when the data is 
cowed elsewhere instead of releasing it, so there's a way to get the old 
version as referenced by that snapshot back too.

But nocow files are normally overwritten in place, that's what nocow 
/is/.  Obviously that conflicts with what a snapshot does, locking the 
existing version in place.

What btrfs does, then, to handle that, is on the first write to a (4KB) 
block in a (normally) nowcow file after a snapshot, a cow write is forced 
on that block anyway.  The file remains nocow, and additional writes to 
the /same/ block continue to write to the same new location... until 
another snapshot locks /that/ in place.

All fine if you're just doing occasional snapshots and/or if the nocow 
file isn't being very actively rewritten after all; it's not that big a 
deal in that case.  *BUT*, if you're doing time-based snapshots say every 
hour or so, and the file is actively being semi-randomly rewritten, the 
constant snapshotting locking in place the current version, forcing many 
of those writes to cow anyway, is going to end up fragmenting that file 
nearly as fast as it would without the nocow.  IOW, the nocow ends up 
being nearly worthless on that file!

There is a (partial) workaround, however.  You can use the fact that 
snapshots stop at subvolume boundaries, putting the nocow files on their 
own dedicated subvolume.  You can then continue snapshotting the up-tree 
subvolume as you were before and it'll stop at the dedicated subvolume, 
so the nocow files on that subvolume don't get snapshotted and thus don't 
get fragmented anyway.

Of course without that snapshotting you'll need to do conventional backup 
on the files in that dedicated nocow subvolume.

Another alternative is to continue snapshotting the dedicated subvolume 
and its nocow files, but at a lower frequency, perhaps every day or twice 
a day instead of every hour, or maybe twice a week instead of daily, or 
whatever.  That will slow down but not eliminate the snapshot-triggered 
fragmentation of the nocow files.

If you then combine that with scheduled (presumably cron job or systemd-
timer) defrag of that dedicated subvolume, perhaps weekly or monthly, 
depending on how fast it still fragments, that can help keep performance 
from dragging down too badly.

Of course you can use the scheduled defrag technique without the 
dedicated subvolume and just up the frequency of the defrags instead of 
decreasing the frequency of the snapshotting, too, if it works better for 
you.


Meanwhile, how big are those files?  If you're not dealing with any nocow-
candidate files approaching a gig or larger, you may find that the 
autodefrag mount option helps.  However, it works by queuing up a rewrite 
of the entire file for a worker thread that comes along a bit later, and 
if the file is too big and being written to too much, the changes to the 
file can end up coming faster than the file can be rewritten.  Obviously 
that's not a good thing.  Generally, for files under 100 MB autodefrag 
works very well.  For actively rewritten files over a GB, it doesn't work 
well at all, and for files between 100 MB and 1 GB, it depends on the 
speed of your hardware and how fast the rewrites are coming in.  
Actually, most folks seem to be OK up to a quarter GiB or so, and most 
folks have problems starting around 3/4 GiB or so.  256-768 MiB is the 
YMMV zone.

Meanwhile, from what I've read sqlite apparently works best with under 
half a gig of data to manage anyway, otherwise it's time to consider 
scaling up to something like mysql/mariadb.  So for most people, if all 
they're dealing with is sqlite files, they're usually under half a gig in 
size and the autodefrag mount option works at least reasonably well.


But I mentioned defrag as not working so well with snapshots too.  The 
problem there is somewhat different.

Before kernel 3.9 btrfs defrag wasn't snapshot aware -- it would defrag 
just the current snapshot, leaving others in place.  This of course 
duplicated the data that defrag moved since the old locations couldn't be 
freed as other snapshots were still referencing them, thus eating up 
space rather faster than might have been expected.

With 3.9 defrag became snapshot aware, and would track and adjust all 
reference to a block when defrag moved it.  Unfortunately, that first 
attempt had **HUGE** scaling issues -- defrags that should have taken 
hours were taking days, even weeks, and multiple gigabytes of memory, 
such that it was running into out-of-memory errors even on 16 and 32 GiB 
RAM machines!  (IIRC we had one report of it happening on a 64 gig 
machine too!)  Let alone the poor 32-bit folks!  It turned out that 
quotas and snapshots were the big culprits, and people with thousands of 
snapshots (as can happen with snapper and the like if it's not set to 
thin them out regularly) AND quotas enabled simply found defrag didn't 
work at all for them.

So along about 3.12 (I'm not sure exactly), that first attempt at 
snapshot-aware-defrag was disabled again, so people could at least /run/ 
defrag.

While they've rewritten various bits to scale MUCH better now, snapshot-
aware-defrag remains disabled for the time being.

Which means defrag is again only working on the current snapshot it is 
pointed at, leaving other snapshots in place as they are.  Which means if 
you're snapshotting and defragging, and not deleting those snapshots 
within a reasonable time, data usage is going to go up as defrag 
duplicates the data it moves around, because it's only moving it around 
for the current snapshot, the references other snapshots have to the 
fragmented version remain in place, continuing to take up space until all 
snapshots referencing the old blocks are deleted.

So if you're doing regular snapshots, try to keep them to a reasonably 
limited time frame, with conventional backups if needed before that.  If 
you can keep snapshots to a month's time, great.  But do try to keep it 
to 60 or 90 days if possible.  Beyond that, keep conventional backups if 
you need to.  And since btrfs is still under development and not fully 
stable, such backups are strongly recommended anyway.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

