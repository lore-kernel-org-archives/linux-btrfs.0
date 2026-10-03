Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A16C39890A
	for <linux-btrfs@vger.kernel.org>; Sat,  3 Oct 2026 21:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791063390; cv=none; b=EUUcq15wX+zHI5+LxX4QndGrTYsQYHA5ynZaRh+1R/HOoL7MzKoCGueOD8cyf7VUraJ8ad0+mwtzNVJul+aEdUfA6J47kbhS3EXgyN0MYYcUDD003HXmN9DDTOszX6yh7+YK/u1JPtjZ8E4UZKDAql/AJPuwIgEWpKEkUs3jDD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791063390; c=relaxed/simple;
	bh=uXJyJct4a9RpZd42S9VWhCfNvaVbHFDd6clqOLPyl4M=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RxK4CdQ3XSeP7P6BlZ0UmIlQOLDnFXlWxbGNx8+GCH5shbJ4h0RjnHbstXeNNpifjP5zir5sTx0mZjB6DoKqAnfTDd7DAKfLsKlbhsGp2NPdly/R0lTMQyMlt1lEcfajN+b5fMw71841nt9ccmjjTK7HbXWAAXVfJ8ZxTKj7GY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=X8qTvamp; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="X8qTvamp"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a16c1608faso2563795e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Oct 2026 14:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791063387; x=1791668187; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GslxcUUavKHlTdFwaar0hu27Mm5uFqzdCxZ5qCSULms=;
        b=X8qTvampenB7RB6XN4bFcs8VaqXt64gWgwENqFNh2deJIf3MAsqhVRBgSj3H66TdoR
         HmiPa/MajNV39dajlWypA7kTmh+wiF8FTAbqADv1mJtpQylYsfM5Y24AggzF550/32Rz
         GVOPrRNsOTVrgZREPuDS0/UlgZlj3jRi4L+LTbnmA5pLxZc1Rrjg9WwspMqlXy8/Kpfn
         KCNS14swSOsEDyNK3DaGDFWwmQeFG+6EdCsEgK3Ult+Ll9ae0mG8hrce4F/G+NrL47ns
         ZERYB3kx8zF70FzTI3RRF6wvT4iOkItHHWEGuq1qGcHPgGM3EB/DwzY0aw/Oys8NDfKF
         bvww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791063387; x=1791668187;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GslxcUUavKHlTdFwaar0hu27Mm5uFqzdCxZ5qCSULms=;
        b=OJaPYJX3ykUr+86n1Tbu36KbonJBWrAk2YEhmwEPJckrgYbvKunGDCDegpM+QtECx5
         YBb+5fKLA9fiNwzYZkfP6zIq3nLOvAddb6BSla5/Eqktph+Du3YPRnh7SeYX3x0dnXqW
         TaQjKBIEEMkgJdMMewx3EKNtDkIBt00fkqE6ypuQVyHcKdubqNciwSXNrGbkGup4g1HX
         1ePS8ymxBKEvAvLH/UVusnocktzfft8X9KJxjsGUeg30zJPI0wqJ4gEjYOWoJOdp4iQx
         prPwUbj+c3DIUnchka0k6zpv6Bj0Wv28xJ/8U0YpGJvYD6pCQJC5V+euSzpP8yAhxxFx
         /MRA==
X-Forwarded-Encrypted: i=1; AKwUvBwrfZoiM9tmszZQC17uZPpy3RQQOzMSETx7XBYCi96CkeD/CABuVlT6p6jg2tUw0JINuU+Ou3mbZ83iXQ==@vger.kernel.org
X-Gm-Message-State: AFuF++n+mDPKmSSVTQw6v0F7pwdd1LPN5h8lullh2tKrQiz2wT6JCwhH
	+vkP8UEaseLewOCHttHWi5koUKsswYanu7D2De/alVuYvo9VVugpH1d4w3LGVKJR83T+KXF+SOq
	Tp/fzk6hnKg==
X-Gm-Gg: AYBFou2K7n4BgKG7pkTfFnzlCtqg6EPYJnqjfzH3BaO206dt72oV5W6e5oO3OOdXAjk
	E5DzVCWTkguufIsibWx6Ij80AuvVFVGQiCWdELFSKgVi8GGQ5JbNQYsCeYIpwJKqKzRuk6pYK5I
	paBHOUxDImiP147VbqX3of8PZFFslitEdHfTwDLffpmphW78vH+VDoFT8P/EHkWCcr8gsQN7Tgc
	q4JeUHR8T3yukznNgaIRDh8Oh6lvLBVnf0lDYCtXd5eHiRZjSFrD9rXVJZbRwfCykg5sQvwWzRm
	FHfRVjThapS4mDWBvn/d0yw1q7iEOz/fsxIJNtxJDX5qjtyTl0C6DutYkBqahUmdPHtTTdoNu3v
	l3Q08gvmsXto2EsFPgzbtlTgjaYE6lVh68JPHXjUKTyAPT92sC0kjKo5uukW0J9u0mDYkGqBydA
	b0x2i4R0dY/ixMSO4LFaj3cu/OhsXNagbuNIfaUee8mYInphE3hknlA4fxE8HkcDY=
X-Received: by 2002:a05:600c:ad7:b0:49c:f13d:ffed with SMTP id 5b1f17b1804b1-4a01eb4c01dmr143351775e9.17.1791063387350;
        Sat, 03 Oct 2026 14:36:27 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e49f70be7esm19246305ad.67.2026.10.03.14.36.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Oct 2026 14:36:26 -0700 (PDT)
Message-ID: <d6f47c04-cf2c-4a52-899f-744d5843b010@suse.com>
Date: Sun, 4 Oct 2026 08:06:23 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] btrfs: qgroup: fix off-by-one max level check in
 qgroup_trace_new_subtree_blocks()
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <cover.1791046651.git.fdmanana@suse.com>
 <866f66a876b64f392fd225f0cb291dc8eae0ac7e.1791046651.git.fdmanana@suse.com>
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
In-Reply-To: <866f66a876b64f392fd225f0cb291dc8eae0ac7e.1791046651.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/10/4 03:30, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We have maximum of 8 (BTRFS_MAX_LEVEL) levels in a btree, going from 0 to
> 7, so the upper bound checks should be:
> 
>    >= BTRFS_MAX_LEVEL
> 
> and not:
> 
>    >= BTRFS_MAX_LEVEL - 1
> 
> In practice this will hardly ever be a problem since having a btree with
> 8 levels would imply a massively huge fs.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/qgroup.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index c9fc3b6a5132..54d82d6fd4bb 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2491,8 +2491,8 @@ static int qgroup_trace_new_subtree_blocks(struct btrfs_trans_handle* trans,
>   	int i;
>   
>   	/* Level sanity check */
> -	if (unlikely(cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL - 1 ||
> -		     root_level < 0 || root_level >= BTRFS_MAX_LEVEL - 1 ||
> +	if (unlikely(cur_level < 0 || cur_level >= BTRFS_MAX_LEVEL ||
> +		     root_level < 0 || root_level >= BTRFS_MAX_LEVEL ||
>   		     root_level < cur_level)) {
>   		btrfs_err_rl(fs_info,
>   			"%s: bad levels, cur_level=%d root_level=%d",

