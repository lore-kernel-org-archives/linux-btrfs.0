Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16B2382F13
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 21:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773437315; cv=none; b=GKW67UT43zpdR4qLP6izQ/h0kldzKyePh4weC4jyBLIYulWYDHJ+fyoz/rZ/xRzLbHdRBqZ2qsshKt6ZR+gjr/bZZLPY0NYmMxsql9nb6q8gTJx6doJonNiryYsyUb15gVzEtrfW6FCUtb4fg4BSk6s/1aDWuTvgSTTnOPfazCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773437315; c=relaxed/simple;
	bh=AuwzzdejiT4niT4nqPBbDQj2yl6AaofKMKbf7pafTGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HQz8GgpNN9PO2vFZvGvP5iHJ7ChYJGAjfvn79RzRMY5OycBZqoqXMACxnxXWU8EQRMu0LfABoDyXTVV2JWBdoG5MynUZL+frVCYJiE8QAm0R6QgWJGsiv9OUzKosa6zVlXwKjWRiJXgQvuLc+5qR5cOt/YlISCDuplDPDvWIuUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EzKFqTre; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EzKFqTre"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-485392de558so16661075e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 14:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773437312; x=1774042112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2qi8MzfoG+FIFER59ReJnccG58/GmD3aQGvmgr9VrzA=;
        b=EzKFqTreDbMAkDh+K7HfWDTHxMCRv0/0dUYUdMu+h952lNDDL0Z19i4Z3EHRMtET3m
         iGZ/miJBbGR0cSTa0jZEHs3Txp71Bzo6NbQHazauKNw+RcNPj5NMZumAT66/Xu/bTUos
         iKXKlKx8UCkzk1X5cTjRpn6lYEP/twVf+8GmHil36z3fS3ZTC9MqwrJADjDoDO4xZDlj
         5/dLqEeEFzbP3JdF+u743xcjJMYkp6lo/x5bKhtgz9oDtCdUzL4SyZ7VOaSfzJUK5/kz
         1zNZe+Xcs6oz5XP14gocmgpbuEHCxlOaobn1lLlY4y+JR1JrJtpSe2420cIAYfCkdA8N
         M6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773437312; x=1774042112;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qi8MzfoG+FIFER59ReJnccG58/GmD3aQGvmgr9VrzA=;
        b=IDYpSzumU7dm+aAYq+2LDlrogDVPwcDDS8eH6lekEnlacNsqoNbpI4HFlbjhKYWsDg
         6GL+6JuZreTXWCHOFHI+ANlC8RqUy0TRicHk0RSix9uKb1Qw5PXcllKpdM+PsX3vHo+n
         PK9gjUwXCnLVeSA4I+VhM/+COUt19FbC1UqEa86Pg1tYs4sac4k33bGQ/n9RwHkdxlPa
         2G4LGmnuhadW+RMDSITLanTxPNhCR/qY8gK4wbHEvvWK9kzsSpq39h81DmUJ8JeITnpn
         yQeaauA3WzrUgnk+hVdNd8T+/WXR/yEdLGKiD1diaZI41Wae49Dj2oZq2RdEByXwDWX7
         bI8A==
X-Gm-Message-State: AOJu0YxVTPsaX2jwg5S05Y0pcKnBg1Uyp8xEXAL9RP/IfytzNkfuAShP
	tVZ89+i/8ArpWEV6u+xRpJXA9+l0fBFvlbzP9WbIYInjX9B+B0ltNMa+j+zmHa/Fjys=
