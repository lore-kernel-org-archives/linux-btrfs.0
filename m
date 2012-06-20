Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:57121 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584Ab2FTAD4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 20:03:56 -0400
Message-ID: <4FE11365.3010802@zytor.com>
Date: Tue, 19 Jun 2012 17:03:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Subvolumes and /proc/self/mountinfo
References: <4FDFCA43.2070407@zytor.com> <20120619234919.GA4102@shiny>
In-Reply-To: <20120619234919.GA4102@shiny>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/19/2012 04:49 PM, Chris Mason wrote:
> On Mon, Jun 18, 2012 at 06:39:31PM -0600, H. Peter Anvin wrote:
>> I'm trying to figure out an algorithm from taking an arbitrary mounted
>> btrfs directory and break it down into:
>>
>> <device(s), subvolume, subpath>
>>
>> where, keep in mind, <subpath> may not actually be part of the mount.
> 
> Do you want an API for this, or is it enough to wander through /dev/disk
> style symlinks?
> 
> The big reason it isn't here yet is because Kay had this neat patch to
> blkid and udev to just put all the info you need into /dev/btrfs (or
> some other suitable location).  It would allow you to see which devices
> belong to which filesystems etc.
> 

I want an algorithm, it doesn't have an API per se.  I would really like
to avoid relying on blkid and udev for this, though... that is pretty
much a nonstarter.

If the answer is to walk the tree then I'm fine with that.

> subvolumes may become disconnected from the root namespace.  In this
> case we can find it just by the subvol id, and mount it into an
> arbitrary directory.

OK, so it sounds like the best thing is actually to record the subvolume
*number* (ID) where (in my case) Syslinux is installed. This is actually
a good thing because the fewer O(n) strings I have to stick into the
boot block the better.

>> b. Are there better ways (walking the tree using BTRFS_IOC_TREE_SEARCH?)
>> to accomplish this than using /proc/self/mountinfo?
> 
> Not yet, but I'm definitely open to adding them.  Lets just hash out
> what you need and we'll either go through Kay's stuff or add ioctls for
> you.

Well, I'd be interested in what Kay's stuff actually does.  Other than
that, I would suggest adding a pair of ioctls that when executed on an
arbitrary btrfs inode returns the corresponding subvolume and one which
returns the path relative to the subvolume root.

	-hpa

