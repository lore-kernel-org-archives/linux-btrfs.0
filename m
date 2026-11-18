Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034312;
	b=rg32RbfVVbBqdSI7Rfl7kQ/1zds6Duh08Gb+EPJmwH0wAO9oZSbn1GMntzTSlTd3huFo
	 Lbk0KypzT34Fp5tmh11nea6a4j1gDOd1/0s0I3uAmUoz36YeCBnST8EMa5TcOExTHo8Lp
	 IB/u6exngFwsXo4rqFDjT7SXOXY3mqYeNzv+iIDME2kHVmtxyA7l1GMBnxlP5c98DfwoG
	 VMPlwh2VmLMkpL7H+SKDIWFyah4Zgkd7DFS1QCwx/Wbus0NdHeP+OoqAUVXhK53xHGlUV
	 Bcjzmmq6tsJVCX/j7AwvbKbPhuJLjDqckCDdvEi5yxHuk5Z++JLM3qkghQQXkr9NBnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034312;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=gl3uARuCLrvmOuEUSt0jl78CwT5lLVAwnYwWKnlCtjg=;
	b=AGYPSvChAMBJN7yDoyXqhVBYcrMrtAWdBmDESGlqE1WjVp0iXzkKXVlehKdamCxgzfQI
	 HT//OrqdQrUdmCNR8TznjDomeLGL5fANPkEi+au0YpxC4XaJiVBuVf1/YUyPEa4qJlugZ
	 2gNWbCqL/pwDsy6EkoKMEWhUPOju2gG+Wc99kOtLAC+okWwJMqQEISsFnFys9B2cX7bqh
	 RbV3KO48zLJ8bxFWHFO3R5gIABQ1JUNd24qcfU3wAHX2s6fwNKzBqrGIUTuUrjkuWx6C4
	 DFzZwzpXGbrcJ1Rl8tZHGMA1H8DSre3Yk/sNt4iFXxN8Qs3V0N3jrhx8Tjh2rY+4ncw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=aMjMPqIK;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CF1606A331
	for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 20:38:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09CF1606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=aMjMPqIK
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4ba013938d7so14856745e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Nov 2026 12:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1795034310; x=1795639110; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gl3uARuCLrvmOuEUSt0jl78CwT5lLVAwnYwWKnlCtjg=;
        b=aMjMPqIKTeoUDpBgnMIqwkeYUd0CBMu/ebiA1IObULvrIXU2b8hu0MhxRqN4vGMBe2
         6e4QpLWrODjeS8x/3VFhJV2e+/oPGqmXBLolqnoJ97EtdwZTBsJ+3vP4khGLjB9U7S1c
         ic8Sf4Ko+ZV6WOHmoSmTrXW/zlCyWfP3ygTRmYzsBAGynkOK75a8nG3jc8V1rCfQSAb+
         s3zRFpYRITW/QUa5bUD4mXjprH5yy6u8KowlmJrdBmbL5A8MT5ymTHsCzoUEYM5gzSqC
         gGc5WYxxqGGtjQklZfBz936Jdp4ZAV7QHQNn1ySvjQ1cEyXyynywM4Klj+/3HWPUYhK1
         Sypg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795034310; x=1795639110;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gl3uARuCLrvmOuEUSt0jl78CwT5lLVAwnYwWKnlCtjg=;
        b=PQZM/2KrvUtvjULMv4Ul8Ijct63GguwzygQJ9nHl4VdWvN9VVo20QVMbcAyCgUBPfX
         /piW/LpZ/qRp7MwGrQ4AXHGNF0/LTuxvGgKtAN9XoAj49l2AAacawYS1oTM7fqGEQVcL
         Fj2plxfPqoBL8s5ggi3feGMQD2/UEsUVWVR7CG1SVfiI7AK1TVx8AIR+fo7ZK6nW1Mua
         WDv85yCpa7fJnno0ImUcJDmcFmk8S4tNYHGVi5CX2/dlamc8h8GFM1Y8gJTuQgRbeyyC
         Oa4UVkyBwox02h6eHB8VUpCtfxCsv0L6UdrVQps/tDKQrI7XldQWXUPq446ZdtFz3qyd
         x+JQ==
