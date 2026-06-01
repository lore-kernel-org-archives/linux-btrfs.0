Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D562390606
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jun 2026 10:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780308803; cv=none; b=EF8SZvpExE8EZd3AUii5WECu/xsVffesklzbdD+t9JPV6socWPU5piMzWyoKfIEn1pFHHG50OJDReYzBQhRcIi9SdVNd32Eht6zFbovbIqUih7j2eim77FZT8stwtoTSVfogBIvn4Vhy0S1/FDeC3fk3j+lD58n2RtpjIv9iTj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780308803; c=relaxed/simple;
	bh=VW00pO2aIbhyKvOdYKjEeIJA4OsOLmQu97ZzaoXj+jM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kgJf4d5EvCJcMoKf1DD9hQM7tAOm3Wq0PNsN5vC1jfayjAxgd7PXjlsKuvZ5NXZTyZbXHtnVxr3Pz0nVsQKgIR9S3+8Qk4lmAt2xG1hY3ZgxGQ2MFcez2aBnHVb2Kh8hBBrqN5tyNo7XVpwfgGy/dwaj+dthHILMYHk2EMDotxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=g5v9UR3u; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="g5v9UR3u"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-68d23430690so2078478a12.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Jun 2026 03:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780308798; x=1780913598; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2QDvKFTQLOBwj/nDuY7JbFLbtx/8W1yZ+oNILCd6x+c=;
        b=g5v9UR3uI4KbjS5JRTPJmoXG+TXMZrF096Uwc+0roJd+XnY6MGbLIuNHpLGY+WhJmk
         VKERTGJVqg8uPmDAy6kU8vTUdYGq3jUzOCGEWsH7CZ10vnCuIIKRexEY7Dcn0IwYLJHI
         ZIBSBCJW68ZvBdH8W/s7S6+PbKM0/VRw5CzjxStdrMOaVT8KQRLvEnk8XSCybf+261/O
         uYCvE8wFDiXNZ+QRh97OavN+G53jxihzM7VFgzkd9riy0ndgCO74bVY6S6WjArO5cmXM
         WnvvE6g/0UHedD+Nrd65U5LygNuCKhn9zNDW08dT7Dsd/ab/s3iW4+XizYmepuf3VbY9
         775Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780308798; x=1780913598;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2QDvKFTQLOBwj/nDuY7JbFLbtx/8W1yZ+oNILCd6x+c=;
        b=NQAou6o4DCjuo1Sp6MpEW5AVT9X464Kioui4Mh7twqcwFazH8yEH4HRigVXwhkQ5WP
         BGHsKBj/uwnQwDFaMQiCd9WH0a0e2L8XydlWelKfi+D+twFBvCYD059V9bXuhfJDnoth
         70DPRdX7AL1UkrvN9K+KaoX1WfWuaW/vf3tH4uwyS1Pq3fZhgG7tPMMuYkzYPg5+Yej1
         ZdFuGO+aAllo14rP0ImBmHsW/hnoALoPqtAersoNOhC6M3RTmB0gqyqMRVdnIhiutfj/
         ZlR71givBcEBh6TLsORSwoqOTSeEtEOTOHG4CXC265CtxmSJztMf5j5aPvt6OYZXOox8
         2IbA==
X-Forwarded-Encrypted: i=1; AFNElJ+VYbp+x2V39eHnmkXAijDtJqCuvfxaNyVLZwy+Drrpjpw8fPBnSxF9gYYzEGStVqgruP84z01xxpsESQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwFrD88j1x/9U+uYj9g2Ss6VuPQT+vi6TQwckb/uM41NFuWNfW1
	Hn7iVaVPIjs4woE8R2QXIFaqqFMk4ZWTMAPN0lq5s+8cJe9MGMRoD7t3KJmRNt/aHAo=
