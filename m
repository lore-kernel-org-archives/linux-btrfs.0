Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f44.google.com ([74.125.83.44]:33309 "EHLO
        mail-pg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbcKRUba (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 15:31:30 -0500
Received: by mail-pg0-f44.google.com with SMTP id 3so106434783pgd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 12:31:30 -0800 (PST)
Date: Fri, 18 Nov 2016 12:31:28 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 7/9] btrfs: refactor __btrfs_lookup_bio_sums to use
 bio_for_each_segment_all
Message-ID: <20161118203128.GG19038@vader.DHCP.thefacebook.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-8-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479300736-9724-8-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:52:14PM +0100, Christoph Hellwig wrote:
> Rework the loop a little bit to use the generic bio_for_each_segment_all
> helper for iterating over the bio.

One minor nit. Besides that,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/file-item.c | 31 +++++++++++--------------------
>  1 file changed, 11 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index fa8aa53..54ccb91 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -163,7 +163,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  				   struct inode *inode, struct bio *bio,
>  				   u64 logical_offset, u32 *dst, int dio)
>  {
> -	struct bio_vec *bvec = bio->bi_io_vec;
> +	struct bio_vec *bvec;
>  	struct btrfs_io_bio *btrfs_bio = btrfs_io_bio(bio);
>  	struct btrfs_csum_item *item = NULL;
>  	struct extent_io_tree *io_tree = &BTRFS_I(inode)->io_tree;
> @@ -177,7 +177,7 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  	u32 diff;
>  	int nblocks;
>  	int bio_index = 0;
> -	int count;
> +	int count = 0;
>  	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
>  
>  	path = btrfs_alloc_path();
> @@ -223,8 +223,11 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  	if (dio)
>  		offset = logical_offset;
>  
> -	page_bytes_left = bvec->bv_len;
> -	while (bio_index < bio->bi_vcnt) {
> +	bio_for_each_segment_all(bvec, bio, bio_index) {

Can we just rename bio_index to i now?

> +		page_bytes_left = bvec->bv_len;
> +		if (count)
> +			goto next;
> +
>  		if (!dio)
>  			offset = page_offset(bvec->bv_page) + bvec->bv_offset;
>  		count = btrfs_find_ordered_sum(inode, offset, disk_bytenr,
> @@ -285,29 +288,17 @@ static int __btrfs_lookup_bio_sums(struct btrfs_root *root,
>  found:
>  		csum += count * csum_size;
>  		nblocks -= count;
> -
> +next:
>  		while (count--) {
>  			disk_bytenr += root->sectorsize;
>  			offset += root->sectorsize;
>  			page_bytes_left -= root->sectorsize;
> -			if (!page_bytes_left) {
> -				bio_index++;
> -				/*
> -				 * make sure we're still inside the
> -				 * bio before we update page_bytes_left
> -				 */
> -				if (bio_index >= bio->bi_vcnt) {
> -					WARN_ON_ONCE(count);
> -					goto done;
> -				}
> -				bvec++;
> -				page_bytes_left = bvec->bv_len;
> -			}
> -
> +			if (!page_bytes_left)
> +				break; /* move to next bio */
>  		}
>  	}
>  
> -done:
> +	WARN_ON_ONCE(count);
>  	btrfs_free_path(path);
>  	return 0;
>  }
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Omar
