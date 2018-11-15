Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F93C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 22:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20C022145D
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 22:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="kuiKUdcP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 20C022145D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbeKPInp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 16 Nov 2018 03:43:45 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42617 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbeKPInp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Nov 2018 03:43:45 -0500
Received: by mail-pl1-f196.google.com with SMTP id x21-v6so7420415pln.9
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2018 14:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a098WawebiQEI35+UC6o+h5gSwtB4cT8kXe3OZC4l0Y=;
        b=kuiKUdcPwp6i0ipF7JnmuAigwlNOsM4+m6qSabIm42If8aj+totidZe5lZiL7oO3kz
         BAhagr77MnqmgZ7eJWQg3VCHfO5DQAu5B/ELsVk1Ogyjyde/Jq4fE19hf3kEDo9ep/C3
         calrtB9C3oEy/4eL96VN4o8NMKFKYA8fxw68HkD+pWc0fD9c9qT2nDmt2/bQQ6GcYiEv
         aOXHIkQkKlwuRbZLR0ZwByLvFrDZQeTCmWv+ruWgn2KZ5YUt2NnmCOEigJr7YfMzztyX
         gw6owHpEOl6KBog3pwkQmq66aF+B1cskdGh1Ug/PjRWSu/6ZuRFFodoysD09sNm4r7oP
         s01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a098WawebiQEI35+UC6o+h5gSwtB4cT8kXe3OZC4l0Y=;
        b=HxFpObri28S3MN4YqIJENWTAY9JrsdGeegscJazy1M0IrIoISeSFXRHQWNtP5xJziv
         0xWmSiyNNlJUOVDkbB0sg5XMARj9N6IE4QUTMck5/Rq6FFCqH9IAyjH8IT4f4XPTUPqX
         vavU2RUVRk8pnfu9jvx5XXTPg3r83CacxP5ITI64Nt01aoa8p6SNeql3yZnVPltpRB/w
         EAZqTePcY52Q9zRd2H0M0tJJqS0KGuwx6ZWSvapyQ7iD5Nxua2v8NGzCVCxytLJ9fI7E
         /5E66xb1xAbpLM1uJnEbXPsPrmfFptSkMYcFwRibip0hySDFdae5o0mJQP4wKD1x6U57
         NEdg==
X-Gm-Message-State: AGRZ1gLGoh7saDKhxFDcs93u15YlHa1oYCyEEEYr4/gyAt0HX9Fqql4f
        tjFzIBHk1y4yWs6q/bNBfM4z7Q==
X-Google-Smtp-Source: AJdET5dmw/PuqSJI5XAo05F8Etf2qQJnLYladxMDCUzBzACO+pRIj9hKSJx7qc0yli6+d8UR+CjTyg==
X-Received: by 2002:a17:902:128c:: with SMTP id g12-v6mr7885468pla.143.1542321241844;
        Thu, 15 Nov 2018 14:34:01 -0800 (PST)
Received: from vader ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id h128sm32821115pgc.15.2018.11.15.14.34.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Nov 2018 14:34:01 -0800 (PST)
Date:   Thu, 15 Nov 2018 14:33:58 -0800
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
Subject: Re: [PATCH V10 04/19] block: use bio_for_each_bvec() to map sg
Message-ID: <20181115223358.GE9348@vader>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-5-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115085306.9910-5-ming.lei@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 04:52:51PM +0800, Ming Lei wrote:
> It is more efficient to use bio_for_each_bvec() to map sg, meantime
> we have to consider splitting multipage bvec as done in blk_bio_segment_split().
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

Reviewed-by: Omar Sandoval <osandov@fb.com>

> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-merge.c | 72 +++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 20 deletions(-)
> 
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 6f7deb94a23f..cb9f49bcfd36 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -473,6 +473,56 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
>  	return biovec_phys_mergeable(q, &end_bv, &nxt_bv);
>  }
>  
> +static struct scatterlist *blk_next_sg(struct scatterlist **sg,
> +		struct scatterlist *sglist)
> +{
> +	if (!*sg)
> +		return sglist;
> +	else {
> +		/*
> +		 * If the driver previously mapped a shorter
> +		 * list, we could see a termination bit
> +		 * prematurely unless it fully inits the sg
> +		 * table on each mapping. We KNOW that there
> +		 * must be more entries here or the driver
> +		 * would be buggy, so force clear the
> +		 * termination bit to avoid doing a full
> +		 * sg_init_table() in drivers for each command.
> +		 */
> +		sg_unmark_end(*sg);
> +		return sg_next(*sg);
> +	}
> +}
> +
> +static unsigned blk_bvec_map_sg(struct request_queue *q,
> +		struct bio_vec *bvec, struct scatterlist *sglist,
> +		struct scatterlist **sg)
> +{
> +	unsigned nbytes = bvec->bv_len;
> +	unsigned nsegs = 0, total = 0;
> +
> +	while (nbytes > 0) {
> +		unsigned seg_size;
> +		struct page *pg;
> +		unsigned offset, idx;
> +
> +		*sg = blk_next_sg(sg, sglist);
> +
> +		seg_size = min(nbytes, queue_max_segment_size(q));
> +		offset = (total + bvec->bv_offset) % PAGE_SIZE;
> +		idx = (total + bvec->bv_offset) / PAGE_SIZE;
> +		pg = nth_page(bvec->bv_page, idx);
> +
> +		sg_set_page(*sg, pg, seg_size, offset);
> +
> +		total += seg_size;
> +		nbytes -= seg_size;
> +		nsegs++;
> +	}
> +
> +	return nsegs;
> +}
> +
>  static inline void
>  __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
>  		     struct scatterlist *sglist, struct bio_vec *bvprv,
> @@ -490,25 +540,7 @@ __blk_segment_map_sg(struct request_queue *q, struct bio_vec *bvec,
>  		(*sg)->length += nbytes;
>  	} else {
>  new_segment:
> -		if (!*sg)
> -			*sg = sglist;
> -		else {
> -			/*
> -			 * If the driver previously mapped a shorter
> -			 * list, we could see a termination bit
> -			 * prematurely unless it fully inits the sg
> -			 * table on each mapping. We KNOW that there
> -			 * must be more entries here or the driver
> -			 * would be buggy, so force clear the
> -			 * termination bit to avoid doing a full
> -			 * sg_init_table() in drivers for each command.
> -			 */
> -			sg_unmark_end(*sg);
> -			*sg = sg_next(*sg);
> -		}
> -
> -		sg_set_page(*sg, bvec->bv_page, nbytes, bvec->bv_offset);
> -		(*nsegs)++;
> +		(*nsegs) += blk_bvec_map_sg(q, bvec, sglist, sg);
>  	}
>  	*bvprv = *bvec;
>  }
> @@ -530,7 +562,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
>  	int cluster = blk_queue_cluster(q), nsegs = 0;
>  
>  	for_each_bio(bio)
> -		bio_for_each_segment(bvec, bio, iter)
> +		bio_for_each_bvec(bvec, bio, iter)
>  			__blk_segment_map_sg(q, &bvec, sglist, &bvprv, sg,
>  					     &nsegs, &cluster);
>  
> -- 
> 2.9.5
> 
