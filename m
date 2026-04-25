Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD4C346E56
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2026 08:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777104417; cv=none; b=uaWFE+KPf1Mzd01LinpSHqY+JO2Sc/VuHCRDwrD22cMpkNJcfuA/rvAlLCT9HRRxA7Wlg9Mit7AwBHPU2dCcnWLXQbJJcYku42IU24MUZpSs0Q4ifPFteFS2Ma9eNJVzqlAVqvWG6fvwow8AIuWAgfAwchom6G0N8hOzExr9Bus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777104417; c=relaxed/simple;
	bh=nXk9rUq7vorIlyrBo4lgvIb2Q8zFEV0hFxBpQ/vbpRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DwF7FZnubUTZuymwdEP+fWjboDa/HmwekvMSLplvKV+6ZxdivoxUKDwTQabPT26nqlBko+2tq3+j2clvbzqtqs+JwpW01h06qzq1s2YXEgMY/i0YG98BoMYN6lgbVQOf07Axpvi+Bw10yntpEFmf+hM+2veAbaB3dE+7GTOAj84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YZll8neC; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YZll8neC"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4896c22fcbaso57162155e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Apr 2026 01:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777104413; x=1777709213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iVaw8PdZDzYbOkduGbjvCJP60/bP9Mr1OKxnXxCFIbo=;
        b=YZll8neCppB8gQa9uW4/NQQQsy1xjJ18CSI3fOcBj9Rgk0VwUblzr/fGBQEeehPBwc
         B2Letz84giINI04SCinnJCr7dQ6z2lSvydw95woCw8yV2oWTgeYAmrepkbmeoGPXKYBS
         2fpegrFitoAQUwCMldozdv30pI/JxqL+vbjlB3Z0i0SukSclpWW37Vek82efnfnIdu5u
         NfYZLXndXCZxLlXyA1wZKsGuuPi7CFL0EPB0EZ0XVJxmqNiJ7Zs9TX0/InfGnwUo3uc9
         hpM6xezy/0ANBeUCpTtHgCZAyivQQC/DDSyROS63WFIn0lhNcoYd+D8E25Ee9ylthu4a
         V+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777104413; x=1777709213;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVaw8PdZDzYbOkduGbjvCJP60/bP9Mr1OKxnXxCFIbo=;
        b=URZAbaQMiRiXK/cYNZv/E1LbuTrwlEJCIlrh/V2sNjrKS80Mqk8Tlzlyx4gEc7Q1NA
         Y1w1ajmf0axwle0KTlUsnCFYJCXab6xofQexEb9/sskgY7irnM4enZvwQjXFa7b30CQT
         qOUbguBRLSOE60ORuWI57eENuQMObxM1/AvDshKbwLk7TTh3FeALGm5jQfARn0x58tFl
         8rKb6UVMjjQLj7ibYRluwtmR9ddhVTbu2r4j4vQVIcJ8xeWNbchq0OACTT5bfsnDo97s
         gDR8mmEMUBZGwKKGZ/wurp3ZHG+cMwCdZ221wDi15oX9BBKKp7AtdtoGxzmziIHx4M7G
         A+oQ==
X-Forwarded-Encrypted: i=1; AFNElJ8Wo+RkzGVJjOmNKc45JtLCidD52t7cmpso8+qL1wWYRyuDnkNPZnt/SDPogQ3OGsavwgUYpwW+/E1CrQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwE8tbFyKsVaP/Gz4LwjoYk3Nqy4DJPoPQf2ICIV45JY3ohbsla
	xF0RaCfNG6rqJnSsLDCpXDsTZarKVx801pYSLKmZmWxn1LfLapUq0TCsYelPfKLWsVg=
