Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307624;
	b=G4sfnwU7OcKNnPZNBKqlw4GiWgtXLeZva+cG/H73KTfd8MjEdHIyw0IZ4wwP2G7JMucQ
	 y+NhRQX+78os/lhOtg4NimDCSD2ikK2MbcxZxzqmQDYffRt4YU5gPpv+SK4v8H8s2vf61
	 9FBckIqrUqLUKRe0ulVvYGHEt5yqQHCmu/ZrL9ZPCRfyYd+GFgpNGikCtuvmkX+zwcNy5
	 a7MvmnW0xcCqO1WS/HTMkdFBFLit2tTshFmqM4vKmfyuSQLfHgvfBXR/jtcBzZy5agxyO
	 B1pTtedEPvSc1rMzD/bHpFsCd3cyce+8ZBPaeTyWeAN2CFiD7Bgp1pfSHXDj/k9kb3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307624;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:Autocrypt:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FZ3xAAoQ7KTxcnFozk8njy0v9vP13bSoxVqgwxzM6N4=;
	b=Mkxkrh6FUMiUld/+HfBXXdpijxe9dZvDsWcuM5f50iuE3na7+kLDbRFdJ6JF+CFsN+71
	 IUCbOtGIn1jyV03bBaAkboxz7B/rUqbUwMlNm4cYlUl7BLauGuz1+2Z32eyM+Fh64Oq7z
	 Ltf1mWWsr0u0OP5qkjjvrKWD3pWXrOnKvUsd9LSq1gO1X0Z5WfHL+Voc4uE74Q2ofk6r4
	 rRU3Dnp2UI5ePPUnvNtYsqfPHyeWhtRBQB6MFlKN/AXJTh7eyEw2/sGExqWW8diVKtRZG
	 KhUklKO6Fmh9xTuR4Tgz3+oltJxwktcKImi5OA5YGlo6JGVHpm8U9Hypr8PTIPXpNvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.com;
	spf=pass smtp.mailfrom=suse.com;
	dkim=pass header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NROchiMU;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99647606A31E
	for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 21:00:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99647606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=NROchiMU
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a7992e2f7dso24193695e9.3
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2026 14:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1793307622; x=1793912422; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FZ3xAAoQ7KTxcnFozk8njy0v9vP13bSoxVqgwxzM6N4=;
        b=NROchiMUwfPSnMItLWl1ZgnVceM+TLUqZO9ODpjiQPaShn0SN4H8h61I5CRHeiM5GG
         OAJmdT3Mi0ysz/DIKvvmqs/OynOc0ITVrtTthl3ms1LWb3+dZF9KYI1AXJA2hlL12341
         iOvM/YgT2ZYkKR0R3Te+VE+1u5wadYpHTMSAY0+7f9LVJjJzuqK1318MWg6iubhpzMeu
         SqBqJec8Okn6Um0QzrCp2tjqYw0kzH/aGc1YFKzhjwqcr2JJiCwennhX6C5YPCDAwbN/
         xElVj0tTprPBnka3gDT7qNd5dthcpZthXhjKMERVZ80Ck29Usu1fIdhR/OHerv9VBnbM
         Xasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793307622; x=1793912422;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FZ3xAAoQ7KTxcnFozk8njy0v9vP13bSoxVqgwxzM6N4=;
        b=wj6CJ33yzgdgPzjvS7fuG6OGAvTQMG7ZLOwdxu6Uv/Vpl3Dd4QiHUk5OvIo6l1+2wi
         2KCMDI8WVqKsjb5zP2S9wqVDOuU34FVWdLPGBCr9k5m938Co0MKAUDwTe5mNZUJQUycq
         vup6OYVCh9ESbauKLjzf4zXta15VNwiQ1wIVAq5qhqzsEnvadJgBJN5WjzS+OL9w71eD
         dkbYjVt3cxj+YkAaKWDeDNb/opa5q/YQUD9eLQcQBCXYKYlmKpYWjoAMoQgp5Davdqpc
         PqeZSh4i0CSyS68LEnJCgXGS6gxYGURFERAnWWdRUv7qUc77g/bcyZf8HKCqMPav0CKC
         3FvA==
X-Forwarded-Encrypted: i=1; AKwUvBx4gERCR287YVDuObpBJGzC4dF4Sw7Nq4Qmzo/4rnhUy01849G24tgxnfQ0u/1MwqYejhuIjD5+ckIx3A==@vger.kernel.org
X-Gm-Message-State: AFq9FYLY7yaU7KzzVcO/CHs7DeC2TziW6CzaJXSCE/RqeJipNusWoLNR
	nwsY99RYzHhnGJ1zppKXj/DxsYzlMBl2wuayAxCQy2kIDk/F9FZbY++286ZNg1euvKwbnKHoEnN
	wGQoShKI=
