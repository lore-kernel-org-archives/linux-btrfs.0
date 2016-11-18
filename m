Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:32952 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752035AbcKRUgN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Nov 2016 15:36:13 -0500
Received: by mail-pg0-f43.google.com with SMTP id 3so106469329pgd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Nov 2016 12:36:13 -0800 (PST)
Date: Fri, 18 Nov 2016 12:36:11 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/9] btrfs: use bio_for_each_segment_all in
 __btrfsic_submit_bio
Message-ID: <20161118203611.GH19038@vader.DHCP.thefacebook.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-9-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1479300736-9724-9-git-send-email-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 16, 2016 at 01:52:15PM +0100, Christoph Hellwig wrote:
> And remove the bogus check for a NULL return value from kmap, which
> can't happen.  While we're at it: I don't think that kmapping up to 256
> will work without deadlocks on highmem machines, a better idea would
> be to use vm_map_ram to map all of them into a single virtual address
> range.  Incidentally that would also simplify the code a lot.

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/check-integrity.c | 30 +++++++++++-------------------
>  1 file changed, 11 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index a6f657f..86f681f 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -2819,10 +2819,11 @@ static void __btrfsic_submit_bio(struct bio *bio)
>  	 * btrfsic_mount(), this might return NULL */
>  	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
>  	if (NULL != dev_state &&
> -	    (bio_op(bio) == REQ_OP_WRITE) && NULL != bio->bi_io_vec) {
> +	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
>  		unsigned int i;
>  		u64 dev_bytenr;
>  		u64 cur_bytenr;
> +		struct bio_vec *bvec;
>  		int bio_is_patched;
>  		char **mapped_datav;
>  
> @@ -2840,32 +2841,23 @@ static void __btrfsic_submit_bio(struct bio *bio)
>  		if (!mapped_datav)
>  			goto leave;
>  		cur_bytenr = dev_bytenr;
> -		for (i = 0; i < bio->bi_vcnt; i++) {
> -			BUG_ON(bio->bi_io_vec[i].bv_len != PAGE_SIZE);
> -			mapped_datav[i] = kmap(bio->bi_io_vec[i].bv_page);
> -			if (!mapped_datav[i]) {
> -				while (i > 0) {
> -					i--;
> -					kunmap(bio->bi_io_vec[i].bv_page);
> -				}
> -				kfree(mapped_datav);
> -				goto leave;
> -			}
> +
> +		bio_for_each_segment_all(bvec, bio, i) {
> +			BUG_ON(bvec->bv_len != PAGE_SIZE);
> +			mapped_datav[i] = kmap(bvec->bv_page);
> +
>  			if (dev_state->state->print_mask &
>  			    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH_VERBOSE)
>  				pr_info("#%u: bytenr=%llu, len=%u, offset=%u\n",
> -				       i, cur_bytenr, bio->bi_io_vec[i].bv_len,
> -				       bio->bi_io_vec[i].bv_offset);
> -			cur_bytenr += bio->bi_io_vec[i].bv_len;
> +				       i, cur_bytenr, bvec->bv_len, bvec->bv_offset);
> +			cur_bytenr += bvec->bv_len;
>  		}
>  		btrfsic_process_written_block(dev_state, dev_bytenr,
>  					      mapped_datav, bio->bi_vcnt,
>  					      bio, &bio_is_patched,
>  					      NULL, bio->bi_opf);
> -		while (i > 0) {
> -			i--;
> -			kunmap(bio->bi_io_vec[i].bv_page);
> -		}
> +		bio_for_each_segment_all(bvec, bio, i)
> +			kunmap(bvec->bv_page);
>  		kfree(mapped_datav);
>  	} else if (NULL != dev_state && (bio->bi_opf & REQ_PREFLUSH)) {
>  		if (dev_state->state->print_mask &
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Omar
