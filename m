Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:51963 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005Ab2FSXtW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 19:49:22 -0400
Date: Tue, 19 Jun 2012 19:49:19 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Subvolumes and /proc/self/mountinfo
Message-ID: <20120619234919.GA4102@shiny>
References: <4FDFCA43.2070407@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FDFCA43.2070407@zytor.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2012 at 06:39:31PM -0600, H. Peter Anvin wrote:
> I'm trying to figure out an algorithm from taking an arbitrary mounted
> btrfs directory and break it down into:
> 
> <device(s), subvolume, subpath>
> 
> where, keep in mind, <subpath> may not actually be part of the mount.

Do you want an API for this, or is it enough to wander through /dev/disk
style symlinks?

The big reason it isn't here yet is because Kay had this neat patch to
blkid and udev to just put all the info you need into /dev/btrfs (or
some other suitable location).  It would allow you to see which devices
belong to which filesystems etc.

> 
> /proc/self/mountinfo seems to have some of that information, however, it
> does not appear to distinguish between non-default subvolumes and
> directories.  At the same time, once I have mounted a subvolume I see
> its name in the root btrfs directory even if I didn't access it.
> 
> Questions, thus:
> 
> a. Are subvolumes always part of the "root" namespace?  If so, is it the
> mounted root, the default subvolume, or subvolume 0 which always exposes
> these other subvolumes?  Are there disambiguation rules so that if I
> have /btrfs/root/blah and "blah" is both a subvolume and a directory (I
> presume that can happen?)

subvolumes may become disconnected from the root namespace.  In this
case we can find it just by the subvol id, and mount it into an
arbitrary directory.

> 
> b. Are there better ways (walking the tree using BTRFS_IOC_TREE_SEARCH?)
> to accomplish this than using /proc/self/mountinfo?

Not yet, but I'm definitely open to adding them.  Lets just hash out
what you need and we'll either go through Kay's stuff or add ioctls for
you.

-chris
