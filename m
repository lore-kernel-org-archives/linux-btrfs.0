Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DE63C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 369342133F
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 22:37:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="S7vcjb+U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 369342133F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbeK0Jcy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 04:32:54 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40474 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbeK0Jcw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:32:52 -0500
Received: by mail-pf1-f196.google.com with SMTP id i12so7293917pfo.7
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Nov 2018 14:37:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uhf9PmeFp5uR8MyDNViNYXqSE9sP3pshz27LXMLouUY=;
        b=S7vcjb+U19LY2I8bQTvcI5HOgm6kZsNU+Q6URCPW/sybEbtvvK6srpBFp/F6Z8LHgG
         23/O9A9kK7tOawhnXjdBfkxsVb9/YtdfzvR9s8S/xhk/tMiXwzxqru0+9kzhjnww3EaQ
         Yly7Ol/pdTUr06oceR8TgobO7nHADdQW8zluRpEyVjWtNjAHI1XjD9BjTsoPZpH51dTX
         p/kOfiQQmrYpoNwb1oo64XRcH9xE0+E+n3V95AqxRU4PhVRusygyeHbKToS8Ya4p2Z5F
         S+UbKpDGXmFVqPWrTkvDU/NGqrVQDa563RfM1mY/DVr+jVX5/lfaV7HQ7HdCdPnY47pK
         cD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uhf9PmeFp5uR8MyDNViNYXqSE9sP3pshz27LXMLouUY=;
        b=CHUh9Fax9FH9Zg/o6sCouR6c5+Mibecfmy+9cAnUYB0Sfa+rLJ7XJTb4tLZliTwIZo
         hA4Uf7X1oK58WKIVdB6GQQzFPB214dyZp9wUVli3puwn8iUK+62VkEnCuK6fc1BlBtKk
         Hd9VKrRy3odTZyS04UlrIiInfro5pZh6TZIfX1bUSriSIANvlinRRThw5H2jqLM0kMKX
         kpKnIAJeRosnxckQmh1DRef8GA6YIaPGzKBIeS/eumI8BR3GkaZOEC3nFtU5aFjLidwi
         25Q3d+DS4QqGL5OZIhKXtd8UnElvDMtmNby5TMl3kc+lrUG4syKUYIXtZDwCRHX60bhA
         oIMw==
X-Gm-Message-State: AGRZ1gILtUC0PAftE434y+3CcdR66PjloVKzJHiyThsJBo9e1m+GtEyS
        nPGo1RcP+tJb+/I1sLcPdkFHAg==
X-Google-Smtp-Source: AJdET5cAwRsDVEEuvzYg9ba/mZpsL0wG01LG0brt2kuGgAFWPJZnVn3PjPLBst3i5b/NFB+TPt4k6g==
X-Received: by 2002:a62:1c06:: with SMTP id c6mr29538517pfc.157.1543271831916;
        Mon, 26 Nov 2018 14:37:11 -0800 (PST)
Received: from vader ([2601:602:8b00:55d3:e6a7:a0ff:fe0b:c9a8])
        by smtp.gmail.com with ESMTPSA id s184sm1677235pgc.38.2018.11.26.14.37.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Nov 2018 14:37:10 -0800 (PST)
Date:   Mon, 26 Nov 2018 14:37:09 -0800
From:   Omar Sandoval <osandov@osandov.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Theodore Ts'o <tytso@mit.edu>, Omar Sandoval <osandov@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Dave Chinner <dchinner@redhat.com>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        linux-raid@vger.kernel.org, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>,
        Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V12 09/20] block: use bio_for_each_bvec() to compute
 multi-page bvec count
