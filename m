Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56321 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787Ab3IYGiz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Sep 2013 02:38:55 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VOikQ-0005bJ-2f
	for linux-btrfs@vger.kernel.org; Wed, 25 Sep 2013 08:38:54 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 08:38:54 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Sep 2013 08:38:54 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: balance induced csum errors, systemd-journal
Date: Wed, 25 Sep 2013 06:38:34 +0000 (UTC)
Message-ID: <pan$91f96$7364eee7$ad78a549$c1cff0ef@cox.net>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com>
	<1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
	<F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
	<795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Tue, 24 Sep 2013 22:34:20 -0600 as excerpted:

> However, even after deleting all corrupt journal files, and a subsequent
> scrub reporting no errors, on each reboot (and mount of the filesystem)
> I get:
> 
> [    3.646448] btrfs: bdev /dev/sda6 errs: wr 0, rd 0, flush 0, corrupt
> 17, gen 0
> 
> So somehow the corrupt counter isn't being reset?

AFAIK, it's deliberate that errors aren't reset automatically so there's 
some historical record and it's possible to see if they start to 
accumulate.

But there is of course a manual reset available, should a sysadmin wish 
to use it...  <quick lookup, quoting the commandline help output> ...

btrfs device stats [-z] <path>|<device>

Show current device IO stats.  -z to reset stats afterwards.

What the (brief) help output doesn't say but the (longer) manpage does... 
for multi-device filesystems <path> will list (and zero with -z) stats 
for all devices (listing one device's stats after another) composing the 
filesystem, <device> will list/zero them for just that single component 
device.

The -r does reset things here.

(FWIW I have a device that's occasionally slow enough to stabilize on 
power-up, that at least with 3.11, btrfs would occasionally drop it on 
resume after a suspend, forcing a hard reboot soon after, with resulting 
corruption.  Fortunately I'm running raid1 mode both data/metadata, and a 
scrub has always fixed things as verified by a further scrub and balance, 
but the stats errors of course stuck around until I did a -r/reset.  So I 
have personal knowledge of this one.  But with last nite's 3.12-rc2 git 
kernel pull and build I changed the kernel commandline option I was using 
from rootdelay=N to rootwait, and between that and the btrfs fixes in 
3.12, I'm hoping I won't see that problem again.  I guess I'll find out 
over the coming couple weeks or so, at which I'll declare the issue gone 
if I've not seen it again.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

