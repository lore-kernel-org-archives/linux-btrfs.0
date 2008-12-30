From: Chris Mason <chris.mason@oracle.com>
Subject: Re: multiple device usage
Date: Tue, 30 Dec 2008 16:25:08 -0500
Message-ID: <1230672308.4229.6.camel@think.oraclecorp.com>
References: <556243856@web.de> <200812292232.08037.chris@csamuel.org>
	 <3d0408630812290433r7f2bb07cue3239c8acf958bb3@mail.gmail.com>
	 <200812292352.33059.chris@csamuel.org>
	 <3d0408630812290716i5ac68b27i17fe35891706e449@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: Yan Zheng <yanzheng@21cn.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3d0408630812290716i5ac68b27i17fe35891706e449@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-12-29 at 23:16 +0800, Yan Zheng wrote:
> 2008/12/29 Chris Samuel <chris@csamuel.org>:
> > Hello Yan,
> >
> > On Mon, 29 Dec 2008 11:33:18 pm Yan Zheng wrote:
> >
> >> 2008/12/29 Chris Samuel <chris@csamuel.org>:
> >>
> >> > The rebalancing code does appear (from a naive read of the code) to be
> >> > able to rebalance over stripes, but I have no idea if the disk format
> >> > currently supports changing that on the fly.
> >>
> >> The rebalancing moves data/metadata to newly created chunks. If there
> >> are two devices, the new chunks will be set up as RAID-1 by default.
> >
> > Very interesting!  I didn't realise that - I was presuming that the
> > BTRFS_BLOCK_GROUP_RAID1 ioctl needed to be passed through (as at mkfs time) to
> > change it into a RAID1 array.
> >
> 
> See __btrfs_reserve_extent and __btrfs_alloc_chunk.  There is a mistake in
> my previous reply. Only metadata chunks are set up as RAID-1 by default
> when there are two devices.

This gets confusing in a hurry, but the idea is to duplicate metadata by
default.  So, if you're using the default mount options on a single
drive and add a second drive, it should switch metadata to raid1.

I've always planned on adding an option to btrfs-vol -b to have it
change the data or metadata allocation policies (raidX to raidY,
restripe etc).  The kernel side code is all there, we just need
something to wire it up to userland.

data duplication on a single spindle could work, I just haven't hooked
it up because I couldn't think of a really strong reason to do it ;)

-chris


