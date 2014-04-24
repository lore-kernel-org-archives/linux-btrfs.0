Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50807 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaDXTbS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 15:31:18 -0400
Date: Thu, 24 Apr 2014 12:31:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Message-ID: <20140424193117.GQ26949@merlins.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org> <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 09:51:30PM +0300, Пламен Петров wrote:
> So, here is what I did:
> My debug VM had:
> sda
> 	sda1 200 MB /boot - ext2
> 	sda2 5 GB / - BTRFS
> 	sda3 5 GB / - XFS
> 	sda4 One extra partition used for mangling (XFS).
> 
> sda2 and sda3 were mostly the same, except /etc/fstab, for obvious reasons.
> 
> I booted 3.14.1 using sda3 as root, and then tried mounting sda2. It went OK, here is what dmesg said:
> [   12.412465] Btrfs loaded
> [   86.490078] BTRFS: device fsid 2ba08fbc-4b95-46cc-b638-299f16462620 devid 1 transid 22 /dev/sda2
> [   86.492947] BTRFS info (device sda2): disk space caching is enabled
> [   86.579155] BTRFS: creating UUID tree
> [   86.748681] mount (1899) used greatest stack depth: 2560 bytes left

Ok, that's good news. It indeed rules out that your new kernel cannot mount
an older btrfs filesystem.

At this point, you may have a problem with the device not being available
when btrfs tries to mount it.
 
> From the above - the first obvious thing is that with 3.13.11 BTRFS gets loaded much earlier in the boot process - that is why the second dmesg dump is much larger, and both start at " Btrfs loaded" - mind you.
> 
> Next was booting the BTRFS sda2 with 3.14.1.
> Sadly, it panicked again. So, no dmesg dump - just a screenshot. See the attached file.
> So, what got changed during the 3.14 merge window, that messed up booting for BTRFS partitions?
> Should I try building an "allyesconfig" kernel, in case something is messed up with my kernel .configs?
> What do you think guys and galls?
> Anything you want me try  - this is entirely disposable VM now, so I'll gladly try everything you ask...

So, I'm not sure how many people use btrfs built it vs as a module. Clearly
the code works for mounting your partition, but when built in the kernel,
there seems to be a timing issue.

For reference, you said this was the bug where you found the CL that causes
this change:
https://bugzilla.kernel.org/show_bug.cgi?id=74261

You said using rootwait as recommended by Chris Mason did not help.

What output are you getting when you use this?

By the way, you should be able to define a pseudo serial port in your VM and
specify something like
console=tty0 console=ttyS0,38400n8
on your boot command line.
This will give you serial console output in text that you can cut/paste/diff

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
