Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40772 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827AbaHDFYH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 01:24:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XEAkf-0007Kf-0r
	for linux-btrfs@vger.kernel.org; Mon, 04 Aug 2014 07:24:05 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 07:24:05 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Aug 2014 07:24:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Scan not being performed properly on boot
Date: Mon, 4 Aug 2014 05:23:51 +0000 (UTC)
Message-ID: <pan$a693c$ad9d22e3$2215559b$722c9bf2@cox.net>
References: <53DEF7DD.5070002@peter-r.co.uk> <1704788.vV3kpDkpOK@xev>
	<53DF0553.1010404@chinilu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

George Mitchell posted on Sun, 03 Aug 2014 21:00:19 -0700 as excerpted:

>>> I cannot mount my root with anything other than an explicit /dev/sdx
>>> reference until I manually run a scan. Then UUID etc all work. I've
>> That sounds like a problem with the Ubuntu initrd, probably filing an
>> Ubuntu bug report would be the best thing to do.  Is BTRFS supported in
>> that version of Ubuntu?
>>
>> But just changing your boot configuration to use /dev/sdx is probably
>> the best option.
>>
> Assuming you are booting with grub2, you will need to use /dev/sdx in
> the grub2 configuration file.  This is known issue with grub2. Example
> from my script:
> 
> ------------------------------------------------------------------------
> echo    'Loading Linux desktop ...'
> linux   /vmlinuz-desktop root=/dev/sda7 ro splash quiet
> echo    'Loading initial ramdisk ...'
> initrd  /initrd-desktop.img
> 
> ------------------------------------------------------------------------

??

Known issue with ubuntu's grub2, perhaps?  Or perhaps with separate 
initrds as opposed to kernel-appended initramfss?  Or maybe it's with 
loadable kernel modules as opposed to a custom-built monolithic kernel?  
Or maybe it's an issue with mbr style grub2 but not gpt with a dedicated 
BIOS boot partition, or perhaps with grub2 in EFI mode instead of BIOS 
mode?

Because it works just fine here, grub2, root=LABEL= style root= line 
pointed at a multi-device btrfs rootfs, BIOS mode gpt partitions with a 
dedicated BIOS partition for grub2 to use, custom built monolithic kernel 
with all necessary modules builtin and an appended initramfs, not a 
separately loaded initrd.

As rootfs /is/ a multi-device btrfs I /do/ have to have an initramfs, 
because apparently the kernel's command-line parser doesn't properly 
handle the btrs device= mount option in rootflags=device= parameters, and 
without a userspace btrfs device scan, the btrfs device= mount option 
must be passed for multi-device filesystems or btrfs will refuse to mount 
the device without degraded.  But with an appropriate initramfs, it most 
certainly does work here.

FWIW, my initramfs is dracut-based, btrfs and udev dracut modules loaded 
of course, with or without the systemd dracut module also loaded (I 
recently converted to systemd and was running the non-systemd dracut 
before that.

And root=LABEL= works just fine.

In fact, I have grub2 variables setup with the labels for several 
different rootfs choices, working multi-device btrfs rootfs, primary 
backup multi-device btrfs rootfs, and secondary backup reiserfs rootfs.  
I then have a grub2 menu setup that lets me choose between the three, 
substituting in the appropriate grub2 variable based root=LABEL= kernel 
commandline option as necessary.  With the previously mentioned exception 
of having to use the initramfs in the first place in ordered to work 
around the kernel's rootflags=device= parsing issue instead of being able 
to direct-boot the rootfs without an initramfs at all, it all works 
exactly as expected.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

