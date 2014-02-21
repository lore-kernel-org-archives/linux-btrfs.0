Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41990 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbaBUQK1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Feb 2014 11:10:27 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WGsgA-00015x-1z
	for linux-btrfs@vger.kernel.org; Fri, 21 Feb 2014 17:10:22 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 17:10:22 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Feb 2014 17:10:22 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Hard drive hangs after excessive I/O
Date: Fri, 21 Feb 2014 16:09:56 +0000 (UTC)
Message-ID: <pan$9db86$8cb7b8f1$9ed699ad$9da2e024@cox.net>
References: <CAAVQaYCkxpp8vX8PnO3OLffSm_MMCt6N2qFT=5DWjseZmZ1xbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dave posted on Fri, 21 Feb 2014 10:21:38 -0500 as excerpted:

> During this time, all IO totally freezes.  Atop reports no disk
> activity, while my desktop is totally hung.  After a few minutes
> everything comes back to life, only to freeze again after a few more
> minutes.
> 
> A reboot clears everything up for a day or so but the problem invariably
> comes back.  Can anybody shed some light on this?
> 
> PS, the above qemu process is accessing image files on a btrfs volume.
>  These files were created as such:
> touch winxp.img
> chattr +C winxp.img
> fallocate -l20G winxp.img

That procedure should indeed make those VM images properly NOCOW.
Thanks for being so explicit. =:^)

One other question:  Are you, or perhaps your distro via likely automated 
script, doing any btrfs snapshotting of the VM-image containing btrfs 
(sub)volume?

Because snapshotting on a an actively being rewritten NOCOW file is one 
known exception to that NOCOW.  The snapshot takes a copy of the file at 
that moment, and further writes to it must therefore be COWed -- tho only 
the first time a block is written to after the snapshot, further writes 
to the same block will remain in-place written until the next snapshot 
freezes that in-place, triggering yet another COW on first write once 
again.

So depending on the presumably scripted snapshotting schedule and the 
activity on the VM, fragmentation probably won't be as bad on a 
snapshotted NOCOW image as on a standard COW image, but it will still 
happen.

So if you have a snapshotting script running on that subvolume, that 
might be /part/ of it, tho to my knowledge that doesn't fully explain why 
it'd be better for a day or so after a reboot, since the fragmentation 
should be the same as before the reboot.

If you're not doing snapshotting, given that the VMs should indeed be 
NOCOW and as posted you've handled that correctly, I've no idea.  But 
I'll certainly be following the thread, as this is one aspect I've been 
particularly interested in. I don't have any specific personal 
involvement in it at this point, but it's a general enough problem I very 
well could in the future.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