X-Forwarded-Encrypted: i=1; AL+hErGR1RJDX7VJcUrHy6eeL4KOuaV+6aX9J40u21qVpJoQ9fj8/wDtJZq9raPjzdrr2lFWbGe/+f4qh38fkQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z8G5KzU0S9CqnpcI3GwcoWbtuA7c30IbRLbUdg/jhStm4vcCHH2
	lGEuOlX9pZd46a336Tfu84kb0I7y/tHT7Syqe+DtWEfzaC3hiVHgIGBs0k1D3r8T7T4=
X-Gm-Gg: AYBFou34to/glAAqzvBnwua4Rctxskctws704cwbxxILv79mpqypk0S+Y6WaFJ30H10
	8SuzsywXmX+4yi2nPFe7U+prORL77WS6+Ievk3jR5ZNa74ovLmKfLBAwNbCBfYYkfSJwhEdqinm
	uBXbe6C81TAPuoaQI9qEJ0/PkcJijufGMfgkAkg5h73OQ0AJnlxCtI3b9OoOYXBSfzsLbSvu6Ii
	JicdAxOD35RL8fQI/ml3krCZOHs76Id0HWtV2uKZTgrfPzTaJoeeVqJNtRe6USNO7pPI25i5RIb
	Wd7/LEVvqQvkpgwNl1bkJ0u1hsYH/y+2VmIRU7p3sMvvjgjPfoK7j/Odo1k97w3Kz+IQwhRN+gV
	crCmxy219inNLgF2LcTvbpkekClKnV3013D6Wu++YAhv4nT9QgIi4mBCuZuVIq90yJaV+kmRNHH
	BGNyOXR6goEMw3rKRWcV9FOwy5Gbz/mWfNlB17R273g56Zj2DP8404JU4ZWGDhiau64f8yF+I6j
	XnYJ8jesiEUzVvjjYriO5iNLXttTEH/0l8u/MGaYYge05YiV5GdpB1MHkS08nr+caCPQT/oTwPR
	w3P+U722neyP4UrT3Z7mOw==
X-Received: by 2002:a05:600c:6298:b0:4a2:397:73fd with SMTP id 5b1f17b1804b1-4bb7da1b37fmr77157215e9.12.1795034310161;
        Wed, 18 Nov 2026 12:38:30 -0800 (PST)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3f687baaasm841803a91.2.2026.11.18.12.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 12:38:29 -0800 (PST)
Message-ID: <da879d7e-7790-4507-bfbc-55a78fe20ddc@suse.com>
Date: Thu, 19 Nov 2026 07:08:22 +1030
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix bytes_may_use underflow after a failed tree
 block allocation
To: Vlad Poenaru <vlad.wing@gmail.com>, dsterba@suse.com,
 linux-btrfs@vger.kernel.org
Cc: mason@kernel.org, osandov@osandov.com, josef@toxicpanda.com,
 fdmanana@suse.com, boris@bur.io, quwenruo.btrfs@gmx.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, stable@vger.kernel.org
