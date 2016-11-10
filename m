Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35068 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755961AbcKJWpk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 17:45:40 -0500
Received: by mail-pf0-f169.google.com with SMTP id i88so152602351pfk.2
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Nov 2016 14:45:39 -0800 (PST)
Date: Thu, 10 Nov 2016 14:45:36 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: deal with existing encompassing extent map in
 btrfs_get_extent()
Message-ID: <20161110224536.GA8597@vader.DHCP.thefacebook.com>
References: <262a1e171d091626edbd23c637cb138ba9d84ed8.1478733376.git.osandov@fb.com>
 <20161110195718.GA22740@localhost.localdomain>
 <20161110200906.GA22359@vader.DHCP.thefacebook.com>
 <20161110202413.GB22359@vader.DHCP.thefacebook.com>
 <20161110223813.GB22740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161110223813.GB22740@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2016 at 02:38:14PM -0800, Liu Bo wrote:
> On Thu, Nov 10, 2016 at 12:24:13PM -0800, Omar Sandoval wrote:
> > On Thu, Nov 10, 2016 at 12:09:06PM -0800, Omar Sandoval wrote:
> > > On Thu, Nov 10, 2016 at 12:01:20PM -0800, Liu Bo wrote:
> > > > On Wed, Nov 09, 2016 at 03:26:50PM -0800, Omar Sandoval wrote:
> > > > > From: Omar Sandoval <osandov@fb.com>
> > > > > 
> > > > > My QEMU VM was seeing inexplicable I/O errors that I tracked down to
> > > > > errors coming from the qcow2 virtual drive in the host system. The qcow2
> > > > > file is a nocow file on my Btrfs drive, which QEMU opens with O_DIRECT.
> > > > > Every once in awhile, pread() or pwrite() would return EEXIST, which
> > > > > makes no sense. This turned out to be a bug in btrfs_get_extent().
> > > > > 
> > > > > Commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map
> > > > > insertion in btrfs_get_extent") fixed a case in btrfs_get_extent() where
> > > > > two threads race on adding the same extent map to an inode's extent map
> > > > > tree. However, if the added em is merged with an adjacent em in the
> > > > > extent tree, then we'll end up with an existing extent that is not
> > > > > identical to but instead encompasses the extent we tried to add. When we
> > > > > call merge_extent_mapping() to find the nonoverlapping part of the new
> > > > > em, the arithmetic overflows because there is no such thing. We then end
> > > > > up trying to add a bogus em to the em_tree, which results in a EEXIST
> > > > > that can bubble all the way up to userspace.
> > > > 
> > > > I don't get how this could happen(even after reading Commit
> > > > 8dff9c853410), btrfs_get_extent in direct_IO is protected by
> > > > lock_extent_direct, the assumption is that a racy thread should be
> > > > blocked by lock_extent_direct and when it gets the lock, it finds the
> > > > just-inserted em when going into btrfs_get_extent if its offset is
> > > > within [em->start, extent_map_end(em)].
> > > > 
> > > > I think we may also need to figure out why the above doesn't work as
> > > > expected besides fixing another special case.
> > > > 
> > > > Thanks,
> > > > 
> > > > -liubo
> > > 
> > > lock_extent_direct() only protects the range you're doing I/O into, not
> > > the entire extent. If two threads are doing two non-overlapping reads in
> > > the same extent, then you can get this race.
> > 
> > More concretely, assume the extent tree on disk has:
> > 
> > +-------------------------+-------------------------------+
> > |start=0,len=8192,bytenr=0|start=8192,len=8192,bytenr=8192|
> > +-------------------------+-------------------------------+
> > 
> > And the extent map tree in memory has a single em cached for the second
> > extent {start=8192, len=8192, bytenr=8192}. Then, two threads try do do
> > direct I/O reads:
> > 
> > Thread 1                               | Thread 2
> > ---------------------------------------+-------------------------------
> > pread(offset=0, nbyte=4096)            | pread(offset=4096, nbyte=4096)
> > lock_extent_direct(start=0, end=4095)  | lock_extent_direct(start=4096, end=8191)
> > btrfs_get_extent(start=0, len=4096)    | btrfs_get_extent(start=4096, len4096)
> >   lookup_extent_mapping() = NULL       |   lookup_extent_mapping() = NULL
> >   reads extent from B-tree             |   reads extent from B-tree
> >                                        |   write_lock(&em_tree->lock)
> > 				       |   add_extent_mapping(start=0, len=8192, bytenr=0)
> > 				       |     try_merge_map()
> > 				       |     em_tree now has {start=0, len=16384, bytenr=0}
> > 				       |   write_unlock(&em_tree->lock)
> > write_lock(&em_tree->lock)             |
> > add_extent_mapping(start=0, len=8192,  |
> >                    bytenr=0) = -EEXIST |
> > search_extent_mapping() = {start=0,    |
> >                            len=16384,  |
> > 			   bytenr=0}   |
> > merge_extent_mapping() does bogus math |
> > and overflows, returns EEXIST          |
> 
> Yeah, so much fun.
> 
> The problem is that we lock and request [0, 4096], but we insert a em of
> [0, 8192] instead.  So if we insert a [0, 4096] em, then we can make
> sure that the em returned by btrfs_get_extent is protected from race by
> the range of lock_extent_direct.
> 
> I'll give it a shot and do some testing.
> 
> For this patch,
> 
> Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thank you!

> Would you please make a reproducer for fstests?

Sure. Trying to trigger this with xfs_io never works because it's such a
narrow race window, but I'll send in my reproducer and see what the
xfstests guys think about adding new binaries.

> Thanks,
> 
> -liubo

-- 
Omar
