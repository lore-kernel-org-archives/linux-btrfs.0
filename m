Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59164 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbaDXLdW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 07:33:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WdHu4-0001ZH-JV
	for linux-btrfs@vger.kernel.org; Thu, 24 Apr 2014 13:33:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 13:33:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Apr 2014 13:33:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: raid6, disks of different sizes, ENOSPC errors despite having
 plenty of space
Date: Thu, 24 Apr 2014 11:33:06 +0000 (UTC)
Message-ID: <pan$7eb50$9c2488c9$7c669a8f$2cc6e41@cox.net>
References: <CACZaor2-NMo2PeZ=pO0ygz=VjE4JDoORp4Np8unVGd3buwKBxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sergey Ivanyuk posted on Wed, 23 Apr 2014 17:04:10 -0400 as excerpted:

> I have a filesystem that I've converted to raid6 from raid1, on 4 drives
> (I have another copy of the data):
> 
> Total devices 4 FS bytes used 924.64GiB
> devid    1 size 1.82TiB used 474.00GiB path /dev/sdd
> devid    2 size 465.76GiB used 465.76GiB path /dev/sda
> devid    3 size 465.76GiB used 465.76GiB path /dev/sdb
> devid    4 size 465.76GiB used 465.73GiB path /dev/sdc

That tells your story right there.  Btrfs raid6 mode requires a minimum 
of four available devices to allocate new chunks.  You have four devices, 
but three of them are full (465.76 out of 465.76 gigs allocated, no 
further free space left to allocate), so as soon as you run out of 
already allocated data or metadata space, you'll be unable to write 
anything else, since to allocate more in raid6 mode you'd have to have 
room on all four devices.

And here's your current allocation:

> Data, RAID6: total=924.00GiB, used=923.42GiB
> System, RAID1: total=32.00MiB, used=208.00KiB
> Metadata, RAID1: total=1.70GiB, used=1.28GiB
> Metadata, DUP: total=384.00MiB, used=252.13MiB
> unknown, single: total=512.00MiB, used=0.00

OK, it's only data that's raid6, and actually, it appears to be data 
that's full (close enough to it, you might write a few small files), too.

Metadata is raid1 (which requires two devices to allocate more) and dup, 
presumably from the original single-device setup, since dup on a multi-
device filesystem is not normally possible.  The raid1 metadata has 
nearly half a gig free, but btrfs will reserve about 200 MiB of that 
which won't be usable, so you should have about 200 MiB available 
metadata space to use.

So metadata isn't full ATM, but it's getting close.

Meanwhile, last I knew, btrfs raid5/6 mode support wasn't yet complete in 
any case.  Normal runtime works fine, but recovery from a lost device 
isn't fully implemented yet.  So effectively, raid6 is really inefficient 
raid0 in terms of recovery ATM, on two less devices since two are parity, 
but with the prospect of a "free" upgrade to raid6 reliability once 
that's fully implemented, since you're actually doing the parity writing 
for it already if configured for raid6, you just can't use it to restore 
so you're effectively raid0 reliability ATM.

Which isn't a good position to be in since with raid0, loss of a single 
device effectively kills the entire thing.  So unless you're purely 
playing and don't care about either possible data loss or the speed and 
capacity loss over normal raid0 mode, raid6 isn't a good idea at this 
point anyway.

As Hugo says, adding another device temporarily may give you enough room 
to balance-convert the raid6 back to raid1, or to raid0 or single or 
whatever.  That's what I'd do for now.

Meanwhile, it's worth noting that with the unevenly sized devices you 
have, single mode is the only way you're going to get full usage.  Tho 
with raid1 mode you shouldn't be too far out, basically being able to 
utilize 465*3=1395 GiB of the large device, since it's greater than the 
size of the other devices put together, with a bit over 400 gig left 
unusable.  Effectively, btrfs raid1 does pair-mirroring, and you'd be 
putting one of the pair on the larger device with the other one of the 
pair alternating between the other three devices.  Or get one more 465 
gig device and you'd basically fill them all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

