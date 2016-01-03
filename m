Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56020 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbcACQIy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Jan 2016 11:08:54 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aFlD8-0002ha-El
	for linux-btrfs@vger.kernel.org; Sun, 03 Jan 2016 17:08:50 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 17:08:50 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Jan 2016 17:08:50 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Unrecoverable fs corruption?
Date: Sun, 3 Jan 2016 16:08:35 +0000 (UTC)
Message-ID: <pan$9d4e3$8e43ab0$7c386064$b1282bb4@cox.net>
References: <pan$775e4$fad1d9d7$a69e525a$ff4dac1a@cox.net>
	<20160102115318.4e76f773@hydra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Alexander Duscheleit posted on Sat, 02 Jan 2016 11:53:18 +0100 as
excerpted:


> I was under the impression that a mount (actually any) command issued
> against a member of a multi-device btrfs would affect the whole
> multi-device.

Well, yes and no.  Yes, when it mounts correctly.

But with a multi-device btrfs, it can happen that btrfs doesn't yet know 
about all the devices when a mount is attempted, in which case the mount 
may fail (particularly without the degraded option), simply because it 
doesn't know about the other devices.

A btrfs device scan after all devices are available but before the mount 
attempt should fix this problem and allow a mount with any of the 
component devices, and these days, udev normally triggers that when any 
new devices appear, so it seldom needs to be done manually.  However, in 
udev-free cases or in early boot before udev is up, udev obviously won't 
handle it and the mount can still fail.

Additionally, if a device is missing or damaged to the point that btrfs 
can't see it, btrfs will normally refuse a mount unless degraded is one 
of the mount options.  And depending on the situation, degraded,ro may be 
needed.  While you mentioned below this part in your reply that you had 
tried degraded,ro, that wasn't in your original post, so we wanted the 
mount options you had actually tried, to see if you had tried degraded,ro, 
or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

