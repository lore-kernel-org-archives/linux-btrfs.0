Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0693EDAD5
	for <linux-btrfs@vger.kernel.org>; Thu,  3 Sep 2026 06:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788417964; cv=none; b=F65amyp2TC84R/jAVJO7PueqRvGMy8pA9IQ7jlzIHQYN5XegeIzYmYjtE4rGLatrkT8egTTcaM2T4t3iKnNC5R8WEMMT1REnp6oNFrgzVyNxOwzkvdaQFI//K3nLXn4WSFUeizFD2OsDtMSiNXJhifo57yDiCsRImPOOf2Ky++U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788417964; c=relaxed/simple;
	bh=grvph8If3lzlAPYT4Gy+DR3UaTxrnwsGsahzCiaJkgw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GOcMEkn+1ngGJhFZBWdqOC0O05oTmJZ4NzmdQVCs/EH7YicHbZMp/vh+5Ov3thCZAV0blPpC7ixeqUYm2vlxx8qO3oPGXaQXGVgzI7UOIOu9b7vfWFAaOQOSTVBCjBsez0eFVMSLeRB2rhbcRQs0eYyJgRY+BKrOXK7fMTqBOMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UUPOPmka; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UUPOPmka"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so15765265e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Sep 2026 23:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788417960; x=1789022760; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2fbpGmqELrmjcqUZI6/pjcd+E3CRw7Dc23xtKRKM6wo=;
        b=UUPOPmkaQFiHC+fEGaFagmBii8kfSVyvPN7S1vtnHxUAOza4vDjeaa7sgt0bnlh7YF
         lY9p7hu5DAYnGAAsjxUOIfdO6ma+cgeLn87b0xKBAvqSvCM0ppKEnL+hUTvhQNTvTgso
         5d+8wRoCTQaD3EQguKHCD7dK9ZjyhrteB5Xt2Gp14lBubhq8jwLVKHST9ZbtwQtflazb
         vXpxFkhkaRJ9KLivqTgCuyXGLlsnmTR5/+puNDnf16Mg+7Af30veWnrLZAEGewFWA9xz
         Ks+37XgBsi5h2TFzGqJ0T/fRa9Bpq3tXjc621GUd6DTn4JGnWn5Am/rWA2dHl81EcBqV
         4I/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788417960; x=1789022760;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2fbpGmqELrmjcqUZI6/pjcd+E3CRw7Dc23xtKRKM6wo=;
        b=PNuRWZH8efrsCEJVUaRYqPdRkQB1n0BkjL7vGfMThxWncZqUETiQ42AwXTfJ9C+kXN
         Xpo6u1np260H/kVCJB/fzBQVL+O7BYxBzof9Hd30TIkQi3ZtMIa70Je3J0y4PnVYNGS9
         jtM+SM+zAXtDXvyJIAOSLKDZVJTr5zcQjHw9BQA7RXzqXV6pAw40S7KtnytD5drNxeIm
         pln1VeMZwELWEh/X0vAONYV/DAFlCitdp00d6QuxXS26qZrzIVhnVBZk16GbNqjUabmr
         KUf/3+Ku+baDGxOdLHUE6ZX+RBclmWXbtLS7QWM1t6dYfBKMQw50m/emJ82E0dPjbqDa
         h9FA==
X-Gm-Message-State: AFuF++nwU9TtS1vqpYPnYByHFqKxcZPqSICHIzDA2sNm6hNuKaISZ4Jj
	FEQ7+WMnvCiCcrXRfwtG63vZNHQeGoPCvoRGirHditw96kUyoLeH9tIkcPSd03NHkh8=
X-Gm-Gg: AYBFou0Tr4rYtY/PrTQf5SYQXEwkSECGCYqM238JYQKnsg5CpWgiJkjJ8Rr3q+Y2Icu
	q1Fes1KblNFoYYjPz7haMMdI2aaFUeEQQoanuoXlRnpCKVz1+WyBYeRP+j++nFskbzUKHugeTqC
	hkwlnoPgQEB6GaQmgi3qz5B92+rj3cyX4tZyNF52O55eMuMIoFbASoJT2P4lAaOQla0ytj0RriT
	e/xUJeSdSmpScy+FfQVEjYtCv2p/tkBYqPP5ZcEyjJ1FuP66zBM0ccqvqSMdp/jpyn59wo9yA/M
	mz/j25iwkQ7VRGEbu7DFkZBaGRK/T3oXZx6N0+BNqmhjtYKAY/3LJ9s7EeBJunMZvzf0MJ+kXyJ
	hTNBFPe7FCx8sLwKa7381l8a8uK7pxrcdS1B0fxp29TmsOrBcrfzQP16Gd8jyTS17kZuDDkJnzu
	oDkDPUb6j+rS9tXm/4aO1Gn9wEiaQiKDbvGNosJALPMfJNbwmeXsyA
