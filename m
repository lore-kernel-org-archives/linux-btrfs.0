Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50940 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbbL1BAj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 20:00:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aDMAu-0006Ej-2Q
	for linux-btrfs@vger.kernel.org; Mon, 28 Dec 2015 02:00:36 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 02:00:36 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Dec 2015 02:00:36 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: How to change BTRFS filesystem UUID
Date: Mon, 28 Dec 2015 01:00:31 +0000 (UTC)
Message-ID: <pan$8bf16$985344aa$92227c0d$35b2d9fb@cox.net>
References: <567FF63E.3010106@ganomi.com>
	<20151227144535.GJ1586@carfax.org.uk> <5680034D.7030509@ganomi.com>
	<1451257299.6320.3.camel@scientia.net>
	<20151227231303.GL1586@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sun, 27 Dec 2015 23:13:03 +0000 as excerpted:

> On Mon, Dec 28, 2015 at 12:01:39AM +0100, Christoph Anton Mitterer
> wrote:
>> On Mon, 2015-12-28 at 02:27 +1100, Jiri Kanicky wrote:
>> > Thanks for the reply. Looks like I will have o use some newer distro.
>> As it was already said... btrfs may even corrupt your filesystem if
>> colliding UUIDs are "seen".
>> 
>> At least to me it's currently unclear what "seen" exactly means...
>> actually trying a mount, or already when just a device with colliding
>> IDs appear.
> 
>    The damage happens on (or after) mount. Until that point there's no
> danger.
> 
>    The OS (usually udev) will run btfs dev scan when a new block
> device is detected, and it tells the kernel that there's a btrfs
> filesystem with a particular UUID on a particular block device.
> 
>    The kernel uses this information to decide which devices to include
> when it assembles a filesystem. If you have two devices where there
> should be only one (particularly if the data on the two was similar but
> has now diverged), then the kernel can end up writing to one or other
> device arbitrarily, possibly having read state from the other one, and
> things screw up rather fast.

This.  (Mostly repeating the above in different words to I'd like 
knowledgeable confirmation on activator 2 below, which is my own.  This 
sort of other-words repetition can help in reinforcing or understanding 
the concepts for some readers, while simply being annoying for others.  
YMMV.)

Two major triggers and an activator.

Triggers:

1) Btrfs device scan is the primary trigger.  Without this, btrfs will 
only know about either the device fed to it the mount command itself, or 
the devices listed in fstab, either in the device field, or as device= 
options.

2) The secondary trigger is often udev, which will normally run btrfs 
device scan automatically (due to udev rules often dropped into place by 
the btrfs-progs package, tho they may be included in the udev package 
itself or generic udev-rules packages in some distros), when the device 
is detected.

As a result of this secondary trigger, the btrfs will often know about 
the device at boot or as soon as it is attached, and it then becomes 
unsafe to have that UUID mounted.  This is where the "seen" comes in, 
with an assumption that a filesystem using that UUID is already mounted, 
and may be damaged as soon as udev triggers btrfs device scan and btrfs 
learns about the newly added device with the same filesystem UUID.

Activator(s):

1) Mount is the usual and primary activator.  Under normal circumstances, 
despite the triggers above if a btrfs with that UUID isn't mounted, no 
damage occurs as btrfs won't be writing to any of the devices containing 
a filesystem with that UUID.

2) Unsure on this one but I _believe_ various other btrfs userspace 
(btrfs-progs) commands that write to the unmounted filesystem either use 
the data provided by btrfs device scan or otherwise do similar scans as 
well.  In particular, btrfs check with --repair or --init-* will have to 
know about the multiple devices in the filesystem to properly do its 
work.  How it actually gets the list of devices is, however, unclear to 
me, tho my own experience with it seems to indicate that it's unnecessary 
to feed all the devices on the commandline and indeed, the manpage shows 
a single device, with no indication that feeding multiple devices on the 
commandline is even supported.  However, these sorts of commands only 
tend to be run very deliberately and under very specific circumstances, 
and thus are unlikely to be run when one is working with multiple images 
of a device that shouldn't be combined into the same filesystem.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

