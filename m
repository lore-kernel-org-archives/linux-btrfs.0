Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33664 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaCTHhb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 03:37:31 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WQXXd-0007eH-So
	for linux-btrfs@vger.kernel.org; Thu, 20 Mar 2014 08:37:29 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 08:37:29 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 08:37:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to handle a RAID5 arrawy with a failing drive? -> raid5
 mostly works, just no rebuilds
Date: Thu, 20 Mar 2014 07:37:05 +0000 (UTC)
Message-ID: <pan$cb2d8$ca7492f$8d528793$b5010601@cox.net>
References: <1394983430-20440-1-git-send-email-fdmanana@gmail.com>
	<1395002246-3840-1-git-send-email-fdmanana@gmail.com>
	<20140316222026.GU16946@merlins.org>
	<pan$2239d$446ec5c7$d67506b7$f25a7c65@cox.net>
	<20140319060902.GM6143@merlins.org>
	<CD1D8CED-8BC2-4C16-AE9E-0C47DC954CFA@colorremedies.com>
	<20140319154031.GP6143@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Wed, 19 Mar 2014 08:40:31 -0700 as excerpted:

> That's the thing though. If the bad device hadn't been forcibly removed,
> and apparently the only way to do this was to unmount, make the device
> node disappear, and remount in degraded mode, it looked to me like btrfs
> was still consideing that the drive was part of the array and trying to
> write to it.
> After adding a drive, I couldn't quite tell if it was striping over 11
> drive2 or 10, but it felt that at least at times, it was striping over
> 11 drives with write failures on the missing drive.
> I can't prove it, but I'm thinking the new data I was writing was being
> striped in degraded mode.

FWIW, there's at least two problems here, one a bug (or perhaps it'd more 
accurately be described as an as yet incomplete feature) unrelated to 
btrfs raid5/6 mode, the other the incomplete raid5/6 support.  Both are 
known issues, however.

The incomplete raid5/6 is discussed well enough elsewhere including in 
this thread as a whole, which leaves the other issue.

The other issue, not specifically raid5/6 mode related, is that 
currently, in-kernel btrfs is basically oblivious to disappearing drives, 
thus explaining some of the more complex bits of the behavior you 
described.  Yes, the kernel has the device data and other layers know 
when a device goes missing, but it's basically a case of the right hand 
not knowing what the left hand is doing -- once setup on a set of 
devices, in-kernel btrfs basically doesn't do anything with the device 
information available to it, at least in terms of removing a device from 
its listing when it goes missing.  (It does seem to transparently handle 
a missing btrfs component device reappearing, arguably /too/ 
transparently!)

Basically all btrfs does is log errors when a component device 
disappears.  It doesn't do anything with the disappeared device, and 
really doesn't "know" it has disappeared at all, until an unmount and 
(possibly degraded) remount, at which point it re-enumerates the devices 
and again knows what's actually there... until a device disappears again.

There's actually patches being worked on to fix that situation as we 
speak, and it's possible they're actually in btrfs-next already.  (I've 
seen the patches and discussion go by on the list but haven't tracked 
them to the extent that I know current status, other than that they're 
not in mainline yet.)

Meanwhile, counter-intuitively, btrfs-userspace is sometimes more aware 
of current device status than btrfs-kernel is ATM, since parts of 
userspace actually either get current status from the kernel, or trigger 
a rescan in ordered to get it.  But even after a rescan updates what 
userspace knows and thus what the kernel as a whole knows, btrfs-kernel 
still doesn't actually use that new information available to it in the 
same kernel that btrfs-userspace used to get it from!

Knowing that rather counterintuitive "little" inconsistency, that isn't 
actually so little, goes quite a way toward explaining what otherwise 
looks like illogical btrfs behavior -- how could kernel-btrfs not know 
the status of its own devices?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

