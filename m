Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751125AbdEERNM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 13:13:12 -0400
Date: Fri, 5 May 2017 19:13:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 5/6] Btrfs: change check-integrity to use bvec_iter
Message-ID: <20170505171304.GG10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1492478187-24875-1-git-send-email-bo.li.liu@oracle.com>
 <1492478187-24875-6-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1492478187-24875-6-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 17, 2017 at 06:16:26PM -0700, Liu Bo wrote:
> Some check-integrity code depends on bio->bi_vcnt, this changes it to use
> bio segments because some bios passing here may not have a reliable
> bi_vcnt.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/check-integrity.c | 27 +++++++++++++++------------
>  1 file changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index ab14c2e..8e7ce48 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -2822,44 +2822,47 @@ static void __btrfsic_submit_bio(struct bio *bio)
>  	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
>  	if (NULL != dev_state &&
>  	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
> -		unsigned int i;
> +		unsigned int i = 0;
>  		u64 dev_bytenr;
>  		u64 cur_bytenr;
> -		struct bio_vec *bvec;
> +		struct bio_vec bvec;
> +		struct bvec_iter iter;
>  		int bio_is_patched;
>  		char **mapped_datav;
> +		int segs = bio_segments(bio);

Type mismatch, bio_segments return unsigned.

>  
>  		dev_bytenr = 512 * bio->bi_iter.bi_sector;
>  		bio_is_patched = 0;
>  		if (dev_state->state->print_mask &
>  		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
>  			pr_info("submit_bio(rw=%d,0x%x, bi_vcnt=%u, bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
> -			       bio_op(bio), bio->bi_opf, bio->bi_vcnt,
> +			       bio_op(bio), bio->bi_opf, segs,
>  			       (unsigned long long)bio->bi_iter.bi_sector,
>  			       dev_bytenr, bio->bi_bdev);
>  
> -		mapped_datav = kmalloc_array(bio->bi_vcnt,
> +		mapped_datav = kmalloc_array(segs,
>  					     sizeof(*mapped_datav), GFP_NOFS);
>  		if (!mapped_datav)
>  			goto leave;
>  		cur_bytenr = dev_bytenr;
>  
> -		bio_for_each_segment_all(bvec, bio, i) {
> -			BUG_ON(bvec->bv_len != PAGE_SIZE);
> -			mapped_datav[i] = kmap(bvec->bv_page);
> +		bio_for_each_segment(bvec, bio, iter) {
> +			BUG_ON(bvec.bv_len != PAGE_SIZE);
> +			mapped_datav[i] = kmap(bvec.bv_page);
> +			i++;
>  
>  			if (dev_state->state->print_mask &
>  			    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH_VERBOSE)
>  				pr_info("#%u: bytenr=%llu, len=%u, offset=%u\n",
> -				       i, cur_bytenr, bvec->bv_len, bvec->bv_offset);
> -			cur_bytenr += bvec->bv_len;
> +				       i, cur_bytenr, bvec.bv_len, bvec.bv_offset);
> +			cur_bytenr += bvec.bv_len;
>  		}
>  		btrfsic_process_written_block(dev_state, dev_bytenr,
> -					      mapped_datav, bio->bi_vcnt,
> +					      mapped_datav, segs,
>  					      bio, &bio_is_patched,
>  					      NULL, bio->bi_opf);
> -		bio_for_each_segment_all(bvec, bio, i)
> -			kunmap(bvec->bv_page);
> +		bio_for_each_segment(bvec, bio, iter)
> +			kunmap(bvec.bv_page);
>  		kfree(mapped_datav);
>  	} else if (NULL != dev_state && (bio->bi_opf & REQ_PREFLUSH)) {
>  		if (dev_state->state->print_mask &
> -- 
> 2.5.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
