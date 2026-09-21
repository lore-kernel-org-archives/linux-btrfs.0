Received: from mail-ed2-f26.google.com (mail-ed2-f26.google.com [74.125.228.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9542C4A1E01
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 13:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789999042; cv=none; b=JhemQi4FMsQleqicf3U1PW9bGYiHYYVU1qr3vqKZGrp00TPhkJiqlqDFAMGRi/WQVMWCVNy4HFhc9k9dhPdB20qLkWV0T8NjGXVnsbeNqWHuv59lgnwSBJx2H9xceEb5Qi09tol6qp/rh4emvt+c8VALVRQZHT4aui5RIUfQ7h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789999042; c=relaxed/simple;
	bh=05nQQn1fD5gOEpF/ULLHdZqTcDXLkNhHu9x2ubpJqaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QoRh/g2I4kUk6Gcm6UZcsrFYf3P31GjII7OmAPCGGyaH01HTpIMyvEfHOR/KazLuPG4FBlk771iJgEgmK6E2b+czvCwB0HKiymFfaUJEmJbtVSRDFdWuPfHBfxnRbaTSZb5lefV34+qKkV8CqITAZKleO9XkSCiRAk4LAhRQXVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mzWI9N2G; arc=none smtp.client-ip=74.125.228.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mzWI9N2G"
Received: by mail-ed2-f26.google.com with SMTP id 4fb4d7f45d1cf-6aa13e194easo4685495a12.1
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 06:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789999037; x=1790603837; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ofpT4h/xZOk97T1LnY16xox+YwsLCtjUsNXPXQGc7Q0=;
        b=mzWI9N2GG3yCh33wQMPJzyAje6/w1azTh4oUjAdlzJOreyc1TK6YMNTV/hQZ9TK3Gd
         CEyFT6JaVuVjed/fVn+ehu8kPa8HNUOBbo0dKThcMYqAxQ33Sj3C6fOg7tWRzo9WCdYB
         CgktU7m3qHBLqKFnkA5IBAlERt+FmUYJlBApJNKVhbQFFUR5JGgAq2NbcjsWbRyg6SFr
         8Cqy4Q2D+SN+vgDtmn38CUCnH3wPIvBSzJNJo61M9aWxru9kd6n65Lm/HaoGXxtsYsZY
         9ms6vbHcQFg4jHmo+4f1jqR7dpXme2eRW7XmPC1nlYjnriBkw/EB1U5QYlSftufCNk/N
         jkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789999037; x=1790603837;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ofpT4h/xZOk97T1LnY16xox+YwsLCtjUsNXPXQGc7Q0=;
        b=rrmWEb+wlJGyvZKwnb+msqvMn2+kDUlNLl8sgy2CyCL6UkHllHUF2qo/KORcGzNnql
         IO/tq9SOEphiYLn+mgj7CG7aquTdXGM1Ej6x9yTsxdL8LpA4JbY4ZQLg9NT+CyuH4skN
         fjWW4NQNAQgFcq8GuUB7MgAqEGjcG5KfCEc81GFTTNdW3BULcppaf7MNFOuW2Q8frXbR
         zDG3dG+KQ3b03KVPufAVECqq06p7jTHc0Yoa9Og3qWOO5kz8+W3Ifr1OOuIshuFHWTlT
         EOQ1tD6DqX2+58pqByDoA2XlBu9WZeD2dG1Qt5bBCd4U7SW3OGDJ7zc3TU6iNOcI9uDB
         qVhA==
X-Forwarded-Encrypted: i=1; AKwUvByD4nSBIQTJL+77amDDlXh/lB3ChPh+HQe1iJ3k3Lh7bkmcl56ZLsumCQyVIUZFZiJ8bvfa8f11Y+E1dA==@vger.kernel.org
X-Gm-Message-State: AFuF++mwjF4J1PkaNw9doyMa7pOPT8G+d5P1XSfLhQ1pwsjTtDhhNczp
	HBgBcp7ui5QOv3GkUUvyb79lhsiwsDLwpGWJNBLrbQSKEVPvLOqCoMF9
X-Gm-Gg: AYBFou2QMnosAhXW302LDlJB4f5g7caf8EamYNXhVLBWJhZ1kim61HIqQIvkoCBqBQR
	ruWoYwNqOx1mtzGAEgFKsWfaBYcVIBokjRcIjTtulhJKy8aqDByTvtbBq+ze11gGcLQ4WEco2SP
	FnhJNBNsT1bChaREjyqZdRIg86nRohng65ZYPngbe8gtgdoBGAG4+dgbR5HsrbUYQZQ1FgDpuS5
	juTbnwkcWS/iI7Tmm+Rxm6DPvDlOAD8ck9rsC4yAM3KmHFfVU84F7h9uO3yNBZFPT2fOUUgxyW7
	33doXeLqLRweFo5lTlDJuODw0nLbZHLssL1rMeSdyWMpmtjSyQS+3q8LHbDSuyBwWGMHzYWwBb1
	AtSUDQQrieY3hNWD85tUwfrRIf5epGrQvmp0yzyW8DLPK3H8tkylhPx59BLUK5XhP/i1iBFya72
	q0SMjXW71MLWuFmlep4us8wOKbiIK45qAgfRD51jUwMHLRhRVyTOIb1r0S1OX55rPTb28InDS1D
	/k5ZoTQvjacHPZHLO7xxC3V/jGMR1Ku4+Ug5PO5Z3RMKqSPF65MvKO7lj+fLWQ9ghNXbU7csMhN
	iTujZzjOlqyEdupRmUnHZUe3elbENcFYW+xn
X-Received: by 2002:a05:6402:210f:b0:6a9:aead:4e98 with SMTP id 4fb4d7f45d1cf-6aa577f5cfdmr8215865a12.1.1789999036894;
        Mon, 21 Sep 2026 06:57:16 -0700 (PDT)
Received: from [10.54.182.141] (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa67e0d3c5sm4446691a12.22.2026.09.21.06.57.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 06:57:14 -0700 (PDT)
Message-ID: <a8b01e56-bc86-412b-862c-d6a3efef2e6d@gmail.com>
Date: Mon, 21 Sep 2026 14:57:05 +0100
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/14] dma-buf: introduce initial file I/O
 infrastructure
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, Nitesh Shetty
 <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
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
 <bc20381e8daf85ac58811c344325d8192cde9d1e.1785274111.git.asml.silence@gmail.com>
 <181b08be-04bc-4ae9-bb88-15321a82440f@amd.com>
 <8285ede8-bebb-403a-8a37-b9987cd37a8f@gmail.com>
 <0113c49a-a364-4df6-9ab4-681c789d9d3b@amd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0113c49a-a364-4df6-9ab4-681c789d9d3b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/6/26 08:29, Christian König wrote:
> On 8/5/26 12:59, Pavel Begunkov wrote:
>> On 8/5/26 09:27, Christian König wrote:
> 
>>>> +
>>>> +    dma_resv_lock(dmabuf->resv, NULL);
>>>> +    ctx->dev_ops->unmap(ctx, map);
>>>> +    dma_resv_unlock(dmabuf->resv);
>>>> +
>>>> +    dma_fence_put(&fence->base);
>>>
>>> You should probably set map->fence to NULL after that.
>>
>> The map is freed two lines below, but I can add it as
>> a defensive measure.
> 
> In that case it's ok, I've just haven't seen the kfree(map) below.
> 
>> ...
>>>> +    ret = dma_resv_reserve_fences(dmabuf->resv, 1);
>>>> +    if (WARN_ON_ONCE(ret)) {
>>>> +        struct dma_fence *fence = &map->fence->base;
>>>> +
>>>> +        dma_fence_get(fence);
>>>> +        percpu_ref_kill(&map->refs);
>>>> +        dma_fence_wait(fence, false);
>>>> +        dma_fence_put(fence);
>>>> +        return;
>>>> +    }
>>>> +
>>>> +    dma_resv_add_fence(dmabuf->resv, &map->fence->base,
>>>> +               DMA_RESV_USAGE_KERNEL);
>>>
>>> That sequence is clearly incorrect!
>>>
>>> The fence must be created after dma_resv_reserve_fences(), otherwise you definately have an illegal memory operation here.
>>
>> I'm not sure what you mean, can you elaborate? I only cared about
>> pre-allocating it to avoid allocations here. We add / signal the fence
>> only once, no reuse. The map is going to be killed here, and if we
>> create a new map, it'll have its own fence.
>>
>> I can move the dma_fence_init() call here if that makes a difference?
> 
> Yeah that is a good start, but you might need a bit more.
> 
> Here is a summary of the usual procedure you need to follow when implementing a dma_fence backend:
> 
> 1. Allocate your operation object, in this case here it's your mapping I think.
> 2. Prepare your operation, including all memory allocations.
> 3. Call dma_resv_reserve_fences() to reserve a fence slot.
> 4. Allocate and init your dma_fence object.

Looks I forgot it reply here, sorry for that. I killed dma fences in
v6 in favour of synchronous waiting, it turned to be less trouble even
outside of these fencing rules as I can rely on dma-resv lock less in
the code.

-- 
Pavel Begunkov

