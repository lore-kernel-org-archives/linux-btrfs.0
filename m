Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C37D3A9D8E
	for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 21:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350971; cv=none; b=dMdDeo/sA55toZsMWTlMiZLR5Z66TNrx/yX4Zl6xha9iqI9euU+wyXT6wWAyBFvXCjUONUZb05bLuBmv5V5KiP3Evl/ATSZertFO3bJ1aDlrw7r2VlK55pkSjGlLQn3Sax7FYVKjHcceh3MvgE4VZt44qFzraXgfoG+L1cCcFYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350971; c=relaxed/simple;
	bh=1mrcok7lLWw3BKqb6jcTbX/ttIp2UVoNTzWkQHr3+jw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H9etbxGVWfAM7ACN1TSjy1ZJmJUFkfUU3GwuPiLZdjerW++KQpjHDet1jisJp3P/XftyCUuGuzgDqYuOgpFS4f0t0GGpnQdf+LNolxPF1pfItSGY5Zod8jpusxOt5Fs9lFRl/RJrtZ1R3f5pKHT3fC5xM+QjxkYfe9OM3nLtmTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WHcjPxi1; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WHcjPxi1"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4853c1ca73aso12240565e9.2
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Mar 2026 14:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773350968; x=1773955768; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rYZIRyMjn1f9/0KoletAcCwq5B4EGUP8BoRgBSg1lAA=;
        b=WHcjPxi16t9sVdwFUWVi+CSwrCUIj8c90OM29MsaO450NeZzoMCbpcMh6d0XKQwRJG
         HJ5j2KP4I2SIT2YAZhNHNIWQ+y3QSuvahn6jbgIe8EIHtp4Lx4OlIx58R+NFlcb69xFU
         9oOo5anZNN96uG5FM4FqtnZXf7qsblLLU78QwNXElBN/+jY5Lnd3xxsesbHlK5g0sa7I
         oDsVa8ucrx3GZopdeODM5U+swmzeSkuGpPYoKs6xr+Fkg7uDtsFVUcbrJvpenX2vXw/S
         G9JsYKuhMq3KYu++YQv37TEacpU/xUjcMRbMzTyAgFbEmpE37Gmb3V4/H8aAUV3mYehW
         QeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773350968; x=1773955768;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rYZIRyMjn1f9/0KoletAcCwq5B4EGUP8BoRgBSg1lAA=;
        b=lomgqklQ2GMTriMw7yvubZvGIpO6tcAAj7ewUxESmKYmQwPUJ+eevp0zQzOgqo8nGV
         tnDBNMN8ecTiTly/jTQvCJL5lclomq6wwesLZ9s6870RZECxvsX8J7tBIjykCRfTvZRv
         n+m7cHpAw+jGun24GaJhmKtxWDcNbnhrPbLFKk3Dj0QelkM9oEiD9bJtbg43pS2HNaPR
         DcJhSJvFQtcYYR+RGCAVcogh/9gBvVhokkrvCaApEQXEF+Mq4NFpOgpyKdIpo9paEmD2
         Mw+/iqmr4FYIsR6rWv3pAD5vOieHkPXtreBACvL1HJX+tb30whkIV5PhyHlwOkn87pHO
         GRIg==
X-Gm-Message-State: AOJu0YwEAZ3h9DLyfoAOw/v56TUo8jDam3Pm056Zi0WHLNU8SlAayspe
	AIg63FD366h9hi0gTyoKJkeTjMwifrvAp7JcE5j8mLr6A+ZbGjm9ZHAIY5GvDnFPHng=
X-Gm-Gg: ATEYQzyfdIjID+h7h+IXQHST4+RSh3PH07T63jGsH2a+stJtGHDZURrXUOJvD1DI8fn
	Kf4KTFWZaBIf3YDqc6cfDzkWOVpzJ97g/hu4/xIqVx6MW/UpnEdc4XDQBomjWnTNW2OKqZx9Erm
	drB+DzlxgD1WHZw5UMUjJ36o7M5+UFaGWSVsykRfyE/jBT7wmCaD3tF9NYliqfQniEFHrMrGS7C
	wDe+7Xo3eQ+dBv/r/Ifd5hVnT08jj9ZKJiXVaQrdPHS+BAnJzvIo+ssOscN83MP/C6w4xZlhPHo
	nt54S5iuY8CBZqxRtaHU/n8qhgM8Kn8mnOQ2ZwCuQd/98TkgYgFr6x8qkpaWNnMzeWqSTETikxZ
	uXtfUfTdr3NmpN73f0Y56lXZHsAFOORtTKBgULRZAEoRstbipPwkPPTT1T2Ou/YmbgiqwnOZMCr
	B1GRACzaW8zHjc+A+yF3E1AuTP30RtYjslIoj5mgE99Gx35vw/tY0=
