Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6241E54652
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 02:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786244123; cv=none; b=H483h8niriHFLH/TTYHvGQgGifY92ElkjsXuSD5dKf/AM/GxZeuF3sjd6oYRvR5faJgA6jUH23hySblrAa7QcIcLKgcHzBNpHhf5AP4Y/6N4jOYpoCBZjGSEZnuAfeNo1dm7l+U2JgcXw1sCD97AVQfBbB7qmmwOH5ZlTUB5RjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786244123; c=relaxed/simple;
	bh=csFx2yeh9c9p5fct7QLDRWHqCGnB32F+et63XJi3AEE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pw9hr9UYOsGJTVdX61TDnC0IdAmLbvKB0Md7FQJcZhjAEl2wUs8XIhch/pb4Y+xvgZONkyILrKgGZwHYQGaMU/HPQYV0IJ+ahSO+YXVfG6+SyfcJRK8VG5aslIccT22QD098En6ZgZn3wItmHvw8w4F3HBHXpkemCcM8bsQac0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RaDzVUDz; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RaDzVUDz"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4956869750eso4681535e9.2
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 19:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786244120; x=1786848920; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nue06wqRuTmQho2mMAV4Dw/xH0w6lZfgRaQi6DOr5To=;
        b=RaDzVUDzf5hAf1NlQDl9EhBN3qEIVEvfVObZ+JXOaoGlxONwA3nAa0SndcPbPr2QtD
         2/OG+Wq6ifzEU5zD+LjOvo3rJ56H47iiM62VNZ6RkWlrSTfA7z651uj7j23K2srp4KsP
         iPWDa01oHsK0UZhiajuJ3Ypq5BVtTLoeWdnChG8sSFyOKskjRkOJ4beHYEiw4X87UVSN
         lFRxklKCOkNTAouRFkDWF5ODf+bntXguLtwiYT04J/8nByaDJ8D0jSdhwoDulL2rGlZo
         w3NGG38o9sfQCL16Rc32DBx7v1H7KreP202/CimMHNFcZ+UcHymiZHLbl01oTP6fLqna
         m3kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786244120; x=1786848920;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nue06wqRuTmQho2mMAV4Dw/xH0w6lZfgRaQi6DOr5To=;
        b=U9cZ9UTjzZ/mtslQkTaSn1Cpe5P080msKHFzpRCjkKXgXc57DTypj4VGGLiWxIwl6G
         WSfatZa/Ib33926qyYwz5zC3Hx5YuOrZMAupNJCIU8dotCCGlznaGcS2kFtO+4IP6gaq
         xeMrfGHAlRcMCRXabd894G0IX3DrNL/fM7H8/USzQdBoXYTEXMjr+T0lk8djiyVbpwD5
         n6DbCFZX/Xo+o3n+pjAet5wdwiJJoGwnm+fPpezHlOF5DlpnsTHxED4wGZHPLZofADbj
         a9pL4ILzbrlhyBoPTOsk0U+cpfn4EjLaMbFi/P1BOFEE/CH//GXBK59WcQm3WcyJPyXM
         qUGA==
X-Forwarded-Encrypted: i=1; AHgh+RrMy43njw5eO1yQj4o5p+PFHbcidCT8E+g7RXFqlmAGlB7B26L4hDQyALSE6432TdUWotjhmH3mSYFCbA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+EI1oCn6XJZjefHP0g0KgKTKa3Q5DMZMhd8Rl+DwS6rUrKAS+
	ncnxaqEDjsQNQSjeqvrHO0WAnPZ2bzq7nGW0FPdh68C55zxxlmMTFt8Aoe4u1mogt9k=
X-Gm-Gg: AR+sD13039FxhStQPY5rq6w1HTnhSZ8SeQ/l1faB4/VdtcEkkOnZbKdcAIJoAJkcE84
	ToZFMOKqan6CcI7TR1hMw2KSlkZigz6Sr1jOKp6WW2w1GjeebwtQaNf5OL9I4ccFVsyX7OGeUOc
	7e8E9xRKeQFzt/ukMwgheE/ixdWFp8Q+UnqfeHoH9Q5ZJy5VsJHXGFwA/w+r1q1rjhsqQxNMUvH
	xg+KYIWuETRfWMSAjwGeBrAFCi94GGzOTi7rwbpf6Ongy+OmBc6ZOi1B3OOyc8hoL8EQMFyWktl
	8P5b/xPAJEtHyIh47KPY3fG+kPCXYpnJzH4mG0XizLfHxRsciQl5L39R/Dpixo960jPRqhhbZ/B
	uStjffp9u1B9n6jSE4+JsTZ3qwrxZwecrVBBP8x9UQUiRgDsZZT+Uk5uwKSgLu+9LDBl000KeBc
	eegXkIaR4QJfS58z55M6m4c0oeqrql50ehOPByYaG6SShxkex8evOEwetpZPCeiuNmZA==
X-Received: by 2002:a05:600c:34d1:b0:498:1595:be7b with SMTP id 5b1f17b1804b1-4994e794ee7mr473189405e9.4.1786244119588;
        Sat, 08 Aug 2026 19:55:19 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1410199bfd8sm21030669c88.2.2026.08.08.19.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 19:55:18 -0700 (PDT)
