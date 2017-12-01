Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:33742 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750921AbdLAV1d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Dec 2017 16:27:33 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eKsqC-0007kI-Dw
        for linux-btrfs@vger.kernel.org; Fri, 01 Dec 2017 22:27:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: exclusive subvolume space missing
Date: Fri, 1 Dec 2017 21:27:14 +0000 (UTC)
Message-ID: <pan$2b97f$a3dcbb0a$d48d1bdc$1d78ee0a@cox.net>
References: <20171201161555.GA11892@polanet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Pala posted on Fri, 01 Dec 2017 17:15:55 +0100 as excerpted:

> Hello,
> 
> I got a problem with btrfs running out of space (not THE
> Internet-wide, well known issues with interpretation).
> 
> The problem is: something eats the space while not running anything that
> justifies this. There were 18 GB free space available, suddenly it
> dropped to 8 GB and then to 63 MB during one night. I recovered 1 GB
> with rebalance -dusage=5 -musage=5 (or sth about), but it is being eaten
> right now, just as I'm writing this e-mail:
> 
> /dev/sda2        64G   63G  452M 100% /
> /dev/sda2        64G   63G  365M 100% /
> /dev/sda2        64G   63G  316M 100% /
> /dev/sda2        64G   63G  287M 100% /
> /dev/sda2        64G   63G  268M 100% /
> /dev/sda2        64G   63G  239M 100% /
> /dev/sda2        64G   63G  230M 100% /
> /dev/sda2        64G   63G  182M 100% /
> /dev/sda2        64G   63G  163M 100% /
> /dev/sda2        64G   64G  153M 100% /
> /dev/sda2        64G   64G  143M 100% /
> /dev/sda2        64G   64G   96M 100% /
> /dev/sda2        64G   64G   88M 100% /
> /dev/sda2        64G   64G   57M 100% /
> /dev/sda2        64G   64G   25M 100% /

Scary.

> while my rough calculations show, that there should be at least 10 GB of
> free space. After enabling quotas it is somehow confirmed:

I don't use quotas so won't claim working knowledge or an explanation of
that side of things, however...
> 
> btrfs-progs-4.12 running on Linux 4.9.46.

Until quite recently btrfs quotas were too buggy to recommend for use.
While the known blocker-level bugs are now fixed, scaling and real-world
performance are still an issue, and AFAIK, the fixes didn't make 4.9 and
may not be backported as the feature was simply known to be broken beyond
reliable usability at that point.

Based on comments in other threads here, I /think/ the critical quota
fixes hit 4.10, but of course not being an LTS, 4.10 is long out of support.
I'd suggest either turning off and forgetting about quotas since it doesn't
appear you actually need them, or upgrading to at least 4.13 and keeping
current, or the LTS 4.14 if you want to stay on the same kernel series for
awhile.

As for the scaling and performance issues, during normal/generic filesystem
use things are generally fine; it's various btrfs maintenance commands such
as balance, snapshot deletion, and btrfs check, that have the scaling
issues, and they have /some/ scaling issues even without quotas, it's just
that quotas makes the problem *much* worse.  One workaround for balance
and snapshot deletion is to temporarily disable quotas while the job is
running, then reenable (and rescan if necessary, as I don't use the feature
here I'm not sure whether it is).  That can literally turn a job that was
looking to take /weeks/ due to the scaling issue, into a job of hours.
Unfortunately, the sorts of conditions that would trigger running a btrfs
check don't lend themselves to the same sort of workaround, so not having
quotas on at all is the only workaround there.


As to your space being eaten problem, the output of btrfs filesystem usage
(and perhaps btrfs device usage if it's a multi-device btrfs) could be
really helpful here, much more so than quota reports if it's a btrfs
issue, or to help eliminate btrfs as the problem if it's not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

