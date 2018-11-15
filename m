Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5472C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 20:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 615A720858
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 20:20:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="uI/+pM0r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 615A720858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389003AbeKPG36 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 01:29:58 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44254 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbeKPG3t (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 01:29:49 -0500
Received: by mail-pg1-f195.google.com with SMTP id t13so847815pgr.11
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 12:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DjOESrPx+LNX18fh9qfhKZ+KPyRBzNVp6MIp26IMeXY=;
        b=uI/+pM0rn1iRPxN5FCtrq1SbFlHuUR18/4dsIL4bsMQhabDgi4ZdSzX2Mfe3XjsNY6
         4xQVm6vhr3p/PDRuutZ6VLpjOwi9mFZPDHQx0rB5UyG36UukDTCzePLW/v9wHyzWXmw6
         3iZj2IDB2P6v7SdxGUDwwve4RBxhs4dBxxVg8jnpI2qlLc2xjMwvqL5kU/9e7PSAOizB
         b5OL49aW0fD7MULdwpyDUNWc8iFy219aQu5r5fJmQWtARH8vxLVZa791D8sgq2RdhJhF
         /8Dky+e1W5d6XNa5MVm3fJyyOYnjGqh/evPg8z/4hrklwK47hYtiOxVOjBDiEGeC5+e5
         ifww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DjOESrPx+LNX18fh9qfhKZ+KPyRBzNVp6MIp26IMeXY=;
        b=qpnI3YffJ3NkilDrylGE9UhdjzGCavvL2qGNfrplTDm8/cs8gTTJ7akt2geNHWLR+/
         M87QBJP5CvWcV7fgZqYrsmPKxd3vYPrwtxWza7PAYob4YVf/coxzFWtKkNbFTtJQpN/9
         V/xDo6bovYxjhgJaIBp+m1HgSo2gx8umcii2Ht9HRlVsMB0xfPkcMAVVs6H49/f59iJd
         nMmjjtImej9ABr7BRwkWb25ySFhz0q179oTci6Fs+qKxe35uhY32eM3JxeFhYzjY4rPd
         6dbM67I6IN9hINqD2v434/507WkjYJ+YdzaGW2rQhp+JoACkKRO8TFp0z4/2UjCqdCgI
         LFFQ==
X-Gm-Message-State: AGRZ1gJRGH3ZVESSbqgf8921a1sMVGrmOcaoot5FHUvkPeNm1tXFzGSi
        hrmCtfxobmYIaIJpMS8aPRra4A==
X-Google-Smtp-Source: AJdET5eqiyk2OGn04uLS3hlfRbTbPwj0U3PjWJBYhsPYxSUqp/qicx6znFMaWRavGC1+hem7C/qLAQ==
X-Received: by 2002:a62:2741:: with SMTP id n62-v6mr8098091pfn.138.1542313230689;
        Thu, 15 Nov 2018 12:20:30 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id u127-v6sm29173365pfb.47.2018.11.15.12.20.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 12:20:30 -0800 (PST)
Date:   Thu, 15 Nov 2018 12:20:28 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>,
        linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 03/19] block: use bio_for_each_bvec() to compute
 multi-page bvec count
