Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6AE317159
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 22:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775081519; cv=none; b=bp92YsZP4zQUd97oQAjnMUu2sO6p+43TKkoC1zIMfLeCbfS6Yq1wsQ9DBYH0oPMVwRN8HT59ZOrQldYy7hFW+/O3Xh0KOOLHb5f6on0b2Qr5YgNZoej3JY5VLKdJV/RVb7Kf++RrwbR/uD6JnqACOpg7pyeLG1YfZG6KgJxTQJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775081519; c=relaxed/simple;
	bh=mXm/RVkydjltxBYXI3wsGZqHDOjU3KCa3eQf0otGLHA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqJyCAf5JliHEd/KPlrIRnTO0QvmxUyxRAUTwMeX5Q9GXXbOVHaNPh/yIGI/i2Pn7/OeRuQel1y5tIOToiTWWxNMzpVjwe1WHdsD/S2th6zJQ/L2ktrq/siJC5J1fiyyEqmLKaGrimsfhoidtdxgfaPfl/5w1ID8vwTxb2yBXVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IFNjY6/e; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IFNjY6/e"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4852c9b4158so1738195e9.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 15:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775081514; x=1775686314; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=fuaXeXdxXua3ooI0sFkXIl7FkYLoUgWL2eTcBzrMgAk=;
        b=IFNjY6/e81MPsvow3rvkbotTMBvg92VTrH0Hidf9DZIT/jIHJYVJ9RTuoyyvNTEDZa
         ELgi+rFwwjK5TFj0o8GImHPAf/xNoMOSdmEAweS4HlLOAPpbY8DM6oGsHg9U+BswDawz
         BfnEma9AY2aKYj1nG/atn6qiUIlphikzYrXIjQzBnyyEKZ9SCleBO022RLeXTwIzeHKr
         +fpRzuYO5G9wkBIzjLT5G5oGlzjtOufhd0pUWUCd2R6q2tJg/84bSDaQIG/qxdZG99xU
         E9jzrL7lIMIX1LeTeADxXFkBEf/Z7d+nKoqgwT4jS4cTflkuwwM+apY5NROByiECBFf2
         5kdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775081514; x=1775686314;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fuaXeXdxXua3ooI0sFkXIl7FkYLoUgWL2eTcBzrMgAk=;
        b=ijB62r77mdNlIFLjkW+PiOgDtrE2/VMDs467SWFgm9LwtE8XV+VRbk05DsaDCZNdp7
         565RECEvhXZVJbz0RS5NhK6Gh0SsGX+A0jlBn52ul5MwIovsxgIa1X/NTwhoNpebnXQq
         Le9UoGOw0VD15OU69+37+JZ2IRnXq4w485haRq5eC+Cxj8Ku7CpNm5oa5qROXROaz/xP
         cFGM9THJcAe79i5E3JV+YfA0snn+TjV0Mph6xc28R8Xr8r3QpmF6hQP8Qz59R+wLKdOM
         C7Xz2QmjdWdDYkWlAkRxL5Mll/zDQH0fJORx2BOYbxIpzbRvpoCTwxUDfN4ShEIP46+K
         /77w==
X-Forwarded-Encrypted: i=1; AJvYcCU4FwMIJX8gVcewBo+P+eccfGJ+bdNxU8oSOdFQBHBR1Eq0UkoLQhPMnZnQqkODsx11mEXt+aihKaP/vw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+6PLfDsWBjgfIFss1Xv8+fRUiindiDtbfWauizF0wkPRKHM6G
	9X9lCM7HVbyJl7kjgO6c3jACahSU5DeYEltmhTEGCLEkoCtJ3W8PFrLFdAY8U6Co95Q=
X-Gm-Gg: ATEYQzwL23jxxhJ01d2Z3EEmZkIBIa/R4lwKNu4PUpWWwmciJlbgM9olW9J2WwUb9Ne
	NCjMiff4n7ftMJgIKFOcsdRs+cde3aZzv63gkvKUjOXjGOU4wyE+tK8WGoy14Qnv94dOqcvT8BM
	89I/8Hyj5PTfWKANQqr/dE4jOrndWPFWXtDXMiqGWQRqSVD1O+e4ClhtD+1Ss2190T41uXyjxc+
	pjbqzFn+5FNunUyM/ZxsIhiZkkX0ZSF2IhaRaE6c0rS/J8G1S0mDN2BT+dCPREZaBGrJg1Yvc7x
	vPVwzrMDcLGuOIWAr4v+VdvUdUMNwG/U/Nky1UGmSjjGvJNdoZt8WAKHlapqVgEcoZUrj1jkAsB
	2bMuZl6/7cGQG0UqhiljNa0H0HKaLZmtG4DsyMjjK1atn4xXjaF2jB4sE8gjoFyQQFdJkL4MkDe
	SzNiIfGXiP6L8i9TdJCRrDMlbIEYxxNz8uRqpdf1xAY1WJqlNaXlU=
X-Received: by 2002:a05:600c:2d52:b0:488:8d44:bf98 with SMTP id 5b1f17b1804b1-4888d44c16emr3631025e9.7.1775081514540;
        Wed, 01 Apr 2026 15:11:54 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6491157sm716394a12.9.2026.04.01.15.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 15:11:53 -0700 (PDT)
Message-ID: <4e0a7845-a9c0-48f6-9bb8-102411ff0a11@suse.com>
Date: Thu, 2 Apr 2026 08:41:47 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix double free in create_space_info_sub_group()
 error path
To: Guangshuo Li <lgs201920130244@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260401110219.1517804-1-lgs201920130244@gmail.com>
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
In-Reply-To: <20260401110219.1517804-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 21:32, Guangshuo Li 写道:
> When kobject_init_and_add() fails, the call chain is:
> 
> create_space_info_sub_group()
> -> btrfs_sysfs_add_space_info_type()
> -> kobject_init_and_add()
> -> failure
> -> kobject_put(&sub_group->kobj)
> -> space_info_release()
> -> kfree(sub_group)
> 
> Then control returns to create_space_info_sub_group(), where:
> 
> btrfs_sysfs_add_space_info_type() returns error
> -> kfree(sub_group)
> 
> Thus, sub_group is freed twice.
> 
> Keep parent->sub_group[index] = NULL for the failure path, but after
> btrfs_sysfs_add_space_info_type() has called kobject_put(), let the
> kobject release callback handle the cleanup.
> 
> Fixes: f92ee31e031c ("btrfs: introduce btrfs_space_info sub-group")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

> ---
>   fs/btrfs/space-info.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index d7176eb2fcbf..f5d0f587b755 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -277,7 +277,6 @@ static int create_space_info_sub_group(struct btrfs_space_info *parent, u64 flag
>   
>   	ret = btrfs_sysfs_add_space_info_type(sub_group);
>   	if (ret) {
> -		kfree(sub_group);
>   		parent->sub_group[index] = NULL;
>   	}

For single line operation inside a if branch, we do not need the 
brackets anymore.

I'll remove them during merge so you don't need to resend the patch.

Thanks,
Qu
>   	return ret;

