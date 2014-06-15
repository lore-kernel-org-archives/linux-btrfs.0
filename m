Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44661 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108AbaFOFnU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 01:43:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ww3Dq-0006lX-Sf
	for linux-btrfs@vger.kernel.org; Sun, 15 Jun 2014 07:43:18 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 07:43:18 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 07:43:18 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Slow startup of systemd-journal on BTRFS
Date: Sun, 15 Jun 2014 05:43:06 +0000 (UTC)
Message-ID: <pan$c82aa$ea13b40$dc4fc67d$63d84512@cox.net>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<pan$22693$6b452195$976b783a$e4956372@cox.net>
	<20140612232453.GR9508@dastard> <539B78F3.9070607@libero.it>
	<pan$625ac$a8aa7477$d0179ebe$c66ba817@cox.net>
	<539BFF47.8060006@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: systemd-devel@lists.freedesktop.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Goffredo Baroncelli posted on Sat, 14 Jun 2014 09:52:39 +0200 as
excerpted:

> On 06/14/2014 04:53 AM, Duncan wrote:
>> Goffredo Baroncelli posted on Sat, 14 Jun 2014 00:19:31 +0200 as
>> excerpted:
>> 
>>> thanks for pointing that. However I am performing my tests on a fedora
>>> 20 with systemd-208, which seems have this change
>>>
>>> I am reaching the conclusion that fallocate is not the problem. The
>>> fallocate increase the filesize of about 8MB, which is enough for some
>>> logging. So it is not called very often.

Right.

>> But...

Exactly, _but_...

>> [A]n fallocate of 8 MiB will increase the file size
>> by 8 MiB and write that out.  So far so good as at that point the 8 MiB
>> should be a single extent.  But then, data gets written into 4 KiB
>> blocks of that 8 MiB one at a time, and because btrfs is COW, the new
>> data in the block must be written to a new location.
>> 
>> Which effectively means that by the time the 8 MiB is filled, each 4
>> KiB block has been rewritten to a new location and is now an extent
>> unto itself.  So now that 8 MiB is composed of 2048 new extents, each
>> one a single 4 KiB block in size.
> 
> Several people pointed fallocate as the problem. But I don't understand
> the reason.
> 1) 8MB is a quite huge value, so fallocate is called (at worst) 1 time
> during the boot. Often never because the log are less than 8MB.
> 2) it is true that btrfs "rewrite" almost 2 times each 4kb page with
> fallocate. But the first time is a "big" write of 8MB; instead the
> second write would happen in any case. What I mean is that without the
> fallocate in any case journald would make small write.
> 
> To be honest, I fatigue to see the gain of having a fallocate on a COW
> filesystem... may be that I don't understand very well the fallocate()
> call.

The base problem isn't fallocate per se, rather, tho it's the trigger in 
this case.  The base problem is that for COW-based filesystems, *ANY* 
rewriting of existing file content results in fragmentation.

It just so happens that the only reason there's existing file content to 
be rewritten (as opposed to simply appending) in this case, is because of 
the fallocate.  The rewrite of existing file content is the problem, but 
the existing file content is only there in this case because of the 
fallocate.

Taking a step back...

On a non-COW filesystem, allocating 8 MiB ahead and writing into it 
rewrites into the already allocated location, thus guaranteeing extents 
of 8 MiB each, since once the space is allocated it's simply rewritten in-
place.  Thus, on a non-COW filesystem, pre-allocating in something larger 
than single filesystem blocks when an app knows the data is eventually 
going to be written in to fill that space anyway is a GOOD thing, which 
is why systemd is doing it.

But on a COW-based filesystem fallocate is the exact opposite, a BAD 
thing, because an fallocate forces the file to be written out at that 
size, effectively filled with nulls/blanks.  Then the actual logging 
comes along and rewrites those nulls/blanks with actual data, but it's 
now a rewrite, which on a COW, copy-on-write, based filesystem, the 
rewritten block is copied elsewhere, it does NOT overwrite the existing 
null/blank block, and "elsewhere" by definition means detached from the 
previous blocks, thus in an extent all by itself.

Once the full 2048 original blocks composing that 8 MiB are filled in 
with actual data, because they were rewrites from null/blank blocks that 
fallocate had already forced to be allocated, that's now 2048 separate 
extents, 2048 separate file fragments, where without the forced fallocate, 
the writes would have all been appends, and there would have been at 
least /some/ chance of some of those 2048 separate blocks being written 
at close enough to the same time that they would have been written 
together as a single extent.  So while the 8 MiB might not have been a 
single extent as opposed to 2048 separate extents, it might have been 
perhaps 512 or 1024 extents, instead of the 2048 that it ended up being 
because fallocate meant that each block was a rewrite into an existing 
file, not a new append-write at the end of an existing file.

> [...]
>> Another alternative is that distros will start setting /var/log/journal
>> NOCOW in their setup scripts by default when it's btrfs, thus avoiding
>> the problem.  (Altho if they do automated snapshotting they'll also
>> have to set it as its own subvolume, to avoid the
>> first-write-after-snapshot-
>> is-COW problem.)  Well, that, and/or set autodefrag in the default
>> mount options.
> 
> Pay attention, that this remove also the checksum, which are very useful
> in a RAID configuration.

Well, it can be.  But this is only log data, not executable or the like 
data, and (as Kai K points out) journald has its own checksumming method 
in any case.

Besides which, you still haven't explained why you can't either set the 
autodefrag mount option and be done with it, or run a systemd-timer-
triggered or cron-triggered defrag script to defrag them automatically at 
hourly or daily or whatever intervals.  Those don't disable btrfs 
checksumming, but /should/ solve the problem.

(Tho if you're btrfs snapshotting the journals defrag has its own 
implications, but they should be relatively limited in scope compared to 
the fragmentation issues we're dealing with here.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

