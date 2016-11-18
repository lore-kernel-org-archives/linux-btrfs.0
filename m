Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:35088 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751971AbcKRUEk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 15:04:40 -0500
Received: by mail-pf0-f180.google.com with SMTP id i88so55880397pfk.2
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 12:04:40 -0800 (PST)
Date: Fri, 18 Nov 2016 12:04:38 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/9] btrfs: calculate end of bio offset properly
Message-ID: <20161118200438.GF19038@vader.DHCP.thefacebook.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-7-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479300736-9724-7-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:52:13PM +0100, Christoph Hellwig wrote:
> Use the bvec offset and len members to prepare for multipage bvecs.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/compression.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 8618ac3..27e9feb 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -445,6 +445,13 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
>  	return 0;
>  }
>  
> +static u64 bio_end_offset(struct bio *bio)
> +{
> +	struct bio_vec *last = &bio->bi_io_vec[bio->bi_vcnt - 1];
> +
> +	return page_offset(last->bv_page) + last->bv_len - last->bv_offset;

Why is this minus bv_offset and not plus? Am I misunderstanding
bv_offset?

> +}
> +
>  static noinline int add_ra_bio_pages(struct inode *inode,
>  				     u64 compressed_end,
>  				     struct compressed_bio *cb)
> @@ -463,8 +470,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>  	u64 end;
>  	int misses = 0;
>  
> -	page = cb->orig_bio->bi_io_vec[cb->orig_bio->bi_vcnt - 1].bv_page;
> -	last_offset = (page_offset(page) + PAGE_SIZE);
> +	last_offset = bio_end_offset(cb->orig_bio);
>  	em_tree = &BTRFS_I(inode)->extent_tree;
>  	tree = &BTRFS_I(inode)->io_tree;
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
