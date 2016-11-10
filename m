Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:33594 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933923AbcKJUJI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 15:09:08 -0500
Received: by mail-pf0-f173.google.com with SMTP id d2so151796232pfd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Nov 2016 12:09:08 -0800 (PST)
Date: Thu, 10 Nov 2016 12:09:06 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: deal with existing encompassing extent map in
 btrfs_get_extent()
Message-ID: <20161110200906.GA22359@vader.DHCP.thefacebook.com>
References: <262a1e171d091626edbd23c637cb138ba9d84ed8.1478733376.git.osandov@fb.com>
 <20161110195718.GA22740@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161110195718.GA22740@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2016 at 12:01:20PM -0800, Liu Bo wrote:
> On Wed, Nov 09, 2016 at 03:26:50PM -0800, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > My QEMU VM was seeing inexplicable I/O errors that I tracked down to
> > errors coming from the qcow2 virtual drive in the host system. The qcow2
> > file is a nocow file on my Btrfs drive, which QEMU opens with O_DIRECT.
> > Every once in awhile, pread() or pwrite() would return EEXIST, which
> > makes no sense. This turned out to be a bug in btrfs_get_extent().
> > 
> > Commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map
> > insertion in btrfs_get_extent") fixed a case in btrfs_get_extent() where
> > two threads race on adding the same extent map to an inode's extent map
> > tree. However, if the added em is merged with an adjacent em in the
> > extent tree, then we'll end up with an existing extent that is not
> > identical to but instead encompasses the extent we tried to add. When we
> > call merge_extent_mapping() to find the nonoverlapping part of the new
> > em, the arithmetic overflows because there is no such thing. We then end
> > up trying to add a bogus em to the em_tree, which results in a EEXIST
> > that can bubble all the way up to userspace.
> 
> I don't get how this could happen(even after reading Commit
> 8dff9c853410), btrfs_get_extent in direct_IO is protected by
> lock_extent_direct, the assumption is that a racy thread should be
> blocked by lock_extent_direct and when it gets the lock, it finds the
> just-inserted em when going into btrfs_get_extent if its offset is
> within [em->start, extent_map_end(em)].
> 
> I think we may also need to figure out why the above doesn't work as
> expected besides fixing another special case.
> 
> Thanks,
> 
> -liubo

lock_extent_direct() only protects the range you're doing I/O into, not
the entire extent. If two threads are doing two non-overlapping reads in
the same extent, then you can get this race.

-- 
Omar
