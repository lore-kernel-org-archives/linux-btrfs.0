Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49225 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717AbbJBBL4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 1 Oct 2015 21:11:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zhot4-000434-8c
	for linux-btrfs@vger.kernel.org; Fri, 02 Oct 2015 03:11:50 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 03:11:50 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Oct 2015 03:11:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
Date: Fri, 2 Oct 2015 01:11:41 +0000 (UTC)
Message-ID: <pan$f2728$e334692e$5f76fdfc$952e182b@cox.net>
References: <1627746.fEEz2JqgZk@hoefnix>
	<pan$b6f45$856590$f682594c$bd5aae60@cox.net> <1787237.MVYq6GNlXh@hoefnix>
	<20151001174615.GK25907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Thu, 01 Oct 2015 17:46:15 +0000 as excerpted:

> On Thu, Oct 01, 2015 at 07:04:43PM +0200, Sjoerd wrote:
>> On Thursday 01 October 2015 02:21:23 Duncan wrote:
>> 
>> > That's very likely because unlike traditional single-device
>> > filesystems (including single-device btrfs), multi-device btrfs has
>> > multiple devices it must know about before it can mount the device,
>> > while mount only feeds it one device.
>> > 
>> > There are two ways to tell btrfs (the kernel side) about the other
>> > devices.
>> > 
>> > 1) Do a btrfs device scan before trying to mount.
>> > 
>> > 2) Name the component devices in the mount options, using the device=
>> > option (multiple times as necessary to list all devices).
>> > 
>> Option 2 was to simplest to check and that works. Thanks for the tip!
>> Still weird that my single devide SSD BTRFS bootdisk just worked fine
>> (althought it's using the uuid offcourse)...But it would imply to me
>> that there's a btrfs device scan run before mounting it.
> 
> Not really. A single deice FS doesn't need the scan.

Yes.

A mount command takes a single device pointer either on the commandline, 
or from fstab.  For traditional single-device filesystems, that pointer, 
whether via traditional /dev/* path, or by (udev-mediated) LABEL=, UUID=, 
etc, is all that's needed, one device, and the kernel knows what it was 
because it was supplied in that pointer.

But for non-traditional multi-device filesystems, like btrfs in multi-
device mode (as opposed to btrfs used on only a single device where the 
single device pointer works fine), a single device pointer only provides 
part of the necessary information, the kernel has to figure out what 
other devices are needed by some other method.  With btrfs, there are two 
such other methods, btrfs device scan, or supplying the other devices via 
device= mount option, with as many such device= options used as necessary 
to list all filesystem component devices.

... Which is what I was trying to explain in the earlier reply as well, 
when I specifically included the "including single-device btrfs" 
parenthetical in the traditional device class, contrasted with multi-
device btrfs, but apparently that specific bit didn't transfer.

Well, at least the practical solution, use device scan or name the 
devices in mount options, did. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

