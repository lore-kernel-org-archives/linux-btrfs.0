Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38929 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab3JZJtY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 05:49:24 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Va0Ul-000409-OC
	for linux-btrfs@vger.kernel.org; Sat, 26 Oct 2013 11:49:23 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 11:49:23 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 11:49:23 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs raid0 unable to mount
Date: Sat, 26 Oct 2013 09:49:03 +0000 (UTC)
Message-ID: <pan$53d4e$6f3d04d0$63788433$7d4787d@cox.net>
References: <CAC+R54CyxJXTZ=8va-30_0XDA9iNRr67mz=pT3MxysaCR+DFyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

lilofile posted on Sat, 26 Oct 2013 12:19:16 +0800 as excerpted:

> when I use two disk to create raid0 in btrfs, after rebooting system,one
> disk unable to mount ,
> error is as follows:
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>        missing codepage or helper program, or other error In some cases
>        useful info is found in syslog - try dmesg | tail  or so
> 
> in /var/log/kern.log
> 
>  kernel: [  480.962487] btrfs: failed to read the system array on md0
>  kernel: [  480.988400] btrfs: open_ctree failed

You left more questions than you provided answers.  Among them...

So you're using md/raid to create the raid0, not btrfs raid0 mode, or did 
you mean that you created a btrfs raid0 mode filesystem on top of one or 
more md/raid devices?

Did you assemble the mdraid before trying to mount and were there any 
errors or interesting messages related to that?

With what options did you create the btrfs on the md device?  Was the 
btrfs a multi-device filesystem on top of the mdraid as well, or just the 
single md0 device?  If a multi-device btrfs, what modes were data/
metadata, and among how many devices?  Were they all different md/raid 
devices, or...?

And why did you create an mdraid instead of using pure btrfs raid modes?  
(Not that there aren't reasons to do so.  md/raid 5/6 should be far more 
reliable than the still incomplete btrfs raid56 mode, for instance, so if 
you were doing raid5/6, that'd be a reason.)

Meanwhile, if the btrfs was indeed a multi-device filesystem, not simply 
built on top of a single md/raid device, it's worth noting that the 
kernel needs to know which devices to create the multi-device btrfs out 
of.  Normally, that's done with a btrfs device scan before the attempt to 
mount (in an initr* if the btrfs is system root), but individual 
device=/dev/whatever options can be passed to mount instead, if running 
btrfs device scan is inconvenient for some reason.

(However, it should be noted that the usual rootflags= kernel commandline 
parameter to pass root mount options appears to be broken with the 
device= option, or at least it was a couple kernels ago when I tried it.  
I'd guess the kernel gets confused seeing two or more equals characters 
in the same commandline parameter and tries to parse it as 
rootflags=device= instead of simply rootflags=, and it rightly doesn't 
recognize the former as something it knows how to process.  Thus, at that 
point it seemed an initr* was required to mount a multi-device btrfs 
root, likely with the btrfs command in the initr* in ordered to do btrfs 
device scan, the solution I'm using here ATM, using dracut as my initr* 
generator, and I've seen no indication that said kernel commandline 
parsing bug may have been fixed yet, tho I suppose it's possible as I've 
not tested it since then, either.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

