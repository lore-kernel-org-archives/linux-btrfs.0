Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51791 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2FSOWt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 10:22:49 -0400
Received: by qcro28 with SMTP id o28so3528506qcr.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 07:22:48 -0700 (PDT)
Message-ID: <1340115766.3403.19.camel@cwalton-XPS-8300>
Subject: Re: Subvolumes and /proc/self/mountinfo
From: Calvin Walton <calvin.walton@kepstin.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-btrfs@vger.kernel.org
Date: Tue, 19 Jun 2012 10:22:46 -0400
In-Reply-To: <4FDFCA43.2070407@zytor.com>
References: <4FDFCA43.2070407@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2012-06-18 at 17:39 -0700, H. Peter Anvin wrote:
> I'm trying to figure out an algorithm from taking an arbitrary mounted
> btrfs directory and break it down into:
> 
> <device(s), subvolume, subpath>
> 
> where, keep in mind, <subpath> may not actually be part of the mount.
> 
> /proc/self/mountinfo seems to have some of that information, however, it
> does not appear to distinguish between non-default subvolumes and
> directories.  At the same time, once I have mounted a subvolume I see
> its name in the root btrfs directory even if I didn't access it.
> 
> Questions, thus:
> 
> a. Are subvolumes always part of the "root" namespace?

Yes. There is only one namespace in btrfs that all files, directories,
and subvolumes are contained in.

> If so, is it the
> mounted root, the default subvolume, or subvolume 0 which always exposes
> these other subvolumes?

All subvolumes are accessible from the volume mounted when you use -o
subvolid=0. (Note that 0 is not the real ID of the root volume, it's
just a shortcut for mounting it.)

The 'default' subvolume can be arbitrarily changed to any subvolume by a
user; the result is equivalent to having a file-system default
'subvolid=' value that's used when none is specified by the user.

> Are there disambiguation rules so that if I
> have /btrfs/root/blah and "blah" is both a subvolume and a directory (I
> presume that can happen?)

This cannot happen; see my first answer.

> b. Are there better ways (walking the tree using BTRFS_IOC_TREE_SEARCH?)
> to accomplish this than using /proc/self/mountinfo?

I'm not sure; you might want to look into how the 
  btrfs subvolume list <path>
tool reads the list of subvolumes. (Note that this tool lists the
subvolume paths relative to the root, and the <path> parameter is only
used to determine which btrfs filesystem you're looking at.)

Unless it has changed recently, mounting a subvolume by path on btrfs is
(almost) the same as mounting the root volume, then doing a bind mount
like "mount --bind /mnt/subvolume/path /mnt". This used to not even
bother checking if you were attempting to mount a directory or
subvolume.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

