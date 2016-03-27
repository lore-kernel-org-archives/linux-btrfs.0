Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58071 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbcC0Bjw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 21:39:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ajzgD-0000nY-MH
	for linux-btrfs@vger.kernel.org; Sun, 27 Mar 2016 03:39:49 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 03:39:49 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 03:39:49 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Sun, 27 Mar 2016 03:30:32 +0200
Message-ID: <20160327033032.6dce42e0@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<CAJCQCtSzKT2BZ15JwgR4b6Nk+n2tsHBLizwJXOqJ93Jbuv05rQ@mail.gmail.com>
	<CAJCQCtQYkCDLks0Wvnt2nqTRMAvh6wQ5nsHB4GPD4wFA8geAsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 26 Mar 2016 15:04:13 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> On Sat, Mar 26, 2016 at 2:28 PM, Chris Murphy
> <lists@colorremedies.com> wrote:
> > On Sat, Mar 26, 2016 at 1:30 PM, Kai Krakow <hurikhan77@gmail.com>
> > wrote: 
> >> Well, this time it hit me on the USB backup drive which uses no
> >> bcache and no other fancy options except compress-force=zlib.
> >> Apparently, I've only got a (real) screenshot which I'm going to
> >> link here:
> >>
> >> https://www.dropbox.com/s/9qbc7np23y8lrii/IMG_20160326_200033.jpg?dl=0  
> >
> > This is a curious screen shot. It's a dracut pre-mount shell, so
> > nothing should be mounted yet. And btrfs check only works on an
> > unmounted file system. And yet the bottom part of the trace shows a
> > Btrfs volume being made read only, as if it was mounted read write
> > and is still mounted. Huh?  
> 
> Wait. You said no bcache, and yet in this screen shot it shows 'btrfs
> check /dev/bcache2 ...' right before the back trace.
> 
> This thread is confusing. You're talking about two different btrfs
> volumes intermixed, one uses bcache the other doesn't, yet they both
> have corruption. I think it's hardware related: bad cable bad ram bad
> power, something.

No it's not, it's tested. That system ran rock stable until somewhere
in the 4.4 kernel series (probably). It ran high loads without problems
(loadavg >50), it ran huge IO copies concurrently without problems, it
survived unintentional reboots without FS corruption, it ran
VirtualBox VMs without problems. And the system still runs almost
without problems: Except for the "object already exists" which forced
my rootfs RO, I did not even take note that the FS has corruptions:
Nothing in dmesg, everything fine. There's just VirtualBox crashing a
VM now, and I see csum errors in that very VDI file - even after
recovering the file from backup, it happens again and again. Qu
mentioned that this may be a follow-up of other corruption - and tada:
Yes, there are lots of them now (my last check was back in 4.1 or 4.2
series). But because I still can rsync all my important files, I'd like
to get my backup drive in sane state again first.

Both filesystems on this PC show similar corruption now - but they are
connected to completely different buses (SATA3 bcache + 3x SATA2
backing store bache{0,1,2}, and USB3 without bcache = sde), use
different compression (compress=lzo vs. compress-force=zlib), but
similar redundancy scheme (draid=0,mraid=1 vs. draid=single,mraid=dup).
A hardware problem would induce completely random errors on these
pathes.

Completely different hardware shows similar problems - but that system
is currently not available to me, and will stay there for a while
(it's a non-production installation at my workplace). Why would similar
errors show up here, if it'd be a hardware error of the first system?

Meanwhile, I conclude we can rule out bcache or hardware - three file
systems show similar errors:

1. bcache on Crucial MX100 SATA3, 3x SATA2 backing HDD
2. bcache on Samsung Evo 850 SATA2, 1x SATA1 backing HDD
3. 1x plain USB3 btrfs (no bcache)

Not even the SSD hardware is in common, just system configuration in
general (Gentoo kernel, rootfs on btrfs) and workload (I do lot's of
similar things on both machines).

I need to grab the errors for machine setup 2 - tho I can't do that
currently, that system is offline and will be for a while.

-- 
Regards,
Kai

Replies to list-only preferred.

