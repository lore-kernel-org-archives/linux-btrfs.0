Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:34838 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752352AbcKRTek (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 14:34:40 -0500
Received: by mail-pg0-f50.google.com with SMTP id p66so105900913pga.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 11:34:39 -0800 (PST)
Date: Fri, 18 Nov 2016 11:34:38 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/9] btrfs: don't access the bio directly in the raid5/6
 code
Message-ID: <20161118193438.GC19038@vader.DHCP.thefacebook.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479300736-9724-4-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:52:10PM +0100, Christoph Hellwig wrote:
> Just use bio_for_each_segment_all to iterate over all segments.

The subject seems to be copied from patch 2 for this one. Otherwise,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/inode.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 147df4c..3f09cb6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -8394,7 +8394,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct bio *bio;
>  	struct bio *orig_bio = dip->orig_bio;
> -	struct bio_vec *bvec = orig_bio->bi_io_vec;
> +	struct bio_vec *bvec;
>  	u64 start_sector = orig_bio->bi_iter.bi_sector;
>  	u64 file_offset = dip->logical_offset;
>  	u64 submit_len = 0;
> @@ -8403,7 +8403,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  	int async_submit = 0;
>  	int nr_sectors;
>  	int ret;
> -	int i;
> +	int i, j;
>  
>  	map_length = orig_bio->bi_iter.bi_size;
>  	ret = btrfs_map_block(root->fs_info, btrfs_op(orig_bio),
> @@ -8433,7 +8433,7 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  	btrfs_io_bio(bio)->logical = file_offset;
>  	atomic_inc(&dip->pending_bios);
>  
> -	while (bvec <= (orig_bio->bi_io_vec + orig_bio->bi_vcnt - 1)) {
> +	bio_for_each_segment_all(bvec, orig_bio, j) {
>  		nr_sectors = BTRFS_BYTES_TO_BLKS(root->fs_info, bvec->bv_len);
>  		i = 0;
>  next_block:
> @@ -8487,7 +8487,6 @@ static int btrfs_submit_direct_hook(struct btrfs_dio_private *dip,
>  				i++;
>  				goto next_block;
>  			}
> -			bvec++;
>  		}
>  	}
>  
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Omar