X-Gm-Gg: ATEYQzxHfOmoRr/JO5PIxM2lQzTFN2/t6cR1MHkLThjl+2a1mjCMX+PimJgUV4Walk3
	PusVxOoLMedJLBk6T4TSZenNgBn/lJ7cj6nlS1E7zfU67W7vvD/BDtSxtqc5dO+JlVIDc5emUQK
	cX0lpKcqvjoXMCte1qHZ2ZQKfJ+d/f3ni/gnHKV6alg5nFtN97yL/9DjSTZh5u3AIlXq1/CP3Qj
	3wYR3jBAOrKIjGCo0It/XBSYZ8OWRQEPJUscL5nYlUkvYDZP+U9hrmtelN4QbCZPfJ7FWzWmV3H
	dMeWbqKo2E0Tg2W3lHSZAId7tHKW+vdNvgwXwKaGBYJbvXaTmJp9RimmN7ZeWSyFsSZn49sOlGQ
	vMUIU4MNaN0hsu4l+HzyHDf0rWE7GUFDIFkJiSN2iJ0Vzc5ktvS6DmGhq2uWxpkW/c4o2jexV+g
	PIRhXfpFYR1JtjYS1Am8N+y4xkZ+CQ31CT5kxNkOic7zhUo33K4C8=
X-Received: by 2002:a05:600c:a4a:b0:47f:f952:d207 with SMTP id 5b1f17b1804b1-485566facc8mr82860715e9.19.1773437311886;
        Fri, 13 Mar 2026 14:28:31 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece594b4fsm29380365ad.20.2026.03.13.14.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 14:28:30 -0700 (PDT)
Message-ID: <f37e2989-a73c-43a2-acb8-35a08d6345cc@suse.com>
Date: Sat, 14 Mar 2026 07:58:25 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: balance: fix null-ptr-deref in usage filters
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
 idryomov@gmail.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 stable@vger.kernel.org
References: <20260313140608.1110971-1-gality369@gmail.com>
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
In-Reply-To: <20260313140608.1110971-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/14 00:36, ZhengYuan Huang 写道:
[...]
> 
> On a well-formed filesystem these two are kept in 1:1 correspondence.
> However, btrfs_read_block_groups() builds the cache from block group
> items in the extent tree, not directly from the chunk tree.  A corrupted
> image can therefore present a chunk item in the chunk tree whose
> corresponding block group item is absent from the extent tree; that
> chunk's block group is then never inserted into the in-memory cache.

This is unexpected in the first place.

We had a lot of extra checks regarding chunks/bgs, e.g. 
btrfs_verify_dev_extents() to verify there is no such missing mapping 
between chunks and their dev extents.

I believe you can also implement such check between chunks and bgs, in 
another patch of course.

> 
> When balance iterates the chunk tree and reaches such an orphaned chunk,
> should_balance_chunk() calls chunk_usage_filter() or
> chunk_usage_range_filter(), both of which query the block group cache:
> 
>    cache = btrfs_lookup_block_group(fs_info, chunk_offset);
>    chunk_used = cache->used;   /* cache may be NULL */
> 
> btrfs_lookup_block_group() returns NULL silently when no cached entry
> covers chunk_offset. Neither filter checks the return value, so the
> immediately following dereference of cache->used triggers the crash.
> 
> [FIX]
> Add a NULL check after btrfs_lookup_block_group() in both
> chunk_usage_filter() and chunk_usage_range_filter(). When the lookup
> fails, emit a btrfs_err() message identifying the offending bytenr and
> return -EUCLEAN to indicate filesystem corruption.
> 
> Since both filter functions now have an error return path, change their
> return type from bool to int (negative = error, 0 = do not balance,
> positive = balance). Update should_balance_chunk() accordingly (bool ->
> int, same convention) and add error propagation for both usage filter
> branches. Finally, handle the new negative return in __btrfs_balance()
> by jumping to the existing error path, which aborts the balance
> operation and reports the error to userspace.
> 
> After the fix, the same corruption is correctly detected and reported
> by the filters, and the null-ptr-deref is no longer triggered.
> 
> Fixes: 5ce5b3c0916b ("Btrfs: usage filter")
> Fixes: bc3094673f22 ("btrfs: extend balance filter usage to take minimum and maximum")
> Cc: stable@vger.kernel.org # v3.3+

You may not want to add a version that's already EOL, just plain CC to 
stable should be good enough.

> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
> I was not sure whether these two bugs should be fixed in a single patch
> or split into two. They share the same root cause, are very close to
> each other in the code, and both depend on the same change to
> should_balance_chunk(), so I kept them in one patch for now. If splitting
> them would be preferred, I can respin this patch accordingly.

