Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8F02030A
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 00:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776211591; cv=none; b=DExIyXJq9yYL9aPpjUKXUzskQ+GPx2KGhOn2oQyZ7KDYtOyU5PKKw1luxqEoslfU3s924yUl1hzwpHYJ3MAmmBEK/uThGj20QwJYH+S5aO9SFO3mM7M7TbwzXRzpu7j5KXQQRPlC7ETzRN9bynh5EivtlCyOHvCVGlPV+PRPy1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776211591; c=relaxed/simple;
	bh=ocXwQXRpn2Sn9i4ZZD6/EMmdVNW7pf8YyTqxqyJJNoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TLYEvqDfK6jfi8CB/gUXZZcRHK/Peb+XcmZmtlAgU4oGCVe1GnHYuK0ShB12N97yKFNM3YDXum8rtu43VfZt73C951OxnbJYUrqo61Dtloks5ongO/hqjZiUL3nm8mcek4O7M2u0zNf9SDGLvgj4Lzw7rWLn4SJ2jSl8v8EzMJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QO5CPBM/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QO5CPBM/"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso62980575e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 17:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776211588; x=1776816388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=D0UdkAVYInYo7+7wiwTPqnSnYWv/QqaZ0nogYrfyA98=;
        b=QO5CPBM/1E/oRSLIz3knPvFPdgdn+TEIqA8rwZIDPmfdXwHZCfE7gWVZu+BDoNcRBM
         8thY36RydedCrH+OsfI5vwHxslghWRx9JKcHbw8uWeE6gneMQegGQnlnjEvjee4raFyu
         gEIhN9W5fmrBo2dhxylGDVlykThOEZjSNCakJOpTPQVxKDsN7fT5TUpzh9yk6/DXpOsS
         SyfQQKDpbxSydkXUbMvjlI3zUYYa+kyC9s0pg8ek95sNzNXaPAyI0VU41IdLMohSNzzR
         sy5euDOT32UWN0luiwFjkadTJl2hvhRsIj8SdR6gO5202rfG37sDSlcaxG0uFItAK7Nj
         EFfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776211588; x=1776816388;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D0UdkAVYInYo7+7wiwTPqnSnYWv/QqaZ0nogYrfyA98=;
        b=p8c5yxyBsYs9zlMR/XDQRzaEiRs7w6lPqZ8ndhoXfvVhVvu/TGT8v6asXE8r9rynqJ
         eipcqLYnvgftzmAsAwvOKjzfv4TzNd5bDOqprFlgXgHK1umkFlTVRSu7hUaWTZR6TLEL
         xCZX80ZOhy73HQY0SopLXSyDyJ2pR46pmvS+0BISkst/1GCnCxtvZCQVhvDpavBmzKMX
         Iug6tcAMTW22wqE6nrZB3kX3WeIq0QG3TrvE075cHOOB22UEL+qmBOUtBUcrYGpKgY/f
         s5L7tYXdyrBujP7lcjP4US8xO/B0eb6Jn/rnrYalhTetkou2KYtYrLc3ehJx9rIm0wlT
         0TJg==
X-Forwarded-Encrypted: i=1; AFNElJ8/aMd3O+MykVgii2xWvZgxU9KnuxpZjQu+QkUHAWPCwnfgh7UDJennecewT81AbHjhnrlssCBzeSfr2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp2iypmM1ERo+lIW5iAiVv9OtHrAzFRxX+zrx0NwjEnuk+67wg
	1VCwRg9FNW5Ph+xW6CSdS+VZRPLNFlKUO1stw6W1flF2fKhYUcQiKxS8G47i1gOvmNyzjLYnbvU
	/umnz1KU=
X-Gm-Gg: AeBDievj6556WRx7u0ztBzxbGsyBorre7XH3Z6vswT6DQX8ubTWLBzPZ5vwZf5yAgjL
	KhLx/bkfWOVY/21medWA4B3SoD5G33DZkbxRWLgtCgXcJDjBjqpO2FQcrfvzqSTArOhDdvYiogi
	MBSrFETeaxPqYPVkPLWW7lm2UwXIXRkaNTbnpuhPwccX9rb5bt6LJcu1z2DGaM+mBgZKPANDUgN
	vDt8dd9eCoAGowCGPKbNF31lBkiZI1iO5mEfkcvWs0+GECgCPr6mNLsc9BkIt8mfcgYsVQRpK5q
	InJuOl4dphcCFV8QXeuyIbQkN0CS14x+QtBqT5uIls9n1MiwSzsOFXTr5EAf17Oc3s8fMKeBqoE
	J0QMdFEkgZmLJvD8XYjrDbTPA7HsbVgum7F4Q1o64ruwplMc+A7ksPntguF9ZRe3meSuuOn+Ei0
	hsz0PFL5EHegZcvLkqqfn3XnOy/hfTMIeFXHt+LcQKvB3o9JZxbZCNlK3BV0OpHg==
