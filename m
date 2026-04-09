Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9D1D37AA77
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Apr 2026 07:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775721067; cv=none; b=UzJCWDpIxDt7r0L4+J/EmbpxlW2rQhv4eSGo31oYxYAu/kKungNuKqCcKs4q8fgOKE9uQKNs/actp0zGipNMzyVQE2dT+JqzPZKrlPZRpaygWlZ+xzPeC3m6jMf9pI8el34xQgXCnfx/xKAnD7NLeMZ/m9TKilKxPwW1mqfbrI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775721067; c=relaxed/simple;
	bh=IDDk/Wya4l0PUibFr8xjFMlOxJDaPxZaG2XLXP7AR4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NqvZioG6tBP98JumQBEW71fy/VFaf5hkxXlxBejVxw7Pxv8q20powcrn8FJjHZ8llwLfpavjSmufcA8GyTn2D2MKPFJDnDwe3DEnxGWtsjoUdLMgLMyDg53gH3T2EQqKtCLRSZfQE06YhqVwxnRII5gFYyrJdadt1F1d+enIeAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gPpCCD3R; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gPpCCD3R"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so6738065e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Apr 2026 00:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775721064; x=1776325864; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=cfLTxoXIWld1NzW2JejV6OyAGPO/dh2wZ3/2x472Zs4=;
        b=gPpCCD3RPQ+l3fbk1BnsldBxu9aknq6MtkRX+yKulT8L4xYYv+Bt+qkjyutKpnPDKm
         grFRtiCZrQ9rbirY02uec3bx01CeNj+dszcqiBpaPMg74STzt8wYew7V/X1hTkWipu79
         s+021MK5C2H495goP1p5ifTG6Z/cLKEWGN0o2cIqBXDKdVHHPsrK47rcRzokrL4XQ+Ah
         DS0uHbiYCmhC5oaQl4hH1ws0b4oJS8EVJ47Kg9mGmWvKinbgYjeoRE4AZjzlpZpwD47P
         rXmHgGmyFHZS7SbHSaM2Ys3mTE0L5XSIvFe4gFMar+faLtdOwnSAg6dAI/ghW38XgaLg
         mfUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775721064; x=1776325864;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfLTxoXIWld1NzW2JejV6OyAGPO/dh2wZ3/2x472Zs4=;
        b=W6V1ymUB3bIru8C1qzBEm1h0xuzskQQX9hBJyE64ykJCNgp6KclcKO1mQrA1dKAcu2
         6ut5lS/pAXnKrvRj3TnCZASSfhGGunx04mhcrozF3gIrBqLQALkoycqyI+WtMdmz247B
         TTeHZBevt+d9bnXlj+jB7y+3UJIRu5S+EhgD3Z1CKqRItCV42zP2YZYCLBvXyHsiSzZs
         TYektp+gZ+kMtyACPvSAFXB9ye1M6rwuet60PewhEB2vmJK6Ao+Ohgh3fVXg5xig+ehW
         UOyA/kvBJyDsRSLwy3UxFeCD4bYl3Oemxv53+mPaz6mSrWSBv3jqtz8HWbeaF7Ft31Xf
         WfXg==
X-Gm-Message-State: AOJu0Yz4wnPvjZP5XSxduItFg07GX3HXP3KAL0WmqmVpN823mrehaHeO
	+pC0pBAHtN/WEnNrM5zUudYM78mfFUtuZ7mtQozH/PYGy245jSL5JzN9wqrHFLUJWF4=
X-Gm-Gg: AeBDiesqEm6Ml06TWn3EZk7qgRcfX5H+zAlVV99EhZp6AEnYX+HZ6bXvCqLLaZxVl4e
	lmLIH176ofCgi5w9thcNsoqhZjMcByjQ3t+5TAf1P2hE+dXw28gMJB9GOyB5KnjRpRZRUSLvwzg
	eBt7GbcIhRkGcovRPSR/Qh/MRgJ1FAjJABECOMQAFv299ON7LDlhKAHOifUoJt0w684OBk2neWG
	4ojxWl1Iy6SEt6T8ZEeB5EwjEsggh4gYraksrO8FufSouWvAA/Vh/CCAw9HJAZ3A0mCQJhfCIqa
	tKc2Q6IAEdDXCZ0QV2PM6SiHRBM1+5NrUG4kfBkB4JURTrfTwCiOb3ArL/RWMw82+UnAVVlpu1i
	kQHPcsjhBJpnjZTei8byGkqYjCBUX2RH8OGFa92OHRTc7VZ3Jmz8NaPD6dwWJketzam21qVx94b
	JsqpGNAmOt3RTxAdL2Vanh10hEpHO7mLJmxP5op1HN6GS2018Fk6I=
