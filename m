Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56406 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbcEHGbS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 8 May 2016 02:31:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1azIFD-0007Os-Qc
	for linux-btrfs@vger.kernel.org; Sun, 08 May 2016 08:31:11 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 08:31:11 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 08:31:11 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: apt taints kernel - btrfs destroys inode
Date: Sun, 8 May 2016 06:31:06 +0000 (UTC)
Message-ID: <pan$7224d$b81b322a$77a59ede$7de4ae18@cox.net>
References: <pan$a8e59$e73b6bd3$47d0e1e7$4518553f@cox.net>
	<20160507231118.GA19573@angband.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Adam Borowski posted on Sun, 08 May 2016 01:11:18 +0200 as excerpted:

> Duncan wrote:
>> > btrfs_destroy_inode
> 
>> That's a known apparent false-positive warning on current 4.6-rc kernel
>> btrfs.  The destroy-inode bit is related to a file deletion happening
>> in the normal order of things, where this warning code is run, and
>> apparently triggers even under normal operations.
> 
> Are you guys reasonably certain it's false-positive?

I don't personally know.  I'm just a btrfs user and list regular myself, 
not a dev, and I personally haven't seen this bug, but then my use-case 
doesn't require either snapshots or quotas, so I don't use either, and 
wouldn't be _expected_ to see this bug.

But all reported evidence suggests that it's a false-positive, as even 
the people hitting it extremely frequently haven't seen any real problems 
from it.

> If so, you _really_
> want to disable the warning for 4.6, less than a week from now.  Any
> reasonable user of a stable kernel who notices such a warning and stack
> dumps will assume something is broken, rightfully panic and consider the
> filesystem unsound.

I can't disagree.  But I'm a user, not a dev...

However, based on my own tracking of pre-release kernels, reverts or 
(temporarily?) silenced warnings for exactly this sort of appeared-over-
the-release-cycle issue that they had hoped to actually track down and 
fix during the cycle, but simply didn't get there in time, do tend to 
come in at about this time, as it becomes apparent the trace-down, fix, 
and full testing, simply can't be completed in the cycle in which the 
problem was introduced or at least exposed, so the wise action is to 
simply revert or paper over for at least the one release, with the 
appropriate fix very likely to then hit the next kernel, either the 
initial commit window, or in any case before rc3 or so when people like 
me often start testing.

What worries me is that I've seen no on-list indication that this 
particular bug has been traced even to a point that a specific revert can 
be done, or alternatively, that there's enough code-level confidence that 
it's a false-positive to silence the warning.  However, it should be 
noted that particularly if it's a simple revert, there may in fact be no 
such on-list discussion as there's not necessarily anything to discuss, 
only a final decision by the project lead (or occasionally Linus himself) 
to revert or simply let it ride.

>> It's related to some btrfs feature (I think either snapshotting or
>> quotas, but don't recall which) I don't use here so I don't seem the
>> warnings, but there's several threads where people have reported the
>> warnings, so it's apparently quite commonly triggered, but nobody has
>> reported any further problems even where the warnings are coming in the
>> hundreds due to their use-case, so as I said, apparently a
>> false-positive induced by normal operations.
> 
> A data point: I've been running for a week with this WARN_ON replaced by
> a printk:
> 
> --- a/fs/btrfs/inode.c +++ b/fs/btrfs/inode.c @@ -9258,7 +9258,8 @@ void
> btrfs_destroy_inode(struct inode *inode)
>         WARN_ON(BTRFS_I(inode)->outstanding_extents);
>         WARN_ON(BTRFS_I(inode)->reserved_extents);
>         WARN_ON(BTRFS_I(inode)->delalloc_bytes);
> -       WARN_ON(BTRFS_I(inode)->csum_bytes);
> +       if (BTRFS_I(inode)->csum_bytes)
> +               printk("btrfs: btrfs_destroy_inode: WARN csum_bytes\n");
>         WARN_ON(BTRFS_I(inode)->defrag_bytes);
>  
>         /*
> 
> and no data loss or anything suspicious so far.  This box has a SSD
> (moderate use) and HDD (light use), no RAID, no quotas, compress=lzo,
> many subvolumes, 20ish snapshots daily (mostly sbuild for Debian
> packages).

That's nearly identical to what others have noted, as well, thus my 
describing it as an apparent false-positive, because despite many 
triggered warnings among the several reporters, no tragedy has seemed to 
strike as a result.


> [~]$ dmesg|grep btrfs_destroy_inode|wc -l
> 50
> [~]$ uptime
>  00:17:47 up 1 day, 18:44, 19 users,  load average: 0.23, 0.35, 0.61
> [~]$ cat /proc/version
> Linux version 4.6.0-rc6-debug+ (kilobyte@umbar)
> (gcc version 6.1.1 20160430 (Debian 6.1.1-1) )
> #1 SMP Fri May 6 00:33:44 CEST 2016
> 
>> I'd expect the warning to be either fixed to only warn when there's an
>> actual issue, or be silenced, by 4.6 release.
> 
> In order to get to 4.6 such a commit would need to hit Linus about right
> now...

Agreed.  (Matter of fact, I'm about to git pull and git log check what's 
new over the last couple days, as I write this, before I continue 
checking the new messages here.  As you say, it's gotta be real soon now 
if it's going to happen.  Maybe it's either in-kernel or at least in a 
list-announced pull ready for Linus as I write...)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

