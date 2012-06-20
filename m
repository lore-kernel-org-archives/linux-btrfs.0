Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:36976 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756910Ab2FTP7n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 11:59:43 -0400
Message-ID: <4FE1F368.4010904@zytor.com>
Date: Wed, 20 Jun 2012 08:59:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Subvolumes and /proc/self/mountinfo
References: <4FDFCA43.2070407@zytor.com> <20120619234919.GA4102@shiny> <4FE11365.3010802@zytor.com> <20120620133429.GD4102@shiny>
In-Reply-To: <20120620133429.GD4102@shiny>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 06:34 AM, Chris Mason wrote:
>>
>> I want an algorithm, it doesn't have an API per se.  I would really like
>> to avoid relying on blkid and udev for this, though... that is pretty
>> much a nonstarter.
>>
>> If the answer is to walk the tree then I'm fine with that.
> 
> Ok, fair enough.
> 
> 
> Right, the subvolume number doesn't change over the life of the subvol,
> regardless of the path that was used for mounting the subvol.  So all
> you need is that number (64 bits) and the filename relative to the
> subvol root and you're set.
> 
> We'll have to add an ioctl for that.
> 
> Finding the path relative to the subvol is easy, just walk backwards up
> the directory chain (cd ..) until you get to inode number 256.  All the
> subvol roots have inode number 256.
> 

... assuming I can actually see the root (that it is not obscured
because of bindmounts and so on).  Yes, I know I'm weird for worrying
about these hyper-obscure corner cases, but I have a pretty explicit
goal of trying to write Syslinux so it will very rarely if ever do the
wrong thing, and since I can already get that information for other
filesystems.

The other thing, of course, is what is the desirable behavior,which I
have brought up in a few posts already.  Specifically, I see two
possibilities:

a. Always handle a path from the global root, and treat subvolumes as
   directories.  This would mostly require that the behavior of
   /proc/self/mountinfo with regards to mount -o subvolid= would need
   to be fixed.  I also have no idea how one would deal with a detached
   subvolume, or if that subcase even matters.

   A major problem with this is that it may be *very* confusing to a
   user to have to specify a path in their bootloader configuration as
   /subvolume/foo/bar when the string "subvolume" doesn't show up in
   any way in their normal filesystem.

b. Treat the subvolume as the root (which is what I so far have been
   asssuming.)  In this case, I think the <subvolume ID,
   path_in_subvolume> ioctl is the way to go, unless there is a way
   to do this with BTRFS_IOC_TREE_SEARCH already.

I think I'm leaning, still, at "b" just because of the very high
potential for user confusion with "a".

>>
>> Well, I'd be interested in what Kay's stuff actually does.  Other than
>> that, I would suggest adding a pair of ioctls that when executed on an
>> arbitrary btrfs inode returns the corresponding subvolume and one which
>> returns the path relative to the subvolume root.
> 
> udev already scans block devices as they appear.  When it finds btrfs,
> it calls the btrfs dev scan ioctl for that one device.  It also reads in
> the FS uuid and the device uuid and puts them into a tree.
> 
> Very simple stuff, but it gets rid of the need to manually call btrfs
> dev scan yourself.
> 

For the record, I implemented the use of BTRFS_IOC_DEV_INFO yesterday;
it is still way better than what I had there before and will make an
excellent fallback for a new ioctl.

This would be my suggestion for a new ioctl:

1. Add the device number to the information already returned by
   BTRFS_IOC_DEV_INFO.
2. Allow returning more than one device at a time.  Userspace can
   already know the number of devices from BTRFS_IOC_FS_INFO(*), and
   it'd be better to just size a buffer and return N items rather
   having to iterate over the potentially sparse devid space.

I might write this one up if I can carve out some time today...
	
	-hpa

(*) - because race conditions are still possible, a buffer size/limit
check is still needed.

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

