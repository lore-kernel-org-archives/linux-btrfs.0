Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:49990 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751661AbdG2XFZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 29 Jul 2017 19:05:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dbanK-0001yE-F0
        for linux-btrfs@vger.kernel.org; Sun, 30 Jul 2017 01:05:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: write corruption due to bio cloning on raid5/6
Date: Sat, 29 Jul 2017 23:05:07 +0000 (UTC)
Message-ID: <pan$6c020$e98b46d2$7e8ca956$7078db6d@cox.net>
References: <CANznX5FxavW+0_YdA4hir9_A3KrobRLyV9+CNadigDT3uNUkXw@mail.gmail.com>
        <20170726160717.GA32451@localhost.localdomain>
        <CANznX5Hx57JbwS75usDHwWBHbmiLj7dVHrfgZ5Swn=8zX=2iHw@mail.gmail.com>
        <pan$ec007$3f43fe2a$2f099431$cc969edd@cox.net>
        <CANznX5GNuSXRNq7Zo7pghi4AM=jh_C9yGLd-zdi7P88xRE5Tqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Janos Toth F. posted on Sat, 29 Jul 2017 05:02:48 +0200 as excerpted:

> The read-only scrub finished without errors/hangs (with kernel
> 4.12.3). So, I guess the hangs were caused by:
> 1: other bug in 4.13-RC1
> 2: crazy-random SATA/disk-controller issue
> 3: interference between various btrfs tools [*]
> 4: something in the background did DIO write with 4.13-RC1 (but all
> affected content was eventually overwritten/deleted between the scrub
> attempts)
> 
> [*] I expected scrub to finish in ~5 rather than ~40 hours (and didn't
> expect interference issues), so I didn't disable the scheduled
> maintenance script which deletes old files, recursively defrags the
> whole fs and runs a balance with usage=33 filters. I guess either of
> those (especially balance) could potentially cause scrub to hang.

That #3, interference between btrfs tools, could be it.  It seems btrfs
in general is getting stable enough now that we're beginning to see
bugs exposed from running two or more tools at once, because the devs
have apparently caught and fixed enough of the single-usage race bugs
that individual tools are working reasonably well, and it's now the
concurrent multi-usage case races that no one was thinking about when
they were writing the code that are being exposed.  At least, there
have been a number of such bugs either definitely or probability-traced
to concurrent usage, reported and traced/fixed, lately, more than I
remember seeing in the past.


(TL;DR folks can stop at that.)

Incidentally, that's one more advantage to my own strategy of multiple
independent small btrfs, keeping everything small enough that
maintenance jobs are at least tolerably short, making it actually
practical to run them.

Tho my case is surely an extreme, with everything on ssd and my largest
btrfs, even after recently switching my media filesystems to ssd and
btrfs, being 80 GiB (usable and per device, btrfs raid1 on paired
partitions, each on a different physical ssd).  I use neither quotas,
which don't scale well on btrfs and I don't need them, nor snapshots,
which have a bit of a scaling issue (tho apparently not as bad as
quotas) as well, because weekly or monthly backups are enough here, and
the filesystems are small enough (and on ssd) to do full-copy backups
in minutes each.  In fact, making backups easier was a major reason I
switched even the backups and media devices to all ssd, this time.

So scrubs are trivially short enough I can run them and wait for the
results while composing posts such as this (bscrub is my scrub script,
run here by my admin user with a stub setup so sudo isn't required):

$$ bscrub /mm 
scrub device /dev/sda11 (id 1) done
        scrub started at Sat Jul 29 14:50:54 2017 and finished after 00:01:08
        total bytes scrubbed: 33.98GiB with 0 errors
scrub device /dev/sdb11 (id 2) done
        scrub started at Sat Jul 29 14:50:54 2017 and finished after 00:01:08
        total bytes scrubbed: 33.98GiB with 0 errors

Just over a minute for a scrub of both devices on my largest 80 gig per
device btrfs. =:^)  Tho projecting to full it might be 2 and a half minutes...

Tho of course parity-raid scrubs would be far slower, at a WAG an hour or two,
for similar size on spinning rust...

Balances are similar, but being on ssd and not needing one on any of the still
relatively freshly redone filesystems ATM, I don't feel inclined to needlessly
spend a write cycle just for demonstration.

With filesystem maintenance runtimes of a minute, definitely under five minutes,
per filesystem, and with full backups under 10, I don't /need/ to run more than
one tool at once, and backups can trivially be kept fresh enough that I don't
really feel the need to schedule maintenance and risk running more than one
that way, either, particularly when I know it'll be done in minutes if I run it
manually. =:^)

Like I said, I'm obviously an extreme case, but equally obviously, while I see
the runtime concurrency bug reports on the list, it's not something likely to
affect me personally. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