X-Received: by 2002:a05:600c:1d0e:b0:471:700:f281 with SMTP id 5b1f17b1804b1-4855671fac1mr14558705e9.25.1773350967783;
        Thu, 12 Mar 2026 14:29:27 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae378249sm65253025ad.80.2026.03.12.14.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 14:29:26 -0700 (PDT)
Message-ID: <ac5058d0-ba4e-4de6-b231-64a29ee2d5e3@suse.com>
Date: Fri, 13 Mar 2026 07:59:14 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: reject root with mismatched level between
 root_item and node header
To: ZhengYuan Huang <gality369@gmail.com>, dsterba@suse.com, clm@fb.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 baijiaju1990@gmail.com, r33s3n6@gmail.com, zzzccc427@gmail.com,
 stable@vger.kernel.org
References: <20260312102229.220570-1-gality369@gmail.com>
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
In-Reply-To: <20260312102229.220570-1-gality369@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/12 20:52, ZhengYuan Huang 写道:
[...]
> 
> [FIX]
> Catch the inconsistency in read_tree_root_path(), right after read_tree_block()
> returns root->node and the generation and owner checks have passed. At that
> point level = btrfs_root_level(&root->root_item) is already known, so
> comparing it against btrfs_header_level(root->node) costs nothing. If they
> differ, emit a btrfs_crit() message and return -EUCLEAN to prevent the
> inconsistent btrfs_root object from being installed in the radix-tree cache
> and reaching any caller. read_tree_root_path() is the only place that sees
> both root_item.level and the actual root node simultaneously, making it the
> correct and minimal location for this cross-block consistency check.
> Returning -EUCLEAN is consistent with the existing owner-mismatch check
> directly above and with the general btrfs policy of converting detectable
> corruption into -EUCLEAN rather than crashing later.
> 
> After the fix, btrfs detects the level mismatch at root load time and
> fails with -EUCLEAN instead of crashing later in
> handle_indirect_tree_backref().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
> ---
>   fs/btrfs/disk-io.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 900e462d8ea1..06a8689cbf62 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -1067,6 +1067,26 @@ static struct btrfs_root *read_tree_root_path(struct btrfs_root *tree_root,
>   		ret = -EUCLEAN;
>   		goto fail;
>   	}
> +	/*
> +	 * Verify that the root node's on-disk level matches root_item.level.
> +	 * These can diverge when the root item in the root tree was corrupted
> +	 * (e.g. a bit flip changing level) while the actual tree block is
> +	 * already cached in memory at its real level. In that case
> +	 * read_tree_block() returns the cached buffer without re-running
> +	 * btrfs_validate_extent_buffer(), silently bypassing the level check.
> +	 * The mismatch would later cause a null-ptr-deref in backref walking
> +	 * (handle_indirect_tree_backref) when the commit root's real height is
> +	 * lower than what root_item.level claims.
> +	 */
> +	if (unlikely(btrfs_header_level(root->node) != level)) {

Nope, we have btrfs_tree_parent_check structure, which has all the 
needed checks at read time.

The point of using that other than doing it manually here is, if one 
mirror is bad, but the other mirror is good, then we can still grab the 
good copy, but checking it here means if we got the bad mirror first, we 
have no more chance.

And during read of root-node, we have already passed the proper level 
into it.

So the only possibility is, your fuzzing tool is modifying the memory 
after the read check.

If so, it's impossible to fix.

> +		btrfs_crit(fs_info,
> +           "root=%llu block=%llu, root item level mismatch: "
> +           "root_item.level=%d block.level=%u",
> +           btrfs_root_id(root), root->node->start,
> +           level, btrfs_header_level(root->node));
> +		ret = -EUCLEAN;
> +		goto fail;
> +	}
>   	root->commit_root = btrfs_root_node(root);
>   	return root;
>   fail:

