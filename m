Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932111AbdHWSXl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 14:23:41 -0400
Date: Wed, 23 Aug 2017 11:23:38 -0700
From: Shaohua Li <shli@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] raid5: remove a call to get_start_sect
Message-ID: <20170823182338.einsyonnfucyn73y@kernel.org>
References: <20170823171032.30529-1-hch@lst.de>
 <20170823171032.30529-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170823171032.30529-3-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 23, 2017 at 07:10:28PM +0200, Christoph Hellwig wrote:
> The block layer always remaps partitions before calling into the
> ->make_request methods of drivers.  Thus the call to get_start_sect in
> in_chunk_boundary will always return 0 and can be removed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/raid5.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0fc2748aaf95..d687aeb1b538 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5092,10 +5092,12 @@ static int raid5_congested(struct mddev *mddev, int bits)
>  static int in_chunk_boundary(struct mddev *mddev, struct bio *bio)
>  {
>  	struct r5conf *conf = mddev->private;
> -	sector_t sector = bio->bi_iter.bi_sector + get_start_sect(bio->bi_bdev);
> +	sector_t sector = bio->bi_iter.bi_sector;
>  	unsigned int chunk_sectors;
>  	unsigned int bio_sectors = bio_sectors(bio);
>  
> +	WARN_ON_ONCE(bio->bi_partno);
> +
>  	chunk_sectors = min(conf->chunk_sectors, conf->prev_chunk_sectors);
>  	return  chunk_sectors >=
>  		((sector & (chunk_sectors - 1)) + bio_sectors);

Reviewed-by: Shaohua Li <shli@fb.com>
