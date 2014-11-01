Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53641 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbaKAHi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 1 Nov 2014 03:38:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XkTGV-0001bh-Ha
	for linux-btrfs@vger.kernel.org; Sat, 01 Nov 2014 08:38:27 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 08:38:27 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Nov 2014 08:38:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: which subvolume is mounted?
Date: Sat, 1 Nov 2014 07:38:15 +0000 (UTC)
Message-ID: <pan$e3eb3$610d2ef0$6cd17483$51ecd2b4@cox.net>
References: <CFAACED5-055D-4586-A474-CA610881F367@storix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Turner posted on Fri, 31 Oct 2014 09:23:27 -0700 as excerpted:

> let’s first assume the contents of /etc/fstab are either not used or
> invalid in mounting the subvolumes. given the following ‘df’ command,
> how do i know which subvolume of the btrfs filesystem on /dev/sda3 is
> mounted at each mount point (/, /var, /opt, /home)? i would have
> expected to see the mount option used to define the subvolume (subvolid
> or subvol option) in /proc/mounts.

> # uname -a
> Linux turner11.storix 3.10.0-123.el7.x86_64 #1 SMP
> Mon May 5 11:16:57 EDT 2014 x86_64 x86_64 x86_64 GNU/Linux
> 
> # btrfs --version
> Btrfs v3.12

Your versions of both the kernel (3.10) and userspace (3.12) are quite 
dated.  Your question was a known issue back then, with related fixes for 
it in kernel 3.17.  Unfortunately, there were a few bugs with the fixes 
that hit particular corner-cases, but most or all of them have now been 
worked out and 3.17.2+ along with 3.18-rc2+ should be much better.  
Another option would be the 3.16 stable series, now announced as a long-
term-stable with Ubuntu continuing support for it beyond Greg KH's last 
regular stable release, which just occurred.  However, I'm not sure if 
the 3.16 stable series will get those fixes or not, as they may not be 
considered proper stable-series candidates.

In general, while btrfs is no longer considered entirely unstable and the 
former warnings have been stripped now, the 3.10 kernel and 3.12 
userspace were before that happened and mkfs.btrfs among other things 
should warn you about the risks of running the not yet stable code.

But even beyond that, while not as unstable as it was, btrfs is still not 
entirely stable either, and keeping reasonably current is strongly 
recommended, because older kernels in particular tend to have known bugs 
and lacking features such as this one, and stable series backports won't 
take care of all of them like keeping current will.  Userspace isn't 
as critical in normal runtime as for the most part it simply forwards 
instructions to the kernel, but if there's a problem and you end up 
running tools such as btrfs check (aka btrfsck) and btrfs restore (iirc 
the separate btrfs-restore tool back in 3.12), then a current userspace 
is critical as well, because then it's userspace that's actually doing 
the work and is thus bug-critical.

So while you may not want to run absolute newest code, the mainline 
development kernel rcs, for instance, or the very latest stable kernel 
early in its stable series (until 3.x.2 or so), subscribing to this list 
and keeping up with current bugs so you know when for instance the bugs 
in all of 3.15 and early 3.16, as well as in early 3.17 occur and when 
they are fixed, is recommended, as is running something approaching 
current.  People staying a kernel series behind, say on 3.14 until 3.16's 
release, would have known to avoid 3.15 by the time they would have 
upgraded to it.  Similarly, once that bug was fixed for 3.16.2, people 
staying on 3.16 thru the early 3.17 series would have been spared the 
early bugs there and could upgrade to 3.17.2 now, knowing that the early 
3.17 bug was there, and later, knowing that it was fixed for 3.17.2, 
because they follow this list.

Or if you're conservative, stay with the latest long-term-stable, which 
was 3.14, with 3.16 just announced as a long-term-stable sponsored by 
Ubuntu.

If you're more conservative than that and don't want to update from your 
3.10 series, then why are you on the still not entirely mature btrfs in 
the first place?  In that case, a more mature filesystem such as ext4 or 
xfs (or my personal choice, reiserfs, which has done well by me even thru 
various hardware issues, since data=ordered became the default in 2.4.16 
or some such) would be a more appropriate match for your kernel 
conservatism.

As for userspace, as I said it's not quite so vital, but you do want to 
keep at least /semi/-current.  3.14.2 would be the earliest I'd recommend 
there, with 3.16.1 and now 3.17 out as well.

Meanwhile, like I said above, a current kernel and userspace should be a 
bit better about what they report, tho btrfs is still evolving a bit in 
that area.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

