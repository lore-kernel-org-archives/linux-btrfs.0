Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34332 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3G0WOV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jul 2013 18:14:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V3Ckm-0005W7-FT
	for linux-btrfs@vger.kernel.org; Sun, 28 Jul 2013 00:14:20 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jul 2013 00:14:20 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jul 2013 00:14:20 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Mount multiple-device-filesystem by UUID
Date: Sat, 27 Jul 2013 22:14:02 +0000 (UTC)
Message-ID: <pan$b873b$34bc7363$e7fad079$c205b803@cox.net>
References: <51F41660.1070405@friedels.name> <51F41702.2000508@friedels.name
	> <20130727194448.GO20517@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Sat, 27 Jul 2013 20:44:48 +0100 as excerpted:

> On Sat, Jul 27, 2013 at 08:52:50PM +0200, Hendrik Friedel wrote:
>> As stated in the wiki, multiple-device filesystems (e.g. raid 1) will
>> only mount after a btfs device scan, or if all devices are passed with
>> the mount options.
>> 
>> I remember, that for Ubuntu 12.04 I changed the initrd. But after a
>> re-install, I have to do this again, and I don't remember how I did it.
> 
>    With Ubuntu, just install the btrfs-tools package. It should modify
> the initrd correctly.
> 
>> So, the other option would be passing the devices in the fstab. But
>> here, I'd prefer UUIDs rather than device names, as they can change.
> 
>    This is why we don't recommend using device= mount flags.
> 
>> Is this possible? What is the syntax?
> 
>    I don't believe it is possible. Finding filesystems by UUID is (I
> think) a userspace-based thing, so you'd have to have an initrd anyway.

btrfs raid1 root here, was initr*less until I switched to btrfs which is 
broken with direct-kernel-root-mount rootflags=device=whatever syntax.

UUIDs are indeed userspace -- udev/systemd.  However, if your initr* 
includes udev, at least here, it "just works".

I use root=LABEL=whatever here on the kernel commandline for root, and 
LABEL=whatever for non-root in fstab, but as long as udev has the 
directory in /dev/disk/*, mount should work with it, so root=UUID=whatever 
at the kernel commandline should work, as should UUID=whatever in fstab 
as the first field.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

