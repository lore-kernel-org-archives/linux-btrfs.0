Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37713 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbbHZGOO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 02:14:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZUTyN-0002jE-Tw
	for linux-btrfs@vger.kernel.org; Wed, 26 Aug 2015 08:14:12 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 08:14:11 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 08:14:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs -o discard bug in latest dev branches
Date: Wed, 26 Aug 2015 06:14:05 +0000 (UTC)
Message-ID: <pan$a3d06$a94167e8$2a203b5d$1ff3d7f1@cox.net>
References: <20150826040442.GC10927@Juns-MacBook-Pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jun He posted on Tue, 25 Aug 2015 23:04:42 -0500 as excerpted:

> I have been playing with btrfs discard for a while and found that btrfs
> may fail to discard some extents with 'mount -o discard'. I am aware of
> Jeff Mahoney's patches ( https://patchwork.kernel.org/patch/6609491/ ).
> It seems that the patches do not fix the problem. I have seen the same
> problematic behavior for the following versions
> 
> - https://git.kernel.org/cgit/linux/kernel/git/fdmanana/linux.git/
>   integration-4.3 commit:477594f93c43b1ee685
> - 3.16.0 - 4.2.0-rc7
> 
> The problem can be reproduced by writing and fsyncing a 4MB file for 50
> times on a 256MB empty FS (mount option: -o discard). You will find that
> some extents are not discarded (my expected behavior is that, after
> overwriting, an old version of a file extent should be discarded). I use
> several ways to confirm this:
> 
> 1. I created a loop device back by a sparse file in tmpfs. After running
> the workload, I found the file is 29MB (ls -lsh). If you fstrim the file
> system,
> the sparse file will become 4.1MB. This proves that there are a lot of
> data not discarded.
> 
> 2. I collected blktrace + blkparse output and plotted the write and
> discard operations in a space-time graph, where you can intuitively see
> some extents are overwritten but not discarded. Here is the space-time
> graph
> https://gist.githubusercontent.com/junhe/b6ce39eeb6de8887e66a/
raw/825a3c2946b52a50c2b6032a98d637f5a32bc5c3/integration-4.3.png
> 
> Is it a known problem or is it not a problem? If it is a known problem
> and there exists a patch that I am not aware of, can somebody direct me
> to it?
> If it is specifically designed this way, can the designers give the
> rationale of discarding some, but not all of, old extents?

I'm an admin, not a dev, far from an expert on fsync, and didn't pull 
your reproducer down from the linked git to check, but... do the numbers 
continue to change for some time (nominally 30 seconds) after the last 
operation?  Do you do a final sync (not fsync) after the last file write, 
and does that affect the result?

What I'm getting at is that there's a difference between sync and fsync, 
and you mentioned only fsync.  After an fsync, the file's own data and 
metadata should be reliably synced to storage device, but unlike 
filesystems like ext3, where (I've read that) an fsync forces a sync of 
the entire filesystem, on btrfs, other data and metadata related to the 
filesystem, in this case, those discards clearing where the file WAS but 
is no longer due to COW, are not necessarily synced to storage device, 
yet.

In the absence of a full filesystem sync, this outstanding activity may 
remain uncommitted until the normal btrfs commit timeout, 30 seconds by 
default, tho there's a mount option to change it.  In the absence of that 
sync, a failure to discard before the commit, upto 30 seconds later, is 
entirely expected.

Of course if you're either already doing that full filesystem sync, or 
are waiting at least 30 seconds (or whatever you have commit set to if 
non-default) before checking to see if the discard has been done, then 
indeed, it would appear that something's wrong.  But there's no 
indication in your post that you're already doing that.

FWIW, if you prefer to sync just the btrfs in question, not other 
filesystems btrfs and non-btrfs alike (as a full sync would do), you can 
use the btrfs filesystem sync <path> command, as covered in the btrfs-
filesystem manpage.  This command can be used in test scripts, etc, in 
place of sleeping 30 seconds or invoking a full system sync, where what's 
actually on the device counts.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

