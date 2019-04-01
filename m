Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D4FC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 20:39:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7F4020880
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 20:39:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbfDAUjn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 16:39:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:60034 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfDAUjn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 16:39:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5DBFEAEA9;
        Mon,  1 Apr 2019 20:39:41 +0000 (UTC)
Date:   Mon, 1 Apr 2019 15:39:39 -0500
From:   Goldwyn Rodrigues <rgoldwyn@suse.de>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 07/15] btrfs: add dax write support
Message-ID: <20190401203939.gr5zcoauxshgdfys@merlin>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-8-rgoldwyn@suse.de>
 <20190328145307.GD1172@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190328145307.GD1172@magnolia>
User-Agent: NeoMutt/20180323
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On  7:53 28/03, Darrick J. Wong wrote:
> On Tue, Mar 26, 2019 at 02:02:53PM -0500, Goldwyn Rodrigues wrote:
> > From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > 
> > IOMAP_F_COW allows to inform the dax code, to first perform
> > a copy which are not page-aligned before performing the write.
> > 
> > A new struct btrfs_iomap is passed from iomap_begin() to
> > iomap_end(), which contains all the accounting and locking information
> > for CoW based writes.
> > 
> > For writing to a hole, iomap->cow_addr is set to zero. Would this
> > be better handled by a flag or can a valid filesystem block be at
> > offset zero of the device?
> > 
> > Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> > ---
> >  fs/btrfs/ctree.h |   6 +++
> >  fs/btrfs/dax.c   | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/btrfs/file.c  |   4 +-
> >  3 files changed, 124 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index a3543a4a063d..3bcd2a4959c1 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -3801,6 +3801,12 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
> >  #ifdef CONFIG_FS_DAX
> >  /* dax.c */
> >  ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
> > +ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
> > +#else
> > +static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
> > +{
> > +	return 0;
> > +}
> >  #endif /* CONFIG_FS_DAX */
> >  
> >  static inline int is_fstree(u64 rootid)
> > diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
> > index bf3d46b0acb6..49619fe3f94f 100644
> > --- a/fs/btrfs/dax.c
> > +++ b/fs/btrfs/dax.c
> > @@ -9,30 +9,124 @@
> >  #ifdef CONFIG_FS_DAX
> >  #include <linux/dax.h>
> >  #include <linux/iomap.h>
> > +#include <linux/uio.h>
> >  #include "ctree.h"
> >  #include "btrfs_inode.h"
> >  
> > +struct btrfs_iomap {
> > +	u64 start;
> > +	u64 end;
> > +	int nocow;
> > +	struct extent_changeset *data_reserved;
> > +	struct extent_state *cached_state;
> > +};
> > +
> >  static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
> >  		loff_t length, unsigned flags, struct iomap *iomap)
> >  {
> >  	struct extent_map *em;
> >  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> > +
> >  	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, length, 0);
> > +
> > +	if (flags & IOMAP_WRITE) {
> > +		int ret = 0, nocow;
> > +		struct extent_map *map = em;
> > +		struct btrfs_iomap *bi;
> 
> Please consider breaking this up into a separate helper before the
> btrfs_iomap_begin function becomes long and hard to read like the xfs
> one did.  :)
> 
> (Granted people also seem to dislike scrolling back and forth...)
> 
> > +
> > +		bi = kzalloc(sizeof(struct btrfs_iomap), GFP_NOFS);
> > +		if (!bi)
> > +			return -ENOMEM;
> > +
> > +		bi->start = round_down(pos, PAGE_SIZE);
> > +		bi->end = round_up(pos + length, PAGE_SIZE);
> > +
> > +		iomap->private = bi;
> > +
> > +		/* Wait for existing ordered extents in range to finish */
> > +		btrfs_wait_ordered_range(inode, bi->start, bi->end - bi->start);
> > +
> > +		lock_extent_bits(&BTRFS_I(inode)->io_tree, bi->start, bi->end, &bi->cached_state);
> > +
> > +		ret = btrfs_delalloc_reserve_space(inode, &bi->data_reserved,
> > +				bi->start, bi->end - bi->start);
> > +		if (ret) {
> > +			unlock_extent_cached(&BTRFS_I(inode)->io_tree, bi->start, bi->end,
> > +					&bi->cached_state);
> > +			kfree(bi);
> > +			return ret;
> > +		}
> > +
> > +		refcount_inc(&map->refs);
> > +		ret = btrfs_get_extent_map_write(&em, NULL,
> > +				inode, bi->start, bi->end - bi->start, &nocow);
> > +		if (ret) {
> > +			unlock_extent_cached(&BTRFS_I(inode)->io_tree, bi->start, bi->end,
> > +					&bi->cached_state);
> > +			btrfs_delalloc_release_space(inode,
> > +					bi->data_reserved, bi->start,
> > +					bi->end - bi->start, true);
> > +			extent_changeset_free(bi->data_reserved);
> > +			kfree(bi);
> > +			return ret;
> > +		}
> > +		if (!nocow) {
> > +			iomap->flags |= IOMAP_F_COW;
> > +			if (map->block_start != EXTENT_MAP_HOLE) {
> > +				iomap->cow_addr = map->block_start;
> > +				iomap->cow_pos = map->start;
> 
> Oh, I see, cow_pos exists because the extent we're copying from and the
> extent we're copying into are not necessarily going to be positioned at
> the same file offset and (I guess) it's possible that the source range
> could be partially sparse given the destination range?

No, there is no sparse range here.

> 
> Hmm, no, the previous patch doesn't account for that; it only seems to
> know how to handle @cow_pos < @offset.  In that case, why not trim the
> cow_* map to @offset?

Yes, that however would put the calculation responsibility on the filesystem
as opposed to the code. I am fine with either ways though, and it would
eliminate the need of cow_offset. However, for CoW cow_offset will be
calculated as round_down(offset, PAGE_SIZE) which seems reasonable.

> 
> --D
> 
> > +			}
> > +		} else {
> > +			bi->nocow = 1;
> > +		}
> > +		free_extent_map(map);
> > +	}
> > +
> > +	iomap->offset = em->start;
> > +	iomap->length = em->len;
> > +	iomap->bdev = em->bdev;
> > +	iomap->dax_dev = fs_info->dax_dev;
> > +
> >  	if (em->block_start == EXTENT_MAP_HOLE) {
> >  		iomap->type = IOMAP_HOLE;
> >  		return 0;
> >  	}
> > +
> >  	iomap->type = IOMAP_MAPPED;
> > -	iomap->bdev = em->bdev;
> > -	iomap->dax_dev = fs_info->dax_dev;
> > -	iomap->offset = em->start;
> > -	iomap->length = em->len;
> >  	iomap->addr = em->block_start;
> >  	return 0;
> >  }
> >  
> > +static int btrfs_iomap_end(struct inode *inode, loff_t pos,
> > +		loff_t length, ssize_t written, unsigned flags,
> > +		struct iomap *iomap)
> > +{
> > +	struct btrfs_iomap *bi = iomap->private;
> > +	u64 wend;
> > +
> > +	if (!bi)
> > +		return 0;
> > +
> > +	unlock_extent_cached(&BTRFS_I(inode)->io_tree, bi->start, bi->end,
> > +			&bi->cached_state);
> > +
> > +	wend = round_up(pos + written, PAGE_SIZE);
> > +	if (wend < bi->end) {
> > +		btrfs_delalloc_release_space(inode,
> > +				bi->data_reserved, wend,
> > +				bi->end - wend, true);
> > +	}
> > +
> > +	btrfs_update_ordered_extent(inode, bi->start, wend - bi->start, true);
> > +	btrfs_delalloc_release_extents(BTRFS_I(inode), wend - bi->start, false);
> > +	extent_changeset_free(bi->data_reserved);
> > +	kfree(bi);
> > +	return 0;
> > +}
> > +
> >  static const struct iomap_ops btrfs_iomap_ops = {
> >  	.iomap_begin		= btrfs_iomap_begin,
> > +	.iomap_end		= btrfs_iomap_end,
> >  };
> >  
> >  ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
> > @@ -46,4 +140,21 @@ ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
> >  
> >  	return ret;
> >  }
> > +
> > +ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *iter)
> > +{
> > +	ssize_t ret = 0;
> > +	u64 pos = iocb->ki_pos;
> > +	struct inode *inode = file_inode(iocb->ki_filp);
> > +
> > +	ret = dax_iomap_rw(iocb, iter, &btrfs_iomap_ops);
> > +
> > +	if (ret > 0) {
> > +		pos += ret;
> > +		if (pos > i_size_read(inode))
> > +			i_size_write(inode, pos);
> > +		iocb->ki_pos = pos;
> > +	}
> > +	return ret;
> > +}
> >  #endif /* CONFIG_FS_DAX */
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index b620f4e718b2..3b320d0ab495 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1964,7 +1964,9 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
> >  	if (sync)
> >  		atomic_inc(&BTRFS_I(inode)->sync_writers);
> >  
> > -	if (iocb->ki_flags & IOCB_DIRECT) {
> > +	if (IS_DAX(inode)) {
> > +		num_written = btrfs_file_dax_write(iocb, from);
> > +	} else if (iocb->ki_flags & IOCB_DIRECT) {
> >  		num_written = __btrfs_direct_write(iocb, from);
> >  	} else {
> >  		num_written = btrfs_buffered_write(iocb, from);
> > -- 
> > 2.16.4
> > 
> 

-- 
Goldwyn
