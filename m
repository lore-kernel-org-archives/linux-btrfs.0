Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35000 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbaJMAAF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Oct 2014 20:00:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XdT3T-0001Tm-DF
	for linux-btrfs@vger.kernel.org; Mon, 13 Oct 2014 02:00:03 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 02:00:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Oct 2014 02:00:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: What is the vision for btrfs fs repair?
Date: Sun, 12 Oct 2014 23:59:52 +0000 (UTC)
Message-ID: <pan$9d644$428672a3$85285a3a$ab3729f1@cox.net>
References: <54358C77.2070808@redhat.com> <5437BAB2.1040605@shiftmail.org>
	<93B9D2BD-1F0F-4C94-899F-16A3A2A0D57E@colorremedies.com>
	<2313804.P0rE2GFdbV@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 12 Oct 2014 12:14:01 +0200 as excerpted:

> I always thought with a controller and device and driver combination
> that honors fsync with BTRFS it would either be the new state of the
> last known good state *anyway*. So where does the need to rollback arise
> from?

My understanding here is...

With btrfs a full-tree commit is atomic.  You should get either the old 
tree or the new tree.  However, due to the cascading nature of updates on 
cow-based structures, these full-tree commits are done by default 
(there's a mount-option to adjust it) every 30 seconds.  Between these 
atomic commits partial updates may have occurred.  The btrfs log (the one 
that btrfs-zero-log kills) is limited to between-commit updates, and thus 
to the upto 30 seconds (default) worth of changes since the last full-
tree atomic commit.

In addition to that, there's a history of tree-root commits kept (with 
the superblocks pointing to the last one).  Btrfs-find-tree-root can be 
used to list this history.  The recovery mount option simply allows btrfs 
to fall back to this history, should the current root be corrupted.  
Btrfs restore can be used to list tree roots as well, and can be pointed 
at an appropriate one if necessary.

Fsync forces the file and its corresponding metadata update to the log 
and barring hardware or software bugs should not return until it's safely 
in the log, but I'm not sure whether it forces a full-tree commit.  
Either way the guarantees should be the same.  If the log can be replayed 
or a full-tree commit has occurred since the fsync, the new copy should 
appear.  If it can't, the rollback to the last atomic tree commit should 
return an intact copy of the file from that point.  If the recovery mount 
option is used and a further rollback to an earlier full-tree commit is 
forced, provided it existed at the point of that full-tree commit, the 
intact file at that point should appear.

So if the current tree root is a good one, the log will replay the last 
upto 30 seconds of activity on top of that last atomic tree root.  If the 
current root tree itself is corrupt, the recovery mount option will let 
an earlier one be used.  Obviously in that case the log will be discarded 
since it applies to a later root tree that itself has been discarded.

The debate is whether recovery should be automated so the admin doesn't 
have to care about it, or whether having to manually add that option 
serves as a necessary notifier to the admin that something /did/ go 
wrong, and that an earlier root is being used instead, so more than a few 
seconds worth of data may have disappeared.


As someone else has already suggested, I'd argue that as long as btrfs 
continues to be under the sort of development it's in now, keeping 
recovery as a non-default option is desired.  Once it's optimized and 
considered stable, arguably recovery should be made the default, perhaps 
with a no-recovery option for those who prefer that in-the-face 
notification in the form of a mount error, if btrfs would otherwise fall 
back to an earlier tree root commit.

What worries me, however, is that IMO the recent warning stripping was 
premature.  Btrfs is certainly NOT fully stable or optimized for normal 
use at this point.  We're still using the even/odd PID balancing scheme 
for raid1 reads, for instance, and multi-device writes are still 
serialized when they could be parallelized to a much larger degree (tho 
keeping some serialization is arguably good for data safety).  Arguably 
optimizing that now would be premature optimization since the code itself 
is still subject to change, so I'm not complaining, but by that very same 
token, it *IS* still subject to change, which by definition means it's 
*NOT* stable, so why are we removing all the warnings and giving the 
impression that it IS stable?

The decision wasn't mine to make and I don't know, but while a nice 
suggestion, making recovery-by-default a measure of when btrfs goes 
stable simply won't work, because surely, the same folks behind the 
warning stripping would then ensure this indicator too, said btrfs was 
stable, while the state of the code itself continues to say otherwise. 

Meanwhile, if your distributed transactions scenario doesn't account for 
crash and loss of data on one side with real-time backup/redundancy, such 
that loss of a few seconds worth of transactions on a single local 
filesystem is going to kill the entire scenario, I don't think too much 
of that scenario in the first place, and regardless, btrfs, certainly in 
its current state, is definitely NOT an appropriate base for it.  Use 
appropriate tools for the task.  Btrfs at least at this point is simply 
not an appropriate tool for that task.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

