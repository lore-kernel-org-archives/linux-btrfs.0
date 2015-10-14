Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49938 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807AbbJNFIa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 01:08:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZmEId-00070I-V7
	for linux-btrfs@vger.kernel.org; Wed, 14 Oct 2015 07:08:27 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 07:08:27 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 07:08:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: System completely unresponsive after `btrfs balance start
 -dconvert=raid0 /` and `btrfs fi show /`
Date: Wed, 14 Oct 2015 05:08:17 +0000 (UTC)
Message-ID: <pan$39697$bacd3e0c$3e39ab12$ed8c21a7@cox.net>
References: <C1BFF62A-9C2E-4A5D-86F9-7F01DDDF8BF6@paolino.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Carmine Paolino posted on Tue, 13 Oct 2015 23:21:49 +0200 as excerpted:

> I have an home server with 3 hard drives that I added to the same btrfs
> filesystem. Several hours ago I run `btrfs balance start -dconvert=raid0
> /` and as soon as I run `btrfs fi show /` I lost my ssh connection to
> the machine. The machine is still on, but it doesn’t even respond to
> ping[. ...]
> 
> (I have a 250gb internal hard drive, a 120gb usb 2.0 one and a 2TB usb
> 2.0 one so the transfer speeds are pretty low)

I won't attempt to answer the primary question[1] directly, but can point 
out that in many cases, USB-connected devices simply don't have a stable 
enough connection to work reliably in a multi-device btrfs.  There's 
several possibilities for failure, including flaky connections (sometimes 
assisted by cats or kids), unstable USB host port drivers, and unstable 
USB/ATA translators.  A number of folks have reported problems with such 
filesystems with devices connected over USB, that simply disappear if 
they direct-connect the exact same devices to a proper SATA port.  The 
problem seems to be /dramatically/ worse with USB connected devices, than 
it is with, for instance, PCIE-based SATA expansion cards.

Single-device btrfs with USB-attached devices seem to work rather better, 
because at least in that case, if the connection is flaky, the entire 
filesystem appears and disappears at once, and btrfs' COW, atomic-commit 
and data-integrity features, kick in to help deal with the connection's 
instability.

Arguably, a two-device raid1 (both data/metadata, with metadata including 
system) should work reasonably well too, as long as scrubs are done after 
reconnection when there's trouble with one of the pair, because in that 
case, all data appears on both devices, but single and raid0 modes are 
likely to have severe issues in that sort of environment, because even 
temporary disconnection of a single device means loss of access to some 
data/metadata on the filesystem.  Raid10, 3+-device-raid1, and raid5/6, 
are more complex situations.  They should survive loss of at least one 
device, but keeping the filesystem healthy in the presence of unstable 
connections is... complex enough I'd hate to be the one having to deal 
with it, which means I can't recommend it to others, either.

So I'd recommend either connecting all devices internally if possible, or 
setting up the USB-connected devices with separate filesystems, if 
internal direct-connection isn't possible.

---
[1] Sysadmin's rule of backups.  If the data isn't backed up, by 
definition it is of less value than the resource and hassle cost of 
backup.  No exceptions -- post-loss claims to the contrary simply put the 
lie to the claims, as actions spoke louder than words and they defined 
the cost of the backup as more expensive than the data that would have 
been backed up.  Worst-case is then loss of data that was by definition 
of less value than the cost of backup, and the more valuable resource and 
hassle cost of the backup was avoided, so the comparatively lower value 
data loss is no big deal.

So in a case like this, I'd simply power down and take my chances of 
filesystem loss, strictly limiting the time and resources I'd devote to 
any further attempt at recovery, because the data is by definition either 
backed up, or of such low value that a backup was considered too 
expensive to do, meaning there's a very real possibility of spending more 
time in a recovery attempt that's iffy at best, than the data on the 
filesystem is actually worth, either because there are backups, or 
because it's throw-away data in the first place.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

