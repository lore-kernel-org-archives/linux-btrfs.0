Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48974 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753321Ab3G1Ihc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jul 2013 04:37:32 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V3MTr-0001Lj-EL
	for linux-btrfs@vger.kernel.org; Sun, 28 Jul 2013 10:37:31 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jul 2013 10:37:31 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jul 2013 10:37:31 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mount multiple-device-filesystem by UUID
Date: Sun, 28 Jul 2013 08:37:13 +0000 (UTC)
Message-ID: <pan$e00e4$b06f1ef9$18d78546$3ce0429b@cox.net>
References: <51F41660.1070405@friedels.name> <51F41702.2000508@friedels.name
	> <20130727194448.GO20517@carfax.org.uk> <
	pan$b873b$34bc7363$e7fad079$c205b803@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan posted on Sat, 27 Jul 2013 22:14:02 +0000 as excerpted:

> btrfs raid1 root here, was initr*less until I switched to btrfs which is
> broken with direct-kernel-root-mount rootflags=device=whatever syntax.
> 
> UUIDs are indeed userspace -- udev/systemd.  However, if your initr*
> includes udev, at least here, it "just works".
> 
> I use root=LABEL=whatever here on the kernel commandline for root, and
> LABEL=whatever for non-root in fstab, but as long as udev has the
> directory in /dev/disk/*, mount should work with it, so
> root=UUID=whatever at the kernel commandline should work, as should
> UUID=whatever in fstab as the first field.

I can add...

* I use dracut as my initramfs generator, but with some of the default 
modules stripped in ordered to create a leaner initramfs.

* It has a(n optional but obviously activated here) btrfs module that 
among other things, runs btrfs device scan before attempting to mount 
real-root.  That's the critical bit that should be in your initramfs 
before attempting to mount a multi-device btrfs.  With the btrfs 
executable and a call to btrfs device scan, mount, and udev creating the 
/dev/disk/by-*/ subdirs, an initramfs environment should really handle 
pretty much all the mount options available to you at a full-booted 
commandline.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