References: <20261118170332.992625-1-vlad.wing@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ujyBQkUpLw5AAoJEMI9kfOh
 Jf6o8OIH/0mqW+TQM4m2x3hCsnK+oB4yJH1qnGvIhFF/Lhs48wI02sGh6/4aA0hkCDfd9LHQ
 +ci4FUepZ9y4VS01+oIExbg/8ytzGYTzLtb44jK2GBOBVSJkMiha6jp22XFt7WUkT/tvbreu
 WWdGsaJIRQaZChy7xsMI8lqQ2WdmluZJ4LT0wD3l/l6QU1ZseMGySebdY9sVOQEOJNV7Qj92
 /KOAFNmeZshV/qDI8Iw1RTs6TvLqCcqmlZLCmJkYSVhT1RonWRren8xIRcFEgMe004IDnt7V
 qdQhk/nhTS9x9MBAhMRl0TTE1VKDLvVALsud3iZLrmmtYvwPApzGJk052f0m28vOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJq3ukKBQkUzDspAAoJEMI9kfOhJf6o
 SNsH/1ysUWOKmzY0rGS3ZdS61QgqMGhSWD/EJ4UiPw+xO4l4+GtX0fOAqxqsmBKqje3vyhBa
 Z5o/1Y+gNiN+E6RBcSz4b1TAd78sQ2bvT5DWOvBjeeVxHdiuQMIn4S8xk5ZpySBw5ifjoiuL
 0M33UVtJOzM8yfAeL+d/Rp4leJw72SutjkLyZTG/gJIp4pJGD/kFHn24OLL0IxEcO0gOekNZ
 os5e1R6jAJ2ILk7+MDnvU8wXHcCiVzuDhJLI1tih1uUIE50muHQJWbYuVBbdJeu8WlIDDssx
 UOCxLylNG3gDXV5MhLubPTOpp9OiFc/XC37nvkgEcrlmlOFBv4/NJCbECpo=
In-Reply-To: <20261118170332.992625-1-vlad.wing@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/11/19 03:33, Vlad Poenaru 写道:
> When btrfs_alloc_tree_block() fails after btrfs_reserve_extent() has
> succeeded, its error path gives the block back to the block reserve,
> although the block has already left bytes_may_use. Each such failure
> leaves bytes_may_use a block short, and it underflows and warns in
> space-info.h when the global block reserve is released at unmount, or
> earlier.
> 
>    btrfs_alloc_tree_block()
>    |- btrfs_use_block_rsv()
>    |- btrfs_reserve_extent()
>    |  \- btrfs_add_reserved_bytes()  <- bytes_may_use -= blocksize
>    |- btrfs_init_new_buffer()
>    |  \- alloc_extent_buffer()       <- fails with -ENOMEM
>    |- btrfs_free_reserved_extent()   <- bytes_reserved -= blocksize
>    \- btrfs_unuse_block_rsv()        <- block rsv += blocksize again
> 
> Since commit 19d7f65f032f ("btrfs: convert the buffer_radix to an
> xarray") in 6.16, alloc_extent_buffer() can fail this way under memory
> cgroup pressure, because fs_info->buffer_tree is memcg-accounted.
> 
> Return without giving the block back once btrfs_reserve_extent() has
> succeeded.
> 
> Fixes: 67b7859e9bfa ("btrfs: handle ENOMEM in btrfs_alloc_tree_block")
> Cc: stable@vger.kernel.org # 6.16+
> Reviewed-by: Boris Burkov <boris@bur.io>
> Signed-off-by: Vlad Poenaru <vlad.wing@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> v2:
> - Shorter changelog, built around a call trace (Qu Wenruo).
> - Dropped the code comment (Boris Burkov).
> 
> The code is v1's apart from the removed comment, so v1's testing stands:
> its reproducer leaves bytes_may_use below the global reserve without the
> fix and not with it, and fstests btrfs/002, btrfs/220, generic/475 and
> generic/476 pass.
> 
> v1, with the reproducer:
> https://lore.kernel.org/all/20261113170926.1468850-1-vlad.wing@gmail.com/
>   fs/btrfs/extent-tree.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9b0a5c6b96f3c..8d4c66bf850bc 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -5433,6 +5433,7 @@ struct extent_buffer *btrfs_alloc_tree_block(struct btrfs_trans_handle *trans,
>   	free_extent_buffer(buf);
>   out_free_reserved:
>   	btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, false);
> +	return ERR_PTR(ret);
>   out_unuse:
>   	btrfs_unuse_block_rsv(fs_info, block_rsv, blocksize);
>   	return ERR_PTR(ret);

