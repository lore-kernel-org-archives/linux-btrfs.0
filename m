Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D3CBC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D52BB217F9
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 14:53:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VJXRCwBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbfC1OxR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 10:53:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbfC1OxR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 10:53:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2SEcXMN070314;
        Thu, 28 Mar 2019 14:53:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=LLNtWGl6LgDWkUtOapWPE7lu8/l5VYX6HhNdJzvMlFc=;
 b=VJXRCwBLW86lQQB/HAyAWMlOM7KXVFABNi3zcH6VaUN60KDl2yEgmHINrhVD6so4Grvc
 GQ6Q+rfQcD7Q5EQ8c/Ku3O6wjvYJ21jkMznJ6Aog69g2C/5H0C3tV0BoZdzxjssNklN+
 LOSLq7X4wYt5wOe4gVO7B97UVvGmxRK1I9zCIbzpU1BFMS+/83vGYw7tETccZ7BbTDju
 QpaZBK8yqJx1qJUb+Z45sg6YrZHX5scEw+OV9VEj/5+hgQL7RRPxME8aidukQplvan23
 uSV9lnbmAQNsfVJvK2rGRUOHgU8wpQdvJKyro2YDGOk1xu24STJH13gfU9YAnlTfoIrY uA== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2re6djq5rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:53:11 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2SEr9jV005722
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Mar 2019 14:53:10 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x2SEr9jH030937;
        Thu, 28 Mar 2019 14:53:09 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 28 Mar 2019 07:53:08 -0700
