Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:35856 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbcK1Vij (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 Nov 2016 16:38:39 -0500
Received: by mail-pg0-f47.google.com with SMTP id f188so60773307pgc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Nov 2016 13:38:38 -0800 (PST)
Date: Mon, 28 Nov 2016 13:38:34 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>
Subject: Re: [PATCH 6/8] btrfs: calculate end of bio offset properly
Message-ID: <20161128213834.GA8808@vader.DHCP.thefacebook.com>
References: <1480061273-5722-1-git-send-email-hch@lst.de>
 <1480061273-5722-7-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480061273-5722-7-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 25, 2016 at 09:07:51AM +0100, Christoph Hellwig wrote:
> Use the bvec offset and len members to prepare for multipage bvecs.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/compression.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index 77042a8..3c1c25c 100644
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
> +	return page_offset(last->bv_page) + last->bv_len + last->bv_offset;
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
