Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42198 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbbDMFGo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 01:06:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YhWa1-0001lN-QT
	for linux-btrfs@vger.kernel.org; Mon, 13 Apr 2015 07:06:41 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 07:06:41 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2015 07:06:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Big disk space usage difference, even after defrag, on
 identical data
Date: Mon, 13 Apr 2015 05:06:36 +0000 (UTC)
Message-ID: <pan$f11f0$7ca65f9$58551aba$5ec77500@cox.net>
References: <55297D36.8090808@sjeng.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gian-Carlo Pascutto posted on Sat, 11 Apr 2015 21:59:50 +0200 as
excerpted:

> That's a 66G difference for the same data with the same compress option.
> The used size here is much more in line with what I'd have expected
> given the nature of the data.
> 
> I would think that compression differences or things like fragmentation
> or bookending for modified files shouldn't affect this, because the
> first filesystem has been defragmented/recompressed and didn't shrink.
> 
> So what can explain this? Where did the 66G go?

Out of curiosity, does a balance on the actively used btrfs help?

You mentioned defrag -v -r -clzo, but didn't use the -f (flush) or -t 
(minimum size file) options.  Does adding -f -t1 help?

You aren't doing btrfs snapshots of either subvolume, are you?

I'm not sure this is related to the answer to your question, since you 
did defrag, but it might be, and it's good to know when dealing with 
database files on btrfs in any case.

Btrfs is in general a copy-on-write (COW) based filesystem.  Random 
rewrite pattern files, database and VM image files being prime examples, 
typically HEAVILY fragment on COW filesystems, since any rewrite forces a 
copy of the rewritten data block elsewhere.  The often rather large 
original extents get holes, but remained pinned by the existing data 
still remaining in them that hasn't been rewritten.  This is analogous to 
the way databases often rewrite records but leave holes behind that 
aren't immediately cleaned up, only it's occurring at the filesystem 
extent level.  Only after all the data in an extent has been rewritten, 
can the extent itself be unpinned and returned to the free space pool.

Defrag should force the rewrite of entire files and take care of this, 
but obviously it's not returning to "clean" state.  I forgot what the 
default minimum file size is if -t isn't set, maybe 128 MiB?  But a -t1 
will force it to defrag even small files, and I recall at least one 
thread here where the poster said it made all the difference for him, so 
try that.  And the -f should force a filesystem sync afterward, so you 
know the numbers from any report you run afterward match the final state.

Meanwhile, you may consider using the nocow attribute on those database 
files.  It will disable compression on them, but rewrites should then 
occur in-place, so you don't get the fragmentation and extent usage holes 
and duplication that you'd have otherwise.  It'll also disable btrfs 
checksumming, but mature databases already have their own error detection 
and correction system, since they don't normally run on filesystems that 
provide that sort of service like btrfs does.  While initial usage will 
be higher due to the lack of compression, as you've discovered, over 
time, on an actively updated database, compression isn't all that 
effective anyway.  And while usage may be a bit higher at least 
originally, it should be stable, but for expanding the actual size of the 
database, anyway.

But there's a couple of caveats to nocow.  First, in ordered to be 
properly effective, it needs to be set on a file while it's still empty.  
The most effective way to do this is to set nocow on the empty parent 
directory, then copy the nocow-target files into it so they inherit the 
nocow attribute as they are created, before they actually have any data.

The second pertains to btrfs snapshots.  Snapshots lock the existing file 
in place, effectively making an otherwise nocow file cow1 -- the first 
write to an existing file block will cow it, but after that, further 
writes to the same block will rewrite in-place... until the next 
snapshot, of course.  So try to minimize the number of snapshots done to 
nocow files, and if you do snapshot them, defrag them once in awhile as 
well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