X-Received: by 2002:a05:600c:4e16:b0:49c:ee06:9c58 with SMTP id 5b1f17b1804b1-49cee069c79mr92774505e9.4.1788417959140;
        Wed, 02 Sep 2026 23:45:59 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1431990a39bsm3119881c88.3.2026.09.02.23.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 23:45:58 -0700 (PDT)
Message-ID: <0aafc618-0cc4-4b4f-b5a4-99581b6fff5a@suse.com>
Date: Thu, 3 Sep 2026 16:15:52 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] btrfs: consume the given iter directly instead of
 copying in csum_one_bio()
To: Daniel Vacek <neelx@suse.com>, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260903062317.3928665-1-neelx@suse.com>
 <20260903062317.3928665-2-neelx@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <20260903062317.3928665-2-neelx@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/3 15:53, Daniel Vacek 写道:
> This is just a small cleanup to avoid copying the iter twice in async case.
> We already have a copy csum_one_bio() can consume directly. No need to copy
> again the second time.
> We can use this copy also in the sync case and get rid of the parameter.
> 
> Signed-off-by: Daniel Vacek <neelx@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> 
> v2: Use the bbio::csum_saved_iter in both cases and simplify even further.
> ---
>   fs/btrfs/file-item.c | 15 +++++++--------
>   1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index 581ca5653be9..4a7681557ec1 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -797,18 +797,17 @@ int btrfs_lookup_csums_bitmap(struct btrfs_root *root, struct btrfs_path *path,
>   	return ret;
>   }
>   
> -static void csum_one_bio(struct btrfs_bio *bbio, struct bvec_iter *src)
> +static void csum_one_bio(struct btrfs_bio *bbio)
>   {
>   	struct btrfs_inode *inode = bbio->inode;
>   	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>   	struct btrfs_ordered_sum *sums = bbio->sums;
> -	struct bvec_iter iter;
> +	struct bvec_iter *iter = &bbio->csum_saved_iter;
>   	const u32 blocksize = fs_info->sectorsize;
>   	int index = 0;
>   
> -	for (iter = *src; iter.bi_size; bio_advance_iter(&bbio->bio, &iter, blocksize)) {
> -		btrfs_csum_one_bio_block(fs_info, &bbio->bio, &iter,
> -					 sums->sums + index);
> +	for (; iter->bi_size; bio_advance_iter(&bbio->bio, iter, blocksize)) {
> +		btrfs_csum_one_bio_block(fs_info, &bbio->bio, iter, sums->sums + index);
>   
>   		index += fs_info->csum_size;
>   	}
> @@ -820,7 +819,7 @@ static void csum_one_bio_work(struct work_struct *work)
>   
>   	ASSERT(btrfs_op(&bbio->bio) == BTRFS_MAP_WRITE);
>   	ASSERT(bbio->async_csum == true);
> -	csum_one_bio(bbio, &bbio->csum_saved_iter);
> +	csum_one_bio(bbio);
>   	complete(&bbio->csum_done);
>   }
>   
> @@ -850,13 +849,13 @@ int btrfs_csum_one_bio(struct btrfs_bio *bbio, bool async)
>   	bbio->sums = sums;
>   	btrfs_add_ordered_sum(ordered, sums);
>   
> +	bbio->csum_saved_iter = bio->bi_iter;
>   	if (!async) {
> -		csum_one_bio(bbio, &bbio->bio.bi_iter);
> +		csum_one_bio(bbio);
>   		return 0;
>   	}
>   	init_completion(&bbio->csum_done);
>   	bbio->async_csum = true;
> -	bbio->csum_saved_iter = bbio->bio.bi_iter;
>   	INIT_WORK(&bbio->csum_work, csum_one_bio_work);
>   	schedule_work(&bbio->csum_work);
>   	return 0;

