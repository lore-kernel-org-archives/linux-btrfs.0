Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB6948F83B
	for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 21:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789594134; cv=none; b=r3t7GYIQQn3gqx7pUji8QUKg12KtpzJ76t6azOVTx6X8wRIrBhb0XtZKC1176lDhdtiBqcR6kb2YxtfGYx6G1kYyXJPuePxDwH9UsxfA8YYU/25nFLYX0ofBJsPp8ECXYzzW57zKJvbZIVM1BNH2AZKsalNKoS0fBAQkx8zEZWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789594134; c=relaxed/simple;
	bh=DopW7fU47du2OteIJnaemQyUibFpuZm0CA9ygMITefM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JONDe6194nbrabpxwj4wQMzojl3JH0AQMK6g+Ys0Ti9Vg90N6MfC7kwxFvjmkT1+R6dbsXF11QgpFhgY5wUmo3irtdmSU95aVR9+fGBmlfstj3yZILbgtIcGbKmx8MRaZfm0qjqDROWnYfChU191hfTyhu9uI8F8J71qT188k7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TF8N1gwb; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TF8N1gwb"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f6c7a4aso28333966b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Sep 2026 14:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789594114; x=1790198914; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EwklGG5Jn7jc/QjPxziZGh77lggbD1OCUTfNuflEo68=;
        b=TF8N1gwbVGDVSycP2CbPXzKMg+jmqkR+iJ/KgO95FquDkFDKU9VaOadp/h1e6Ks9Fm
         /NQzcWm76xPHJiEcWcQ3h8+JRpJ8w0fIbE7Cwez0eABmyGO55eP+cyzsCHCGGh3I/VAd
         9MGAF+oJhpQk9B9TOlBJAjv94ZmGgwLWQBcbJAA3E7g+4pvm5uP9i7d7o9e7/PjjNVJg
         AfP7Q4HVFnYqgzuIstChFjeJePZVSCGWInLEXPM9dqD7cxiVdoCJ3aRqdJmZR1a5QCoV
         DeUt+PIkFQuPP+Oq8p1Kgzi5/CdfEW60J+27c6RWC5cqho6pR/e0u06C2wbk4KyDRuvj
         rfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789594114; x=1790198914;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EwklGG5Jn7jc/QjPxziZGh77lggbD1OCUTfNuflEo68=;
        b=mxTWJugjJAQHQ1eYTkHFKNwdWHomC2tiGsaygEQ3Svi4MqUOQwsmAes8HDLco9hNVJ
         5pBetp5eLQf5cpfuhGiRqeM8rhOg27CzzDHLOzDXAjGkLPLbt5+ds85NSDalILAsaGvP
         zpYwgNGiQX7qwYIvDuw7qObwlmj5mZx49BvbPaKGn7cVzxrj9dc7dZJyZWMp7obwghQZ
         De8wIBL2Im0/z6IuMDiAS3h9OaHzWoLXkesueyg+m9CGBEMbi84Vk/BuEXRtUkNXZDzl
         xLXM+t9XWd12RjL8oQo6meWGLkAeaHvQOsFFbnX3mRfN/8fD0+6OwHHTFVrsDrr3f++F
         zjxQ==
X-Forwarded-Encrypted: i=1; AKwUvBzvqjMx12rtau4mdWkUCAfiCjhOhwaltx/mn1aJ8G/jU5iDlXWOMc3gHjfQMEfBoWq6Q/xhWIHGdykZJQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kqVcwgXCPkTewurG7KdyWTPmngq+HOL60JE4JHYQLwN4BDhZDC
	7XwrTjKRHcyEUoJ8+bkw1Uvu79p+k2i6I5kG7pxwukPS8LusSR0QzLFCXXoI+UXCrl8=
X-Gm-Gg: AYBFou1tCxK24y7G8nrKcJikqSD2LCzUr/ubFqMGowYXIcvGxe+8gepBeA1IxNw/54y
	3F4tSQVyG8vrqXwBdrpy3VoCvDz0iOwgY2L6nbpNfv5Vv/3tWUPip9eLDhWUsHV+iESAtJP0e7d
	NIEtA4MuEwuxuDqOwc3m7guMFOzkYqOY+yAqbid5/sX6tSuijMtdBVKPotlnfxbN03ULvgGNxbe
	APy1zNzgusGU/Tm6qSO7qUaWwv7PWukHTG9+go7mtlZWmIhB1Q3+lNySoPb1df14nO4LKljwxkF
	bW62NPJkYhZoG183v7b49wYpYgesZkIYMqznUGrEramuwqYI4a+XQy73a1drM3drFZrN+zzCmH2
	t087Wa144QldjTou2WKrBqCc0L0e70uHXRNpEG/Rz/11L5I4GKTfkWG9xBp3u/1no3J+GPVo/QO
	ynxxqDk6s5Ma3bg2ZNZvvuLyUcl0eCqn/0BbWZrYKL/akfugPB66P1leFcUJi3S9Y=
X-Received: by 2002:a17:907:9621:b0:c29:4415:2ec6 with SMTP id a640c23a62f3a-c29e520778fmr332807566b.12.1789594114298;
        Wed, 16 Sep 2026 14:28:34 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35e4e0c6sm1339105a91.8.2026.09.16.14.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 14:28:33 -0700 (PDT)
Message-ID: <99e44bec-be94-465c-ae93-bff828111702@suse.com>
Date: Thu, 17 Sep 2026 06:58:29 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: check if there is space for chunk item when
 validating sys chunk array
To: fdmanana@kernel.org, linux-btrfs@vger.kernel.org
References: <1b84f9c06df52773d921c1b2e58e4d27414b5ac8.1789574998.git.fdmanana@suse.com>
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
In-Reply-To: <1b84f9c06df52773d921c1b2e58e4d27414b5ac8.1789574998.git.fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/17 01:41, fdmanana@kernel.org 写道:
> From: Filipe Manana <fdmanana@suse.com>
> 
> We checked if have enough remaining space for a key before dereferencing a
> key, but we then dereference a chunk item, to get the number of stripes,
> without checking if there is space for the item. So add a check to see if
> there is enough space for a chunk item before dereferencing the item to
> extract the stripe count.
> 
> Fixes: 2a9bb78cfd36 ("btrfs: validate system chunk array at btrfs_validate_super()")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> ---
>   fs/btrfs/disk-io.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index a1d83ad9a4c0..94a7e9059a7b 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2370,6 +2370,10 @@ static int validate_sys_chunk_array(const struct btrfs_fs_info *fs_info,
>   				  key.type, cur);
>   			return -EUCLEAN;
>   		}
> +
> +		if (unlikely(cur + sizeof(*chunk) > sys_array_size))
> +			goto short_read;
> +
>   		chunk = (struct btrfs_chunk *)(sb->sys_chunk_array + cur);
>   		num_stripes = btrfs_stack_chunk_num_stripes(chunk);
>   		if (unlikely(cur + btrfs_chunk_item_size(num_stripes) > sys_array_size))

