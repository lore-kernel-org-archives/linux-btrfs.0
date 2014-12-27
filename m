Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44047 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbaL0Fyl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Dec 2014 00:54:41 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y4kKk-0003i0-OX
	for linux-btrfs@vger.kernel.org; Sat, 27 Dec 2014 06:54:38 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Dec 2014 06:54:38 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Dec 2014 06:54:38 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS free space handling still needs more work: Hangs again
Date: Sat, 27 Dec 2014 05:54:27 +0000 (UTC)
Message-ID: <pan$18609$1b7eaac8$6b7c69d$a9794a34@cox.net>
References: <3738341.y7uRQFcLJH@merkaba> <549DE5C6.2000606@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White posted on Fri, 26 Dec 2014 14:48:38 -0800 as excerpted:

> ITEM: An SSD plus a good fast controller and default system virtual
> memory and disk scheduler activities can completely bog a system down.
> You can get into a mode where the system begins doing synchronous writes
> of vast expanses of dirty cache. The SSD is so fast that there is
> effectively zero "wait for IO time" and the IO subsystem is effectively
> locked or just plain busy.
> 
> Look at /proc/sys/vm/dirty_background_ratio which is probably set to 10%
> of system ram.
> 
> You may need/want to change this number to something closer to 4. That's
> not a hard suggestion. Some reading and analysis will be needed to find
> the best possible tuning for an advanced system.

FWIW, I can second at least this part, myself.  Half of the base problem 
is that memory speeds have increased far faster than storage speeds.  
SSDs do help with that, but the problem remains.  The other half of the 
problem is the comparatively huge memory capacity systems have today, 
with the result being that the default percentages of system RAM that 
were allowed to be dirty before kicking in background and then foreground 
flushing, reasonable back when they were introduced, simply aren't 
reasonable any longer, PARTICULARLY on spinning rust, but even on SSD.

vm.dirty_ratio is the percentage of RAM allowed to dirty before the 
system kicks into high-priority write-flush mode.  
vm.dirty_background_ratio is likewise, but where the system starts even 
worrying about it at all, doing work in the background.

Now take my 16 GiB RAM system as an example.

The default background setting is 5%, foreground/high-priority, 10%.  
With 16 gigs RAM, that 10% is 1.6 GiB of dirty pages to flush.  A 
spinning rust drive might do 100 MiB/sec throughput contiguous, but a 
real-world number is more like 30-50 MiB/sec.

At 100 MiB/sec, that 1.6 GiB will take 16+ seconds, during which nothing 
else can be doing I/O.  So let's just divide the speed by 3 and call it 
33.3 MiB/sec.  Now we're looking at being blocked for nearly 50 seconds 
to flush all those dirty blocks.  And the system doesn't even START 
worrying about it, at even LOW priority, until it has about 25 seconds 
worth of full-usage flushing built-up!

Not only that, but that's *ALSO* 1.6 GiB worth of dirty data that isn't 
yet written to storage, that would lost in the event of a crash!

Of course there's a timer expiry as well.  vm.dirty_writeback_centiseconds 
(that's background) defaults to 499 (5 seconds), 
vm.dirty_expire_centiseconds defaults to 2999 (30 seconds).

So the first thing to notice is that it's going to take more time to 
write the dirty data we're allowing to stack up, than the expiry time!  
At least to me, that makes absolutely NO sense!  At minimum, we need to 
reduce cached writes allowed to stack up to something that can actually 
be done before they expire, time-wise.  Either that, or trying to depend 
on that 30-second expiry to make sure our dirty data is flushed in 
something at least /close/ to that isn't going to work so well!

So assuming we think the 30-seconds is logical, the /minimum/ we need to 
do is reduce the size cap by half, to 5% high-priority/foreground (which 
was as we saw about 25 seconds worth), say 2% lower-priority/background.

But that's STILL about 800 MiB before it kicks to high priority mode at 
risk in case of a crash, and I still considered that a bit more than I 
wanted.

So what I ended up with here (set for spinning rust before I had SSD), 
was:

vm.dirty_background_ratio = 1

(low priority flush, that's still ~160 MiB or about 5 seconds worth of 
activity at lower 30s MiB/sec)

vm.dirty_ratio = 3

(high priority flush, roughly half a GiB, about 15 seconds of activity)

vm.dirty_writeback_centiseconds=1000

(10 seconds, background flush timeout, note that the corresponding size 
cap is ~5 seconds worth so about 50% duty cycle, a bit high for 
background priority, but...)

(I left vm.dirty_expire_centiseconds at the default, 2999 or 30 seconds, 
since I found that an acceptable amount of work to lose in the case of a 
crash.  Again, the corresponding size cap is ~15 seconds worth, so ~50 
duty cycle.  This is very reasonable for high priority, as if data is 
coming in faster than that, it'll trigger high priority flushing "billed" 
to the processes actually dirtying the memory in the first place, thus 
forcing them to slow down and wait for their IO, in turn allowing other 
(CPU-bound) processes to run.)

And while 15-second interactivity latency during disk thrashing isn't 
cake, it's at least tolerable, while 50-second latency is HORRIBLE.

Meanwhile, with vm.dirty_background_ratio already set to 1 and without 
knowing whether it can take a decimal such as 0.5 (I could look I suppose 
but I don't really have to), that's the lowest I can go there unless I 
set it to zero.  HOWEVER, if I wanted to go lower, I could set the actual 
size version, vm.dirty_background_bytes, instead.  If I needed to go 
below ~160 MiB, that's what I'd do.  Of course there's a corresponding 
vm.dirty_bytes setting as well.


As I said I originally set those up for spinning rust.  Now my main 
system is SSD, tho I still have secondary backups and media on spinning 
rust.  But I've seen no reason to change them upward to allow for the 
faster SSDs, particularly since were I to do so, I'd be risking that much 
more data loss in the event of a crash, and I find that risk balance 
about right, just where it is.

And I've been quite happy with btrfs performance on the ssds (the 
spinning rust is still reiserfs).  Tho of course I do run multiple 
smaller independent btrfs instead of the huge all-the-data-eggs-in-a-
single-basket mode most people seem to run.  My biggest btrfs is actually 
only 24 GiB (on each of two devices but in raid1 mode both data/metadata, 
so 24 GiB to work with too), but between working copy and primary backup, 
I have nearly a dozen btrfs filesystems.  But I don't tend to run into 
the scaling issues others see, and being able to do full filesystem 
maintenance (scrub/balance/backup/restore-from-backup/etc) in seconds to 
minutes per filesystem is nice! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