X-Received: by 2002:a05:600c:42d1:b0:488:a62d:76d7 with SMTP id 5b1f17b1804b1-488a62d7745mr127474265e9.1.1775721063982;
        Thu, 09 Apr 2026 00:51:03 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2af067a59sm80077165ad.10.2026.04.09.00.50.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 00:51:02 -0700 (PDT)
Message-ID: <fdc220ea-8f1f-45e4-9851-5eaaf8051153@suse.com>
Date: Thu, 9 Apr 2026 17:20:56 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: treat empty left leaf as corruption in
 push_leaf_left()
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com,
 zheng.yan@oracle.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com
References: <20260409071255.3358044-1-gality369@gmail.com>
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
In-Reply-To: <20260409071255.3358044-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/9 16:42, ZhengYuan Huang 写道:
> [BUG]
> A corrupted tree can leave a non-root leaf with 0 items linked from its
> parent. When btrfs_del_items() later tries to rebalance a right leaf into
> that left sibling, push_leaf_left() passes the empty leaf down and we hit:
> 
> kernel BUG at fs/btrfs/ctree.c:3388!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:__push_leaf_left+0x11f8/0x1610 fs/btrfs/ctree.c:3388
> Code: ff48c1ea 03803c02 000f85bd 00000048
> Call Trace:
>   push_leaf_left+0x3b3/0x540 fs/btrfs/ctree.c:3511
>   btrfs_del_items+0x74d/0xf10 fs/btrfs/ctree.c:4541
>   btrfs_del_csums+0x44d/0xa50 fs/btrfs/file-item.c:969
>   do_free_extent_accounting fs/btrfs/extent-tree.c:2984 [inline]
>   __btrfs_free_extent.isra.0+0xded/0x41d0 fs/btrfs/extent-tree.c:3372
>   run_delayed_data_ref fs/btrfs/extent-tree.c:1599 [inline]
>   run_one_delayed_ref fs/btrfs/extent-tree.c:1779 [inline]
>   btrfs_run_delayed_refs_for_head fs/btrfs/extent-tree.c:1972 [inline]
>   __btrfs_run_delayed_refs+0x86e/0x39a0 fs/btrfs/extent-tree.c:2047
>   btrfs_run_delayed_refs+0x181/0x420 fs/btrfs/extent-tree.c:2159
>   btrfs_commit_transaction+0xc9b/0x3d90 fs/btrfs/transaction.c:2211
>   btrfs_sync_fs+0xf0/0x630 fs/btrfs/super.c:1057
>   sync_fs_one_sb fs/sync.c:84 [inline]
>   sync_fs_one_sb+0xf4/0x140 fs/sync.c:80
>   __iterate_supers+0x1be/0x290 fs/super.c:923
>   iterate_supers+0x24/0x40 fs/super.c:938
>   ksys_sync+0xb4/0x160 fs/sync.c:104
>   __do_sys_sync+0x13/0x20 fs/sync.c:113
>   ...
> 
> [CAUSE]
> push_leaf_left() only checks how much free space the left sibling has.
> An empty leaf has maximum free space, so it passes that test. The sibling
> key validation also skips empty leaves because there are no keys to
> compare, allowing the empty leaf to reach __push_leaf_left().
> 
> [FIX]
> Detect an empty left sibling leaf in push_leaf_left() and treat it as tree
> corruption. Abort the transaction with -EUCLEAN before modifying either
> leaf, which avoids the BUG_ON() and matches how other unexpected btree
> states are handled in btrfs.
> 
> Fixes: 87b29b208c6c ("Btrfs: properly check free space for tree balancing")
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>   fs/btrfs/ctree.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 561658aca018..625aa2ab4c5b 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -3486,6 +3486,15 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>   		return PTR_ERR(left);
>   
>   	btrfs_tree_lock_nested(left, BTRFS_NESTING_LEFT);
> +	/* An empty non-root leaf means the tree is corrupted. */
> +	if (unlikely(btrfs_header_nritems(left) == 0)) {
> +		btrfs_crit(left->fs_info,
> +			   "empty left leaf at bytenr %llu while pushing from right leaf %llu",
> +			   left->start, right->start);
> +		ret = -EUCLEAN;
> +		btrfs_abort_transaction(trans, ret);
> +		goto out;
> +	}

I think the timing is too late, and if there is an non-root empty leaf 
but we never modified it, kernel will not detect it.

I'd recommend to reject such empty leaves at 
btrfs_validate_extent_buffer(), if we have check->has_first_key, then 
the leaf should not be empty.

Thanks,
Qu
>   
>   	free_space = btrfs_leaf_free_space(left);
>   	if (free_space < data_size) {

