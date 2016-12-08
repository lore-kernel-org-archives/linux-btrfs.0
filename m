Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44883 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbcLHKrv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Dec 2016 05:47:51 -0500
Date: Thu, 8 Dec 2016 11:47:41 +0100
From: Jan Kara <jack@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        Jan Kara <jack@suse.cz>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 4/6] Btrfs: add DAX support for nocow btrfs
Message-ID: <20161208104741.GB4049@quack2.suse.cz>
References: <1481147110-20048-1-git-send-email-bo.li.liu@oracle.com>
 <1481147110-20048-5-git-send-email-bo.li.liu@oracle.com>
 <ad5694be-df94-f1ed-46ac-96ef19d8007d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ad5694be-df94-f1ed-46ac-96ef19d8007d@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 07-12-16 17:15:42, Chris Mason wrote:
> On 12/07/2016 04:45 PM, Liu Bo wrote:
> >This has implemented DAX support for btrfs with nocow and single-device.
> >
> >DAX is developed for block devices that are memory-like in order to avoid
> >double buffer in both page cache and the storage, so DAX can performs reads and
> >writes directly to the storage device, and for those who prefer to using
> >filesystem, filesystem dax support can help to map the storage into userspace
> >for file-mapping.
> >
> >Since I haven't figure out how to map multiple devices to userspace without
> >pagecache, this DAX support is only for single-device, and I don't think
> >DAX(Direct Access) can work with cow, this is limited to nocow case.  I made
> >this by setting nodatacow in dax mount option.
> 
> Interesting, this is a nice small start.  It might make more sense to limit
> snapshots to readonly in DAX mode until we can figure out how to cow
> properly.  I think it can be done, I just need to sit down with the dax code
> to do a good review.
> 
> But bigger picture, if we can't cow and we can't crc and we can't
> multi-device, I'd rather let XFS/ext4 sort out the dax space until we pull
> in more of the btrfs features too.

So normal DAX IO (via read(2) and write(2)) is very similar to direct IO so
I don't think there would be any obstacle to support all the features with
that. For mmap(2) things get more difficult but still: The filesystem gets
normal ->fault notifications when the page is first faulted in. So you can
COW if you need to at that moment. Also DAX PTEs can be write-protected
(well, as of the coming merge window) as normal PTEs and then you'll get
->pfn_mkwrite / ->page_mkwrite notification when someone tries to write via
mmap and you can do your stuff at that point. So DAX mappings are not that
different from filesystem point of view. There are some differences wrt.
locking (you don't have page lock, but you use a lock bit in radix tree
entry instead for that) but that's about it. So I don't see a principial
reason why we cannot support all btrfs features for DAX... But if you see
some problem, let me know and we can talk if we could somehow help from the
DAX side.

BTW, I also don't see how the multiple devices are a problem. Actually XFS
supports that (with its real-time devices) just fine - your ->iomap_begin()
returns a <device, blocknumber> pair and that should be all that's needed,
no?

								Honza

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
