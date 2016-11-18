Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36750 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752323AbcKRTsG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 14:48:06 -0500
Received: by mail-pf0-f178.google.com with SMTP id 189so56066780pfz.3
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 11:48:06 -0800 (PST)
Date: Fri, 18 Nov 2016 11:48:03 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/9] btrfs: use bi_size
Message-ID: <20161118194803.GE19038@vader.DHCP.thefacebook.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-6-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479300736-9724-6-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:52:12PM +0100, Christoph Hellwig wrote:
> Instead of using bi_vcnt to calculate it.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/compression.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 12a631d..8618ac3 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -562,7 +562,6 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>   *
>   * bio->bi_iter.bi_sector points to the compressed extent on disk
>   * bio->bi_io_vec points to all of the inode pages
> - * bio->bi_vcnt is a count of pages
>   *
>   * After the compressed pages are read, we copy the bytes into the
>   * bio we were passed and then call the bio end_io calls
> @@ -574,7 +573,6 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  	struct extent_map_tree *em_tree;
>  	struct compressed_bio *cb;
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
> -	unsigned long uncompressed_len = bio->bi_vcnt * PAGE_SIZE;
>  	unsigned long compressed_len;
>  	unsigned long nr_pages;
>  	unsigned long pg_index;
> @@ -619,7 +617,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  	free_extent_map(em);
>  	em = NULL;
>  
> -	cb->len = uncompressed_len;
> +	cb->len = bio->bi_iter.bi_size;
>  	cb->compressed_len = compressed_len;
>  	cb->compress_type = extent_compress_type(bio_flags);
>  	cb->orig_bio = bio;
> @@ -647,8 +645,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
>  	add_ra_bio_pages(inode, em_start + em_len, cb);
>  
>  	/* include any pages we added in add_ra-bio_pages */
> -	uncompressed_len = bio->bi_vcnt * PAGE_SIZE;
> -	cb->len = uncompressed_len;
> +	cb->len = bio->bi_iter.bi_size;
>  
>  	comp_bio = compressed_bio_alloc(bdev, cur_disk_byte, GFP_NOFS);
>  	if (!comp_bio)
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Omar