Date:   Thu, 28 Mar 2019 07:53:07 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: Re: [PATCH 07/15] btrfs: add dax write support
Message-ID: <20190328145307.GD1172@magnolia>
References: <20190326190301.32365-1-rgoldwyn@suse.de>
 <20190326190301.32365-8-rgoldwyn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326190301.32365-8-rgoldwyn@suse.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9208 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1903280100
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 02:02:53PM -0500, Goldwyn Rodrigues wrote:
> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
> 
> IOMAP_F_COW allows to inform the dax code, to first perform
> a copy which are not page-aligned before performing the write.
> 
> A new struct btrfs_iomap is passed from iomap_begin() to
> iomap_end(), which contains all the accounting and locking information
> for CoW based writes.
> 
> For writing to a hole, iomap->cow_addr is set to zero. Would this
> be better handled by a flag or can a valid filesystem block be at
> offset zero of the device?
> 
> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> ---
>  fs/btrfs/ctree.h |   6 +++
>  fs/btrfs/dax.c   | 119 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  fs/btrfs/file.c  |   4 +-
>  3 files changed, 124 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index a3543a4a063d..3bcd2a4959c1 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3801,6 +3801,12 @@ int btree_readahead_hook(struct extent_buffer *eb, int err);
>  #ifdef CONFIG_FS_DAX
>  /* dax.c */
>  ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to);
> +ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from);
> +#else
> +static inline ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *from)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_FS_DAX */
>  
>  static inline int is_fstree(u64 rootid)
> diff --git a/fs/btrfs/dax.c b/fs/btrfs/dax.c
> index bf3d46b0acb6..49619fe3f94f 100644
> --- a/fs/btrfs/dax.c
> +++ b/fs/btrfs/dax.c
> @@ -9,30 +9,124 @@
>  #ifdef CONFIG_FS_DAX
>  #include <linux/dax.h>
>  #include <linux/iomap.h>
> +#include <linux/uio.h>
>  #include "ctree.h"
>  #include "btrfs_inode.h"
>  
> +struct btrfs_iomap {
> +	u64 start;
> +	u64 end;
> +	int nocow;
> +	struct extent_changeset *data_reserved;
> +	struct extent_state *cached_state;
> +};
> +
>  static int btrfs_iomap_begin(struct inode *inode, loff_t pos,
>  		loff_t length, unsigned flags, struct iomap *iomap)
>  {
>  	struct extent_map *em;
>  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> +
>  	em = btrfs_get_extent(BTRFS_I(inode), NULL, 0, pos, length, 0);
> +
> +	if (flags & IOMAP_WRITE) {
> +		int ret = 0, nocow;
> +		struct extent_map *map = em;
> +		struct btrfs_iomap *bi;

Please consider breaking this up into a separate helper before the
btrfs_iomap_begin function becomes long and hard to read like the xfs
one did.  :)

(Granted people also seem to dislike scrolling back and forth...)

> +
> +		bi = kzalloc(sizeof(struct btrfs_iomap), GFP_NOFS);
> +		if (!bi)
> +			return -ENOMEM;
> +
> +		bi->start = round_down(pos, PAGE_SIZE);
> +		bi->end = round_up(pos + length, PAGE_SIZE);
> +
> +		iomap->private = bi;
> +
> +		/* Wait for existing ordered extents in range to finish */
> +		btrfs_wait_ordered_range(inode, bi->start, bi->end - bi->start);
> +
> +		lock_extent_bits(&BTRFS_I(inode)->io_tree, bi->start, bi->end, &bi->cached_state);
> +
> +		ret = btrfs_delalloc_reserve_space(inode, &bi->data_reserved,
> +				bi->start, bi->end - bi->start);
> +		if (ret) {
> +			unlock_extent_cached(&BTRFS_I(inode)->io_tree, bi->start, bi->end,
> +					&bi->cached_state);
> +			kfree(bi);
> +			return ret;
> +		}
> +
> +		refcount_inc(&map->refs);
> +		ret = btrfs_get_extent_map_write(&em, NULL,
> +				inode, bi->start, bi->end - bi->start, &nocow);
> +		if (ret) {
> +			unlock_extent_cached(&BTRFS_I(inode)->io_tree, bi->start, bi->end,
> +					&bi->cached_state);
> +			btrfs_delalloc_release_space(inode,
> +					bi->data_reserved, bi->start,
> +					bi->end - bi->start, true);
> +			extent_changeset_free(bi->data_reserved);
> +			kfree(bi);
> +			return ret;
> +		}
> +		if (!nocow) {
> +			iomap->flags |= IOMAP_F_COW;
> +			if (map->block_start != EXTENT_MAP_HOLE) {
> +				iomap->cow_addr = map->block_start;
> +				iomap->cow_pos = map->start;

Oh, I see, cow_pos exists because the extent we're copying from and the
extent we're copying into are not necessarily going to be positioned at
the same file offset and (I guess) it's possible that the source range
could be partially sparse given the destination range?

Hmm, no, the previous patch doesn't account for that; it only seems to
know how to handle @cow_pos < @offset.  In that case, why not trim the
cow_* map to @offset?

--D

> +			}
> +		} else {
> +			bi->nocow = 1;
> +		}
> +		free_extent_map(map);
> +	}
> +
> +	iomap->offset = em->start;
> +	iomap->length = em->len;
> +	iomap->bdev = em->bdev;
> +	iomap->dax_dev = fs_info->dax_dev;
> +
>  	if (em->block_start == EXTENT_MAP_HOLE) {
>  		iomap->type = IOMAP_HOLE;
>  		return 0;
>  	}
> +
>  	iomap->type = IOMAP_MAPPED;
> -	iomap->bdev = em->bdev;
> -	iomap->dax_dev = fs_info->dax_dev;
> -	iomap->offset = em->start;
> -	iomap->length = em->len;
>  	iomap->addr = em->block_start;
>  	return 0;
>  }
>  
> +static int btrfs_iomap_end(struct inode *inode, loff_t pos,
> +		loff_t length, ssize_t written, unsigned flags,
> +		struct iomap *iomap)
> +{
> +	struct btrfs_iomap *bi = iomap->private;
> +	u64 wend;
> +
> +	if (!bi)
> +		return 0;
> +
> +	unlock_extent_cached(&BTRFS_I(inode)->io_tree, bi->start, bi->end,
> +			&bi->cached_state);
> +
> +	wend = round_up(pos + written, PAGE_SIZE);
> +	if (wend < bi->end) {
> +		btrfs_delalloc_release_space(inode,
> +				bi->data_reserved, wend,
> +				bi->end - wend, true);
> +	}
> +
> +	btrfs_update_ordered_extent(inode, bi->start, wend - bi->start, true);
> +	btrfs_delalloc_release_extents(BTRFS_I(inode), wend - bi->start, false);
> +	extent_changeset_free(bi->data_reserved);
> +	kfree(bi);
> +	return 0;
> +}
> +
>  static const struct iomap_ops btrfs_iomap_ops = {
>  	.iomap_begin		= btrfs_iomap_begin,
> +	.iomap_end		= btrfs_iomap_end,
>  };
>  
>  ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
> @@ -46,4 +140,21 @@ ssize_t btrfs_file_dax_read(struct kiocb *iocb, struct iov_iter *to)
>  
>  	return ret;
>  }
> +
> +ssize_t btrfs_file_dax_write(struct kiocb *iocb, struct iov_iter *iter)
> +{
> +	ssize_t ret = 0;
> +	u64 pos = iocb->ki_pos;
> +	struct inode *inode = file_inode(iocb->ki_filp);
> +
> +	ret = dax_iomap_rw(iocb, iter, &btrfs_iomap_ops);
> +
> +	if (ret > 0) {
> +		pos += ret;
> +		if (pos > i_size_read(inode))
> +			i_size_write(inode, pos);
> +		iocb->ki_pos = pos;
> +	}
> +	return ret;
> +}
>  #endif /* CONFIG_FS_DAX */
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index b620f4e718b2..3b320d0ab495 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1964,7 +1964,9 @@ static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
>  	if (sync)
>  		atomic_inc(&BTRFS_I(inode)->sync_writers);
>  
> -	if (iocb->ki_flags & IOCB_DIRECT) {
> +	if (IS_DAX(inode)) {
> +		num_written = btrfs_file_dax_write(iocb, from);
> +	} else if (iocb->ki_flags & IOCB_DIRECT) {
>  		num_written = __btrfs_direct_write(iocb, from);
>  	} else {
>  		num_written = btrfs_buffered_write(iocb, from);
> -- 
> 2.16.4
> 
