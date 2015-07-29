Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52030 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbbG2Tr2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 15:47:28 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZKXK2-0004PQ-6T
	for linux-btrfs@vger.kernel.org; Wed, 29 Jul 2015 21:47:26 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2015 21:47:26 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2015 21:47:26 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fs got readonly after "btrfs_run_delayed_refs:2783: errno=-5 IO
 failure"
Date: Wed, 29 Jul 2015 19:47:18 +0000 (UTC)
Message-ID: <pan$1132f$8e0726a7$a8f5bf51$89992802@cox.net>
References: <CAOMFOmU3rPtY-VNzXHcYzrVjzwTGNO1qgiWns5=QOgN2O3MvuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anatol Pomozov posted on Wed, 29 Jul 2015 09:26:00 -0700 as excerpted:

> At my home machine I use btrfs from the latest Linux kernel (Linux
> Arch).

Similar here, but on gentoo.  And to be clear, just a list regular and 
btrfs user as yourself, not a dev.  As such, this reply isn't intended to 
directly help you fix the issue at hand, but it does address a possible 
misconception I saw, below, and provide some more general information 
that could be helpful.

> A few days ago I started rebalance but unfortunately the machine got
> rebooted. It looks like rebalance operation is not interrupt-tolerant
> and now my filesystem got corrupted.

In _theory_ btrfs operations are atomic and thus even unplug-the-running-
machine tolerant, let alone reboot tolerant.  However, in _both_ theory 
and practice, btrfs is still not fully stable and mature yet, and bugs 
negatively affect the operation of the theory above...

In theory rebalance simply moves big chunks of data/metadata around, and 
if interrupted, all addresses will either point to the new location for 
for previously balanced chunks, or the old location, for those not yet 
balanced and for the one that was being processed at the time of the 
reboot.

And a balance definitely can and normally does pick up where it left off 
after a reboot.

But...

> I see a lot of checksum errors, but as I use RAID most of these error
> got fixed, I started scrub operation to find/fix all the problems but
> the scrub operation got cancelled at the very beginning. I see following
> error in kernel logs, it says "(device sdb): run_one_delayed_ref
> returned -5" and after that "(device sdb): forced readonly". What does
> it suppose to mean? I expect that scrub either fix filesystem
> inconsistency problems. Or tell me what file are not recoverable so I
> can delete/restore the data from backup. But now I have a readonly
> filsystem and scrub refuses to recover it.

Scrub detects, and fixes in the dup/raid1/5/6/10 case where there's 
either a redundant copy or parity information from which it can rebuild, 
one kind of error, the checksum errors you mentioned.  It does _not_, 
however, and this is the possible misconception I mentioned above, fix 
other types of filesystem inconsistency problems, unless they're a direct 
result of the checksum validated data integrity errors it does detect and 
fix if possible.  For other errors, the kernel itself catches and fixes 
many problems on-mount, with others recoverable with the recovery mount 
option, and still others fixable using btrfs check, tho AFAIK, the 
recommendation remains not to use btrfs check in --repair mode (without --
repair it'll only report any problems it finds, not attempt to fix them) 
unless you have to, because with problems it doesn't understand it might 
make the problem worse instead of better.

Of course with btrfs' immaturity, the rule about having backups if you 
care about the data, and if you don't have backups, by definition you 
don't care about the data, applies double, but you already mentioned the 
possibility of restoring from backups, so you have that one covered. =:^)

As for the read-only, the kernel btrfs code forces a filesystem read-only 
when it detects a filesystem inconsistency that could result in further 
damage were it to continue to write to the filesystem.  Since at that 
point it's read-only, you can't damage it further by rebooting, and it's 
possible btrfs' self-healing properties will fix the problem on reboot.  
However, since it's also possible the damage is bad enough it might not 
mount at all on reboot, you might wish to take advantage of the current 
read-only state to freshen your backups while you can still access the 
filesystem.

(If you do get caught with an unmountable filesystem and stale backups, 
btrfs restore can be used to restore still readable files from the 
unmounted filesystem.  And because restore doesn't actually change the 
filesystem it's restoring from but writes restored files elsewhere, if it 
comes to that, restore is recommended before more risky interventions, 
like btrfs check in --repair mode.  I've done that a couple times when my 
backups were stale, and was quite happy with the results.  Of course that 
does mean you need space on a mounted filesystem to restore to...)

As for the problem at hand itself, I'll let those with more expertise 
address that.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

