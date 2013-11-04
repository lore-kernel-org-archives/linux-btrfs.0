Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55056 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KEAWc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Nov 2013 19:22:32 -0500
Message-ID: <52783444.8070309@cs.wisc.edu>
Date: Mon, 04 Nov 2013 15:56:52 -0800
From: Mike Christie <michaelc@cs.wisc.edu>
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: Kent Overstreet <kmo@daterainc.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        axboe@kernel.dk, hch@infradead.org, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/9] block: Make generic_make_request handle
 arbitrary sized bios
References: <1383608187-27368-1-git-send-email-kmo@daterainc.com> <1383608187-27368-5-git-send-email-kmo@daterainc.com>
In-Reply-To: <1383608187-27368-5-git-send-email-kmo@daterainc.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/04/2013 03:36 PM, Kent Overstreet wrote:
> @@ -1822,6 +1820,14 @@ void generic_make_request(struct bio *bio)
>  		 */
>  		blk_queue_bounce(q, &bio);
>  
> +		if (!blk_queue_largebios(q))
> +			split = blk_bio_segment_split(q, bio, q->bio_split);


Is it assumed bios coming down this path are created using bio_add_page?
If not, does blk_bio_segment_split need a queue_max_sectors or
queue_max_hw_sectors check? I only saw a segment count check below.


> +
> +struct bio *blk_bio_segment_split(struct request_queue *q, struct bio *bio,
> +				  struct bio_set *bs)
> +{
> +	struct bio *split;
> +	struct bio_vec bv, bvprv;
> +	struct bvec_iter iter;
> +	unsigned seg_size = 0, nsegs = 0;
> +	int prev = 0;
> +
> +	struct bvec_merge_data bvm = {
> +		.bi_bdev	= bio->bi_bdev,
> +		.bi_sector	= bio->bi_iter.bi_sector,
> +		.bi_size	= 0,
> +		.bi_rw		= bio->bi_rw,
> +	};
> +
> +	if (bio->bi_rw & REQ_DISCARD)
> +		return blk_bio_discard_split(q, bio, bs);
> +
> +	if (bio->bi_rw & REQ_WRITE_SAME)
> +		return blk_bio_write_same_split(q, bio, bs);
> +
> +	bio_for_each_segment(bv, bio, iter) {
> +		if (q->merge_bvec_fn &&
> +		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
> +			goto split;
> +
> +		bvm.bi_size += bv.bv_len;
> +
> +		if (prev && blk_queue_cluster(q)) {
> +			if (seg_size + bv.bv_len > queue_max_segment_size(q))
> +				goto new_segment;
> +			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
> +				goto new_segment;
> +			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
> +				goto new_segment;
> +
> +			seg_size += bv.bv_len;
> +			bvprv = bv;
> +			prev = 1;
> +			continue;
> +		}
> +new_segment:
> +		if (nsegs == queue_max_segments(q))
> +			goto split;
> +
> +		nsegs++;
> +		bvprv = bv;
> +		prev = 1;
> +		seg_size = bv.bv_len;
> +	}
> +
> +	return NULL;
> +split:
> +	split = bio_clone_bioset(bio, GFP_NOIO, bs);
> +
> +	split->bi_iter.bi_size -= iter.bi_size;
> +	bio->bi_iter = iter;
> +
> +	if (bio_integrity(bio)) {
> +		bio_integrity_advance(bio, split->bi_iter.bi_size);
> +		bio_integrity_trim(split, 0, bio_sectors(split));
> +	}
> +
> +	return split;
> +}
