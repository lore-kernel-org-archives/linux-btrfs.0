Return-Path: <SRS0=zp8L=SK=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F8EC282DE
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 06:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBE2D20870
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Apr 2019 06:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfDHGIA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:08:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:56532 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725854AbfDHGH7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Apr 2019 02:07:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2A050AF6E;
        Mon,  8 Apr 2019 06:07:57 +0000 (UTC)
Subject: Re: [PATCH] block: don't use for-inside-for in
 bio_for_each_segment_all
To:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Qu Wenruo <quwenruo.btrfs@gmx.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Omar Sandoval <osandov@fb.com>
References: <20190406215428.3131-1-ming.lei@redhat.com>
 <20190407065205.GA8799@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f0c82caf-24f3-dba7-0bf0-85dd0e056e73@suse.de>
Date:   Mon, 8 Apr 2019 08:07:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190407065205.GA8799@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 4/7/19 8:52 AM, Christoph Hellwig wrote:
> The change itself looks fine to be, but a few comments on semingly
> unrelated changes:
> 
>> +#define bio_for_each_segment_all(bvl, bio, i, iter_all)			\
>> +	for (i = 0, bvl = bvec_init_iter_all(&iter_all);		\
>> +		iter_all.idx < (bio)->bi_vcnt &&			\
>> +		(mp_bvec_advance(&((bio)->bi_io_vec[iter_all.idx]),	\
>> +				 &iter_all), 1); i++)
> 
> Instead of the complicated expression inside the for loop test
> expression can't we move the index check into mp_bvec_advance and let
> it return a bool?
> 
>> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
>> index f6275c4da13a..6e4996dfc847 100644
>> --- a/include/linux/bvec.h
>> +++ b/include/linux/bvec.h
>> @@ -48,7 +48,7 @@ struct bvec_iter {
>>   struct bvec_iter_all {
>>   	struct bio_vec	bv;
>>   	int		idx;
>> -	unsigned	done;
>> +	unsigned	bv_done;
> 
> Why the rename here?
> 
>> +static inline void mp_bvec_advance(const struct bio_vec *bvec,
>> +				   struct bvec_iter_all *iter_all)
> 
> If we rename this we should probably drop the mp_ prefix..
> 
> Also not for this patch, but we should really consider moving this
> function out of line given how big it is.
> 
> 
> Here is how I'd do this with my slight changes:
> 
> 
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index bb915591557b..fd7629ac9f11 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -120,19 +120,42 @@ static inline bool bio_full(struct bio *bio)
>   	return bio->bi_vcnt >= bio->bi_max_vecs;
>   }
>   
> -#define mp_bvec_for_each_segment(bv, bvl, i, iter_all)			\
> -	for (bv = bvec_init_iter_all(&iter_all);			\
> -		(iter_all.done < (bvl)->bv_len) &&			\
> -		(mp_bvec_next_segment((bvl), &iter_all), 1);		\
> -		iter_all.done += bv->bv_len, i += 1)
> +static inline bool __bio_next_segment_all(struct bio *bio,
> +		struct bvec_iter_all *iter_all)
> +{
> +	struct bio_vec *bvec = &bio->bi_io_vec[iter_all->idx];
> +	struct bio_vec *bv = &iter_all->bv;
> +
> +	if (iter_all->idx >= bio->bi_vcnt)
> +		return false;
> +
> +	if (iter_all->done) {
> +		bv->bv_page = nth_page(bv->bv_page, 1);
> +		bv->bv_offset = 0;
> +	} else {
> +		bv->bv_page = bvec->bv_page;
> +		bv->bv_offset = bvec->bv_offset;
> +	}
> +	bv->bv_len = min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
> +			   bvec->bv_len - iter_all->done);
> +	iter_all->done += bv->bv_len;
> +
> +	if (iter_all->done == bvec->bv_len) {
> +		iter_all->idx++;
> +		iter_all->done = 0;
> +	}
> +
> +	return true;
> +}
>   
>   /*
>    * drivers should _never_ use the all version - the bio may have been split
>    * before it got to the driver and the driver won't own all of it
>    */
> -#define bio_for_each_segment_all(bvl, bio, i, iter_all)		\
> -	for (i = 0, iter_all.idx = 0; iter_all.idx < (bio)->bi_vcnt; iter_all.idx++)	\
> -		mp_bvec_for_each_segment(bvl, &((bio)->bi_io_vec[iter_all.idx]), i, iter_all)
> +#define bio_for_each_segment_all(bvl, bio, i, iter_all)			\
> +	for (i = 0, bvl = bvec_init_iter_all(&iter_all);		\
> +	     __bio_next_segment_all(bio, &iter_all);			\
> +	     i++)
>   
>   static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
>   				    unsigned bytes)
> diff --git a/include/linux/bvec.h b/include/linux/bvec.h
> index f6275c4da13a..bcebfc522498 100644
> --- a/include/linux/bvec.h
> +++ b/include/linux/bvec.h
> @@ -145,28 +145,12 @@ static inline bool bvec_iter_advance(const struct bio_vec *bv,
>   
>   static inline struct bio_vec *bvec_init_iter_all(struct bvec_iter_all *iter_all)
>   {
> -	iter_all->bv.bv_page = NULL;
>   	iter_all->done = 0;
> +	iter_all->idx = 0;
>   
>   	return &iter_all->bv;
>   }
>   
> -static inline void mp_bvec_next_segment(const struct bio_vec *bvec,
> -					struct bvec_iter_all *iter_all)
> -{
> -	struct bio_vec *bv = &iter_all->bv;
> -
> -	if (bv->bv_page) {
> -		bv->bv_page = nth_page(bv->bv_page, 1);
> -		bv->bv_offset = 0;
> -	} else {
> -		bv->bv_page = bvec->bv_page;
> -		bv->bv_offset = bvec->bv_offset;
> -	}
> -	bv->bv_len = min_t(unsigned int, PAGE_SIZE - bv->bv_offset,
> -			   bvec->bv_len - iter_all->done);
> -}
> -
>   /*
>    * Get the last single-page segment from the multi-page bvec and store it
>    * in @seg
> 
Oh yes, please do.
The macros are fast becoming unparseable :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
