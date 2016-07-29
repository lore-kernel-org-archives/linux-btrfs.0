Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55475 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbcG2RX0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jul 2016 13:23:26 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bTBVL-0000Og-CD
	for linux-btrfs@vger.kernel.org; Fri, 29 Jul 2016 19:23:23 +0200
Received: from ip-64-134-228-15.public.wayport.net ([64.134.228.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jul 2016 19:23:23 +0200
Received: from 1i5t5.duncan by ip-64-134-228-15.public.wayport.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jul 2016 19:23:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS: Transaction aborted (error -28)
Date: Fri, 29 Jul 2016 17:23:14 +0000 (UTC)
Message-ID: <pan$5fb1f$7ade4380$d83d2847$ba15621a@cox.net>
References: <CA+xOVSOx56oc5kF+oj18B3m23wcpy2OqbKbH9j13se+s98YvdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mordechay Kaganer posted on Fri, 29 Jul 2016 16:37:05 +0300 as excerpted:

> While saving a backup (using rsync) the FS went read only and i've got
> BTRFS: Transaction aborted (error -28) error. While writing a new backup
> i was also doing btrfs send of another subvolume on the same FS from
> this server out to another server.
> 
> After reboot, the device mounts OK. Does it mean something went wrong
> with the FS? Need to run a full balance?

Because btrfs is designed to be copy-on-write, with atomic transactions, 
an aborted transaction /should/ leave you with a consistent filesystem, 
simply lacking whatever changes would have occurred in that transaction.

Of course the fact that the transaction aborted /does/ indicate some sort 
of problem, which may in fact have left the filesystem in an unknown 
state.  However, I'd recommend a couple other checks, not balance, to be 
sure you're good.  First, a btrfs scrub of the filesystem, just to be 
sure the checksums all come out fine (or are fixable and fixed if not).  
Second, a btrfs check, which will be read-only unless you add --repair or 
similar option.

If those both come out fine it was probably simply stress from the rsync 
and the send at the same time.  Rsync in particular is known to be 
intensive enough to be a reasonable real-world stress test for btrfs, and 
has in fact flushed out a number of bugs over the years that people 
didn't see in otherwise normal usage.  Combining it with send of course 
amplifies the stress on the filesystem, such that if bugs are going to 
show up, and btrfs isn't yet fully stable and mature so that's expected, 
combining rsync with pretty much anything else intensive as well is 
likely to flush them out.

> btrfs-tools version: btrfs-progs v4.3.1
> 
> The kernel is based on Ubuntu mainline PPA 4.3.3
> (http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.3.3-wily/) with a
> patch to fix RAID10 issue.

FWIW, kernel 4.3 is no longer really recommended or supported well on 
this list.  The list recommendation is the last two kernels series in 
either the LTS or current channels.  The last two upstream LTS series are 
4.4 and 4.1.  The latest current kernel is of course 4.7, so 4.7 and 4.6 
would be supported there.

Of course distros can and do choose other kernel series to support, and 
you may choose to go with them and their support instead, but if so, you 
really should be getting support from them, because they are tracking 
what patches they've backported, while this list is generally focused on 
mainline and won't know what distros have backported, and because the 
focus is on moving forward, we only generally support the two current 
kernel series, plus the two current LTS series for those who don't want 
to be upgrading to a new kernel series every couple months.

During normal operation, userspace (btrfs-progs) is less important as 
most commands simply call the kernel code to do the real work.  However, 
once something goes wrong and you're trying to recover, it's mostly 
userspace code, and the newer versions are better positioned to fix more 
problems, so they're recommended then.  Plus, as the commands and their 
output are still changing from time to time, get too old and the commands 
and output are different enough it's hard to compare.  So a good rule of 
thumb is to at least match your kernel x.y version, tho newer is fine.  
That way, provided you're following the kernel recommendations, you're 
assured of a reasonably current btrfs userland as well.

So I'd recommend upgrading to the latest kernel 4.4 if you want to stay 
with the stable series, or 4.6 or 4.7 if you want current, and then (less 
important) upgrading the btrfs userspace as well.  It's possible the 
newer kernel will handle the combined rsync and send stresses better, and 
if not, you're on a better base to provide bug reports, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

