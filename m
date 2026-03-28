Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6193D1A6807
	for <linux-btrfs@vger.kernel.org>; Sat, 28 Mar 2026 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774676496; cv=none; b=FqTr3p3Pwis2lSIVIezm/P41Lkgbk2JXAFUoGiuAwbWQ3XGQI4ohX3IbHrho8oI+nqwGlhyBzMgDF79hGE/QnNAU4Pd/+naWzoo/pBoE+/UW8YkCEGIiwxk5ZwKJIlOeWA5GJLnOUs1JqUmCJYFjVaKSOtmA/kwiP/XGImDRFeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774676496; c=relaxed/simple;
	bh=MIIV4+SwYOFC4srugLFAEL3UKsckD3QWPE0nNp2o8EA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BrgcxDznfSgltY9rh/ynjVtjy8NiWl/YxI0KqaDTvAXMxsaOD45YauKaod2GQuo7koirjEWgRfci0E7qWv+uUYdVHOsxyFPsfMywChoX/kUk9CVngz1cgWjC0S0P6tLhyBAB8ZadgBWbgghcePvfnor10B180Qx61vbeY8LolC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GXKOycQu; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GXKOycQu"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43b87970468so2561697f8f.3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 22:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774676493; x=1775281293; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Gar9NbTSCWU02V8pzR4BPq/T9vLOIXN4qmUm/VWQF0U=;
        b=GXKOycQuzLwnTwy5vpu88Yfj7OlYg8WoV1lbLcqKO7evuZHxv0MwSF3OQkbmLcQjXB
         2YTZAnmtyiB6YH+JhRJk1pvVx1h8Eb/36nMIi3I5L+10wkcM4EA74rcixU6QImHUpgyE
         B0Yt6Emp1ggVZ2d73V+1k6Ck1zFM4E1gu8Pva8L4uMgICxDZqERaaIF9QG8unlwx44hQ
         sCEmwk+xUNR/mIRM/shyKZM8Bxz38jzOWxqo1ijM74JLYHnom0wAIb0EqBbgW6B1cMOn
         3M+iRTVNy7p8NPN26d4zx+jBGKDcKyseXvH2b9USxlPn+P0qWKMeMyQmsKQGPOXs6Vfb
         NjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774676493; x=1775281293;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gar9NbTSCWU02V8pzR4BPq/T9vLOIXN4qmUm/VWQF0U=;
        b=Wy2wkz14Y7rXRRJvuY/TwUSEK8JkSg8UjDL0XjdIJS+oHQ3TxI9RfiqjYUSWyZCHgK
         Vq9rwAm6F9n7VYFv2RSlmxrMmxDmN3pKJZaUilvJUyJUBIzVlTHU4muWZHI8+5E/cTfp
         i62p3JzaUBelTGrhNLnlp9LW0e3PUbm05ChuH4Qg7bRALl9VSbcNOij3X2rrcdoZEkNE
         fH+4pb1aCRjof24XqMa2Ol9Sw869gH9ayh49IqPoOZ76qaNs/ah2wKwKQcpnstuD0DVg
         E8GbecSsEawVlBmdxL0pRJU81LRgJPRO9rxKHcMA8EL43L84WQH0DG7geLbzOsgcvnqa
         0VXg==
X-Forwarded-Encrypted: i=1; AJvYcCXDfXhLeXQ98g6YfxcMGCxwJ0TWq1FdxHDh3x+reUi0KZnaXuN4RXrlXl4ABbNmGQGFv5Oe/uTl5UlVVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZko6TYdEZRKQm0vgbRRBVoZIPqAjjbgkW7uODarOitbVR97Hl
	fh0HOp2e9Q0LwZfmq0Io3TKEJtoou/C5yblA4cRiv4krsQqfBqsE9OrVOSXmsPFm7oGDTLgmb6B
	vWBaq6YM=
X-Gm-Gg: ATEYQzy4w0XpVMyPOPaE40q25OL2HJ2TKnrKvJj9ozV7eGjd1lQel52MZvhNrq7+baH
	5GRZgEhtgiCCHv/XhHi0rN4EXHePyi4mYbFbg8BIsUoeNpudE+TYcXeiiBBrBkon2f1TOm2CC44
	ytBchh1hxqru59s40gGFL5NYZ1wy17q7A2DeVH0rCn5tz1GpHV2of8XjIb0z5MRwI2ccBBKF3L0
	8fVFbvGalbu2uLmyMEw0JqqLAyS396bxf2IZBb6GyBGrPC9QpKdTIEjUIoxip1rSilRrkir0VGt
	2TXV2tAzMtbDDeo7Ma2t51G8EVd0UTvC70ub5x1SXNGsQiSlksTbf/NHLnkwOkJMxxXJglYCQsU
	Rr2b/ldEXa1uKuggKCGUr0AIT/GzJXG0qKjFNOX1lPbaJTjdF7/atEUhpLV9X1P0yEcAUxqheE9
	3e5/28oO1+xXPex3f44bdDWuWVXsHC74Xc28VUjvUJGscOk+kLIzOdoLP3Ak1ftQ==
X-Received: by 2002:a05:600c:1f13:b0:487:169:9f64 with SMTP id 5b1f17b1804b1-48727d73709mr80843205e9.12.1774676492779;
        Fri, 27 Mar 2026 22:41:32 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca85ef0b4sm993683b3a.42.2026.03.27.22.41.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 22:41:31 -0700 (PDT)
Message-ID: <4e053681-b1d1-4d24-b5ce-4c58d0954762@suse.com>
Date: Sat, 28 Mar 2026 16:11:26 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: replace BUG_ON() with error return in
 cache_save_setup()
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org
References: <20260328052200.2838989-1-27rabbitlt@gmail.com>
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
In-Reply-To: <20260328052200.2838989-1-27rabbitlt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/28 15:52, Teng Liu 写道:
> In cache_save_setup(), if create_free_space_inode() succeeds but the
> subsequent lookup_free_space_inode() still fails on retry, the
> BUG_ON(retries) will crash the kernel. This can happen due to I/O
> errors or transient failures, not just programming bugs.
> 
> Replace the BUG_ON with proper error handling that returns -EIO through
> the existing cleanup path. The callers already handle this gracefully:
> disk_cache_state defaults to BTRFS_DC_ERROR, so the space cache simply
> won't be written for that block group.
> 
> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
> ---
>   fs/btrfs/block-group.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
> index ebf507909..9f71362ba 100644
> --- a/fs/btrfs/block-group.c
> +++ b/fs/btrfs/block-group.c
> @@ -3343,7 +3343,13 @@ static int cache_save_setup(struct btrfs_block_group *block_group,
>   	}
>   
>   	if (IS_ERR(inode)) {
> -		BUG_ON(retries);
> +		if (retries) {
> +			btrfs_debug(fs_info,

You mentioned:

  > This can happen due to I/O
  > errors or transient failures, not just programming bugs.

If so, btrfs_debug() is definitely not noisy enough, as it's disabled by 
default.

> +				    "free space inode not found after creation for block group %llu",
> +				    block_group->start);
> +			ret = -EIO;

Furthermore, use the original error code from PTR_ERR(inode) is more 
meaningful, in case there is other causes of the inode lookup.

And showing the error code inside the error message will help indicating 
the bug.

Otherwise looks good to me.

> +			goto out_free;
> +		}
>   		retries++;
>   
>   		if (block_group->ro)

