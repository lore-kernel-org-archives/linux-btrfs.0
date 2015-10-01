Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59662 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbbJACVa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 22:21:30 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZhTUu-0000Xj-K5
	for linux-btrfs@vger.kernel.org; Thu, 01 Oct 2015 04:21:28 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2015 04:21:28 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Oct 2015 04:21:28 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
Date: Thu, 1 Oct 2015 02:21:23 +0000 (UTC)
Message-ID: <pan$b6f45$856590$f682594c$bd5aae60@cox.net>
References: <1627746.fEEz2JqgZk@hoefnix>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sjoerd posted on Wed, 30 Sep 2015 18:49:21 +0200 as excerpted:

> A RAID5 setup on raw devices doesn't want to automount on boot. After I
> skip mounting I can log in (Ubuntu server 14.04 on kernel 4.1.8) and
> just do a "sudo mount -a" to get all mounted fine. So the array doesn't
> seem to be broken. "btrfs fi show /data" doesn't show anything wrong
> either.
> 
> The only weird thing I see in the syslog is :
> 
> BTRFS info (device sdd): disk space caching is enabled BTRFS: has skinny
> extents BTRFS: failed to read the system array on sdd BTRFS: open_ctree
> failed
>  
> If I reboot the machine the drive in the log changed and looks random
> (i've seen in 3 boots sda, sdc and sde passing by)
> 
> I am using btrfs-progs 4.2.1 if that matters in this case...
> 
> Anyone have a clue whyt it's not automounting? Or something I can do to
> troubleshoot?

That's very likely because unlike traditional single-device filesystems 
(including single-device btrfs), multi-device btrfs has multiple devices 
it must know about before it can mount the device, while mount only feeds 
it one device.

There are two ways to tell btrfs (the kernel side) about the other 
devices.

1) Do a btrfs device scan before trying to mount.

2) Name the component devices in the mount options, using the device= 
option (multiple times as necessary to list all devices).

For various reasons including dynamic device discovery effectively 
randomizing device sd* assignment, btrfs device scan is the normally used 
option.

What's probably happening is that at some point in the boot process, 
btrfs device scan is being automatically run, but it's after the attempt 
to mount the filesystem during boot, so the boot attempt to mount fails, 
but doing a manual mount succeeds, because the scan has already been done 
by the time you get a prompt in ordered to run the command.

So what you need to do is find the service that runs the btrfs device 
scan, and make the mount depend on it, so the scan is done before the 
attempt to mount.  Then it should work.

Or if it's easier, simply create a new service that runs the scan, and 
have it run before the mount, since rerunning the scan twice won't hurt 
anything, it simply needs to run before the mount is attempted in ordered 
for btrfs to know what devices compose the filesystem, so it can be 
mounted.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

