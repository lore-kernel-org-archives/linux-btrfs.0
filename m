Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:32768 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab3K0GOw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 01:14:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VlYOh-0002tD-DB
	for linux-btrfs@vger.kernel.org; Wed, 27 Nov 2013 07:14:51 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 07:14:51 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Nov 2013 07:14:51 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: missing /sbin/fsck.btrfs
Date: Wed, 27 Nov 2013 06:14:30 +0000 (UTC)
Message-ID: <pan$22672$ac84637f$865cf9fc$7ac893ec@cox.net>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
	<pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
	<2D538DF7-452A-420F-9826-C2059564C0A5@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 26 Nov 2013 21:55:09 -0700 as excerpted:

> If I change the bootloader kernel paramter line from ro to rw, and
> simply wipe out the roofs entry from fstab, I still have a bootable
> system. Is there a good reason why rootfs on btrfs should initially
> mount ro? It seems the legacy reason for this is so rootfs is available,
> yet can still have fsck run on it, after which it's remounted rw. None
> of that applies to btrfs does it?

I did that for awhile with reiserfs.  Pass rw on the kernel commandline 
and skip the whole fsck and remount read-write.

But then I realized it was getting mounted rw, but the other mount 
options weren't getting set, because they weren't passed on the kernel 
commandline (that was before I knew about rootflags= and likely before it 
was documented in kernel-parameters.txt, tho it possibly existed), so I 
went back to ro mounting so I could get noatime, etc, with the remount.

Now of course one could pass rootflags= on the kernel commandline too, 
and make rw just another part of that, particularly since btrfs has a 
whole lot of other mount options one might like to pass 
(autodefrag,compress=lzo,noatime...).  Further, at least for those 
building their own kernel the builtin kernel commandline could be used, 
thus avoiding the hassle of having to actually pass all that stuff in 
from the bootloader.

But meanwhile, I've recently become a ro-rootfs-by-default convert.  I 
now routinely run a read-only root, unless I'm actively updating or 
reconfiguring something and need a read-write root for that.  But it ro 
as booted, remounted rw only for changes, then mounted ro once again.

That's actually a far more stable and safe way to run, particularly since 
I'm running a still not entirely stable btrfs rootfs, since as long as 
it's mounted ro, a system crash is extremely unlikely to cause any damage 
at all.  It's worth noting that traditionally, rootfs was never fully 
unmounted for shutdown anyway, only mounted ro, since it normally 
couldn't be unmounted because executable files were still open for 
reading/execution.  (I understand that systemd, when run from an 
initramfs, can now fully unmount real-root, leaving only the in-memory 
initramfs mounted, but that's not the way things traditionally worked.)

Which is nice, since it means the entire operating system, or at least 
all of it that's on rootfs, is available to help recover other 
filesystems that /were/ mounted read-write at the time of a crash, and 
/did/ have open files...  Having the full system including manpages, a 
browser, etc, available for recovery is a whole lot nicer than trying to 
recover rootfs with the normally extremely limited tools and 
documentation available in the initramfs, for sure!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