Message-ID: <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>
Date: Sun, 9 Aug 2026 12:25:13 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] btrfs: add per-inode compression levels in xattrs
To: koraynilay <koray.fra@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-4-koray.fra@gmail.com>
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
In-Reply-To: <20260809015054.779137-4-koray.fra@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/9 11:20, koraynilay 写道:
> Add support for specifying algo:level using
> btrfs property set /path/to/file compression "algo:level".
> 
> Add a signed 8 bit prop_compress_level property to btrfs_inode, which
> can support from level -128 to 127, plenty for the currently supported
> algo:level(s).
> 
> Change prop_compression_apply() to use the already present
> btrfs_match_compress_type() and btrfs_compress_str2level() to parse the
> xattr, using kmemdup_nul() to convert the user-supplied xattr value to a
> NUL-terminated string to be used by btrfs_compress_str2level(). The
> same approach was taken in prop_compression_validate() for
> btrfs_compress_is_valid_type().
> 
> Assisted-by: Gemini:3.1-pro antigravity-cli-1.1.5
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>   fs/btrfs/btrfs_inode.h |  1 +
>   fs/btrfs/inode.c       |  2 ++
>   fs/btrfs/props.c       | 43 +++++++++++++++++++++++++++++++++---------
>   3 files changed, 37 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index 1082fa92c145..0a4e567d0109 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -130,6 +130,7 @@ struct btrfs_inode {
>   
>   	/* Cached value of inode property 'compression'. */
>   	u8 prop_compress;
> +	s8 prop_compress_level;
>   
>   	/*
>   	 * Force compression on the file using the defrag ioctl, could be
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 2534cd9284d5..cff4b3e97559 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -938,6 +938,7 @@ static void compress_file_range(struct btrfs_work *work)
>   		compress_level = inode->defrag_compress_level;
>   	} else if (inode->prop_compress) {
>   		compress_type = inode->prop_compress;
> +		compress_level = inode->prop_compress_level;

I'd prefer to have a dedicated patch to set compress_level to the 
default value 0, as a proper bug fix as the first patch of the series.

As you mentioned in the cover-letter, this is in fact fixing a bug in 
the old behavior (mismatched algo and level).

So it's definitely worth a dedicated fix, so that we can backport the 
fix without pulling in the full series for older kernels.

Thanks,
Qu

>   	}
>   
>   	/* Compression level is applied here. */
> @@ -2326,6 +2327,7 @@ static int run_delalloc_inline(struct btrfs_inode *inode, struct folio *locked_f
>   			compress_level = inode->defrag_compress_level;
>   		} else if (inode->prop_compress) {
>   			compress_type = inode->prop_compress;
> +			compress_level = inode->prop_compress_level;
>   		}
>   		cb = btrfs_compress_bio(inode, 0, blocksize, compress_type, compress_level, 0);
>   		if (IS_ERR(cb)) {
> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
> index bb77d46376d4..f79a61a2759f 100644
> --- a/fs/btrfs/props.c
> +++ b/fs/btrfs/props.c
> @@ -295,20 +295,28 @@ int btrfs_load_inode_props(struct btrfs_inode *inode, struct btrfs_path *path)
>   static int prop_compression_validate(const struct btrfs_inode *inode,
>   				     const char *value, size_t len)
>   {
> +	int ret = -EINVAL;
> +	const char *value_str;
> +
>   	if (!btrfs_inode_can_compress(inode))
>   		return -EINVAL;
>   
>   	if (!value)
>   		return 0;
>   
> -	if (btrfs_compress_is_valid_type(value, len))
> -		return 0;
> -
>   	if ((len == 2 && strncmp("no", value, 2) == 0) ||
>   	    (len == 4 && strncmp("none", value, 4) == 0))
>   		return 0;
>   
> -	return -EINVAL;
> +	value_str = kmemdup_nul(value, len, GFP_KERNEL);
> +	if (!value_str)
> +		return -ENOMEM;
> +
> +	if (btrfs_compress_is_valid_type(value_str))
> +		ret = 0;
> +
> +	kfree(value_str);
> +	return ret;
>   }
>   
>   static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
> @@ -316,6 +324,9 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
>   {
>   	struct btrfs_fs_info *fs_info = inode->root->fs_info;
>   	int type;
> +	int level = 0;
> +	int ret = 0;
> +	const char *value_str;
>   
>   	/* Reset to defaults */
>   	if (len == 0) {
> @@ -335,23 +346,37 @@ static int prop_compression_apply(struct btrfs_inode *inode, const char *value,
>   		return 0;
>   	}
>   
> -	if (!strncmp("lzo", value, 3)) {
> +	value_str = kmemdup_nul(value, len, GFP_KERNEL);
> +	if (!value_str)
> +		return -ENOMEM;
> +
> +	if (btrfs_match_compress_type(value_str, "lzo", true)) {
>   		type = BTRFS_COMPRESS_LZO;
>   		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);
> -	} else if (!strncmp("zlib", value, 4)) {
> +	} else if (btrfs_match_compress_type(value_str, "zlib", true)) {
>   		type = BTRFS_COMPRESS_ZLIB;
> -	} else if (!strncmp("zstd", value, 4)) {
> +		ret = btrfs_compress_str2level(type, value_str + 4, &level);
> +		if (ret < 0)
> +			goto out;
> +	} else if (btrfs_match_compress_type(value_str, "zstd", true)) {
>   		type = BTRFS_COMPRESS_ZSTD;
> +		ret = btrfs_compress_str2level(type, value_str + 4, &level);
> +		if (ret < 0)
> +			goto out;
>   		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);
>   	} else {
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto out;
>   	}
>   
>   	inode->flags &= ~BTRFS_INODE_NOCOMPRESS;
>   	inode->flags |= BTRFS_INODE_COMPRESS;
>   	inode->prop_compress = type;
> +	inode->prop_compress_level = level;
>   
> -	return 0;
> +out:
> +	kfree(value_str);
> +	return ret;
>   }
>   
>   static bool prop_compression_ignore(const struct btrfs_inode *inode)

