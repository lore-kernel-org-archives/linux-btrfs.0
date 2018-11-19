Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA9DC43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 03:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E82F2089D
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 03:31:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8E82F2089D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbeKSNx5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 08:53:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728322AbeKSNx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 08:53:56 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C321B58E31;
        Mon, 19 Nov 2018 03:31:42 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 292C71019627;
        Mon, 19 Nov 2018 03:31:15 +0000 (UTC)
Date:   Mon, 19 Nov 2018 11:31:11 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
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
        Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org,
        Boaz Harrosh <ooo@electrozaur.com>,
        Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com
Subject: Re: [PATCH V10 02/19] block: introduce bio_for_each_bvec()
Message-ID: <20181119033110.GE10838@ming.t460p>
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-3-ming.lei@redhat.com>
 <20181116133028.GB3165@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116133028.GB3165@lst.de>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Mon, 19 Nov 2018 03:31:43 +0000 (UTC)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 16, 2018 at 02:30:28PM +0100, Christoph Hellwig wrote:
> > +static inline void __bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> > +				      unsigned bytes, bool mp)
> 
> I think these magic 'bool np' arguments and wrappers over wrapper
> don't help anyone to actually understand the code.  I'd vote for
> removing as many wrappers as we really don't need, and passing the
> actual segment limit instead of the magic bool flag.  Something like
> this untested patch:

I think this way is fine, just a little comment.

> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 277921ad42e7..dcad0b69f57a 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -138,30 +138,21 @@ static inline bool bio_full(struct bio *bio)
>  		bvec_for_each_segment(bvl, &((bio)->bi_io_vec[iter_all.idx]), i, iter_all)
>  
>  static inline void __bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
> -				      unsigned bytes, bool mp)
> +				      unsigned bytes, unsigned max_segment)

The new parameter should have been named as 'max_segment_len' or
'max_seg_len'.

>  {
>  	iter->bi_sector += bytes >> 9;
>  
>  	if (bio_no_advance_iter(bio))
>  		iter->bi_size -= bytes;
>  	else
> -		if (!mp)
> -			bvec_iter_advance(bio->bi_io_vec, iter, bytes);
> -		else
> -			mp_bvec_iter_advance(bio->bi_io_vec, iter, bytes);
> +		__bvec_iter_advance(bio->bi_io_vec, iter, bytes, max_segment);
>  		/* TODO: It is reasonable to complete bio with error here. */
>  }
>  
>  static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
>  				    unsigned bytes)
>  {
> -	__bio_advance_iter(bio, iter, bytes, false);
> -}
> -
> -static inline void bio_advance_mp_iter(struct bio *bio, struct bvec_iter *iter,
> -				       unsigned bytes)
> -{
> -	__bio_advance_iter(bio, iter, bytes, true);
> +	__bio_advance_iter(bio, iter, bytes, PAGE_SIZE);
>  }
>  
>  #define __bio_for_each_segment(bvl, bio, iter, start)			\
> @@ -177,7 +168,7 @@ static inline void bio_advance_mp_iter(struct bio *bio, struct bvec_iter *iter,
>  	for (iter = (start);						\
>  	     (iter).bi_size &&						\
>  		((bvl = bio_iter_mp_iovec((bio), (iter))), 1);	\
> -	     bio_advance_mp_iter((bio), &(iter), (bvl).bv_len))
> +	     __bio_advance_iter((bio), &(iter), (bvl).bv_len, 0))

Even we might pass '-1' for multi-page segment.

>  
>  /* returns one real segment(multipage bvec) each time */
>  #define bio_for_each_bvec(bvl, bio, iter)			\
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index 02f26d2b59ad..5e2ed46c1c88 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -138,8 +138,7 @@ struct bvec_iter_all {
>  })
>  
>  static inline bool __bvec_iter_advance(const struct bio_vec *bv,
> -				       struct bvec_iter *iter,
> -				       unsigned bytes, bool mp)
> +		struct bvec_iter *iter, unsigned bytes, unsigned max_segment)
>  {
>  	if (WARN_ONCE(bytes > iter->bi_size,
>  		     "Attempted to advance past end of bvec iter\n")) {
> @@ -148,18 +147,18 @@ static inline bool __bvec_iter_advance(const struct bio_vec *bv,
>  	}
>  
>  	while (bytes) {
> -		unsigned len;
> +		unsigned segment_len = mp_bvec_iter_len(bv, *iter);
>  
> -		if (mp)
> -			len = mp_bvec_iter_len(bv, *iter);
> -		else
> -			len = bvec_iter_len(bv, *iter);
> +		if (max_segment) {
> +			max_segment -= bvec_iter_offset(bv, *iter);
> +			segment_len = min(segment_len, max_segment);

Looks 'max_segment' needs to be constant, shouldn't be updated.

If '-1' is passed for multipage case, the above change may become:

		segment_len = min_t(segment_len, max_seg_len - bvec_iter_offset(bv, *iter));

This way is more clean, but with extra cost of the above line for multipage
case.

Thanks,
Ming
