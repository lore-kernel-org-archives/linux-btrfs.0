Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFBC33D4FB
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 10:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782728063; cv=none; b=qCOmMlDRZcurZ2aVZVt4uKYlcLfG4Y6xHapWSOTYxff5T0ysnGZC2FAenV9V7+5d11iKi8OE7d7ij6S8LsrCFhyVST2LE/EisMAFzMdZ9auladdDi/MZRTIgD4DHLr8J75/ogrIUIYzK8Zf96FtlMHaiNKRJ6TFz4iSO7oZEHbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782728063; c=relaxed/simple;
	bh=y9SfzR8GR4PfqUpwd22YTYnkhq0g65IJxzxKkgCieek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D9MHPFkllK/W4oKdxqQelLUvvgL/E69/I5qztyY9Pt+BZYYksvVG35YhALaXQmiWdtim5mFjakqY/3jt7JVk1T+sRxWwnzArrwEVWmdgRbp0imchWxNquYXzSwNaOo94vWTPU6wnaA8601FopKGDq0tvZKsdZWyQTDIWUR4O9uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HEZxHdO0; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HEZxHdO0"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-492719b2d81so8320295e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 03:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782728059; x=1783332859; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F4tL1yZpLxOOhTxs7AfYyrBfe18UjeYns714xY+zcmA=;
        b=HEZxHdO0Up1NBiAdFe4a8Bw0Cc6z4Y0i/pm4KeCVQumgD4paf5KxjR7GYmneGDyrhE
         kgrkjjRfPeEY6Xsmndia8/3tNeqdo5EfdbZ67xWErTB2Ajv5eTOrOg7XDf+cddqmS02W
         ynnR4O9+cPLpjBtkKM68IiUNFu5a7nXncq4YwXLEmBZ2Q+/sISHte4/GoIEAKO+dYbFa
         0lSudKB6e7tkelGUzKBFspKAKAax8s24cTOdiHhXRXVP6ydKlRtU5NZ8/97Ciqg6e9Jk
         VWzlk0+rN/oA+yMMDPXaSS2una2wmSbo27cLEXYXRbgU/+YKuLLCOPr/fa+X7TEhQLry
         qn2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782728059; x=1783332859;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4tL1yZpLxOOhTxs7AfYyrBfe18UjeYns714xY+zcmA=;
        b=m/1kskclw6dSvd6uYkN30Y01HU70ua5a0WjoMYZ5aeIDVrRvq9IQjmI6eK03bzEqTi
         TiQwQn/G9ASkyYpmkRd0lW5uc5a5bz4t6hdlGSU3Z+FNhHk+jsXdsz8i06rRCVNmFcRE
         4R9KLzwnP97sl2kaeARoECMuSJwOpmmYN1nvvg5uIkMkVA7wN+EgOB+rcS8jhOJLs/39
         lzG4ihpc1S5q8PbN+1P8fRzHuSmX6UG8FaZaQJhGt0OdIbFF1QFQi14f2HFLwyS9R4Xl
         60TIiHtnNg5yBq+hm1DvhXxcXBz2FY4bXMn3/hYTUpMyaiT6VkOyGSY7upqJ7oev7YcH
         5DHA==
X-Forwarded-Encrypted: i=1; AFNElJ8COEuBWL3gLu0f1F9xpav11oSEmBM1GvYsncJbDq7y3W7nLsR0U89wbV7liEDxP3ssw6ayonFNY+TJgw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpx696QbIXn18xkFuJ4FOIKtLzv+1w3yv6ArFbJnBog/7fbOCV
	XyFP5VOOkxCkYJQfp2tvuirHgY6daa/HplW1u3OR0q1iIkpBqrFip4PxiQmF3ikXTcI=