X-Received: by 2002:a05:600c:49a1:b0:488:a502:8955 with SMTP id 5b1f17b1804b1-488cd4f4a9bmr224922965e9.4.1776211587562;
        Tue, 14 Apr 2026 17:06:27 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fd0a5d093sm159158a91.13.2026.04.14.17.06.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 17:06:26 -0700 (PDT)
Message-ID: <2f4c809b-c304-4afd-a604-7adc7e0da8d0@suse.com>
Date: Wed, 15 Apr 2026 09:36:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: remove 32bit compat code for VFS inode number
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260414201208.2749178-1-dsterba@suse.com>
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
In-Reply-To: <20260414201208.2749178-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/15 05:42, David Sterba 写道:
> Commit 0b2600f81cefcd ("treewide: change inode->i_ino from unsigned long
> to u64") sets the inode number type to u64 unconditionally, so we can
> use it directly as there's no difference on 32bit and 64bit platform. We
> used to have a copy of the number in our btrfs_inode.
> 
> The size of btrfs_inode on 32bit platform is about 688 bytes (after the
> change).
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

But that treewide patch is not yet in our for-next, we can only merge it 
after our for-next is rebased.

Thanks,
Qu

> ---
>   fs/btrfs/btrfs_inode.h | 31 -------------------------------
>   fs/btrfs/verity.c      |  4 ++--
>   2 files changed, 2 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 55c272fe5d92a0..3481c91fec7cfb 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -128,15 +128,6 @@ struct btrfs_inode {
>   	/* which subvolume this inode belongs to */
>   	struct btrfs_root *root;
>   
> -#if BITS_PER_LONG == 32
> -	/*
> -	 * The objectid of the corresponding BTRFS_INODE_ITEM_KEY.
> -	 * On 64 bits platforms we can get it from vfs_inode.i_ino, which is an
> -	 * unsigned long and therefore 64 bits on such platforms.
> -	 */
> -	u64 objectid;
> -#endif
> -
>   	/* Cached value of inode property 'compression'. */
>   	u8 prop_compress;
>   
> @@ -372,30 +363,11 @@ static inline unsigned long btrfs_inode_hash(u64 objectid,
>   	return (unsigned long)h;
>   }
>   
> -#if BITS_PER_LONG == 32
> -
> -/*
> - * On 32 bit systems the i_ino of struct inode is 32 bits (unsigned long), so
> - * we use the inode's location objectid which is a u64 to avoid truncation.
> - */
> -static inline u64 btrfs_ino(const struct btrfs_inode *inode)
> -{
> -	u64 ino = inode->objectid;
> -
> -	if (test_bit(BTRFS_INODE_ROOT_STUB, &inode->runtime_flags))
> -		ino = inode->vfs_inode.i_ino;
> -	return ino;
> -}
> -
> -#else
> -
>   static inline u64 btrfs_ino(const struct btrfs_inode *inode)
>   {
>   	return inode->vfs_inode.i_ino;
>   }
>   
> -#endif
> -
>   static inline void btrfs_get_inode_key(const struct btrfs_inode *inode,
>   				       struct btrfs_key *key)
>   {
> @@ -406,9 +378,6 @@ static inline void btrfs_get_inode_key(const struct btrfs_inode *inode,
>   
>   static inline void btrfs_set_inode_number(struct btrfs_inode *inode, u64 ino)
>   {
> -#if BITS_PER_LONG == 32
> -	inode->objectid = ino;
> -#endif
>   	inode->vfs_inode.i_ino = ino;
>   }
>   
> diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
> index 0062b3a5578199..983365a7354168 100644
> --- a/fs/btrfs/verity.c
> +++ b/fs/btrfs/verity.c
> @@ -458,7 +458,7 @@ static int rollback_verity(struct btrfs_inode *inode)
>   	if (ret) {
>   		btrfs_handle_fs_error(root->fs_info, ret,
>   				"failed to drop verity items in rollback %llu",
> -				(u64)inode->vfs_inode.i_ino);
> +				inode->vfs_inode.i_ino);
>   		goto out;
>   	}
>   
> @@ -472,7 +472,7 @@ static int rollback_verity(struct btrfs_inode *inode)
>   		trans = NULL;
>   		btrfs_handle_fs_error(root->fs_info, ret,
>   			"failed to start transaction in verity rollback %llu",
> -			(u64)inode->vfs_inode.i_ino);
> +			inode->vfs_inode.i_ino);
>   		goto out;
>   	}
>   	inode->ro_flags &= ~BTRFS_INODE_RO_VERITY;

