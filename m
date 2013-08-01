Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33689 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab3HADLx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 23:11:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V4jIu-0006UO-PC
	for linux-btrfs@vger.kernel.org; Thu, 01 Aug 2013 05:11:52 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 05:11:52 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Aug 2013 05:11:52 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Is the checkpoint interval adjustable?
Date: Thu, 1 Aug 2013 03:11:35 +0000 (UTC)
Message-ID: <pan$a83c3$c2cdec86$d7da19c7$c1d975d2@cox.net>
References: <20130731221008.156770@gmx.com> <20130731225640.GO32145@lenny.
	home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zach Brown posted on Wed, 31 Jul 2013 15:56:40 -0700 as excerpted:

[Mike Audia wrote...]

>>  I am NO programmer by any stretch.  Let's say I want them to be once
>> every 5 min (300 sec).  Is the attached patch sane to acheive this?

>>  Are there any unforeseen and effects of doing this?

> I don't *think* that there should be.  One way of looking at it is that
> both 30 and 300 seconds are an *eternity* for cpu, memory, and storage.
> Any trouble that you could get in to in 300 seconds some other machine
> could trivially get in to in 30 with beefier hardware.

As a sysadmin (not a programmer) that has messed around with, for 
example, vm.dirty_bytes/ratio, vm.dirty_writeback_centisecs, etc, the 
concern I'd have is that longer commit periods and larger commit buffers 
increase the possibility of writeback storms.  While I've not tweaked 
btrfs and I probably need to reexamine my current settings since I've 
switched to SSD and btrfs, for spinning rust and reiserfs, I ended up 
tweaking vm.dirty_* here.

The files are /proc/sys/vm/* and the kernel documentation for them in 
Documentation/sysctl/vm.txt.  Most distros have an initscript that writes 
any custom values at boot, using values set in /etc/sysctl.conf and/or
/etc/sysctl.d/*, so that's where you'd normally set them once you've 
settled on values that work for you.

The following are the defaults and what I settled on for a wall-powered 
system.

vm.dirty_ratio defaults to 10 (percent of RAM). I've read and agree with 
opinions that 10% of RAM when RAM is say half a gig (so 10% is ~50 MB) 
isn't too bad on spinning rust, but it can be MUCH worse when RAM is say 
my current 16 gig (so 10% is ~1.6 gig), as that's several seconds of 
writeback on spinning rust.  I reset that to 3% (~half a gig), here.

vm.dirty_background_ratio similarly, 5 (% of RAM) by default, reset to 1 
(~160 MB).

(The vm.dirty_(background_)bytes knobs parallel the above "ratio" knobs 
and may be easier to set for those thinking in terms of writeback backlog 
size and corresponding system responsiveness or lack thereof during that 
writeback, instead of percentage of memory dirty.  Set one set or the 
other.)

OTOH, vm.dirty_expire_centisecs defaults to 2999 (30 seconds, this is the 
high priority foreground value and might well be the reason btrfs is 
coded for a 30 second commit time as well) and 
vm.dirty_writeback_centisecs defaults to 499 (5 seconds, this is the 
lower priority background value).  I left expire where it was, but 
decided with the stricter ratio settings, writeback could be 10 seconds, 
doubling the background writeback time.


Before tuning btrfs' hardcoded defaults, I'd suggest tuning these values 
if you haven't already done so, and keeping them in mind if you do decide 
to tune btrfs as well.

For battery powered systems, also take a look at laptop mode (and laptop-
mode-tools), which I use here on my laptop (which I don't have at hand to 
check what I set for vm.dirty_* on it).

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

