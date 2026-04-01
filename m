Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDDC315D53
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775081436; cv=none; b=bDsH+fBlLy4PqILou1JYOQqghNq0+yh8anYC2+iqzjlP5DGVW/GQ6LcMdKkfe5pMiYlnoJNW3wL4K15/hFwJWIcM+0UsutNwt3CtNH6NxTLo1JxNVgQDwQ/Dqj8GrV9/BvzcmqS8uLmXgv+byXkgdGKU3rOcFlyJzYN/LAq546U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775081436; c=relaxed/simple;
	bh=urctENoJz1VQH9VBs2R67GU+6j7TuKW03BVzg14YeFA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ucrp6B4DLmWN8lRWSB92WaUb8eDqD1MiUhClr6he5sqzDgU2406Nyv26Uwe9gp1R9Hr8LrmCDxMj2IpYJETcXJJQiBiMfyf9PXdZ3u7jrCFXRWS2LFC7S9v46FQz+nIYVe4nojB8oTCbSjFRtLx8R8vwD0FfttA4fMn4SVruWcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NjQD32in; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NjQD32in"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-486ff3a0fc1so1750915e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 15:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775081434; x=1775686234; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGn8ZfejuIHQEAr3dSJQgxj1UyGWLDa21lXVxlUAKPg=;
        b=NjQD32inKqlmYF1HlZBHVLePM/EMkXf8zsq+4wLzrf8yrjYTV5rdgS9hZX/PAh46w/
         No74Z78wDxMnaE45UVQyWt8bw/dPvc/4C+Szsx9K4w4gVY+NvB31h6wYwWxkNMCh6e8V
         BwKxWedxse7xRuhqPG6slJe61+vSZQ4q17KyGDPWrI06lMHplzXkBNBTgZMO64oq9IjH
         joHDvsJ4pvTYNF/3FSdJj31VlI/RbCwmIQCKNrC+pVduv2dn96TvO4+eSiFHV4ts3D43
         EhpreGNfEKpxDDbz9pU4K55GMVxITC7Z25xA9EOY7tnMlQTVB3zpBNyX6wIycpbpoINI
         qGLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775081434; x=1775686234;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZGn8ZfejuIHQEAr3dSJQgxj1UyGWLDa21lXVxlUAKPg=;
        b=Fup1yxtN6VcVo47WiTD1tQZfFDQD3zBbKVa5MZPiynFGID3Hog79JDgC76NL55rHpv
         QvJYtSMeTFeJxp7FqnP2JkDU/mdaR1kDsPaIydoXRcLSDR/0y1h+rDsErefev6ICgsbz
         ozUaltXpf3Y1+d68K3+DVyE2GFN+ZVxU6BMNei13JyKfJchUtn8uIENi1tlHVbyBxxPl
         LFOSq+Py1mZ1VQHZuOoHfoJ21jZQElKN8qnd66g/t0OQz0AvPaQqAofXtFNCuS1GleQF
         JGvCWzgDNIINfWq/x18QrBMGQwkPggCSPmbzuegfFG1ofNQLo1xGLCS2Fy5qo6y9VqUg
         DWmg==
X-Forwarded-Encrypted: i=1; AJvYcCU5aNL4qEPvcUnzH18FatRYXgOoXvdErgbU4Z7+yE7xGC6sq94uNa9Csx2m5qxf0ZomsUSthOxAxUCqmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAzNZYzCC3LaBJbT68pqCv6Bz06YMgEVIbCZLaJkFxPUrAVuHo
	uqHURHgtwYbg2yj73Y4u3LirJHmtB6ZZv+Q1xXrjz9weIPPBjt1kqe/DCWRYA9qznL4=
X-Gm-Gg: ATEYQzwyk/N4cmfb4/eWokHFIverszyw+2LLc0BR6mlrhVRZc8OtLX88VIFT2tcswtM
	isjqqK6MYqvuA6+Gfvd44sAwrnuX+P59UGFU3Fsuvt0CKCPac6ItEVa5A64BjOQuLhPrjAaK6CW
	4e+zucAGzpQbvdI5S+Xzu47hSZ1L7a9HiyXhwlWHaVXtgBpR+RCGlUSPyurUj5d3tnpw6HcoSAG
	yAgUMsEaKpikRkr8mch3J6b4c/nbiKkCI0/zNBjqdmPtRh5tNV0j6eqCsPDUapUpIisl5AF2S+3
	Yv5IgGnaAnekiRQe/m2rk2ug4RnvEM8dFjaXJ4H4+Gx29JbNC+zbg/VD0m0sgNZzpwLDj5OIs1e
	6+7W+khMNwHpPOPfMIz+lkxbYqLskVieue/Gp/oj3vk1oMS72vevy9hWa48h78hnHbq0PGsxGt8
	tKsr8TZilcmsecNHOfuzEOzIO8vzbuTO5efPzj3XvcdHCkly8KmDY=
X-Received: by 2002:a05:600c:46ce:b0:487:1108:48bc with SMTP id 5b1f17b1804b1-4888b74c1f0mr16046915e9.17.1775081433564;
        Wed, 01 Apr 2026 15:10:33 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2749a34a6sm7221725ad.60.2026.04.01.15.10.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 15:10:32 -0700 (PDT)
Message-ID: <d8344ab4-5d26-4cf9-86da-a28434cc9477@suse.com>
Date: Thu, 2 Apr 2026 08:40:26 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: fix double free in create_space_info() error
 path
To: Guangshuo Li <lgs201920130244@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Jiasheng Jiang
 <jiashengjiangcool@gmail.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260401105619.1506398-1-lgs201920130244@gmail.com>
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
In-Reply-To: <20260401105619.1506398-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 21:26, Guangshuo Li 写道:
> When kobject_init_and_add() fails, the call chain is:
> 
> create_space_info()
> -> btrfs_sysfs_add_space_info_type()
> -> kobject_init_and_add()
> -> failure
> -> kobject_put(&space_info->kobj)
> -> space_info_release()
> -> kfree(space_info)
> 
> Then control returns to create_space_info():
> 
> btrfs_sysfs_add_space_info_type() returns error
> -> goto out_free
> -> kfree(space_info)
> 
> This causes a double free.
> 
> Keep the direct kfree(space_info) for the earlier failure path, but
> after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
> the kobject release callback handle the cleanup.
> 
> Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() error paths")
> Cc: stable@vger.kernel.org
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
> v2:
>    - add the full failure path to the changelog
> 
>   fs/btrfs/space-info.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
> index 3f08e450f796..d7176eb2fcbf 100644
> --- a/fs/btrfs/space-info.c
> +++ b/fs/btrfs/space-info.c
> @@ -311,7 +311,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
>   
>   	ret = btrfs_sysfs_add_space_info_type(space_info);
>   	if (ret)
> -		goto out_free;
> +		return ret;
>   
>   	list_add(&space_info->list, &info->space_info);
>   	if (flags & BTRFS_BLOCK_GROUP_DATA)

