Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:58759 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab2FTNec (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 09:34:32 -0400
Date: Wed, 20 Jun 2012 09:34:29 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Subvolumes and /proc/self/mountinfo
Message-ID: <20120620133429.GD4102@shiny>
References: <4FDFCA43.2070407@zytor.com>
 <20120619234919.GA4102@shiny>
 <4FE11365.3010802@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FE11365.3010802@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 19, 2012 at 06:03:49PM -0600, H. Peter Anvin wrote:
> On 06/19/2012 04:49 PM, Chris Mason wrote:
> > On Mon, Jun 18, 2012 at 06:39:31PM -0600, H. Peter Anvin wrote:
> >> I'm trying to figure out an algorithm from taking an arbitrary mounted
> >> btrfs directory and break it down into:
> >>
> >> <device(s), subvolume, subpath>
> >>
> >> where, keep in mind, <subpath> may not actually be part of the mount.
> > 
> > Do you want an API for this, or is it enough to wander through /dev/disk
> > style symlinks?
> > 
> > The big reason it isn't here yet is because Kay had this neat patch to
> > blkid and udev to just put all the info you need into /dev/btrfs (or
> > some other suitable location).  It would allow you to see which devices
> > belong to which filesystems etc.
> > 
> 
> I want an algorithm, it doesn't have an API per se.  I would really like
> to avoid relying on blkid and udev for this, though... that is pretty
> much a nonstarter.
> 
> If the answer is to walk the tree then I'm fine with that.

Ok, fair enough.

> 
> > subvolumes may become disconnected from the root namespace.  In this
> > case we can find it just by the subvol id, and mount it into an
> > arbitrary directory.
> 
> OK, so it sounds like the best thing is actually to record the subvolume
> *number* (ID) where (in my case) Syslinux is installed. This is actually
> a good thing because the fewer O(n) strings I have to stick into the
> boot block the better.

Right, the subvolume number doesn't change over the life of the subvol,
regardless of the path that was used for mounting the subvol.  So all
you need is that number (64 bits) and the filename relative to the
subvol root and you're set.

We'll have to add an ioctl for that.

Finding the path relative to the subvol is easy, just walk backwards up
the directory chain (cd ..) until you get to inode number 256.  All the
subvol roots have inode number 256.

> 
> >> b. Are there better ways (walking the tree using BTRFS_IOC_TREE_SEARCH?)
> >> to accomplish this than using /proc/self/mountinfo?
> > 
> > Not yet, but I'm definitely open to adding them.  Lets just hash out
> > what you need and we'll either go through Kay's stuff or add ioctls for
> > you.
> 
> Well, I'd be interested in what Kay's stuff actually does.  Other than
> that, I would suggest adding a pair of ioctls that when executed on an
> arbitrary btrfs inode returns the corresponding subvolume and one which
> returns the path relative to the subvolume root.

udev already scans block devices as they appear.  When it finds btrfs,
it calls the btrfs dev scan ioctl for that one device.  It also reads in
the FS uuid and the device uuid and puts them into a tree.

Very simple stuff, but it gets rid of the need to manually call btrfs
dev scan yourself.

-chris
