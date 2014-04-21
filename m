Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42401 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751561AbaDUXoX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 19:44:23 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WcNss-0001tL-9K
	for linux-btrfs@vger.kernel.org; Tue, 22 Apr 2014 01:44:22 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 01:44:22 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Apr 2014 01:44:22 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Bug: "corrupt leaf. slot offset bad": root subvolume
 unmountable, "btrfs check" crashes
Date: Mon, 21 Apr 2014 23:44:10 +0000 (UTC)
Message-ID: <pan$8bfac$8e221e7d$ddf57415$e1995c17@cox.net>
References: <53554469.5070503@gmail.com> <53556DCC.3000108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Andreas Reis posted on Mon, 21 Apr 2014 21:13:16 +0200 as excerpted:

> Alright, turns out the partition does actually mount on 3.15-rc2 (error
> messages remain, of course).
> 
> But systemd will fail to continue booting as /bin/mount returns "exit
> status 32" and / thus ends as ro, yet can be manually remounted as rw.

The mount manpage says status 32 is mount failure.  Dmesg should contain 
more, but that's probably the errors you already mentioned.

So you're getting the read-only mount, but can't remount rw.

(This doesn't apply in your case, but FWIW, I now have my root filesystem 
setup to be ro mounted by default, and have been running that way for 
some months, now.  Seems safer that way.  The only time I remount / rw is 
when I'm updating the system or changing something in the config, then I 
normally remount ro again, altho after updating the system I normally 
have to exit and restart X and kde as well as various system services 
before I can remount ro, depending on what libraries got changed out from 
under my running processes.  Of course in ordered to make this work a 
few /var/ subdirs that need to be writable are actually symlinks to
/home/var/ subdirs, /var/log is a dedicated writable logging partition of 
its own, etc.  So a read-only rootfs is the /normal/ case for me, and 
wouldn't interfere with normal operations at all. =:^)

> Another error message I've spotted with 3.15 is
> 
> BTRFS error (device sdc5): error loading props for ino 1810424 (root
> 257): -5

That would be one of the new btrfs properties introduced in kernel 3.14.  
See btrfs property list/get/set...  Unless you've set individual file 
properties (such as compress), that's probably a property (such as ro/rw) 
on a subvolume, or possibly on the main filesystem (label, etc).

Meanwhile, "orphans" normally refer to files that are deleted while 
they're still in use.  Normally, these will be libraries, etc, replaced 
during a system upgrade, but still in use by running programs.  Once all 
such running programs have been restarted (loading the new version of the 
library) or terminated, the filesystem can be unmounted or remounted read-
only.  In the event they're not fully cleaned up at umount time, they are 
normally cleaned up after reboot, when a filesystem is first mounted 
writable once again.

Obviously there's a problem with one of these orphans, and attempts to 
clean it up are failing, causing the remount rw to fail.

While that doesn't help with fixing the problem, it should at least give 
you some idea of what's going on, and how to interpret the messages and 
errors you see.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

