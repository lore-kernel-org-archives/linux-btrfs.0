Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37681 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaALEoo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 Jan 2014 23:44:44 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1W2Cug-0008DK-EC
	for linux-btrfs@vger.kernel.org; Sun, 12 Jan 2014 05:44:42 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 05:44:42 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jan 2014 05:44:42 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS over LVM remounts read-only
Date: Sun, 12 Jan 2014 04:44:20 +0000 (UTC)
Message-ID: <pan$44ad6$8e22fa31$f96b5e0f$d62a7be1@cox.net>
References: <CAE8gLh=drhPtUXSbT7zHDSh7pipxuZpVhfuRQ7QOFV+HP4wHPQ@mail.gmail.com>
	<20140111150454.GV15634@carfax.org.uk>
	<CAE8gLhnd8mjRZoJCCj8ns4W6OJJXFGUiO8Ni78aYbyY2MA_Luw@mail.gmail.com>
	<52D19217.3060106@dblaci.hu>
	<600B31B7-08B2-4A72-B8C3-518A736B9DE5@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 11 Jan 2014 16:03:20 -0700 as excerpted:

> On Jan 11, 2014, at 11:48 AM, Szalma László <dblaci@dblaci.hu> wrote:
> 
>> but the grub itself has to be on a standard bios bootable partition (as
>> far as I know)
> 
> Negative. GRUB2 has support for pretty much everything out there: ZFS,
> Btrfs, LVM, LUKS, md raid 0, 1, 10, 5, 6. It will boot Btrfs multiple
> devices, single, raid1, raid0, and raid10, and zlib or lzo.
> 
> The proper modules are baked into core.img during grub-install which
> determines the requirements for finding grub's root (which is typically
> /boot/grub). Core.img is embedded in the MBR gap (or into grubx64.efi).
> And that core.img is all that's needed to locate /boot/grub/ where even
> more modules can be arbitrarily loaded, as well as grub.cfg. At this
> point the kernel and initramfs could be anywhere, located, and booted.

Correct, but omitting one critical bit, GPT on legacy BIOS, with a BIOS-
reserved partition grub can install its core image into.

Recommended BIOS-reserved partition size is 1-2 MiB and grub can often 
work with as little as 32 KiB, often the gap size if it has to install to 
the gap, so 1-2 MiB should be plenty.  However, in ordered to align 
partitions properly, as my smallest partition, I generally start the BIOS 
reserved partition at 1 MiB and make it 3 MiB in size, so all further 
partitions are 4 MiB aligned.

With a full 3 MiB to work with grub-install can do a pretty fat core.img, 
including a bunch of modules it wouldn't otherwise have room for.  
Actually, looking on /boot, the entire grub/i386-pc subdir with ALL 
modules is only 1886013 bytes according to du, so a full grub core with 
all modules (for i386-pc anyway) builtin should be less than 2 MiB, and 
it shouldn't need the modules installed on /boot at all, tho I'm not sure 
whether it takes advantage of all that room to install everything in the 
core image since the room is available to do so, or only includes what it 
detects it needs, regardless.

Completing my under-1-gig layout is a 124 MiB efi-reserved partition, 
unused ATM but there to prevent a forced re-gdisk in case I need it later 
(leaving further partitions 128 MiB aligned), a 256 MiB /boot, and a 640 
MiB /var/log.  That's the first 1 GiB and all further partitions are 
whole-GiBs in size, leaving all partitions beyond 1 GiB, full-GiB aligned.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

