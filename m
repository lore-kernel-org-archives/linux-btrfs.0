Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B762F472F7D
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 21:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791062973; cv=none; b=DlHJW8ytlpM8Q37J+v7Sn8tGlvu3CLlVTYeyKFBUNEQinMK6teyoYBtEU56lwflMa4lK9a48+SIh+TwM3YGYhoDFfbZZDsRT3TerTlcaQwiF7mleiHr5j2L4xdd/65S8q6d7ntRSuwvUKf451vZJd9X28GDyE0nfRR0vwIKW6j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791062973; c=relaxed/simple;
	bh=75h9TbYs2URy0Myh9C665oc6CbTF4h6p4hZVcXTfNmk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IgXEachSAFpx0jRkLcwTjX+FeegVF/VC8xy7uYkksFvDGb/+gw0RRbc0Rm92SRO/VcWogDyROuCZiH+5b1oI9fA3Az7/hkGtDUpYyBvbCZkj0iZtTQxvRJkWfcE4hnKOpgmFEGDfhPqsDaX5YaQMakAp7PdjH3JvyOf4ctl3N00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OcmE5cuy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OcmE5cuy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b6so4719695e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Oct 2026 14:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791062970; x=1791667770; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G1wTGTtJdOYnTt77FpTvkTt9cYqIQVDRlVCTunfZSFg=;
        b=OcmE5cuyAqPIvtql9w3rKsL9K49SW2kGz+Ub7x6iW0rNdqaTRWKBbB5cVbH4Ns+Zwy
         LXL1um9Ls2d8S/U9yALeI+UDZDwmAEx/g0GQn9vhxHpvMrOuV7yTRBhNQgdG8VogQhH6
         x2b/+qpeRz28AaG9yvLyZATfSm6jp2ocgXGEiRr74/POjNpF8xd+fXjH+3kSnkDbkXqK
         lB5WdgJu0DTvWc2y/6BJMU7YxyY6IdDiU8GlOoux8jAG5I8bIRYLAVL35RKU7ZuRG5Ut
         JsOfO1BA+YfldFOz6R/s88CjNQuQodvOuEhwEY8OlYL1qDQ1USqs0Eubq+ymtJpFS63b
         obyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062970; x=1791667770;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G1wTGTtJdOYnTt77FpTvkTt9cYqIQVDRlVCTunfZSFg=;
        b=krMoqXhf50ePDfCWugpfbsPrtTIxiSMJ+BREw25xBFPv9tftK6iAHBaAR5XQnJAkjE
         ILCE4cblAjCxv7z1rc8taz9eBFyXFG3xSHJjO9lJy3iluox+D9VMo4wQ0kKPK/F63QYa
         9gD/EOXAL4I7v6bDmBXgrH3fA6HKj/YlYnylTaduedpPX3Q6+TxrFeqGJt3LFa+eoUq3
         8CeTiIbHAXNjuAPDBUZdZk3GA29UHJxm+5rwHfveZ7mhrtb1G04dXA84maosbIGlAvkM
         5pfAFB6+n5MRZciHUDdBb9e43+oSLaST1QtPdJoZd85vg42UO6czW6OvFmv6j9wH1xxI
         70bg==
X-Forwarded-Encrypted: i=1; AKwUvBwEi3evCQFV1Jl3OruHAn5kaoPKKkAK+bNf9XNIrL7Lb7VbFSgPso3jSWueIdRK1If6fSht4iQze9jeug==@vger.kernel.org
X-Gm-Message-State: AFuF++n3MPqM3NB5vyBtkx1Ly+T3HVfOuw6+usbP1ZBubf9Y2bZYQx+k
	3V7Jsie5RwMJsyC6ta4abiE4OJ6Fb6ZMaU4Sp+79AWCw8fnRmtMiFR/xU44QREx6Zm3o9ip7DUl
	CtI32f3EegQ==
