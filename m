Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33466 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbaEVJnz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 22 May 2014 05:43:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WnPXW-0007dZ-Cb
	for linux-btrfs@vger.kernel.org; Thu, 22 May 2014 11:43:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 11:43:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 22 May 2014 11:43:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: mount hangs after disk crash (RAID-1)
Date: Thu, 22 May 2014 09:43:40 +0000 (UTC)
Message-ID: <pan$4965$e2755b8c$eb8c082f$e15db32d@cox.net>
References: <20140522032258.234aaab7@s9>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Thu, 22 May 2014 03:22:58 +0100 as excerpted:

> One disk in RAID-1 crashed, so powered off, changed disk, powered on,
> trying to mount degraded.
> 
> Unfortunately it hangs (running 3.14.4).
> 
> # mount -o degraded,compress=lzo,noatime /dev/sdb4 /home (...never
> returns...)

1) Just to be sure, btrfs raid1, not btrfs on md/raid1 or the like, 
correct?

2) Btrfs raid1 for both data and metadata, correct?

3) How many devices in the btrfs raid1?

4) Did you try mounting read-only?

Note that unlike md/raid1, btrfs raid1 won't mount writable with only a 
single device.  You must have at least two devices to mount writable, tho 
a formerly two-device raid1 with a device missing should mount read-only.

However, ordinarily you can't add a device to a filesystem unless it's 
mounted writable, and if it won't go writable as you have only the one 
device, so you can't add another device...  I'm actually not sure how 
that's supposed to work, as the requiring two devices to mount writable 
bit is fairly new.

In the worst case, however, you could create a new single-device 
filesystem with the new device and mount it, mount the old one read-only 
and copy everything over, then unmount the old one and add it to the new 
one, then do a balance-convert to raid1 mode again.  That's actually how 
I've been planning to handle it if I lose a device from my paired-device 
btrfs raid1 and it goes read-only, so I can't add the replacement 
device.  Seems there should be an easier way, but...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

