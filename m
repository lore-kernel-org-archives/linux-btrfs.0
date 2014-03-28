Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57147 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaC1GXN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 02:23:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WTQC6-0001oO-O2
	for linux-btrfs@vger.kernel.org; Fri, 28 Mar 2014 07:23:10 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 07:23:10 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Mar 2014 07:23:10 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID-1 - handling disk failures?
Date: Fri, 28 Mar 2014 06:22:45 +0000 (UTC)
Message-ID: <pan$3b396$3130b7c1$e1ba7489$b1f197bf@cox.net>
References: <20140327215215.68b6ef51@virtall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Chmielewski posted on Thu, 27 Mar 2014 21:52:15 +0100 as excerpted:

> Is btrfs supposed to handle disk failures in RAID-1 mode?
> 
> It doesn't seem to be the case for me, with 3.14.0-rc8.
> 
> Right now, the system doesn't see the faulty drive anymore (i.e. hdparm
> -i /dev/sdd is unable to give any info).
> 
> Accesses to most files on btrfs filesystem just "freeze" (waiting for
> IO) the process which is accessing the data.
> 
> The other drive in RAID-1, /dev/sdc, is healthy.

Well, btrfs raid1 mode handles (single) drive loss, but rather 
differently than you might be used to raid1 working, if you've worked 
with it on mdraid or the like.

1) (Not directly related to your problem, but it likely differs from 
other raid1 you've worked with...) Unline normal raid1, btrfs' so-called 
raid1 mode is actually two-way-(only-)mirrored.  No matter how many 
devices there are in the filesystem, btrfs will only do two-way-mirroring 
of each chunk.  Thus, btrfs raid1 mode only tolerates loss of a single 
device without data loss, since once you lose two, both copies of some 
chunks will be gone and not recoverable, regardless of how many devices 
were in the raid1.

2) In btrfs, once you drop below the natural minimum number of devices to 
sustain that raid type, btrfs goes read-only as writes can no longer be 
done in the configured raid mode, which naturally blocks anything 
attempting to write to the filesystem.  I suspect that's what's happening 
to you.

With raid0 or raid1, the natural minimum operational number of devices is 
two.  With raid5, it's three.  With raid6 and raid10, it's four.  
(However, do note that raid5/6 support isn't complete yet.  Don't 
actually rely on it working as raid5/6 if something goes wrong, just yet.)

In your raid1 case, once you drop to a single device, writes can no 
longer be done to two mirrors, so the filesystem is forced read-only.  
Naturally that's going to hang any thread trying to do a write in 
"D" (disk-sleep) state.  Once those hung writing threads plug the IO 
queue reads will stall behind the writes, and anything trying to read 
from that filesystem will ultimately deadlock and hang as well.

OTOH, if you have more than the minimum number of devices, say you have 
three devices for raid1 mode, drop one device and writes can still be 
done in btrfs' normal two-way-mirrored raid1 write mode to the two 
remaining devices.  I'm not actually sure if it goes read-only when a 
device drops in this case or not, but if it does, you should be able to 
set it back to read/write mode and get on with things if you need to.

Basically what that means is that once you drop below two devices in 
raid1 mode, that btrfs will drop to read-only.  If it's your rootfs or 
the like, you're pretty well hosed and will be forced to reboot pretty 
quickly, altho if you catch it quickly enough you can probably umount 
other filesystems, etc, not on the dropped devices.  If it's just some 
auxiliary filesystem, you'll probably lose any processes working with it, 
but otherwise you should hopefully continue to stay in operation.

Mounting the still degraded filesystem in degraded mode (with the 
degraded mount-option) after a shutdown or other fully filesystem 
unmount, will result in the same force-read-only situation, except since 
the filesystem was never writable in the first place, nothing should have 
been able to open files on it in write-mode, so you should be able to get 
back workable enough at least to do a btrfs device add to it, bringing it 
back to the minimum two devices again, after which you should then be 
able to remount it writable.  With it again mounted writable, you should 
be able to do a btrfs device delete missing to remove the bad device, 
followed by a rebalance to create a new second mirror of all chunks where 
one mirror was on the missing device.

Basically, all this means in ordered to keep a btrfs raid1 fully usable 
without rebooting in the event of a dropped device, you'll need to build 
it out to three devices, so you can drop one and still have enough 
devices left to continue writing to a full pair of devices in two-way-
mirroring.

Depending upon your use-case, the drop to read-only and potentially 
forced-reboot may or may not be acceptable, as long as the data's still 
there and accessible, to copy elsewhere or whatever, after the reboot.  
If it's not acceptable, then as mentioned, do plan on making it three 
devices in normal mode, so the filesystem can continue writing in so-
called raid1 mode to the two remaining devices if one drops.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

