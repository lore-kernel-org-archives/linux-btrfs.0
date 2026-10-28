Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221344;
	b=oHqee+XfNISYLLx1fgiuZ12nbXcb37q9VWGBQvl50kB+eGI+Z5hyKLX4k82fx2Tbc61z
	 F/nL54zGj0wm3ZJZ/tn0WzWEKJKO1vYzdvcaEshcbx/2BewhvrIO4qtdstLok2T2bP+5M
	 JwbmxJFXkVKyRwybLznAEkyLTZEE+0gwvJSeJu8AT+5wYeLzMyIjWRcITYzbYnLaEVvTz
	 9FfS95ooYbOe2gcTSYp1ADjh2wFozQ2tLlMBjj9CvltfEh2svfuWYTUN5AeBVNaX/YmZ2
	 YSpH4yPPlWOiQz2BDyqrFpPjFLMffXxj/fzcPPa5YHDKgPtkzmUR7KGhtoQ2/psXspg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221344;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=KJq5x4qtFdwftlwjCSnZ3dvBtK7oZVw0oOvZEW6vsM0=;
	b=sZbChkQYWXgHGFeC5/NTw1tOYZWuwAO1OAyhMle+zDTrC869lHqjXJzlNf50DSE+EjlU
	 qRybW3o/CEQdtizzD4oEyExO78spwnGLDNTqCckDu4aKBf1yIbR2r5gC/yCnzT2ue7pLA
	 4eRLGpFnOwXkVdtn7xqK5pz0aC2z89qdfroia7+yc5gUSPVKmfpLcK+lePd7KYKiscGi3
	 OCQArVpGIQc4Z9UANeNUM9P60nmWCMss1jD8QSvgatE+TA57YA2Fc4KNuBo+/IBY4cNyx
	 RST89qgOjJ5atHm0M1h/n6KM7w7QxZDC42HUihK14HVnuswV/FaMkTF6m+bWgwpDrbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=I6VdWccZ;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559A9606A31C
	for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 21:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 559A9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=I6VdWccZ
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a4d7ae1ae9so13242235e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Oct 2026 14:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793221342; x=1793826142; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KJq5x4qtFdwftlwjCSnZ3dvBtK7oZVw0oOvZEW6vsM0=;
        b=I6VdWccZ34lFN1zBZ8fGVTwa71nz0eMGoWRNeR4BOOYTn8XzzMG9EfeUPufPOHIQTw
         bV97F0O5NwU3ZzBmswKA/4FuspwNXjHXzBVQWZv0xk79EPSIe37YNZu36QYkoJjbUOs/
         uE/x7IdQlT1h7Md7hl8S/UAHKX2Ff7iEe3eSbMdddPVBcg2isAGv7gvgEEtf+DVjVs1z
         K1F8qGnruWVGGHMhOzoEjICpjsYCtbr7Iw/8gjcE2iM5Nxn2keJaBQdxWCmjvwj/NRFw
         fGeSWRCd3IJdtg8L9WoeEBxWDokcTpFMyiYakPzwTyoubMcCsHi56R+NZGCVh/qTQ7cG
         YZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793221342; x=1793826142;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KJq5x4qtFdwftlwjCSnZ3dvBtK7oZVw0oOvZEW6vsM0=;
        b=QipVOxOHpeX8hLIEmuJN66Y/LCLIoSg4EH2mChtoUH8POJYxhbpzzeVYlqpMJGY6nk
         f2AoqCMSC0R1jr6rzdkVGZ3oeLKDPgljOlWIm5Yt6jSOJsO7MLu+TbRG/43QkQU1zC9f
         zT4JTZGgjR3hqQrKljm/gXn6vSaO28pdntLxJuv/j74ApzT2Sww6glzr4YuA5WNww3L4
         rv697krAjEO0EJ2qjCr2dNFcqcHhi5bpC5I+Ry06yxl/JQNAXR6+v0r37uNM2yOD7CwU
         QAgAWkb8q97Xck3bUjJs727BGdKiWKIZ7uzH4IqdOX1vNhLyrvK21t6bTFY8n2GxILmZ
         KUfA==
X-Forwarded-Encrypted: i=1; AKwUvByuuooCDYYyPze3Gv27nsIk3hMecx1sMDaZ6cgYUOnqR8bEE65EidhIG6MBXk6W9l87oCPcH1B/S5enyA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIXaFfTd25xT96hpUYP5kn4eyHaPMesnuMeBzikbZZunsYD51ME
	6rHyJNbWFqDqiOwz4DpEQGb9GeXFP0Fq1+5ykAlBpu7OQi7acHxSReOHDaj0gDHgKqM=