X-Gm-Gg: AYBFou0o/FFQu8/IBhouTRG+5ZlDp51KsLunaD/KcZervmy74dzNfJIJOgzcBg8pDn0
	vRgHJEZub+0Ew16iGyCuBuejW0GKEsK74EuOEgvb36bd8U8SXEzs792lTB3gwoxltq52mNQmVpA
	hNMRYZl0m+p7tH/qMyyxC+e9C4DkfM5X2wu+LajgsuaSTATaHbAkylVQLKDgdk6GKHY8JcGu1s6
	U9zxLdGxAnDOn+uPALH5KDpWuslc6vjvNGleZ2YMesxs8yxHv7+AKrD/WsO52OMxw8RGkED31wC
	En3mTBnRCnRUT295X6qwTLY2jYDZVKj/yVtGCKB5TDzQ7ROLWO6qlMJOFilTrXQVruaRHhDd0BB
	IqcWhEfAWgRK6idXG4E/HS4EtHDs5vccCVxxpezaYNllqc/70F2RKBxxSSS/KiCVGM1CNDoKWFS
	7GpB6MdPe9LcpdbcUmHtd+Zdi8gWxsD5ldMuc+0am0pIDSiptl7dXspc/QoBX3eGzvDyfbkRAq1
	Zj/ND36kqoDhB4JQqlcIF4FGdVrwNJJpWT0aLQAE8X+pynIJSIOYLLVk95RIJydnRpWWgyNU+/0
	+XLfMCRk93rZLD5XcfAkVA==
X-Received: by 2002:a05:600c:46d1:b0:4a2:1867:10e8 with SMTP id 5b1f17b1804b1-4ac17b2c8a7mr3409785e9.25.1793307621934;
        Thu, 29 Oct 2026 14:00:21 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae85e4ff4csm366033a91.1.2026.10.29.14.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 14:00:20 -0700 (PDT)
Message-ID: <6ad220fa-d6a0-4b4c-a313-a0cc052b8637@suse.com>
Date: Fri, 30 Oct 2026 07:30:15 +1030
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
Subject: Re: [PATCH] btrfs: reject zero num_stripes in the system chunk array
To: Cheng Yongkang <teel4res@gmail.com>, David Sterba <dsterba@suse.com>
Cc: Chris Mason <mason@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <179328314071.648427.12527832319954042748@gmail.com>
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
In-Reply-To: <179328314071.648427.12527832319954042748@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/30 00:42, Cheng Yongkang 写道:
> validate_sys_chunk_array() reads the on-disk num_stripes and passes it to
> btrfs_chunk_item_size() to check that the chunk item fits in the system
> chunk array.  btrfs_chunk_item_size() has ASSERT(num_stripes), and the
> only num_stripes == 0 rejection is in btrfs_check_chunk_valid(), which is
> called later.  A crafted superblock with a BTRFS_CHUNK_ITEM_KEY entry
> whose btrfs_chunk has num_stripes == 0 therefore trips the assertion
> before the invalid chunk is rejected:

Since it will be checked by btrfs_check_chunk_valid(), why not remove 
the ASSERT(num_stripes) and let it continue to btrfs_check_chunk_valid()?

The whole idea of tree-checker is to concentrate the checks, not 
distribute them again.

> 
>    assertion failed: num_stripes, in fs/btrfs/volumes.h:714
>    kernel BUG at fs/btrfs/volumes.h:714!
>    RIP: 0010:btrfs_validate_super+0x3ce7/0x4210
>    Call Trace:
>     open_ctree
>     btrfs_get_tree
>     vfs_get_tree
>     do_new_mount
> 
> Commit 2a9bb78cfd36 ("btrfs: validate system chunk array at
> btrfs_validate_super()") moved the validation out of
> btrfs_read_sys_array(), which rejected num_stripes == 0 explicitly.
> Reject zero stripes in validate_sys_chunk_array() before calling
> btrfs_chunk_item_size(), so the crafted superblock is rejected with
> -EUCLEAN before the assertion is evaluated.  open_ctree() turns the
> validation failure into -EINVAL for the mount.
> 
> Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
> ---
>   fs/btrfs/disk-io.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index c628c50..920ca4b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2389,6 +2389,19 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
>   
>   		chunk = (struct btrfs_chunk *)(sb->sys_chunk_array + cur);
>   		num_stripes = btrfs_stack_chunk_num_stripes(chunk);
> +		/*
> +		 * btrfs_chunk_item_size() cannot represent a chunk without
> +		 * stripes; such a chunk is also invalid in the system chunk
> +		 * array (system chunks are never remapped).  Check before
> +		 * btrfs_chunk_item_size() so a crafted super block is rejected
> +		 * with -EUCLEAN instead of tripping its ASSERT().

Please let your agent to drop unnecessary comments.

It only wastes code space without providing any real benefit.

> +		 */
> +		if (unlikely(num_stripes == 0)) {
> +			btrfs_err(fs_info,
> +				  "invalid chunk num_stripes 0 in sys_array at offset %u",
> +				  cur);
> +			return -EUCLEAN;
> +		}
>   		if (unlikely(cur + btrfs_chunk_item_size(num_stripes) > sys_array_size))
>   			goto short_read;
>   		type = btrfs_stack_chunk_type(chunk);

