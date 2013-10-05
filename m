Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33234 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab3JEEnR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Oct 2013 00:43:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VSJhz-0002Ty-GP
	for linux-btrfs@vger.kernel.org; Sat, 05 Oct 2013 06:43:15 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 06:43:15 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 05 Oct 2013 06:43:15 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Linux Arch: kernel BUG at fs/btrfs/inode.c:873!
Date: Sat, 5 Oct 2013 04:42:56 +0000 (UTC)
Message-ID: <pan$29f84$2a19071e$4190bce2$1629fe10@cox.net>
References: <CAOMFOmWzXL5G22Z7srkvXe+p+F9U7atOoiV5jRHc9i0k4kUfnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anatol Pomozov posted on Fri, 04 Oct 2013 21:03:11 -0700 as excerpted:

> Hi,
> 
> I have a home server on Linux Arch (kernel 3.11.2) that uses
> multi-device btrfs on root filesystem.
> 
> Until recently it worked completely fine. And yesterday I rebooted it
> and the machine did not wake up.
> 
> I booted from a USB (kernel 3.10) and tried to mount the filesystem.
> Here is OOPs I see

> ------------[ cut here ]------------
> [   68.126138] kernel BUG at fs/btrfs/inode.c:873!
> [   68.126164] invalid opcode: 0000 [#1] PREEMPT SMP

> The only thing that I did recently is defrag /var/log/journal files
> (journalctl is very slow because of btrfs COW). Something like this
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24878.html
> 
> How to fix this problem? And restore the data...

I'm not a dev just a btrfs user and list regular myself, so the traces 
don't mean much to me.  However, the bit I retained in the quote above 
(especially the 0000 opcode) looks very much like a bug that should be 
fixed in kernel 3.12, with the patch queued for stable as well, but due 
to a mixup it didn't get into stable thru 3.11.4, but the mixup's 
hopefully straightened out now so with luck it'll be in 3.11.5.

So the first thing I'd try is either cherrypicking the btrfs patches from 
3.12 back to 3.11-stable, or wait for 3.11.5 and check for btrfs patches 
there, or try 3.12-rcX (rc3 is out and I guess rc4 should be out shortly 
now as I think it has been nearly a week).

With luck that'll fix it.  If not, then post back with the new kernel you 
tried and hopefully one of the devs can help.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