Considering the two filters are introduced in different patches, one fix 
for each will make backport much easier.

But still, both are very old thus backporting may not be that easy for 
older kernels.

Otherwise the code looks good to me.

Thanks,
Qu

> ---
>   fs/btrfs/volumes.c | 48 ++++++++++++++++++++++++++++++++++------------
>   1 file changed, 36 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2bec544d8ba3..3aa44967c1dd 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3832,8 +3832,8 @@ static bool chunk_profiles_filter(u64 chunk_type, struct btrfs_balance_args *bar
>   	return true;
>   }
>   
> -static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> -				     struct btrfs_balance_args *bargs)
> +static int chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> +				    struct btrfs_balance_args *bargs)
>   {
>   	struct btrfs_block_group *cache;
>   	u64 chunk_used;
> @@ -3842,6 +3842,12 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
>   	bool ret = true;
>   
>   	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
> +	if (!cache) {
> +		btrfs_err(fs_info,
> +			  "balance: chunk at bytenr %llu has no corresponding block group",
> +			  chunk_offset);
> +		return -EUCLEAN;
> +	}
>   	chunk_used = cache->used;
>   
>   	if (bargs->usage_min == 0)
> @@ -3863,14 +3869,20 @@ static bool chunk_usage_range_filter(struct btrfs_fs_info *fs_info, u64 chunk_of
>   	return ret;
>   }
>   
> -static bool chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> -			       struct btrfs_balance_args *bargs)
> +static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
> +			      struct btrfs_balance_args *bargs)
>   {
>   	struct btrfs_block_group *cache;
>   	u64 chunk_used, user_thresh;
>   	bool ret = true;
>   
>   	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
> +	if (!cache) {
> +		btrfs_err(fs_info,
> +			  "balance: chunk at bytenr %llu has no corresponding block group",
> +			  chunk_offset);
> +		return -EUCLEAN;
> +	}
>   	chunk_used = cache->used;
>   
>   	if (bargs->usage_min == 0)
> @@ -3986,8 +3998,8 @@ static bool chunk_soft_convert_filter(u64 chunk_type, struct btrfs_balance_args
>   	return false;
>   }
>   
> -static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
> -				 u64 chunk_offset)
> +static int should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk *chunk,
> +				u64 chunk_offset)
>   {
>   	struct btrfs_fs_info *fs_info = leaf->fs_info;
>   	struct btrfs_balance_control *bctl = fs_info->balance_ctl;
> @@ -4014,12 +4026,20 @@ static bool should_balance_chunk(struct extent_buffer *leaf, struct btrfs_chunk
>   	}
>   
>   	/* usage filter */
> -	if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE) &&
> -	    chunk_usage_filter(fs_info, chunk_offset, bargs)) {
> -		return false;
> -	} else if ((bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) &&
> -	    chunk_usage_range_filter(fs_info, chunk_offset, bargs)) {
> -		return false;
> +	if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE) {
> +		int filter_ret = chunk_usage_filter(fs_info, chunk_offset, bargs);
> +
> +		if (filter_ret < 0)
> +			return filter_ret;
> +		if (filter_ret)
> +			return 0;
> +	} else if (bargs->flags & BTRFS_BALANCE_ARGS_USAGE_RANGE) {
> +		int filter_ret = chunk_usage_range_filter(fs_info, chunk_offset, bargs);
> +
> +		if (filter_ret < 0)
> +			return filter_ret;
> +		if (filter_ret)
> +			return 0;
>   	}
>   
>   	/* devid filter */
> @@ -4172,6 +4192,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>   		ret = should_balance_chunk(leaf, chunk, found_key.offset);
>   
>   		btrfs_release_path(path);
> +		if (ret < 0) {
> +			mutex_unlock(&fs_info->reclaim_bgs_lock);
> +			goto error;
> +		}
>   		if (!ret) {
>   			mutex_unlock(&fs_info->reclaim_bgs_lock);
>   			goto loop;

