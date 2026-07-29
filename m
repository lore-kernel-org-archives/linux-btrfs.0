Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75740449B0D
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 11:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785323042; cv=none; b=aLa3X1HKT+mlgPU0l5sp7oPbv1+BSWtaWlWjXQz2vej46uCwrFdaskZItIP9Lo8TTF2TAes8323/3DF5mMvGHUM2w2yK3UXd/VkxYu+yv/KFXTZOOGFEZm0zwXDvq7G3tuBvO8xzDEXrNzkBBtuc1rl+V3I0srcBk2WXo4nmq44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785323042; c=relaxed/simple;
	bh=udEcdzuH9IWqf5RctvY9uv48hr6A/o6aMv5KW839on8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dnKUlqgzxAwcPQf6oXO4bc/SyaA8gvy4NTIbFYS95UyCfKOVu/PNnGghUBbFkzTyi6O3tERiMqlON+US1iBDwbqNcfdD1Kq6YW5o6mg+57IIjUC92ARAxi3O35pEWMFF8sGv2fzDglLDJ8s7N1/qb7bInqH/K3W/t6rFclbBXuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V/dNijQj; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V/dNijQj"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15dd4b9132so123794166b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2026 04:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785323038; x=1785927838; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vraWe+r+JAvmwr9JBnRk+mSRMk+dBSFMePa2l4q/GaQ=;
        b=V/dNijQju9uACt1iZViHkvpeE0F0EuqD4v40OCTWY/GBU3QbCRQbKk5qHYvd+Eoj2q
         qJAZoT6rd//l5hzy54OL10iE5sYHxFuFsu8qzJfOCnJWYERVwclsMCMkbI9AlSH0MnXC
         ld8FuWAZ3mqGM9hNWTWJ8rWoILOs/Kfopqk/VySnZFFgaj7s84LugmZBGxM+22I/QJxb
         qfzUrKNuvIZ5nbBL/GKgc+pNCZ2H0PKWI9jnYdsI7GacdaORHrcJbzyT/ACVeVtrlZmD
         MDPpcIcz/dE7NzPYKti9Mc3G45HDj/yVSx/5QzlprRj+FTSWmCcc90dMZ7mxIxSiJQPD
         EdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785323038; x=1785927838;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vraWe+r+JAvmwr9JBnRk+mSRMk+dBSFMePa2l4q/GaQ=;
        b=JaahDCSnAn7foqHNoB1YnR9C089WcSHNSYRYhHXqg/WPE5dvT8N4rXOBEL4pvU6rW9
         EteBipa1JRV+OuOHtu7SRe/BTv9csOMZMdRo/xXTxWA/Lt9vIgyM+P3OqpfnIbl32AoN
         LySijbk2PswUnqXiPd9pSHsVJRhW4lrZLZ0f/QVaPYK8Qg3p0jIOImkZfkK8so/zbEDW
         ggcfr35Tc3LGBH2NrAHYXf2qRzCpT8X9TFxVGyksuFSlb8aMPmK5BvrjM5CPOL3Nt7Yp
         Tnw7xuvUyL78XtnJ3WOyUZjJy2YoN1VvE+ABW5+2vQX04rqY1VPnci2uVGt6Nzie2DGf
         5zcw==
X-Forwarded-Encrypted: i=1; AHgh+RpAln+qtknK3sJvb94TjnOonT7qOGEbuMf4Yj8afnaqMagMvnthVjvFAEcgg+jonRlh52avrirG5LisQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxNSbKbGA5ORTqdmjI/Ix3hR0PjVU2Y1b8hN0bfLScf5BwH8G0S
	kWU0vDyR7QbSUCeZQr7/qEgB0WJFKt9xUCgcMNakAZvi+xv5746HCmVK
