Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45565 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752375AbcLIMbF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Dec 2016 07:31:05 -0500
Date: Fri, 9 Dec 2016 13:31:03 +0100
From: Jan Kara <jack@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
Message-ID: <20161209123103.GA10957@quack2.suse.cz>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
 <ad5694be-df94-f1ed-46ac-96ef19d8007d@fb.com>
 <20161208104741.GB4049@quack2.suse.cz>
 <20161208164539.GB20111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161208164539.GB20111@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu 08-12-16 08:45:39, Liu Bo wrote:
> On Thu, Dec 08, 2016 at 11:47:41AM +0100, Jan Kara wrote:
> > On Wed 07-12-16 17:15:42, Chris Mason wrote:
> > > On 12/07/2016 04:45 PM, Liu Bo wrote:
> > > >This has implemented DAX support for btrfs with nocow and single-device.
> > > >
> > > >DAX is developed for block devices that are memory-like in order to avoid
> > > >double buffer in both page cache and the storage, so DAX can performs reads and
> > > >writes directly to the storage device, and for those who prefer to using
> > > >filesystem, filesystem dax support can help to map the storage into userspace
> > > >for file-mapping.
> > > >
> > > >Since I haven't figure out how to map multiple devices to userspace without
> > > >pagecache, this DAX support is only for single-device, and I don't think
> > > >DAX(Direct Access) can work with cow, this is limited to nocow case.  I made
> > > >this by setting nodatacow in dax mount option.
> > > 
> > > Interesting, this is a nice small start.  It might make more sense to limit
> > > snapshots to readonly in DAX mode until we can figure out how to cow
> > > properly.  I think it can be done, I just need to sit down with the dax code
> > > to do a good review.
> > > 
> > > But bigger picture, if we can't cow and we can't crc and we can't
> > > multi-device, I'd rather let XFS/ext4 sort out the dax space until we pull
> > > in more of the btrfs features too.
> > 
> > So normal DAX IO (via read(2) and write(2)) is very similar to direct IO so
> > I don't think there would be any obstacle to support all the features with
> > that.
> 
> For DAX IO via read(2)/write(2), cow is OK while the mutliple devices is
> a problem as currently iomap_dax_actor only takes one <device, blocknum>
> pair:
> 
> - raid 0, one device is written once a time
> - raid 1/10 and others, 2 or more devices need to be written each time

OK, but how do you cope with direct IO for multiple devices then? Do you
just disallow it? That's the same issue AFAICS.

> > For mmap(2) things get more difficult but still: The filesystem gets
> > normal ->fault notifications when the page is first faulted in. So you
> > can COW if you need to at that moment.
> 
> Right.
> 
> > Also DAX PTEs can be write-protected (well, as of the coming merge
> > window) as normal PTEs and then you'll get ->pfn_mkwrite /
> > ->page_mkwrite notification when someone tries to write via mmap and
> > you can do your stuff at that point.
> 
> That's right, but I think the problem comes from the fact that only
> ->fault with FAULT_FLAG_WRITE gets to space allocation where we could
> cow to new location.
> 
> For page_mkwrite, btrfs does cow while writing back a dirty page, but
> dax doesn't do delayed allocation so dax_writeback_one doesn't have
> place to do cow.

Yes, so you'd have to change this logic so that for DAX COW happens already
on page_mkwrite() time (when iomap_begin() handler is called to prepare
blocks for writing at given file offset) and not at write back time.
 
							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
