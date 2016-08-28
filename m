Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:35452 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbcH1Hya (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 03:54:30 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1bduug-0002SW-8V
        for linux-btrfs@vger.kernel.org; Sun, 28 Aug 2016 09:53:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs send extremely slow (almost stuck)
Date: Sun, 28 Aug 2016 07:53:45 +0000 (UTC)
Message-ID: <pan$c68ee$dd1cd083$c7ecb753$6c544fa4@cox.net>
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oliver Freyermuth posted on Sun, 28 Aug 2016 05:38:00 +0200 as excerpted:

> Dear btrfs experts,
> 
> I just tried to make use of btrfs send / receive for incremental backups
> (using btrbk to simplify the process).
> It seems that on my two machines, btrfs send gets stuck after
> transferring some GiB - it's not fully halted, but instead of making
> full use of the available I/O, I get something < 500 kiB on average,
> which are just some "full speed spikes" with many seconds / minutes of
> no I/O in between.
> 
> During this "halting", btrfs send eats one full CPU core.
> A "perf top" shows this is spent in "find_parent_nodes" and
> "__merge_refs" inside the kernel.
> I am using btrfs-progs 4.7 and kernel 4.7.0.
> 
> I googled a bit and found related patchwork
> (https://patchwork.kernel.org/patch/9238987/) which seems to workaround
> high load in this area and mentions a real solution is proposed but not
> yet there.
> 
> Since this affects two machines of mine and backupping my root volume
> would take about 80 hours in case I can extrapolate the average rate,
> this means btrfs send is unusable to me.
> 
> Can I assume this is a common issue which will be fixed in a later
> kernel release (4.8, 4.9) or can I do something to my FS's to workaround
> this issue?
> 
> One FS is only two weeks old, the other one now about 1 year. I did some
> balancing at some points of time to have more unallocated space for
> trimming,
> and used duperemove regularly to free space. One FS has skinny extents,
> the other has not.

The problem is as the patch says, multiple references per extent 
increases process time geometrically.

And dupremove works by doing just that, pointing multiple duplications to 
the same extents, increasing the reference count per extent, thereby 
exacerbating the problem on your system, if dupremove is actually finding 
a reasonable number of duplicates to reflink to the same extents.

The other common multi-reflink usage is snapshots, since each snapshot 
creates another reflink to each extent it snapshots.  However, being just 
a list regular and btrfs user, not a dev, and using neither dedupe nor 
snapshots nor send/receive in my own use-case, I'm not absolutely sure 
whether other snapshot references affect send/receive or whether it's 
only multiple reflinks per sent snapshot.  Either way, over a few hundred 
snapshots per subvolume or a couple thousand snapshots per filesystem, 
they do seriously affect scaling of balance and fsck, even if they don't 
actually affect send/receive so badly.

So a workaround would be reducing your duperemove usage and possibly 
rewriting (for instance via defrag) the deduped files to kill the 
multiple reflinks.  Or simply delete the additional reflinked copies, if 
your use-case allows it.

And thin down your snapshot retention if you have many snapshots per 
subvolume.  With the geometric scaling issues, thinning to under 300 per 
subvolume should be quite reasonable in nearly all circumstances, and 
thinning to under 100 per subvolume may be possible and should result in 
dramatically reduced scaling issues.

Note that the current patch doesn't really workaround the geometric 
scaling issues or extreme cpu usage bottlenecking send/receive, but 
rather, addresses the soft lockups problem due to not scheduling often 
enough to give other threads time to process.  You didn't mention 
problems with soft lockups, so it's likely to be of limited help for the 
send/receive problem.

As for the longer term, yes, it should be fixed, eventually, but keep in 
mind that btrfs isn't considered fully stable and mature yet, so this 
sort of problem isn't unexpected and indeed scaling issues like this are 
known to still be an issue, and while I haven't been tracking that red/
black tree work, in general it can be noted that btrfs fixes for this 
sort of problem often take rather longer than might be expected, so a fix 
may be more like a year or two out than a kernel cycle or two out.

Unless of course you see otherwise from someone working on this problem 
specifically, and even then, sometimes the first fix doesn't get it quite 
right, and the problem may remain for some time as more is learned about 
the ultimate issue via multiple attempts to fix it.  This has happened to 
the quota code a number of times for instance, as it as turned out to be 
a /really/ hard problem, with multiple rewrites necessary, such that even 
now, the practical recommendation is often to either just turn off quotas 
and not worry about them if you don't need them, or use a more mature 
filesystem where the quota code is known to be stable and mature, if your 
use-case depends on them.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

