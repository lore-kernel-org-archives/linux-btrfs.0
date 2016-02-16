Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52709 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754793AbcBPKRn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 05:17:43 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aVchQ-00054S-NP
	for linux-btrfs@vger.kernel.org; Tue, 16 Feb 2016 11:17:40 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 11:17:40 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Feb 2016 11:17:40 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unable to mount BTRFS home dir anymore
Date: Tue, 16 Feb 2016 10:17:29 +0000 (UTC)
Message-ID: <pan$38e94$3057337b$ae29a823$231b907e@cox.net>
References: <CAPLCSGCBYLyxRU+SYpJCcJBWu=X=u0QFept0nV+0Oq4igc_rAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bhasker C V posted on Tue, 16 Feb 2016 08:24:24 +0100 as excerpted:

>  Help with recovery of BTRFS home directory data.
>  I have been using BTRFS happily for an year now. It has worked across
> power failures and many such situations.
> 
>  Last week, however, the filesystem could not be mounted after a power
>  failure.
> None of the following methods were helpful
> 
> 1) I tried ro,recovery,nospace_cache,nospace_cache option of mount 2) I
> tried btrfs-zero-log -y -v 3) btrfsck  --repair --init-csum-tree
> 
> btrfsck does a SIGSEGV in the end.
> 
> Please can someone help me by telling me how to proceed ?
> 
> Kernel: 4.2.0

First, kernel 4.2 series is not an LTS and is already out of mainline 
current-kernel stable support, so the recommendation would be to either 
upgrade to 4.4 current, which is also an LTS series, or downgrade to the 
previous 4.1 LTS series.  An alternative, of course, would be to continue 
to use your distro kernel if they support it, but in that case, you 
should probably look to your distro for btrfs support as well, since this 
list tends to track the mainline kernel series and we really don't track 
what stability patches random distros might or might not backport to 
their random non-mainline-LTS-series kernels, and thus don't really know 
their stability status.

Similarly for btrfs userspace (btrfs-progs), where the rule of thumb is 
to use at least the latest release matching your kernel series, which if 
you follow the kernel recommendations, will avoid getting too far behind 
on userspace as well.

Tho once you're actually needing to work with an offline filesystem, 
using btrfs check, etc to try to fix it, or btrfs restore to restore 
files from it, the latest userspace is recommended, as it will have the 
latest patches and thus be most likely to successfully recover your data.


Second, as the sysadmin's first rule of backups states in its simplest 
form, if you don't have at least one backup, you're defining the data 
without that backup as worth less than the time and resources necessary 
to do that backup.

And of course, that's the general rule, as it applies to fully mature and 
stable filesystems.  Btrfs however, is still stabilizing and maturing, 
and while stable enough for daily use if you have backups, it's not yet 
fully stable and mature, so the sysadmin's first rule of backups applies 
even more strongly on btrfs than it does in the normal, fully stable and 
mature filesystem, case.

As such, you can be happy, as you either have a backup to restore your 
files from, or you had already by your actions defined those files as of 
only trivial value, with your time and the resources necessary to do that 
backup of more value than the data you weren't backing up.  So even if 
you lose the data, you saved what was self-evidently more valuable to 
you, the time and resources that you'd have otherwise spent doing that 
backup, and thus can be happy that you saved the real important stuff. 
=:^)

So no sweat.  Just restore from your backups, or if you didn't have them, 
the data was self-evidently of only trivial, throw-away value, in any 
case. =:^)

Meanwhile, third, now assuming your data was valuable enough to be backed 
up, and you do have backups to use if you have to, but they weren't 
necessarily current, and you'd prefer to avoid redoing the lost work 
between the time of your backup and the time the filesystem crashed on 
you, if at all possible...

In this case, btrfs restore is the tool most likely to help you recover 
the data in as close a state to current as possible.  Btrfs restore works 
with the /unmounted/ filesystem, attempting to find and pull files off 
it, saving them to some other mounted filesystem (which doesn't have to 
be btrfs) as it recovers them.

Again, you'll want to be using current btrfs-tools (4.4 as I type this) 
if possible, as it has the best chance at restoring files.  For btrfs 
restore, the kernel version doesn't matter, as userspace is doing all the 
work using its own code.

Ideally, you'll simply be able to point btrfs restore at the bad device
(s) and tell it where to put the files as it restores them, and it'll go 
from there.  However, if that doesn't work, there's still a chance to 
make it work manually, by finding suitable old root nodes (which btrfs 
keeps around due to copy-on-write) using btrfs-find-root, and pointing 
btrfs restore at them using its -t <bytenr> option.  This does tend to 
get a bit down and dirty technical, however, and some potential users 
find they can't handle it at that technical level, and have to give up.

There's a page on the wiki covering the procedure, tho it's not 
necessarily current and you may have to read between the lines a bit.

https://btrfs.wiki.kernel.org/index.php/Restore

[Unfortunately, I'm getting sec_error_ocsp_bad_signature for the OCSP 
response for the wiki ATM.  Here's a couple archive links to it, courtesy 
of the resurrect-page plugin I run.]

https://archive.is/PPkKP

http://webcache.googleusercontent.com/search?q=cache:https%3A%2F%
2Fbtrfs.wiki.kernel.org%2Findex.php%2FRestore

If btrfs-find-root segfaults too, or if you're unsuccessful with it and 
btrfs restore either because you can't follow it or because it simply 
doesn't work in your case, you may be out of luck and will need to use 
your backups even if they aren't current, unless one of the devs takes an 
interest and you can build and run various debugging patches to trace 
down the problem further and hopefully eventually get a btrfs check patch 
that will fix it.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

