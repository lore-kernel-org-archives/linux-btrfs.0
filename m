Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:53614 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbeGUHHU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 21 Jul 2018 03:07:20 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1fgl96-00051n-E3
        for linux-btrfs@vger.kernel.org; Sat, 21 Jul 2018 08:13:36 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs filesystem corruptions with 4.18. git kernels
Date: Sat, 21 Jul 2018 06:13:29 +0000 (UTC)
Message-ID: <pan$a3874$d541babc$9d303d23$b4cafe51@cox.net>
References: <50997dd6-6e60-af55-1aff-993b7cc3b801@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Wetzel posted on Fri, 20 Jul 2018 23:28:42 +0200 as excerpted:

> A btrfs subvolume is used as the rootfs on a "Samsung SSD 850 EVO mSATA
> 1TB" and I'm running Gentoo ~amd64 on a Thinkpad W530. Discard is
> enabled as mount option and there were roughly 5 other subvolumes.

Regardless of what your trigger problem is, running with the discard 
mount option considerably increases your risks in at least two ways:

1) Btrfs normally has a feature that tracks old root blocks, which are 
COWed out at each commit.  Should something be wrong with the current 
one, btrfs can fall back to an older one using the usebackuproot 
(formerly recovery, but that clashed with the (no)recovery standard 
option a used on other OSs so they renamed it usebackuproot) mount 
option.  This won't always work, but when it does it's one of the first-
line recovery/repair options, as it tends to mean losing only 30-90 
seconds (first thru third old roots) worth of writes, while being quite 
likely to get you the working filesystem as it was at that commit.

But once the root goes unused, with discard, it gets marked for discard, 
and depending on the hardware/firmware implementation, it may be 
discarded immediately.  If it is, that means no backup roots available 
for recovery should the current root be bad for whatever reason, which 
pretty well takes out your first and best three chances of a quick fix 
without much risk.

2) In the past there have been bugs that triggered on discard.  AFAIK 
there are no such known bugs at this time, but in addition to the risk of 
point one, there is the additional risk of bugs that trigger on discard 
itself, and due to the nature of the discard feature itself, these sorts 
of bugs have a much higher chance than normal of being data eating bugs.

3) Depending on the device, the discard mount option may or may not have 
negative performance implications as well.

So while the discard mount option is there, it's definitely not 
recommended, unless you really are willing to deal with that extra risk 
and the loss of the backuproot safety-nets, and of course have 
additionally researched its effects on your hardware to make sure it's 
not actually slowing you down (which granted, on good mSATA, it may not 
be, as those are new enough to have a higher likelihood of actually 
having working queued-trim support).

The discard mount option alternative is a scheduled timer/cron job (like 
the one systemd has, just activate it) that does a periodic (weekly for 
systemd's timer) fstrim.  That lowers the risk to the few commits 
immediately after the fstrim job runs -- as long as you don't crash 
during that time, you'll have backup roots available as the current root 
will have moved on since then, creating backups again as it did so.

Or just leave a bit of extra room on the ssd untouched (ideally initially 
trimmed before partitioning and then left unpartitioned, so the firmware 
knows its clean and can use it at its convenience), so the ssd can use 
that extra room to do its wear-leveling, and don't do trim/discard at all.

FWIW I actually do both of these here, leaving significant space on the 
device unpartitioned, and enabling that systemd fstrim timer job, as well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

