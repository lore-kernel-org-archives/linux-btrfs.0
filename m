Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:60204 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834AbbJCUxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Oct 2015 16:53:48 -0400
Received: from guidonb ([91.45.89.230]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LcnRD-1aSa8z2VLb-00k6ds for
 <linux-btrfs@vger.kernel.org>; Sat, 03 Oct 2015 22:53:46 +0200
From: <guido_kuenne@gmx.de>
To: <linux-btrfs@vger.kernel.org>
References: <1627746.fEEz2JqgZk@hoefnix>	<pan$b6f45$856590$f682594c$bd5aae60@cox.net> <1787237.MVYq6GNlXh@hoefnix>	<20151001174615.GK25907@carfax.org.uk> <pan$f2728$e334692e$5f76fdfc$952e182b@cox.net>
In-Reply-To: <pan$f2728$e334692e$5f76fdfc$952e182b@cox.net>
Subject: RE: RAID5 doesn't mount on boot, but you can afterwards?
Date: Sat, 3 Oct 2015 22:53:46 +0200
Message-ID: <003401d0fe1d$999b41a0$ccd1c4e0$@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Duncan
> Sent: Friday, October 02, 2015 3:12 AM
> To: linux-btrfs@vger.kernel.org
> Subject: Re: RAID5 doesn't mount on boot, but you can afterwards?
> 
> Hugo Mills posted on Thu, 01 Oct 2015 17:46:15 +0000 as excerpted:
> 
> > On Thu, Oct 01, 2015 at 07:04:43PM +0200, Sjoerd wrote:
> >> On Thursday 01 October 2015 02:21:23 Duncan wrote:
> >>
> >> > That's very likely because unlike traditional single-device
> >> > filesystems (including single-device btrfs), multi-device btrfs has
> >> > multiple devices it must know about before it can mount the device,
> >> > while mount only feeds it one device.
> >> >
> >> > There are two ways to tell btrfs (the kernel side) about the other
> >> > devices.
> >> >
> >> > 1) Do a btrfs device scan before trying to mount.
> >> >
> >> > 2) Name the component devices in the mount options, using the
> >> > device= option (multiple times as necessary to list all devices).
> >> >
> >> Option 2 was to simplest to check and that works. Thanks for the tip!
> >> Still weird that my single devide SSD BTRFS bootdisk just worked fine
> >> (althought it's using the uuid offcourse)...But it would imply to me
> >> that there's a btrfs device scan run before mounting it.
> >
> > Not really. A single deice FS doesn't need the scan.
> 
> Yes.
> 
> A mount command takes a single device pointer either on the
> commandline, or from fstab.  For traditional single-device filesystems, that
> pointer, whether via traditional /dev/* path, or by (udev-mediated) LABEL=,
> UUID=, etc, is all that's needed, one device, and the kernel knows what it
> was because it was supplied in that pointer.
> 
> But for non-traditional multi-device filesystems, like btrfs in multi- device
> mode (as opposed to btrfs used on only a single device where the single
> device pointer works fine), a single device pointer only provides part of the
> necessary information, the kernel has to figure out what other devices are
> needed by some other method.  With btrfs, there are two such other
> methods, btrfs device scan, or supplying the other devices via device=
> mount option, with as many such device= options used as necessary to list
> all filesystem component devices.
> 
> ... Which is what I was trying to explain in the earlier reply as well, when I
> specifically included the "including single-device btrfs"
> parenthetical in the traditional device class, contrasted with multi- device
> btrfs, but apparently that specific bit didn't transfer.
> 
> Well, at least the practical solution, use device scan or name the devices in
> mount options, did. =:^)
> 
Beginner here, so just if it helps: My two-device raid 1 mounts on boot in Fedora 22 (uuid in fstab, no further devices specified) but I mount the fs via uuid while Sjoerd mounted subvolumes. From what I understand (not much) it's either an subvolume issue or Fedora must then somehow perform a device scan before handling fstab. 

