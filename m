Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36226 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbbBOLMQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 06:12:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YMx7W-0000QP-Bj
	for linux-btrfs@vger.kernel.org; Sun, 15 Feb 2015 12:12:14 +0100
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 12:12:14 +0100
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 12:12:14 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: btrfs raid-1 uuid-fstab
Date: Sun, 15 Feb 2015 12:11:56 +0100
Message-ID: <sgb6rb-2hv.ln1@hurikhan77.spdns.de>
References: <loom.20150214T001556-40@post.gmane.org> <CAJCQCtSRgOmUfNFdvxoU1m77m-K_oKvp-nFeyaR8VtuYZbacyg@mail.gmail.com> <pan$61fb6$e370d823$43b0d70$79a222c6@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

> While in theory btrfs has the device= mount option, and the kernel has
> rootflags= to tell it what mount options to use, at least last I checked
> a few kernel cycles ago (I'd say last summer, so 3-5 kernel cycles ago),
> for some reason rootflags=device= doesn't appear to work correctly.  My
> theory is that the kernel commandline parser breaks at the second/last =
> instead of the first, so instead of seeing settings for the rootflags
> parameter, it sees settings for the rootflags=device parameter, which of
> course makes no sense to the kernel and is ignored.  But that's just my
> best theory.

Gentoo here, too. And I tried to fiddle around with the exact same issue 
some kernel versions back and didn't get it to work, so I did go with dracut 
which works pretty well for me - combined with grub2, multi-device detection 
works pretty well tho you sometimes need rootdelay={1,2,3} to wait up to 
three seconds for btrfs figure out its setup. Looks like btrfs devices are 
assembled with a delay by the kernel and at the point you try to mount one 
of the compound devices, if done too early, the kernel code cannot yet find 
all the other devices of the set. Maybe "rootwait" would also do tho I 
didn't tried that yet (it probably won't as the root device is initrd 
initially). It may be a side-effect of the kernel doing async SCSI device 
detection. It may be worth trying to turn that option of.

But about your theory: I don't think the cmdline parser works incorrect, 
becauce rootflags=subvol=something works. It's probably just a flaw that 
btrfs device composition comes up later and the kernel tries to early to 
mount root. "rootwait" probably won't help here, too. But "rootdelay" may 
help that case tho I myself don't have the ambitions to experiment with it. 
My dracut initrd setup works fine and has some benefits like early debug 
shell to investigate problems without resorting to rescue systems or 
bootable USB sticks.

-- 
Replies to list only preferred.

