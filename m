Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:33019 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbcKRTGB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 14:06:01 -0500
Received: by mail-pg0-f45.google.com with SMTP id 3so105823801pgd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 11:06:01 -0800 (PST)
Date: Fri, 18 Nov 2016 11:05:59 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/9] btrfs: don't access the bio directly in the raid5/6
 code
Message-ID: <20161118190559.GB19038@vader.DHCP.thefacebook.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-3-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479300736-9724-3-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:52:09PM +0100, Christoph Hellwig wrote:
> Just use bio_for_each_segment_all to iterate over all segments.
> 

Besides the minor whitespace issue below,

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/raid56.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
> index d016d4a..da941fb 100644
> --- a/fs/btrfs/raid56.c
> +++ b/fs/btrfs/raid56.c
> @@ -1144,10 +1144,10 @@ static void validate_rbio_for_rmw(struct btrfs_raid_bio *rbio)
>  static void index_rbio_pages(struct btrfs_raid_bio *rbio)
>  {
>  	struct bio *bio;
> +	struct bio_vec *bvec;
>  	u64 start;
>  	unsigned long stripe_offset;
>  	unsigned long page_index;
> -	struct page *p;
>  	int i;
>  
>  	spin_lock_irq(&rbio->bio_list_lock);
> @@ -1156,10 +1156,8 @@ static void index_rbio_pages(struct btrfs_raid_bio *rbio)
>  		stripe_offset = start - rbio->bbio->raid_map[0];
>  		page_index = stripe_offset >> PAGE_SHIFT;
>  
> -		for (i = 0; i < bio->bi_vcnt; i++) {
> -			p = bio->bi_io_vec[i].bv_page;
> -			rbio->bio_pages[page_index + i] = p;
> -		}
> +		bio_for_each_segment_all(bvec, bio, i)
> +			rbio->bio_pages[page_index+ i] = bvec->bv_page;

Missing a space right here ----------------------^

>  	}
>  	spin_unlock_irq(&rbio->bio_list_lock);
>  }
> @@ -1433,13 +1431,11 @@ static int fail_bio_stripe(struct btrfs_raid_bio *rbio,
>   */
>  static void set_bio_pages_uptodate(struct bio *bio)
>  {
> +	struct bio_vec *bvec;
>  	int i;
> -	struct page *p;
>  
> -	for (i = 0; i < bio->bi_vcnt; i++) {
> -		p = bio->bi_io_vec[i].bv_page;
> -		SetPageUptodate(p);
> -	}
> +	bio_for_each_segment_all(bvec, bio, i)
> +		SetPageUptodate(bvec->bv_page);
>  }
>  
>  /*
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Omar
