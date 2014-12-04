Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41543 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbaLDFPi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 00:15:38 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XwOlL-0004k7-1I
	for linux-btrfs@vger.kernel.org; Thu, 04 Dec 2014 06:15:35 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 06:15:35 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Dec 2014 06:15:35 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: PROBLEM: #89121 BTRFS mixes up mounted devices with their
 snapshots
Date: Thu, 4 Dec 2014 05:15:22 +0000 (UTC)
Message-ID: <pan$98ead$1818dba6$1ce717a3$590ca971@cox.net>
References: <CAE8gLhm8Oma6kWdeJtdc1-U2e4+TJDzhmw2Vfr=CYwvJ78GRJQ@mail.gmail.com>
	<547CA4E7.8060209@pobox.com>
	<CAE8gLhmbws6E7YQVBLHfaUXF6Jz1qob9iOFiAEW7pRTq65YCyw@mail.gmail.com>
	<547CF8B1.4000303@pobox.com>
	<CAE8gLhkxgi8nTab0rzmLNzhsek_v2zs6RxPDL9GU_EAen9+kvA@mail.gmail.com>
	<547D6F42.9000009@inwind.it>
	<CAE8gLhmVqPTArDKxBenbRasUwifGOEoy+askejqneEA9WH-iOQ@mail.gmail.com>
	<547D9F18.3030400@inwind.it> <547DA86C.4050100@oracle.com>
	<547DAF2A.7020902@gmail.com> <547E0EE5.2040504@ubuntu.com>
	<547EC8B5.1060002@inwind.it> <547FD069.5050407@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Phillip Susi posted on Wed, 03 Dec 2014 22:09:29 -0500 as excerpted:

> Are you sure the kernel only gains awareness of btrfs volumes when user
> space runs btrfs device scan?  If that is so then that means you can not
> boot from a multi device btrfs root without using an initramfs.  I
> thought the kernel auto scanned all devices if you tried to mount a
> multi device volume, but if this is so, then yes, the udev rules could
> be fixed to not call btrfs device scan on an lvm snapshot.

That has indeed been the case in the past, and to my knowledge remains 
the case.

Unless it has changed in the last cycle or two (and I've not seen patches 
to that effect on the list nor any hint of such, so I doubt it) the 
kernel doesn't do any such scanning without userspace telling it to.  The 
device= mount option can be used instead, but it didn't work with 
rootflags= on the kernel commandline last I tried so for a multidevice 
btrfs root, yes, an initramfs/initrd is required.

Which is why I'm running an initramfs for the first time since I've 
switched to btrfs raid1 mode root, as I quit with initrds back before 
initramfs was an option.  An initramfs appended to the kernel image beats 
a separate initrd, but I'd still love to see the kernel commandline 
parsing fixed so it broke at the correct = in rootflags=device= (which 
seemed to be the problem, the kernel then didn't seem to recognize 
rootflags at all, as it was apparently seeing it as a parameter called 
rootflags=device, instead of rootflags), so I could be rid of the 
initramfs again.

FWIW, I'm using dracut to generate the cpio archive, which with the right 
kernel config options set, the kernel build process then appends to the 
kernel.  Dracut btrfs module enabled of course, most of the rest force-
disabled as I run a monolithic kernel so don't need module loading, etc.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

