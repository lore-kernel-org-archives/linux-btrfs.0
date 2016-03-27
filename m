Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57218 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbcC0BBW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Mar 2016 21:01:22 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ajz4w-00079Y-BB
	for linux-btrfs@vger.kernel.org; Sun, 27 Mar 2016 03:01:18 +0200
Received: from ip5f5ae008.dynamic.kabel-deutschland.de ([95.90.224.8])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 03:01:18 +0200
Received: from hurikhan77 by ip5f5ae008.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 27 Mar 2016 03:01:18 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum errors in VirtualBox VDI files
Date: Sun, 27 Mar 2016 03:01:12 +0200
Message-ID: <20160327030112.6e737a2b@jupiter.sol.kaishome.de>
References: <20160322090342.595fefac@jupiter.sol.kaishome.de>
	<56F1068E.6050806@cn.fujitsu.com>
	<20160322194854.161e9c4c@jupiter.sol.kaishome.de>
	<56F21898.3020101@cn.fujitsu.com>
	<20160326203035.4b876a04@jupiter.sol.kaishome.de>
	<CAJCQCtSzKT2BZ15JwgR4b6Nk+n2tsHBLizwJXOqJ93Jbuv05rQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 26 Mar 2016 14:28:22 -0600
schrieb Chris Murphy <lists@colorremedies.com>:

> On Sat, Mar 26, 2016 at 1:30 PM, Kai Krakow <hurikhan77@gmail.com>
> wrote:
> 
> > Well, this time it hit me on the USB backup drive which uses no
> > bcache and no other fancy options except compress-force=zlib.
> > Apparently, I've only got a (real) screenshot which I'm going to
> > link here:
> >
> > https://www.dropbox.com/s/9qbc7np23y8lrii/IMG_20160326_200033.jpg?dl=0  
> 
> This is a curious screen shot. It's a dracut pre-mount shell, so
> nothing should be mounted yet. And btrfs check only works on an
> unmounted file system. And yet the bottom part of the trace shows a
> Btrfs volume being made read only, as if it was mounted read write and
> is still mounted. Huh?

It's a pre-mount shell because I wanted to check the rootfs from there.
I mounted it once (and unmounted) before checking (that's
bcache{0,1,2}). Yeah, you can get there forcibly by using
rd.break=pre-mount - and yeah, nothing "should" be mounted unless I did
so previously. But I cut that away as it contained unrelated errors to
this problem and would be even more confusing.

The file system that failed then was the one I just mounted to put the
stdout of btrfsck on (sde1). That one showed these (screenshot) kernel
console logs just in the middle of typing the command - so a few
seconds after mounting.

What may be consusing to you: I use more than one btrfs. ;-)

bcache{0,1,2} = my rootfs (plus subvolumes)
sde = my USB3 backup drive (or whatever the kernel assigns)

Both run btrfs. The bcache*'s have their own problems currently, I'd
like to set those aside first and get the backup drive back in good
shape. The latter seems easier to fix.

-- 
Regards,
Kai

Replies to list-only preferred.

