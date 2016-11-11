Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23989 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935141AbcKKAgX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 19:36:23 -0500
Date: Thu, 10 Nov 2016 16:36:12 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: deal with existing encompassing extent map in
 btrfs_get_extent()
Message-ID: <20161111003611.GC22740@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <262a1e171d091626edbd23c637cb138ba9d84ed8.1478733376.git.osandov@fb.com>
 <20161110150651.GE12522@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161110150651.GE12522@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 10, 2016 at 04:06:51PM +0100, David Sterba wrote:
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
> Is this possibly the same bug that Liu Bo fixes in
> https://patchwork.kernel.org/patch/9413129/ ?

It's not, Omar is fixing a bug for read, my patch was to save space for
during DIO write.

Thanks,

-liubo
