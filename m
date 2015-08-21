Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55348 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbbHUSHY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 14:07:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZSqip-00025b-1A
	for linux-btrfs@vger.kernel.org; Fri, 21 Aug 2015 20:07:23 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 20:07:23 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 20:07:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS cannot remove empry directory pretending it is not empty
Date: Fri, 21 Aug 2015 18:07:12 +0000 (UTC)
Message-ID: <pan$4fa97$8f2170ac$4ac8e423$97115d2@cox.net>
References: <2017000.AEG9PyVY17@zafu>
	<pan$3546e$3dbd1a66$4b200cff$9537e206@cox.net> <1563126.2Gc1A7GJcV@zafu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swâmi Petaramesh posted on Fri, 21 Aug 2015 17:39:49 +0200 as excerpted:

> Even though I have backups, I don't have too much time and desire for
> breaking and restoring my system, and I'd rather keep this "dead"
> directory forever rather than taking any risk of frying my root FS...

Understood.  FWIW, you should be able to rename it...

That's what I did for awhile, when I got "an undeletable", awhile back.

My primary backups, however, are identically sized partitions on the same 
set of physical devices, with fstab actually being a symlink that I can 
easily switch between fstab.working and fstab.bak1, that has the working 
and primary-backup mounts switched, the idea being that I have an 
emergency boot partition that's guaranteed to be 100% functional, same 
manpages, same full boot to kde on X GUI, same web browser and media 
players installed, everything, since it's effectively a snapshot (not 
btrfs snapshot, separate filesystem) copy of the root filesystem as it 
was at the time I did the backup.  No cramped limited-functionality 
emergency boot disk for me, just select the option in grub that sets the 
variable that I use in the root= kernel commandline option to point to 
the backup root instead of the working root, and I'm good to go! =:^)

And with the working set and primary-backups being on dual-device btrfs 
raid1, I'm protected from device failure and fat-finger or filesystem 
failure, both.

Meanwhile, every so often when it's time to freshen the backup, instead 
of simply doing a mkfs on the backup and copying everything over again, 
I'll do that, then boot to the backup (which I always do to test it 
anyway), and from there reverse the process, doing a mkfs on the normal 
working version and copying everything back to it again.

Particularly back when btrfs was still rather more experimental and 
buggy, that was my way of ensuring that any latent bugs in the after all 
then still experimental filesystem had a limited lifetime on my system, 
so they couldn't come back to haunt me years later.  It also allowed me 
to take better advantage of newly introduced filesystem features (like 
the now default 16 KiB metadata nodes, where the old default was 4 KiB) 
that couldn't be enabled on existing filesystems.

So that undeletable was eventually blown away, along with the filesystem 
it was on, when I recreated my working copy with a fresh mkfs and copy 
back over from the backup.

Of course I have secondary (other physical media, and my pre-btrfs 
filesystem, reiserfs, same computer) and third level backup (external 
media, disconnected by default) as well, tho they're updated relatively 
less frequently.  Same backup strategy, tho.  The backup media has a 
local copy of grub2 installed that I can boot by simply selecting the 
appropriate boot device in the BIOS, and from any of the grub copies, I 
can scan all devices and boot any of the backup rootfs I find, switching 
to its local grub config and set of loadable kernels first, should I need 
to.  Similarly with the other partitions, home partitions/filesystem, 
log, distro packages, media...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