X-Gm-Gg: AeBDietcv9jXF6ctXIo0mZh4MeN8u+PktB1amfTTTwo9xfMJypynM2vysQidvxH+ZT4
	6KRuVLy//STNxFeHKqn57fqs6gp1j1D84m+LXVW3/Vp75VzI3LsdvnIr6jNrmCX6WCgGFdDynLr
	DR8OpHEgaY6kmGE6YW3+gVp27s3cu8u0+wqzvWloMsECDaWMVCtdncNQJH6hNj7FpdYOkZC2Mxg
	6w4cKPcluUnUp09JUi+PiaTipKcnyhT0MUqHR7Schgw1pwq9O1J7Od6A32PMv9/tnW1mdzvhBfG
	OqM0ajt/OcZUVFvY8iZHEgfMXz1fscYJi6mcZz033pIg0jr7Fflv5sf/E+s60uiwjHX0fiv5Vyu
	1aLUuwXjVAvQ68H/AKivfFb6a0Fz6Pos7XtypVCkoDIg4wHUc7J3DBs+z5y1JwcrKIugIUsjNev
	PrcLh3Il0TL0lU7TTBy1IP2sQZNqahjNGAzwJh6GVRcAASwN/hYiJWlC9fAHLSmg==
X-Received: by 2002:a05:600c:5299:b0:48a:5342:36b5 with SMTP id 5b1f17b1804b1-48a54514646mr295734265e9.21.1777104412979;
        Sat, 25 Apr 2026 01:06:52 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f8ec06cbfsm29939521b3a.58.2026.04.25.01.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2026 01:06:51 -0700 (PDT)
Message-ID: <6c54901d-5e07-4c46-9553-997b28c93b86@suse.com>
Date: Sat, 25 Apr 2026 17:36:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: replace BUG_ON() with error return in
 get_new_location()
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org,
 syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
References: <20260425061214.235982-1-27rabbitlt@gmail.com>
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
In-Reply-To: <20260425061214.235982-1-27rabbitlt@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/25 15:40, Teng Liu 写道:
> In get_new_location(), BUG_ON() crashes the kernel if the looked up
> file extent item has any of offset, compression, encryption, or other
> encoding set. While entries created by the relocation code itself are
> not expected to have these fields set, the values come from on-disk
> data and a malformed file system can reach this code with non-zero
> values, panicking the kernel during a balance operation.
> 
> Replace the BUG_ON() with a return of -EUCLEAN, the established error
> code in fs/btrfs/relocation.c for filesystem corruption. The caller in
> replace_file_extents() already handles errors from get_new_location()
> by breaking out of the loop without aborting the transaction so no
> caller changes are needed.
> 
> Reported-by: syzbot+3e20d8f3d41bac5dc9a2@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3e20d8f3d41bac5dc9a2
> Signed-off-by: Teng Liu <27rabbitlt@gmail.com>
> ---
>   fs/btrfs/relocation.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
> index 1c42c5180bdd..ce751c35945f 100644
> --- a/fs/btrfs/relocation.c
> +++ b/fs/btrfs/relocation.c
> @@ -835,10 +835,11 @@ static int get_new_location(struct inode *reloc_inode, u64 *new_bytenr,
>   	fi = btrfs_item_ptr(leaf, path->slots[0],
>   			    struct btrfs_file_extent_item);
>   
> -	BUG_ON(btrfs_file_extent_offset(leaf, fi) ||
> -	       btrfs_file_extent_compression(leaf, fi) ||
> -	       btrfs_file_extent_encryption(leaf, fi) ||
> -	       btrfs_file_extent_other_encoding(leaf, fi));
> +	if (unlikely(btrfs_file_extent_offset(leaf, fi) ||
> +		     btrfs_file_extent_compression(leaf, fi) ||
> +		     btrfs_file_extent_encryption(leaf, fi) ||
> +		     btrfs_file_extent_other_encoding(leaf, fi)))
> +		return -EUCLEAN;

Every EUCLEAN should be paired with an error message.

And in this particular case, it's better to provide the tree dump, to 
really be sure that such data is corrupted other than caused by some bugs.

>   
>   	if (num_bytes != btrfs_file_extent_disk_num_bytes(leaf, fi))
>   		return -EINVAL;