X-Gm-Gg: AR+sD12rXe00jhLC3ENkyGGgfJ+1GH83KZw9mOyg5MRFGcRlr7DALt1YzOltqkabeic
	mBYhGlyzPogpWez7WedKqL0HbQscbDwiit6SsQSDIJGxxfL6LFVbDpS1wKi1v0sjbbeJ2CucRYL
	K2g9FjuT8bFAd7AyRegT4IwyBofpLGp4x1iji2CnCJjMOBluOQ2Y3vYbqVVjOGA1Ub0s6SFVIvW
	2FUN3lV/Gsc9sycB32yqDDZ3sy/wK41GcniGXZdWvxF3DOIRlxEslxN/MvkO49QHvVLGcmxsVyW
	VVJyItLy/oOWBI+d5iG1xavOE8ZQ+1xquy17eI2iFRsYgfvYQO1fT/hEoYWqnqJD5S9t4p729tK
	mmsY8VvwFgEbidCGxSM8q67El8fp9Ecb3isMLYr600MHqbF33x3f3dbsPcWSQAEEzGfiIk5A9Hi
	Xs8Vn8pQR5R6RAeAXq2P1ZhLlOSn7CkGwoQ1vtfQIUHYIur05O3bW72x3lOs6CTn880/hL64Vtg
	zMp1GjJY087XuRBPQDI9OJjbCQ5+PmTumI6ltrnorbyo32x46wcA8R7dUTQatBJSLt54H4KS3zM
	NRe96W4KCCjYwMlJSN4=
X-Received: by 2002:a17:907:5c5:b0:c12:8cbe:b897 with SMTP id a640c23a62f3a-c1f7209f906mr333725866b.15.1785323037380;
        Wed, 29 Jul 2026 04:03:57 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:640])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1f83c6858asm99322666b.10.2026.07.29.04.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 04:03:56 -0700 (PDT)
Message-ID: <e3dff1e5-8b66-49d7-9a47-88a9d26c5c10@gmail.com>
Date: Wed, 29 Jul 2026 12:03:46 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/14] block: introduce dma map backed bio type
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <f97985ac5cfff3d9f7777b93f11456af57e253e2.1785274111.git.asml.silence@gmail.com>
 <20260729070727.GF9534@lst.de>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20260729070727.GF9534@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/29/26 08:07, Christoph Hellwig wrote:
>> -	bio->bi_io_vec = bio_src->bi_io_vec;
>> +
>> +	if (op_is_dmabuf(bio->bi_opf)) {
>> +		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
>> +	} else {
>> +		bio->bi_io_vec = bio_src->bi_io_vec;
>> +	}
> 
> No need for the braces.  

Got it,

But given that these are the fields why
> even bother doing both sides and not rely on the union?

Compiles into the same, but comparing to a comment makes
the compiler to check it for us if anything happens.

Noticed static_assert() below, that works as well, though I
think the current version is nicer b/c it preserves assignment
types for the compiler. Strict aliasing is obviously not a
thing, so don't have a strong opinion.

