Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51190 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935537AbcKJUB2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 15:01:28 -0500
Date: Thu, 10 Nov 2016 12:01:20 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: deal with existing encompassing extent map in
 btrfs_get_extent()
Message-ID: <20161110195718.GA22740@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <262a1e171d091626edbd23c637cb138ba9d84ed8.1478733376.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <262a1e171d091626edbd23c637cb138ba9d84ed8.1478733376.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 09, 2016 at 03:26:50PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> My QEMU VM was seeing inexplicable I/O errors that I tracked down to
> errors coming from the qcow2 virtual drive in the host system. The qcow2
> file is a nocow file on my Btrfs drive, which QEMU opens with O_DIRECT.
> Every once in awhile, pread() or pwrite() would return EEXIST, which
> makes no sense. This turned out to be a bug in btrfs_get_extent().
> 
> Commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map
> insertion in btrfs_get_extent") fixed a case in btrfs_get_extent() where
> two threads race on adding the same extent map to an inode's extent map
> tree. However, if the added em is merged with an adjacent em in the
> extent tree, then we'll end up with an existing extent that is not
> identical to but instead encompasses the extent we tried to add. When we
> call merge_extent_mapping() to find the nonoverlapping part of the new
> em, the arithmetic overflows because there is no such thing. We then end
> up trying to add a bogus em to the em_tree, which results in a EEXIST
> that can bubble all the way up to userspace.

I don't get how this could happen(even after reading Commit
8dff9c853410), btrfs_get_extent in direct_IO is protected by
lock_extent_direct, the assumption is that a racy thread should be
blocked by lock_extent_direct and when it gets the lock, it finds the
just-inserted em when going into btrfs_get_extent if its offset is
within [em->start, extent_map_end(em)].

I think we may also need to figure out why the above doesn't work as
expected besides fixing another special case.

Thanks,

-liubo

> 
> Fix it by extending the identical extent map special case.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Applies to 4.9-rc4.
> 
> Here [1] is a reproducer for this bug that doesn't involve firing up a
> QEMU VM. Also, a big shoutout to BCC [2] and BPF for making it possible
> to debug this on my laptop without compiling a custom kernel and
> rebooting just to add printks [3].
> 
> 1: https://gist.github.com/osandov/d08aabe5d4dec15517e9fde17012fd3b
> 2: https://github.com/iovisor/bcc
> 3: https://gist.github.com/osandov/eb1db868ce10c3af9e00b90f3a65bf9f
> 
>  fs/btrfs/inode.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2b790bd..e5cf589 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7049,11 +7049,11 @@ struct extent_map *btrfs_get_extent(struct inode *inode, struct page *page,
>  		 * extent causing the -EEXIST.
>  		 */
>  		if (existing->start == em->start &&
> -		    extent_map_end(existing) == extent_map_end(em) &&
> +		    extent_map_end(existing) >= extent_map_end(em) &&
>  		    em->block_start == existing->block_start) {
>  			/*
> -			 * these two extents are the same, it happens
> -			 * with inlines especially
> +			 * The existing extent map already encompasses the
> +			 * entire extent map we tried to add.
>  			 */
>  			free_extent_map(em);
>  			em = existing;
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