X-Gm-Gg: Acq92OHFtWM809vbaoWff5ipLqgz4CPY0hiKD8FimiChXUGJuCMEuwdkJyBJCzSa8U6
	QJVd9ylw3PeMFhUiDPXVVnNuvxa4lBk3AR3x9WQ1Pz4aBbtbpnX1Uz/zCnYhRGG1VdSOR4lOkU2
	0ZGZuS1mS6fdm2wI1SSJbhTf99N0D0BCgq1Wg8t+2SXPr6PSDLg81V6UyssCXzQqE97l3i5jpqV
	Hh8NsJTibJoApC68tPXzTfQcneAUlUfWGQbktGxd1GSNhLun3LVovjOb20ICYIGOdm+Ay93i+bz
	Bu7W+HJhnZZXkUdEm1ZfbY993FO/pzb3zNRgVJshwTfPyTjOcDeOnr6/4K9gyWr3bmmUQz9TZnG
	ZeWO1/oREN/0M9VY/LF00m2+iS7ae4s71VCUVbArFd8pTggJWVioAo6WWcDzMGzXfjtpRGgVIPm
	Oay2KfZZG9NZJfeNsl/5K9f1BpoGRyneuoo0fL4xf0QO/j8JDjmS0hAi/6CL0rpwP9f5q0Qq/xq
	9dfukyZFa0GymyYeyBjp2kLW/1acxsq2Oyl2wC/TzuJvtbl8GHpq89+sPFG/d04Kk56
X-Received: by 2002:a17:907:7710:b0:bec:fa92:d36c with SMTP id a640c23a62f3a-becfa92d54bmr193376266b.38.1780308798226;
        Mon, 01 Jun 2026 03:13:18 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc0c341dasm10772197a91.15.2026.06.01.03.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 03:13:17 -0700 (PDT)
Message-ID: <1e7cae27-1e3f-4c6c-9498-2e76b1058b20@suse.com>
Date: Mon, 1 Jun 2026 19:43:12 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: use mapping shared locking for reading super block
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <6085d60d77ea781ccb71be379b2e93825c489b4b.1780306581.git.fdmanana@suse.com>
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
In-Reply-To: <6085d60d77ea781ccb71be379b2e93825c489b4b.1780306581.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/1 19:21, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no need to exclusively lock the mapping, shared locking is enough
> to protect from a concurrent set block size operation (BLKBSZSET ioctl).
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/volumes.c | 4 ++--
>   fs/btrfs/zoned.c   | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 66c44aa678c0..f409f870a6bc 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1369,9 +1369,9 @@ struct btrfs_super_block *btrfs_read_disk_super(struct block_device *bdev,
>   				      (bytenr + BTRFS_SUPER_INFO_SIZE) >> PAGE_SHIFT);
>   	}
>   
> -	filemap_invalidate_lock(mapping);
> +	filemap_invalidate_lock_shared(mapping);
>   	page = read_cache_page_gfp(mapping, bytenr >> PAGE_SHIFT, GFP_NOFS);
> -	filemap_invalidate_unlock(mapping);
> +	filemap_invalidate_unlock_shared(mapping);
>   	if (IS_ERR(page))
>   		return ERR_CAST(page);
>   
> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
> index ec15a57c46fa..0f87701e38e3 100644
> --- a/fs/btrfs/zoned.c
> +++ b/fs/btrfs/zoned.c
> @@ -131,10 +131,10 @@ static int sb_write_pointer(struct block_device *bdev, struct blk_zone *zones,
>   			u64 bytenr = ALIGN_DOWN(zone_end, BTRFS_SUPER_INFO_SIZE) -
>   						BTRFS_SUPER_INFO_SIZE;
>   
> -			filemap_invalidate_lock(mapping);
> +			filemap_invalidate_lock_shared(mapping);
>   			page[i] = read_cache_page_gfp(mapping,
>   					bytenr >> PAGE_SHIFT, GFP_NOFS);
> -			filemap_invalidate_unlock(mapping);
> +			filemap_invalidate_unlock_shared(mapping);
>   			if (IS_ERR(page[i])) {
>   				if (i == 1)
>   					btrfs_release_disk_super(super[0]);