X-Gm-Gg: AYBFou3xwvdWNqhs5hbNB6GgMY2+coAra3+AHE9xeRjWJz9jXxf8QTBzIYdIsHQpsH9
	MjprZbneJcw2OsDlO5g9iIoxfSBrU+dSqp/eQvxRb9pVuoa5l9aUozwgnjhKx2Wn5GViy4tQypp
	Gu0jprHtshZ+VnarIb1DH/nRCsxSR6h2xnv+wBAYCfXbH2APbg0Cpo7Q5FHCj2CoWyEOtZJ3BnC
	PP9+XenjtV3G7xjBR8vNLu5rTuHAFlUw8ns6gJcL/bvh9hKN4NyAMbqkTK9DPhS8IMfRksPAG0j
	677mrj5Q1cWd5/tIXuf/Vmo7g+8xOkPI8DpPI2RLNRBXRYfpQA6gWg0UvRCdGoKJY4O3Akndwtj
	detyglWHlka/5tZqSaVG6dnjcFy/+qWyWS1VElIyEBVn9YY/J1RPZf7hlAfhUUippbydAnq5wBE
	oV3sgxaEwdVu1aD7nC7Xrp7DxSzeJBkQ+a5d1oVg9gPtkXfMRSs3ZTZJlAw5dTZfqHL7cuJ4wcq
	JkwODxL98ycHQWT8uKnv1eZ+BLFjQxi/hF99JjzYk9U7WarUyQEEGl2UFrnf83IZYyaLW+0Kwqu
	ZNskIROGBJNgL57YkuwA3Q==
X-Received: by 2002:a05:600c:1d0a:b0:4a2:883:4adb with SMTP id 5b1f17b1804b1-4a9678c28ffmr80849565e9.22.1793221341733;
        Wed, 28 Oct 2026 14:02:21 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae57a010basm2292120a91.3.2026.10.28.14.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:02:20 -0700 (PDT)
Message-ID: <4de45a85-6db2-48ce-826a-90dee4e44a5a@suse.com>
Date: Thu, 29 Oct 2026 07:32:15 +1030
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
Subject: Re: [PATCH 1/2] btrfs: account partially completed discards
To: luca.stefani.ge1@gmail.com, David Sterba <dsterba@suse.com>,
 Chris Mason <mason@kernel.org>
Cc: Robbie Ko <robbieko@synology.com>, Filipe Manana <fdmanana@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261028-b4-btrfs-fitrim-interruption-v1-0-bf5c53738b3a@gmail.com>
 <20261028-b4-btrfs-fitrim-interruption-v1-1-bf5c53738b3a@gmail.com>
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
In-Reply-To: <20261028-b4-btrfs-fitrim-interruption-v1-1-bf5c53738b3a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/29 04:25, Luca Stefani via B4 Relay 写道:
> From: Luca Stefani <luca.stefani.ge1@gmail.com>
> 
> A discard can complete part of a range before a later chunk is interrupted
> or fails. btrfs_issue_discard() reports the bytes already discarded, but
> its callers only accumulate those bytes when the entire operation succeeds.
> 
> Link: https://lore.kernel.org/20261028-btrfs-fitrim-freezer-v1-1-0ad1d58aa94d@zliang.me/

I don't think this link tag adds any value.

This series is going a completely different, and more sane fix than that 
LLM generated one.

Otherwise looks good to me.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu


> Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
> ---
>   fs/btrfs/extent-tree.c      | 5 ++---
>   fs/btrfs/free-space-cache.c | 5 ++---
>   2 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 9b0a5c6b96f3..242db255cf1c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1463,6 +1463,7 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
>   				continue;
>   
>   			ret = do_discard_extent(stripe, &bytes);
> +			discarded_bytes += bytes;
>   			if (ret) {
>   				/*
>   				 * Keep going if discard is not supported by the
> @@ -1471,8 +1472,6 @@ int btrfs_discard_extent(struct btrfs_fs_info *fs_info, u64 bytenr,
>   				if (ret != -EOPNOTSUPP)
>   					break;
>   				ret = 0;
> -			} else {
> -				discarded_bytes += bytes;
>   			}
>   		}
>   		kfree(stripes);
> @@ -6703,6 +6702,7 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
>   
>   		ret = btrfs_issue_discard(device->bdev, start, len,
>   					  &bytes);
> +		*trimmed += bytes;
>   		if (!ret)
>   			btrfs_set_extent_bit(&device->alloc_state, start,
>   					     start + bytes - 1, CHUNK_TRIMMED, NULL);
> @@ -6712,7 +6712,6 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
>   			break;
>   
>   		start += len;
> -		*trimmed += bytes;
>   		trim_len += len;
>   		if (trim_len >= BTRFS_MAX_TRIM_LENGTH) {
>   			*ret_next_pos = start;
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index bff6e5b372d6..a85806bcf87a 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2415,10 +2415,9 @@ static int do_trimming(struct btrfs_block_group *block_group,
>   	spin_unlock(&space_info->lock);
>   
>   	ret = btrfs_discard_extent(fs_info, start, bytes, &trimmed, false);
> -	if (!ret) {
> -		*total_trimmed += trimmed;
> +	*total_trimmed += trimmed;
> +	if (!ret)
>   		trim_state = BTRFS_TRIM_STATE_TRIMMED;
> -	}
>   
>   	if (reserved_start < start)
>   		__btrfs_add_free_space(block_group, reserved_start,
> 