X-Gm-Gg: AYBFou1CZMQbHpj3qzDc/ZSEDTd6pGwcBhvlf5UsngC5iItp2gChOG2Tb6a1n0vceJ3
	FZRKTUrVsuAn8I6W7MieTrPCGFxq0Nu1HS2n5uWQr1/Akn30ECn/rxCRH96btMSeuDD2JyVboUD
	FaAlT+Ekj6SDl6j8mfwtxMpn9XRj7MtBT6lJATYz09muno4CW/DhPSY+wEkgdmU3QfeuBb/t4AN
	rEMoyBrzhcH8drCTz/qbjlLcRXGu2Cb/nkqja7vD40eAgsqgKyt+fdJS3bvVDdUuPy4QPut755i
	pVFwX1pY6rAbNxbWw9ZGu60M/05WdGEFcKNYNATrlV6rUu586Upr3x7PUzqGKPP0WYnz+u8TM5B
	yJx2uDISkYirgZbzhR4UO5w2hoMG8k2qmlQB1TLZnwBtsc2MG23JDBtGsjINvvKs/0gFHGO7uHW
	fDfZNbJ8Uqi6l9IXoWF5m8xizTJ+jJitxhgsuiZqsEYATNsxY1E+EubLgnUzDlFpo=
X-Received: by 2002:a05:600c:a011:b0:49f:ce78:356f with SMTP id 5b1f17b1804b1-4a0276b869fmr98099065e9.32.1791062969616;
        Sat, 03 Oct 2026 14:29:29 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a7ae260f19sm1076639a91.4.2026.10.03.14.29.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 14:29:27 -0700 (PDT)
Message-ID: <bc377417-8c26-4982-9668-94d5e4368cf7@suse.com>
Date: Sun, 4 Oct 2026 07:59:16 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] btrfs: qgroup: fix swapped blocks existence check
 when tracing after COW
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1791046651.git.fdmanana@suse.com>
 <59dc69757209cf74399ee29786aee0f5392f1a47.1791046651.git.fdmanana@suse.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <59dc69757209cf74399ee29786aee0f5392f1a47.1791046651.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/4 03:30, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> In btrfs_qgroup_trace_subtree_after_cow(), after we erase the swapped
> block, iterate over all possible tree levels to check if we sill have
> other swapped blocks. However the check is wrong, it considers that there
> are other swapped blocks if any rbtree for any level is empty, instead of
> not empty. As a consequence we set blocks->swapped to true basically every
> time since we always find an empty rbtree at least at level 7, since in
> practice it's nearly impossible to find such a huge btree. This makes
> every future call to btrfs_qgroup_trace_subtree_after_cow() do an
> unnecessary rbtree search instead of returning immediately.
> 
> Fix this by updating the condition to set swapped to true if we find an
> rbtree that is not empty.
> 
> Fixes: f616f5cd9da7 ("btrfs: qgroup: Use delayed subtree rescan for balance")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/ctree.h  | 2 +-
>   fs/btrfs/qgroup.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 22ba2b4505b3..00d4c4184e76 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -160,7 +160,7 @@ enum {
>    */
>   struct btrfs_qgroup_swapped_blocks {
>   	spinlock_t lock;
> -	/* RM_EMPTY_ROOT() of above blocks[] */
> +	/* True if any of the rbtrees in the blocks array below is not empty. */
>   	bool swapped;
>   	struct rb_root blocks[BTRFS_MAX_LEVEL];
>   };
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index 46de0a5e80d5..798f21608de5 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -4913,7 +4913,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
>   	/* Found one, remove it from @blocks first and update blocks->swapped */
>   	rb_erase(&block->node, &blocks->blocks[level]);
>   	for (i = 0; i < BTRFS_MAX_LEVEL; i++) {
> -		if (RB_EMPTY_ROOT(&blocks->blocks[i])) {
> +		if (!RB_EMPTY_ROOT(&blocks->blocks[i])) {
>   			swapped = true;
>   			break;
>   		}

