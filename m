Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96135241139
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 21:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776980591; cv=none; b=qV5nMtFLiWZv0HnEzw+htsGEph9HsOXOaT03DSekjTk2TJfs6ZgztyMipinPENtx70ZwS61TTwC7pQp7Gquqgz5/JEKop8b0X9MblPJ0Ggetq5tbyzNbzGnPMtiBqF7J9felE3+ICNK91djj7shZtHMpPiYrwe/PTnjAhY2m7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776980591; c=relaxed/simple;
	bh=g+PaylH6yu0RsZP6CmqEskklkYRGzugJqTUaEA+m6OY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PUvCnofZal2teImJe5g8T9ZpJvHcwf5LG7sudZwM+7BDmIfMHT2IeuIfKixefwDFMugEVNKOzwDlzo4pJ3EXs6HsmSwd4Ql/vxUgcIw8eTD+hcaTNHTo04ZsYcCTgfvPkTMoqBk9BSjXxsmPRYqUZHu2eGLWMZ/w07k+DB+kRE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YsHyqNGa; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YsHyqNGa"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488ad135063so63371925e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 14:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776980588; x=1777585388; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K4/ccKjIbfL5FRe38iOKiUCUXP4+dg2Zr/TdlmB2s94=;
        b=YsHyqNGa3m9PMRRDyXcjfqr8ujKeM8zAZlmYqKqITNoXJ45+dMAz+qb6QsUIVrwg8K
         EuuH01Slo/57va9AcGdQ6vyieDTenxUlE80TpuXWfueLwK3OwT8gRQNcmQsYH0SsB/3n
         yCwiKRkk6ZTPol3W+iF156PRY+I1ijAwNI9D1X2xNGRYgTs1mlVHflR+uLGCX+pS4toJ
         iO7wXMBraGoAFsPjdWcdYFbk7Pdittcs7/GBv+/I6+IhxDpv/8hDU1pldp2u3o3xeYnv
         c9amTKfFMWX6+aYrxoKTVPRxkrifas41GAHixXBUKU95Bx9NZGZiNv5Z5MJKatNUX3t4
         uuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776980588; x=1777585388;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4/ccKjIbfL5FRe38iOKiUCUXP4+dg2Zr/TdlmB2s94=;
        b=pgMDHLvJtZjlK9Mn/7cMbYBcEly1EDbdK2ohz+B3tnc+B5XtShYlIcBjMm0MV0ElQQ
         fZgRJWlMPqMSLu+K2mGStBjC1ea+22gZpeMGGs4WsUf6D3kN45PlSZhFD1rhwWorjdoD
         EwFNADJkgzrpJ98nuOPZY6Nj+c1BH2eTSQ1tuLLseFulYaJAa8Mfu7e32qHi7d4rZNwM
         XlJbAY8mkhcJw3/MvfbPCIcYACBrYmV0DrF1TXtFAFOdMU8PQynZDyVTN5GDWOCmY2yH
         QX+7MmmNqHV61Aaq5rxLBm5bejpSLAGxAIiL0f1+VscEB2Ajsj+CtChjxl0SrmGYUKt8
         2n7Q==
X-Forwarded-Encrypted: i=1; AFNElJ+2RT6VLAM/Myc8OKaRhgFS6901BNK74MRnUUAEbm78F9oaPd4/N6ho0tztTu0ILaytfil+ya+e0o1qoA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBZ74fYG7iy6Is35ocHSok3CUb5vvRnI9eFNxBB+AQiDdyibjT
	mSng3tSFxDZgQ1zIAX0qHCZTO8B97GMKew5dy58T8ELjcsZp/+iDBtPl/uS2szgwh1M=
X-Gm-Gg: AeBDietyXs/cT3ByX8KUa1OIYKd42eGu4hnjgn09Uy8o26OOcCT7S3P7QU4Nbk63L+7
	3W843+FJN6aKmwgQXKHasyPFnYRJrkvshSUsoyd4juAyUaZ1kR5eDhDnnXtGGOgvvimj/XRR0bi
	0uLEygwRaxy779YuEP9PdU7Z2HpkNgbsmnfA99xrCnpOg3pRRGEqO4FeOMGyDHKhmu3yqH3Qojk
	9E3oT9WLAi0HKXLs4N0Iv5DyB4TAKvINlNMqheaQvN0b32PBeKChS4DH91T1H/C731aHk/Y8WA5
	lJ01TD8a7uPjIm4wgjWccTc5SOYFxjCan7RfVBkZ/F1tFCH9XS9yd7ohtFZrJpoTW4mnyl3gi91
	7M+tVoNTitH+yHvZF9TTiK6bvYepqrz32U2KMTq8fUGw5YJlXQJrm8bJ2MGvhPj7pUGl5nj5/pf
	rP0fBXw6CDjJ4qSlcF9elEl+v2JQCVuF4snQxAy0x15Jjc3LbAgfedQulfFbWi7g==
X-Received: by 2002:a05:600c:3f10:b0:485:35d3:ce59 with SMTP id 5b1f17b1804b1-488fb753c9amr381338155e9.10.1776980587900;
        Thu, 23 Apr 2026 14:43:07 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797704c332sm16023220a12.30.2026.04.23.14.43.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 14:43:06 -0700 (PDT)
Message-ID: <fb37b237-b6ef-4b12-9255-66ee23fead2e@suse.com>
Date: Fri, 24 Apr 2026 07:13:01 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: collapse report_eb_range() into its single caller
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
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
In-Reply-To: <b2dc0f485fc063e2b666e150002f59a278b97023.1776944252.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/23 21:08, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> There's no point in having this static function since it's too short and
> it has a single caller (check_eb_range()), so move its code into the
> caller and remove it.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/extent_io.c | 20 +++++++-------------
>   1 file changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 6a6d98eec787..2b0aec031a9a 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -3976,17 +3976,6 @@ int read_extent_buffer_pages(struct extent_buffer *eb, int mirror_num,
>   	return 0;
>   }
>   
> -static bool report_eb_range(const struct extent_buffer *eb, unsigned long start,
> -			    unsigned long len)
> -{
> -	btrfs_warn(eb->fs_info,
> -		"access to eb bytenr %llu len %u out of range start %lu len %lu",
> -		eb->start, eb->len, start, len);
> -	DEBUG_WARN();
> -
> -	return true;
> -}
> -
>   /*
>    * Check if the [start, start + len) range is valid before reading/writing
>    * the eb.
> @@ -4000,8 +3989,13 @@ static inline int check_eb_range(const struct extent_buffer *eb,
>   	unsigned long offset;
>   
>   	/* start, start + len should not go beyond eb->len nor overflow */
> -	if (unlikely(check_add_overflow(start, len, &offset) || offset > eb->len))
> -		return report_eb_range(eb, start, len);
> +	if (unlikely(check_add_overflow(start, len, &offset) || offset > eb->len)) {
> +		btrfs_warn(eb->fs_info,
> +		   "access to eb bytenr %llu len %u out of range start %lu len %lu",
> +			   eb->start, eb->len, start, len);
> +		DEBUG_WARN();
> +		return true;
> +	}
>   
>   	return false;
>   }

