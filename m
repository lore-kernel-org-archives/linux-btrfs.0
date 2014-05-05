Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45846 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbaEFTnW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 May 2014 15:43:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WhjlW-0005lT-8n
	for linux-btrfs@vger.kernel.org; Tue, 06 May 2014 20:06:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:06:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 06 May 2014 20:06:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How does Suse do live filesystem revert with btrfs?
Date: Mon, 5 May 2014 02:39:57 +0000 (UTC)
Message-ID: <pan$1e4dd$1456e7b9$312797ca$4849ce65@cox.net>
References: <20140504005257.GF9061@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 03 May 2014 17:52:57 -0700 as excerpted:

> (more questions I'm asking myself while writing my talk slides)
> 
> I know Suse uses btrfs to roll back filesystem changes.
> 
> So I understand how you can take a snapshot before making a change, but
> not how you revert to that snapshot without rebooting or using rsync,
> 
> How do you do a pivot-root like mountpoint swap to an older snapshot,
> especially if you have filehandles opened on the current snapshot?
> 
> Is that what Suse manages, or are they doing something simpler?

While I don't have any OpenSuSE specific knowledge on this, I strongly 
suspect their solution is more along the select-the-root-snapshot-to-roll-
back-to-from-the-initramfs/initrd line.

Consider, they do the snapshot, then the upgrade.  In-use files won't be 
entirely removed and the upgrade actually activated for them until a 
reboot or at least an application restart[1] for all those running apps 
in ordered to free their in-use files, anyway.  At that point, if the 
user finds something broke, they've just rebooted[1], so rebooting[1] to 
select the pre-upgrade rootfs snapshot won't be too big a deal, since 
they've already disrupted the normal high level session and have just 
attempted a reload in ordered to discover the breakage, in the first 
place.

IOW, for the rootfs and main system, anyway, the rollback technology is a 
great step up from not having that snapshot to rollback to in the first 
place, but it's /not/ /magic/; if a rollback is needed, they almost 
certainly will need to reboot[1] and from there select the rootfs 
snapshot to rollback to, in ordered to mount it and accomplish that 
rollback.

---
[1] Reboot:  Or possibly dipped to single user mode, and/or to the 
initramfs, which they'd need to reload and switch-root into for the 
purpose, but systemd is doing just that sort of thing these days in 
ordered to properly unmount rootfs after upgrades before shutdown as it's 
a step safer than the old style remount read-only, and implementing a 
snapshot selector and remount of the rootfs in that initr* instead of 
dropping all the way to a full reboot is only a small step from there.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