>> +void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter)
>> +{
>> +	WARN_ON_ONCE(bio->bi_max_vecs);
>> +
>> +	bio->bi_dmabuf_map = iter->dmabuf_map;
>> +	bio->bi_vcnt = 0;
>> +	bio->bi_iter.bi_offset = iter->iov_offset;
>> +	bio->bi_iter.bi_size = iov_iter_count(iter);
>> +	bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
> 
> This seems to be largely copied from bio_iov_bvec_set, but misses
> the REQ_CLONE there that we should probably set as well to indicate
> that the data descriptor is not owned (although not setting it is
> not really a bug).
> 
> What about merging these two into a single and easier to use interface
> like this:

No opinion on this, I can add it, probably as another prep patch.


> diff --git a/block/bio.c b/block/bio.c
> index cc2bb9183c1a..25393bdd119d 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -860,12 +860,9 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
>   	bio->bi_write_hint = bio_src->bi_write_hint;
>   	bio->bi_write_stream = bio_src->bi_write_stream;
>   	bio->bi_iter = bio_src->bi_iter;
> -
> -	if (op_is_dmabuf(bio->bi_opf)) {
> -		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
> -	} else {
> -		bio->bi_io_vec = bio_src->bi_io_vec;
> -	}
> +	static_assert(offsetof(struct bio, bi_io_vec) ==
> +		      offsetof(struct bio, bi_dmabuf_map));
> +	bio->bi_io_vec = bio_src->bi_io_vec;
>   
>   	if (bio->bi_bdev) {
>   		if (bio->bi_bdev == bio_src->bi_bdev &&
> @@ -1186,26 +1183,21 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty)
>   }
>   EXPORT_SYMBOL_GPL(__bio_release_pages);
>   
> -void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
> +bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
>   {
>   	WARN_ON_ONCE(bio->bi_max_vecs);
>   
> +	if (!iov_iter_is_bvec(iter) && !iov_iter_is_dmabuf_map(iter))
> +		return false;
> +
>   	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
>   	bio->bi_iter.bi_idx = 0;
>   	bio->bi_iter.bi_offset = iter->iov_offset;
>   	bio->bi_iter.bi_size = iov_iter_count(iter);
>   	bio_set_flag(bio, BIO_CLONED);
> -}
> -
> -void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter)
> -{
> -	WARN_ON_ONCE(bio->bi_max_vecs);
> -
> -	bio->bi_dmabuf_map = iter->dmabuf_map;
> -	bio->bi_vcnt = 0;
> -	bio->bi_iter.bi_offset = iter->iov_offset;
> -	bio->bi_iter.bi_size = iov_iter_count(iter);
> -	bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
> +	if (iov_iter_is_dmabuf_map(iter))
> +		bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
> +	return true;
>   }
>   
>   /*
> @@ -1265,13 +1257,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>   	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>   		return -EIO;
>   
> -	if (iov_iter_is_bvec(iter)) {
> -		bio_iov_bvec_set(bio, iter);
> -		iov_iter_advance(iter, bio->bi_iter.bi_size);
> -		return 0;
> -	}
> -	if (iov_iter_is_dmabuf_map(iter)) {
> -		bio_dmabuf_map_set(bio, iter);
> +	if (bio_iov_iter_set(bio, iter)) {
>   		iov_iter_advance(iter, bio->bi_iter.bi_size);
>   		return 0;
>   	}
> diff --git a/block/blk-map.c b/block/blk-map.c
> index d1d6bbe0ecf1..34816e6e64de 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -473,7 +473,7 @@ static int blk_rq_map_user_bvec(struct request *rq, const struct iov_iter *iter)
>   	bio = blk_rq_map_bio_alloc(rq, 0, GFP_KERNEL);
>   	if (!bio)
>   		return -ENOMEM;
> -	bio_iov_bvec_set(bio, iter);
> +	bio_iov_iter_set(bio, iter);
>   
>   	ret = blk_rq_append_bio(rq, bio);
>   	if (ret)
> diff --git a/block/fops.c b/block/fops.c
> index d83cdbab65a6..97fb124a19b2 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -340,17 +340,12 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
>   	bio->bi_end_io = blkdev_bio_end_io_async;
>   	bio->bi_ioprio = iocb->ki_ioprio;
>   
> -	if (iov_iter_is_bvec(iter)) {
> -		/*
> -		 * Users don't rely on the iterator being in any particular
> -		 * state for async I/O returning -EIOCBQUEUED, hence we can
> -		 * avoid expensive iov_iter_advance(). Bypass
> -		 * bio_iov_iter_get_pages() and set the bvec directly.
> -		 */
> -		bio_iov_bvec_set(bio, iter);
> -	} else if (iov_iter_is_dmabuf_map(iter)) {
> -		bio_dmabuf_map_set(bio, iter);
> -	} else {
> +	/*
> +	 * Users don't rely on the iterator being in any particular state for
> +	 * async I/O returning -EIOCBQUEUED, hence we can avoid the expensive
> +	 * iov_iter_advance() if we could set the bvec/dmabuf directly.
> +	 */
> +	if (!bio_iov_iter_set(bio, iter)) {
>   		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
>   		if (unlikely(ret))
>   			goto out_bio_put;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index c053e9444514..1eff02a843ef 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -484,8 +484,7 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
>   int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>   		unsigned len_align_mask);
>   
> -void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
> -void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter);
> +bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter);
>   void __bio_release_pages(struct bio *bio, bool mark_dirty);
>   extern void bio_set_pages_dirty(struct bio *bio);
>   extern void bio_check_pages_dirty(struct bio *bio);

-- 
Pavel Begunkov

