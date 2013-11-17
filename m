Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42473 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab3KQUYU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Nov 2013 15:24:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vi8tG-0004Gk-Qs
	for linux-btrfs@vger.kernel.org; Sun, 17 Nov 2013 21:24:18 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Nov 2013 21:24:18 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Nov 2013 21:24:18 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Ubunutu scanning for a btrfs fs it will never find
Date: Sun, 17 Nov 2013 20:23:56 +0000 (UTC)
Message-ID: <pan$78cfa$e66d0bd7$51d5f50d$ea952b6a@cox.net>
References: <5288B4CF.90703@zignux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Antonio Rodulfo posted on Sun, 17 Nov 2013 13:21:35 +0100 as excerpted:

> After upgrading one of my laptops from XUbuntu 12.04 to 12.10, I started
> to see a "Scanning for Btrfs filesystems" message after the initial grub
> menu and before the system issues its startup sequence of messages.

> The system hangs now there for several seconds (15, maybe?) and keeps
> going with no further reference to btrfs.
> 
> I don't have any btrfs in my laptop nor plan to have it.

> I have read I could remove btrfs-tools module from my kernel and / or
> blacklist it in /etc/modprobe.d
> 
> What do you recommend?

I'm not really familiar with xubuntu (or indeed, ubuntu at all), but an 
educated guess based on your description is that 12.10 has a btrfs 
option, possibly even the default, if installed "clean", thus the 
scanning for btrfs (which from your description is coming from the pre-
packaged initramfs/initrd before root is even mounted).

Since you upgraded and apparently kept the existing partitioning and 
filesystems without btrfs, you don't have any btrfs for it to find, so 
all it does is delay your boot.

Yes, it should be possible to turn off that scan, but because it appears 
to be coming from the pre-built initr* that's shipped by the distro with 
the assumption that new installs will likely have btrfs, turning it off 
may be a bit complex, possibly involving an initr* rebuild, tho it's also 
possible the distro has an alternative initr* available without that 
scan, exactly because of situations like yours, and all you need to do is 
install that alternative.

However, that's a distro-specific issue, so chances are you'll need to 
post the question to your distro's lists or forums (unless someone here 
by simple chance happens to have distro-specific knowledge of (x)ubuntu 
and can post an answer).  I don't know whether that'd be xubuntu 
specifically, or the general ubuntu forums/lists, but that's where I'd 
suggest you post the question if nobody chances to have a good answer for 
you here.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