Message-ID: <20181126223709.GI30411@vader>
References: <20181126021720.19471-1-ming.lei@redhat.com>
 <20181126021720.19471-10-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181126021720.19471-10-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 26, 2018 at 10:17:09AM +0800, Ming Lei wrote:
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

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-merge.c | 100 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 80 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 51ec6ca56a0a..2d8f388d43de 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -161,6 +161,70 @@ static inline unsigned get_max_io_size(struct request_queue *q,
>  	return sectors;
>  }
>  
> +static unsigned get_max_segment_size(struct request_queue *q,
> +				     unsigned offset)
> +{
> +	unsigned long mask = queue_segment_boundary(q);
> +
> +	return min_t(unsigned long, mask - (mask & offset) + 1,
> +		     queue_max_segment_size(q));
> +}
> +
> +/*
> + * Split the bvec @bv into segments, and update all kinds of
> + * variables.
> + */
> +static bool bvec_split_segs(struct request_queue *q, struct bio_vec *bv,
> +		unsigned *nsegs, unsigned *last_seg_size,
> +		unsigned *front_seg_size, unsigned *sectors)
> +{
> +	unsigned len = bv->bv_len;
> +	unsigned total_len = 0;
> +	unsigned new_nsegs = 0, seg_size = 0;
> +
> +	/*
> +	 * Multipage bvec may be too big to hold in one segment,
> +	 * so the current bvec has to be splitted as multiple
> +	 * segments.
> +	 */
> +	while (len && new_nsegs + *nsegs < queue_max_segments(q)) {
> +		seg_size = get_max_segment_size(q, bv->bv_offset + total_len);
> +		seg_size = min(seg_size, len);
> +
> +		new_nsegs++;
> +		total_len += seg_size;
> +		len -= seg_size;
> +
> +		if ((bv->bv_offset + total_len) & queue_virt_boundary(q))
> +			break;
> +	}
> +
> +	if (!new_nsegs)
> +		return !!len;
> +
> +	/* update front segment size */
> +	if (!*nsegs) {
> +		unsigned first_seg_size;
> +
> +		if (new_nsegs == 1)
> +			first_seg_size = get_max_segment_size(q, bv->bv_offset);
> +		else
> +			first_seg_size = queue_max_segment_size(q);
> +
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
> +	/* split in the middle of the bvec if len != 0 */
> +	return !!len;
> +}
> +
>  static struct bio *blk_bio_segment_split(struct request_queue *q,
>  					 struct bio *bio,
>  					 struct bio_set *bs,
> @@ -174,7 +238,7 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  	struct bio *new = NULL;
>  	const unsigned max_sectors = get_max_io_size(q, bio);
>  
> -	bio_for_each_segment(bv, bio, iter) {
> +	bio_for_each_bvec(bv, bio, iter) {
>  		/*
>  		 * If the queue doesn't support SG gaps and adding this
>  		 * offset would create a gap, disallow it.
> @@ -189,8 +253,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
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
> @@ -212,14 +280,12 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  		if (nsegs == queue_max_segments(q))
>  			goto split;
>  
> -		if (nsegs == 1 && seg_size > front_seg_size)
> -			front_seg_size = seg_size;
> -
> -		nsegs++;
>  		bvprv = bv;
>  		bvprvp = &bvprv;
> -		seg_size = bv.bv_len;
> -		sectors += bv.bv_len >> 9;
> +
> +		if (bvec_split_segs(q, &bv, &nsegs, &seg_size,
> +				    &front_seg_size, &sectors))
> +			goto split;
>  
>  	}
>  
> @@ -233,8 +299,6 @@ static struct bio *blk_bio_segment_split(struct request_queue *q,
>  			bio = new;
>  	}
>  
> -	if (nsegs == 1 && seg_size > front_seg_size)
> -		front_seg_size = seg_size;
>  	bio->bi_seg_front_size = front_seg_size;
>  	if (seg_size > bio->bi_seg_back_size)
>  		bio->bi_seg_back_size = seg_size;
> @@ -296,6 +360,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  {
>  	struct bio_vec bv, bvprv = { NULL };
>  	unsigned int seg_size, nr_phys_segs;
> +	unsigned front_seg_size = bio->bi_seg_front_size;
>  	struct bio *fbio, *bbio;
>  	struct bvec_iter iter;
>  	bool prev = false;
> @@ -316,7 +381,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  	seg_size = 0;
>  	nr_phys_segs = 0;
>  	for_each_bio(bio) {
> -		bio_for_each_segment(bv, bio, iter) {
> +		bio_for_each_bvec(bv, bio, iter) {
>  			/*
>  			 * If SG merging is disabled, each bio vector is
>  			 * a segment
> @@ -336,20 +401,15 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
>  				continue;
>  			}
>  new_segment:
> -			if (nr_phys_segs == 1 && seg_size >
> -			    fbio->bi_seg_front_size)
> -				fbio->bi_seg_front_size = seg_size;
> -
> -			nr_phys_segs++;
>  			bvprv = bv;
>  			prev = true;
> -			seg_size = bv.bv_len;
> +			bvec_split_segs(q, &bv, &nr_phys_segs, &seg_size,
> +					&front_seg_size, NULL);
>  		}
>  		bbio = bio;
>  	}
>  
> -	if (nr_phys_segs == 1 && seg_size > fbio->bi_seg_front_size)
> -		fbio->bi_seg_front_size = seg_size;
> +	fbio->bi_seg_front_size = front_seg_size;
>  	if (seg_size > bbio->bi_seg_back_size)
>  		bbio->bi_seg_back_size = seg_size;
>  
> -- 
> 2.9.5
> 
