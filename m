Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:35667 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751177AbaDXU1J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 16:27:09 -0400
From: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org> <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info> <20140424193117.GQ26949@merlins.org>
In-Reply-To: <20140424193117.GQ26949@merlins.org>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Thu, 24 Apr 2014 23:26:48 +0300
Message-ID: <000001cf5ffb$84da9020$8e8fb060$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Marc MERLIN [mailto:marc@merlins.org]
> Sent: Thursday, April 24, 2014 10:31 PM
> To: Пламен Петров
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
> newer?
> 
> On Thu, Apr 24, 2014 at 09:51:30PM +0300, Пламен Петров wrote:
> > So, here is what I did:
> > My debug VM had:
> > sda
> > 	sda1 200 MB /boot - ext2
> > 	sda2 5 GB / - BTRFS
> > 	sda3 5 GB / - XFS
> > 	sda4 One extra partition used for mangling (XFS).
> >
> > sda2 and sda3 were mostly the same, except /etc/fstab, for obvious
> reasons.
> >
> > I booted 3.14.1 using sda3 as root, and then tried mounting sda2. It went
> OK, here is what dmesg said:
> > [   12.412465] Btrfs loaded
> > [   86.490078] BTRFS: device fsid 2ba08fbc-4b95-46cc-b638-299f16462620
> devid 1 transid 22 /dev/sda2
> > [   86.492947] BTRFS info (device sda2): disk space caching is enabled
> > [   86.579155] BTRFS: creating UUID tree
> > [   86.748681] mount (1899) used greatest stack depth: 2560 bytes left
> 
> Ok, that's good news. It indeed rules out that your new kernel cannot mount
> an older btrfs filesystem.
> 
> At this point, you may have a problem with the device not being available
> when btrfs tries to mount it.

Need a way to pinpoint the actual problem then.

> 
> > From the above - the first obvious thing is that with 3.13.11 BTRFS gets
> loaded much earlier in the boot process - that is why the second dmesg
> dump is much larger, and both start at " Btrfs loaded" - mind you.
> >
> > Next was booting the BTRFS sda2 with 3.14.1.
> > Sadly, it panicked again. So, no dmesg dump - just a screenshot. See the
> attached file.
> > So, what got changed during the 3.14 merge window, that messed up
> booting for BTRFS partitions?
> > Should I try building an "allyesconfig" kernel, in case something is messed
> up with my kernel .configs?
> > What do you think guys and galls?
> > Anything you want me try  - this is entirely disposable VM now, so I'll gladly
> try everything you ask...
> 
> So, I'm not sure how many people use btrfs built it vs as a module. Clearly the
> code works for mounting your partition, but when built in the kernel, there
> seems to be a timing issue.

Yeah, and an issue that just popped up with kernels >= 3.14. If memory serves - I started using BTRFS on linux 3.6.x, and since then I followed exactly the same method of upgrading the kernel - described in this thread and in the bugzilla entry - and it always "Just Works" TM!

> 
> For reference, you said this was the bug where you found the CL that causes
> this change:
> https://bugzilla.kernel.org/show_bug.cgi?id=74261
> 
> You said using rootwait as recommended by Chris Mason did not help.
> 
> What output are you getting when you use this?

The image file attached to my previous mail applies to both rootwait and no-rootwait cases. Result is always a kernel panic for 3.14.x on BTRFS root. All other filesystem/kernel combos just work either way.

> 
> By the way, you should be able to define a pseudo serial port in your VM and
> specify something like
> console=tty0 console=ttyS0,38400n8
> on your boot command line.
> This will give you serial console output in text that you can cut/paste/diff

I will try and use this the next time.
Thanks!
---------------------------------
Plamen Petrov


