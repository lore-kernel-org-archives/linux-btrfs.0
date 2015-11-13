Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39368 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150AbbKMVAW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 16:00:22 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZxLSG-0006AM-I4
	for linux-btrfs@vger.kernel.org; Fri, 13 Nov 2015 22:00:20 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 22:00:20 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 22:00:20 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Where is the disk space?
Date: Fri, 13 Nov 2015 21:00:09 +0000 (UTC)
Message-ID: <pan$18dab$9511f910$5c72bde7$8748826@cox.net>
References: <20151113174101.GC19249@merlins.org>
	<pan$d16ba$8434e942$7cc09c55$439d7a74@cox.net>
	<20151113200158.GA18943@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Fri, 13 Nov 2015 12:01:58 -0800 as excerpted:

> I'm still seeing 39GB used for 28GB of actual data, but I definitely
> fixed one bit already thanks to you.

For the data side, I think I understand what's going on with the space, 
but am not in sufficient mastery of the concept to feel confident that I 
can explain it well.  Never-the-less, here's a go at it.  One of the devs 
did a post complete with nice ascii diagrams if you're interested in 
trying to look it up.

What happens is that with larger files (particularly VM images and the 
like if they're not set nocow or if they're nocow but cow1-ed due to 
snapshotting, which AFAIK fits your use-case directly) originally setup 
in a few reasonably large extents, as rewrites occur, they cow and thus 
unmap random smaller extents from within the larger extents.  But, btrfs 
doesn't do extent splitting, so those larger extents remain pinned as 
long as at least some of the data within them remains referenced.  The 
result can eventually be rather cavernous mostly empty original extents 
still pinned in place by the few 4K blocks that haven't ever been 
rewritten.

If you believe you know what files are likely to be the culprit, and if 
you're doing VMs that's exactly where I'd look first, try temporarily 
moving them (and any old snapshots of them) out of the filesystem, doing 
a quick fi df to see if it has indeed emptied out some data chunks, and 
if so, a balance -dusage=80 or whatever to try to reclaim them, then move 
the file(s) back.

Of course if you still have other snapshots of the file pinning down 
those extents it won't free them, so you have to either delete the 
snapshots or at least delete the culprit file(s) from within them 
(obviously only with writable snapshots) in ordered for this to work.

In theory, defrag can do much the same thing, assuming of course there 
aren't snapshots containing the same file and still locking down its old 
extents, but that doesn't get the file off the filesystem for the 
cleanup, so it's likely to be somewhat less effective, perhaps 
considerably less effective if the remaining free space inside existing 
data chunks is itself highly fragmented.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

