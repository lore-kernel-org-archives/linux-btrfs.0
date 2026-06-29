Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8BD40D568
	for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2026 01:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782698058; cv=none; b=t6b5nz5VKADVhjFzgjiP6ikf0pe2xzVyxcLKtLTHJ+eM4xaBcjQiLEPp5ckBx91C4r8m1Cs9yKT1t1vOyva2EP3hrxjmfs2SwP2TCx04xIP8d6YOgT3xBOrUGEz5YHxc1LD+ByxaNGPkaFpYnn/qHyWtP2ZVGmO4LTLQMuK5THM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782698058; c=relaxed/simple;
	bh=HSeHyu7n4wGWlWse2EQKzTJhnB1BKzvXNRtXslnfDAM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bCmoLzVBgRkesU4p9tbJnqswcZwydSYTBEkJJznvkpNK0lxH76sqIBg3MXjjLZmr3yw9agFE8kfSLelBCldIEWLcxf7Z3TtkEjAI1qejplsFZ0s1F98GrWHOnU0m6gqVhJcLoAKmhbegTI7bGXLXI2FuqUMP49LqtWvfu4AdxCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UNYqLfgW; arc=none smtp.client-ip=74.125.227.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UNYqLfgW"
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-37e00ef127eso135180a91.1
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Jun 2026 18:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782698056; x=1783302856; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lRdWVg7KJgFb12WQoGhPg3Je4rPMNfAc0SvIof4ZQ70=;
        b=UNYqLfgWqoWeEvKJv52iiZU3wK3zEbcQ2SStonJ3LUd77ZELePWdFLxaBHyclfG0R8
         pd2igBQDg5M3yasEB5xC0gDQMIY76JqTMvSmw2jKDu5PUqhGIJeaA7poEyLdBp5DXNOy
         w4XzgOXkM8AndRu/iCpnwn1etGs56XHvrjJNv32pWSTlprn/89/rZU9SH5qaDT3K+mz7
         qesSohQQkFSzIHDRbD370Cl3CJxUep21dW4yPz8c6i2jHgOn8ooNEcclURIPulydNHpI
         F+MeDW79yTzFZBrAhhCa2Rd3rEOaaM+mAco/hgU9s6NCPtzYfCV1/yxgL8+mv+bWue3S
         kIIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782698056; x=1783302856;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lRdWVg7KJgFb12WQoGhPg3Je4rPMNfAc0SvIof4ZQ70=;
        b=TkP8Z8k3aoKSLwM3CiLMoYulIkStP1T8yXAp3o4mr6gSoNaguIf9lAbYIdYyEgcO0x
         NWU3s8xjUm6tLx8b5jDhCjqv5LBM0BgNgi584RQXufUSQrTtZCvLSTuIKpqmvXfFtYoB
         R6r9npUVBLo1qpSL4pIlHPQSt9mwmlpvmwwsraieXD4moYoaiimkm/I/kgQ8H2jcKUad
         0orTOSGLrV7cJUnIBPun6oKm88kQCg7X/GdC8CIAdsEvVXrd80Xu2hxPaWTqvrSQNuvJ
         uM3G57inf+sgbBJifjox3Z1gN6Bw/8o0VTLKMCw+kFnE8VQ0tfBIYajmVzpFOXFveIxC
         M7bA==
X-Forwarded-Encrypted: i=1; AHgh+RoFbgJlBsI5VdluADpNmnlnsMwkDI65Tv7o8O9FF09GntrACtNbdGaoPvWpUYeSklGxHEtSrSZ+6DJcwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFDvjOF+Hs95yFtYK5S0qSafvW4895xrKb9zeHa5U+WHZo33xx
	a2e4Kj92ydNvVrSvWd4bif9adwykbvvhzmjszt7awLeQWBMFB2SEyX0PH4sePsa0+yukGQ==
X-Gm-Gg: AfdE7ckbzYyhjY0X/UFXd/2y4lCD2GDdTIJdIeReYXp65z80OT66FknX2ODyqSUlWxP
	mynjj8xWvtsyXahiaYwfm4MAqYnXWbOJhH0LC/Obhe1av7fkqQlR86VSKJM7zcw36S3EzAnzpd5
	jzCOOb5TxyJzqQ0cXBDk3LxBOhckJwnCFfAz/aNFPa/Vt8Zk1CftqArWWX9H5qXq2yIHX3CUeE5
	ZZHEjfmwA5kEda5hRZ4hAwMSEYyIYnYpZmf56HGhkZFTkplj+o+U1S5jSAGvSb6UYEX5wKJYnJi
	J0Ct8ibmdooc/3ngn8u+hKlV5YqhHvrq2mPvTKVqXgyQn8uflGAxeE+BRd35jtyrqlyJ1xPPMqR
	lz++vVb/BYUBXyYCgKfZiYbHa4KccvXlKxaFu+Iv+tZgdxOqCImI/7i9dUCeXieskCIf8++rnZN
	kY7kguKAO0tXe/BqSFsHXHHpqP3LrAT2uc1Tv9yj5DmJrxytE=
X-Received: by 2002:a17:90b:2886:b0:380:925:aa38 with SMTP id 98e67ed59e1d1-3800925bb16mr964016a91.1.1782698055967;
        Sun, 28 Jun 2026 18:54:15 -0700 (PDT)
Received: from [192.168.10.237] ([154.83.91.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9ae00b6545sm107557a12.12.2026.06.28.18.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2026 18:54:15 -0700 (PDT)
Message-ID: <c6f9a5f5-0aaf-4f89-9e88-fb7eaf6aa3d2@gmail.com>
Date: Mon, 29 Jun 2026 09:54:11 +0800
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
From: Sun YangKai <sunk67188@gmail.com>
In-Reply-To: <20260629002505.1552238-1-rosenp@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/29 08:25, Rosen Penev wrote:
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

It seems that size is fixed and known at compile time, and since we want 
to inline the buckets in the struct, I think we can have something like 
this to save one pointer:

struct heuristic_ws {
	...
	struct bucket_item bucket[BUCKET_SIZE];
	struct bucket_item bucket_b[BUCKET_SIZE];
}

However, each bucket array takes exactly 1024B memory. Currently we have 
a 48B allocation for the struct it self, 2 * 1024B allocation for bucket 
array, and 8192B allocation for sample. With these 2 arrays inlined, the 
struct will need 32 + 2048B allocation if my calculation is correct, 
which will goes into kmalloc-4k. Seems not good.

Thanks,
Sun YangKai

>   	if (!ws)
>   		return ERR_PTR(-ENOMEM);
>   
> +	ws->bucket_b = ws->bucket + BUCKET_SIZE;
> +
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

