Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50431 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdFFKPN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 06:15:13 -0400
Subject: Re: [PATCH 1/8] btrfs: bioset allocations will never fail, adapt our
 helpers
To: David Sterba <dsterba@suse.com>
References: <cover.1496422340.git.dsterba@suse.com>
 <559a7bd7acc20ab9eb967dd205e41a4a3f2cdb97.1496422340.git.dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Liu Bo <bo.li.liu@oracle.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0fb07221-b538-ccc3-c910-296d97ea64aa@oracle.com>
Date: Tue, 6 Jun 2017 18:21:17 +0800
MIME-Version: 1.0
In-Reply-To: <559a7bd7acc20ab9eb967dd205e41a4a3f2cdb97.1496422340.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/03/17 00:58, David Sterba wrote:
> Christoph pointed out that bio allocations backed by a bioset will never
> fail.

David,

  Looks like this feature comes when  __GFP_DIRECT_RECLAIM is
  set and we aren't, such as [1]. Any idea why? Looks like I am
  missing something ?


[1]
-----
static int submit_extent_page(int op, int op_flags, struct 
extent_io_tree *tree,
::

  bio = btrfs_bio_alloc(bdev, sector, BIO_MAX_PAGES,
                 GFP_NOFS | __GFP_HIGH);

------

Thanks, Anand


>  As we always use a bioset for all bio allocations, we can skip
> the error handling.  This patch adjusts our low-level helpers, the
> cascaded changes to all callers will come next.
>
> CC: Christoph Hellwig <hch@lst.de>
> CC: Liu Bo <bo.li.liu@oracle.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/extent_io.c | 50 +++++++++++++++++++-------------------------------
>  1 file changed, 19 insertions(+), 31 deletions(-)
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 5909f8214255..78a787c36a35 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2659,8 +2659,9 @@ static void end_bio_extent_readpage(struct bio *bio)
>  }
>
>  /*
> - * this allocates from the btrfs_bioset.  We're returning a bio right now
> - * but you can call btrfs_io_bio for the appropriate container_of magic
> + * The following helpers allocate a bio. As it's backed by a bioset, it'll
> + * never fail.  We're returning a bio right now but you can call btrfs_io_bio
> + * for the appropriate container_of magic
>   */
>  struct bio *
>  btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
> @@ -2670,22 +2671,12 @@ btrfs_bio_alloc(struct block_device *bdev, u64 first_sector, int nr_vecs,
>  	struct bio *bio;
>
>  	bio = bio_alloc_bioset(gfp_flags, nr_vecs, btrfs_bioset);
> -
> -	if (bio == NULL && (current->flags & PF_MEMALLOC)) {
> -		while (!bio && (nr_vecs /= 2)) {
> -			bio = bio_alloc_bioset(gfp_flags,
> -					       nr_vecs, btrfs_bioset);
> -		}
> -	}
> -
> -	if (bio) {
> -		bio->bi_bdev = bdev;
> -		bio->bi_iter.bi_sector = first_sector;
> -		btrfs_bio = btrfs_io_bio(bio);
> -		btrfs_bio->csum = NULL;
> -		btrfs_bio->csum_allocated = NULL;
> -		btrfs_bio->end_io = NULL;
> -	}
> +	bio->bi_bdev = bdev;
> +	bio->bi_iter.bi_sector = first_sector;
> +	btrfs_bio = btrfs_io_bio(bio);
> +	btrfs_bio->csum = NULL;
> +	btrfs_bio->csum_allocated = NULL;
> +	btrfs_bio->end_io = NULL;
>  	return bio;
>  }
>
> @@ -2694,29 +2685,26 @@ struct bio *btrfs_bio_clone(struct bio *bio, gfp_t gfp_mask)
>  	struct btrfs_io_bio *btrfs_bio;
>  	struct bio *new;
>
> +	/* Bio allocation backed by a bioset does not fail */
>  	new = bio_clone_fast(bio, gfp_mask, btrfs_bioset);
> -	if (new) {
> -		btrfs_bio = btrfs_io_bio(new);
> -		btrfs_bio->csum = NULL;
> -		btrfs_bio->csum_allocated = NULL;
> -		btrfs_bio->end_io = NULL;
> -	}
> +	btrfs_bio = btrfs_io_bio(new);
> +	btrfs_bio->csum = NULL;
> +	btrfs_bio->csum_allocated = NULL;
> +	btrfs_bio->end_io = NULL;
>  	return new;
>  }
>
> -/* this also allocates from the btrfs_bioset */
>  struct bio *btrfs_io_bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
>  {
>  	struct btrfs_io_bio *btrfs_bio;
>  	struct bio *bio;
>
> +	/* Bio allocation backed by a bioset does not fail */
>  	bio = bio_alloc_bioset(gfp_mask, nr_iovecs, btrfs_bioset);
> -	if (bio) {
> -		btrfs_bio = btrfs_io_bio(bio);
> -		btrfs_bio->csum = NULL;
> -		btrfs_bio->csum_allocated = NULL;
> -		btrfs_bio->end_io = NULL;
> -	}
> +	btrfs_bio = btrfs_io_bio(bio);
> +	btrfs_bio->csum = NULL;
> +	btrfs_bio->csum_allocated = NULL;
> +	btrfs_bio->end_io = NULL;
>  	return bio;
>  }
>
>