Message-ID: <20181115202028.GC9348@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-4-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-4-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:50PM +0800, Ming Lei wrote:
> First it is more efficient to use bio_for_each_bvec() in both
> blk_bio_segment_split() and __blk_recalc_rq_segments() to compute how
> many multi-page bvecs there are in the bio.
> 
> Secondly once bio_for_each_bvec() is used, the bvec may need to be
> splitted because its length can be very longer than max segment size,
> so we have to split the big bvec into several segments.
> 
> Thirdly when splitting multi-page bvec into segments, the max segment
> limit may be reached, so the bio split need to be considered under
> this situation too.
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: Kent Overstreet <kent.overstreet@gmail.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Shaohua Li <shli@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Cc: linux-erofs@lists.ozlabs.org
> Cc: David Sterba <dsterba@suse.com>
> Cc: linux-btrfs@vger.kernel.org
> Cc: Darrick J. Wong <darrick.wong@oracle.com>
> Cc: linux-xfs@vger.kernel.org
> Cc: Gao Xiang <gaoxiang25@huawei.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: linux-ext4@vger.kernel.org
> Cc: Coly Li <colyli@suse.de>
> Cc: linux-bcache@vger.kernel.org
> Cc: Boaz Harrosh <ooo@electrozaur.com>
> Cc: Bob Peterson <rpeterso@redhat.com>
> Cc: cluster-devel@redhat.com
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-merge.c | 90 ++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 76 insertions(+), 14 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 91b2af332a84..6f7deb94a23f 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -160,6 +160,62 @@ static inline unsigned get_max_io_size(struct request_queue *q,
>  	return sectors;
>  }
>  
> +/*
> + * Split the bvec @bv into segments, and update all kinds of
> + * variables.
> + */
> +static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
> +		unsigned *nsegs, unsigned *last_seg_size,
> +		unsigned *front_seg_size, unsigned *sectors)
> +{
> +	bool need_split = false;
> +	unsigned len = bv->bv_len;
> +	unsigned total_len = 0;
> +	unsigned new_nsegs = 0, seg_size = 0;

"unsigned int" here and everywhere else.

> +	if ((*nsegs >= queue_max_segments(q)) || !len)
> +		return need_split;
> +
> +	/*
> +	 * Multipage bvec may be too big to hold in one segment,
> +	 * so the current bvec has to be splitted as multiple
> +	 * segments.
> +	 */
> +	while (new_nsegs + *nsegs < queue_max_segments(q)) {
> +		seg_size = min(queue_max_segment_size(q), len);
> +
> +		new_nsegs++;
> +		total_len += seg_size;
> +		len -= seg_size;
> +
> +		if ((queue_virt_boundary(q) && ((bv->bv_offset +
> +		    total_len) & queue_virt_boundary(q))) || !len)
> +			break;

Checking queue_virt_boundary(q) != 0 is superfluous, and the len check
could just control the loop, i.e.,

	while (len && new_nsegs + *nsegs < queue_max_segments(q)) {
		seg_size = min(queue_max_segment_size(q), len);

		new_nsegs++;
		total_len += seg_size;
		len -= seg_size;

		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
			break;
	}

And if you rewrite it this way, I _think_ you can get rid of this
special case:

	if ((*nsegs >= queue_max_segments(q)) || !len)
		return need_split;

above.

> +	}
> +
> +	/* split in the middle of the bvec */
> +	if (len)
> +		need_split = true;

need_split is unnecessary, just return len != 0.

> +
> +	/* update front segment size */
> +	if (!*nsegs) {
> +		unsigned first_seg_size = seg_size;
> +
> +		if (new_nsegs > 1)
> +			first_seg_size = queue_max_segment_size(q);
> +		if (*front_seg_size < first_seg_size)
> +			*front_seg_size = first_seg_size;
> +	}
> +
> +	/* update other varibles */
> +	*last_seg_size = seg_size;
> +	*nsegs += new_nsegs;
> +	if (sectors)
> +		*sectors += total_len >> 9;
> +
> +	return need_split;
> +}
> +
>  static struct bio *blk_bio_segment_split(struct request_queue *q,
>  					 struct bio *bio,
>  					 struct bio_set *bs,
> @@ -173,7 +229,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  	struct bio *new = NULL;
>  	const unsigned max_sectors = get_max_io_size(q, bio);
>  
> -	bio_for_each_segment(bv, bio, iter) {
> +	bio_for_each_bvec(bv, bio, iter) {
>  		/*
>  		 * If the queue doesn't support SG gaps and adding this
>  		 * offset would create a gap, disallow it.
> @@ -188,8 +244,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  			 */
>  			if (nsegs < queue_max_segments(q) &&
>  			    sectors < max_sectors) {
> -				nsegs++;
> -				sectors = max_sectors;
> +				/* split in the middle of bvec */
> +				bv.bv_len = (max_sectors - sectors) << 9;
> +				bvec_split_segs(q, &bv, &nsegs,
> +						&seg_size,
> +						&front_seg_size,
> +						&sectors);
>  			}
>  			goto split;
>  		}
> @@ -214,11 +274,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  		if (nsegs == 1 && seg_size > front_seg_size)
>  			front_seg_size = seg_size;

Hm, do we still need to check this here now that we're updating
front_seg_size inside of bvec_split_segs()?

>  
> -		nsegs++;
>  		bvprv = bv;
>  		bvprvp = &bvprv;
> -		seg_size = bv.bv_len;
> -		sectors += bv.bv_len >> 9;
> +
> +		if (bvec_split_segs(q, &bv, &nsegs, &seg_size,
> +					&front_seg_size, &sectors))

What happened to the indent alignment here?

> +			goto split;
>  
>  	}
>  
> @@ -296,6 +357,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  	struct bio_vec bv, bvprv = { NULL };
>  	int cluster, prev = 0;
>  	unsigned int seg_size, nr_phys_segs;
> +	unsigned front_seg_size = bio->bi_seg_front_size;
>  	struct bio *fbio, *bbio;
>  	struct bvec_iter iter;
>  
> @@ -316,7 +378,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  	seg_size = 0;
>  	nr_phys_segs = 0;
>  	for_each_bio(bio) {
> -		bio_for_each_segment(bv, bio, iter) {
> +		bio_for_each_bvec(bv, bio, iter) {
>  			/*
>  			 * If SG merging is disabled, each bio vector is
>  			 * a segment
> @@ -336,20 +398,20 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  				continue;
>  			}
>  new_segment:
> -			if (nr_phys_segs == 1 && seg_size >
> -			    fbio->bi_seg_front_size)
> -				fbio->bi_seg_front_size = seg_size;
> +			if (nr_phys_segs == 1 && seg_size > front_seg_size)
> +				front_seg_size = seg_size;

Same comment as in blk_bio_segment_split(), do we still need to check
this if we're updating front_seg_size in bvec_split_segs()?

>  
> -			nr_phys_segs++;
>  			bvprv = bv;
>  			prev = 1;
> -			seg_size = bv.bv_len;
> +			bvec_split_segs(q, &bv, &nr_phys_segs, &seg_size,
> +					&front_seg_size, NULL);
>  		}
>  		bbio = bio;
>  	}
>  
> -	if (nr_phys_segs == 1 && seg_size > fbio->bi_seg_front_size)
> -		fbio->bi_seg_front_size = seg_size;
> +	if (nr_phys_segs == 1 && seg_size > front_seg_size)
> +		front_seg_size = seg_size;
> +	fbio->bi_seg_front_size = front_seg_size;
>  	if (seg_size > bbio->bi_seg_back_size)
>  		bbio->bi_seg_back_size = seg_size;
>  
> -- 
> 2.9.5
> 