X-Gm-Gg: AfdE7claJuSUiCkAlOz2H4S+QMVUY4C2OJmK/hC8hP5KDRfO/UMiPG1hVysnCxgz/Mc
	ji2LPiiV5Bj0cOKhOkoypnZx/TkWMJ1bQqOxqV1CK5SEYXt9/aMnWGW8xNRJpCnf40E9XOYyJsw
	g/o2yQ92h2iBSsg5CJz58YFcFz7QT1e3Voi/vIUhQ4pV61TTgveSKVIdvq4n8xLxrx6rGlnH/7A
	R0+9hqACb3ODJniU6AuTJJZ5l32s4x1WO1pi3QUSxfgKjBQO0NnLCagv9FSLWYiG2CLr99BEJlY
	YcvTaAwxCIY+csOLkjEnGtIhtCtdyLF3hBNAmeXiznC3KrKJzvnUrsoVBC1c4ai6KBaW0C1iMKY
	u8wEfPTXH8Nm/IaaWuKo7wXOVMM7bfIig4f7ZCsJCfUsL5B3mNb2VeA8XEajb2aaRqzZaNblzhK
	XiqHUFkbVdXLpgaKKOEoR5k7yYDKHh/WavrLRkKI6h
X-Received: by 2002:a05:600d:8494:10b0:493:adcb:d368 with SMTP id 5b1f17b1804b1-493adcbd480mr35777665e9.9.1782728059187;
        Mon, 29 Jun 2026 03:14:19 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c8255602fcsm57452465ad.60.2026.06.29.03.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 03:14:18 -0700 (PDT)
Message-ID: <0a3b352d-a267-46a8-84b4-ba97def25f5c@suse.com>
Date: Mon, 29 Jun 2026 19:44:13 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: compression: allocate buckets with workspace
To: Rosen Penev <rosenp@gmail.com>, linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260629002505.1552238-1-rosenp@gmail.com>
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
In-Reply-To: <20260629002505.1552238-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/29 09:55, Rosen Penev 写道:
> Convert 3 allocations into one. Simplifies code slightly.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>   fs/btrfs/compression.c | 18 +++++-------------
>   1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index ffb6b52863a7..da6749ff5924 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -650,11 +650,11 @@ struct heuristic_ws {
>   	/* Partial copy of input data */
>   	u8 *sample;
>   	u32 sample_size;
> -	/* Buckets store counters for each byte value */
> -	struct bucket_item *bucket;
>   	/* Sorting buffer */
>   	struct bucket_item *bucket_b;
>   	struct list_head list;
> +	/* Buckets store counters for each byte value */
> +	struct bucket_item bucket[];
>   };
>   
>   static void free_heuristic_ws(struct list_head *ws)
> @@ -664,8 +664,6 @@ static void free_heuristic_ws(struct list_head *ws)
>   	workspace = list_entry(ws, struct heuristic_ws, list);
>   
>   	kvfree(workspace->sample);
> -	kfree(workspace->bucket);
> -	kfree(workspace->bucket_b);
>   	kfree(workspace);
>   }
>   
> @@ -673,22 +671,16 @@ static struct list_head *alloc_heuristic_ws(struct btrfs_fs_info *fs_info)
>   {
>   	struct heuristic_ws *ws;
>   
> -	ws = kzalloc_obj(*ws);
> +	ws = kzalloc(struct_size(ws, bucket, BUCKET_SIZE * 2), GFP_KERNEL);
>   	if (!ws)
>   		return ERR_PTR(-ENOMEM);
>   
> +	ws->bucket_b = ws->bucket + BUCKET_SIZE;
> +

This barely improves any readability.

We have two different bucket pointers, one is a variable sized member, 
one (bucket_b) is a pointer.

Not a fan of this at all.
>   	ws->sample = kvmalloc(MAX_SAMPLE_SIZE, GFP_KERNEL);
>   	if (!ws->sample)
>   		goto fail;
>   
> -	ws->bucket = kzalloc_objs(*ws->bucket, BUCKET_SIZE);
> -	if (!ws->bucket)
> -		goto fail;
> -
> -	ws->bucket_b = kzalloc_objs(*ws->bucket_b, BUCKET_SIZE);
> -	if (!ws->bucket_b)
> -		goto fail;
> -
>   	INIT_LIST_HEAD(&ws->list);
>   	return &ws->list;
>   fail:

