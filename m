Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF294F5E0
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 09:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775034504; cv=none; b=EPjfv6ZsAV4ioL0zQWXwIGDS0XtML+sazw9XYWwsj+XQxWuI4o5dchxJ5iqf3x3siLb+wp243lLaYwYgtGvuizGQioUpCXSiLty3om3v83VLhZVfawd16mdoPyAtP528QtfKSetkuUFLVNLl8hiCNgKd/2MW2oRTL90N/6X1+Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775034504; c=relaxed/simple;
	bh=HE8l2eFMGZGC/yaUGKtrjGzh0jGajyAP126vVz0cl28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P6UY/kSTyOtLLK4AShWSNrAPw1/tO5FksELf2aRF+5os1SvbnNEpe7M64u2NOSD9FrvgdlsCvq2SvyR9t8a6zJwH/l/1Vh0kdAXuWHLJtuXEOzN2Lu+D8AzvSbfvSLj8hV20l5dfusMb8q2DaLVk/JvAhEONVMH053/iO8fH4Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PbLhz+r7; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PbLhz+r7"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4853c1ca73aso68617415e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 02:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775034501; x=1775639301; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KMaIiVr+f/hE5SivT8e6i4Zfgwziv+JOGWcyYdrol2A=;
        b=PbLhz+r7sHJdsQQ6vGoPWr9F/keBT1mytDZbs6hvwiCDpoz9vSlmwhoIfMhjqThwCX
         Nsh34gK9n4YUxRkGTOnhOo5jvQk2JR0wj+R8V8HMj8qS07Wa4eRtF/tHuNDZtztvfn6f
         rPvV3pFFXFap/wssDoBikKbqpAi4b7WoUp3zhOyyZRcGiPvV3pzfc2Gxk5Lapjm0gViy
         nUmi2wankBWC2+FoXi3CGCxW/tw7pdDxbuBIpL+y8nqjcQwYooZUivmaQn0sKR/MJn1g
         iJqfm7lKG3mf5XM51h/dTNWu/QW02LXsXL78seXPuqni737qqro0bzOToLqgBMFk6uff
         1Mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775034501; x=1775639301;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KMaIiVr+f/hE5SivT8e6i4Zfgwziv+JOGWcyYdrol2A=;
        b=VIbla1nYQ2Ge/xy2xw25S2TjKjCpbixW2NVxLxLU7IVfbs/iexFpblpFxCsqHd9GTe
         VE53Ul6OwAqV98VrYWAIUo9eTJZCSOTVakOzuYd5dO3woKKFzbYFghvZvhxzjmNecQtK
         KotFkqQXRN/DPrGP7MZJI9lZIyjV22cBBkikgn1L4dVBMLZpD867jTR12kg/0182WUmY
         17G9N8a3wsF2DZ6hzV+2cRq+UA4IJjPD96hver1PXJwF0IG17dHPz6JLgnis8oNK48g/
         bF3JW67BiJtCAlzh2fEpwjP71zApAvRRNRSPnFmqbYkwk+M8cSbDv1CUL3vIa2LPtRzj
         fIow==
X-Forwarded-Encrypted: i=1; AJvYcCWtNWvdFrvN+nfE6nGd4BeulIxKiS2/J1a7Tn/tO9WOXLGnE5sLrWf2BixQ1h6nEsyq1Imoujo0QfrfFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxQVBWUhMO9YlfWjyyd8Qt+InCg/mUWTwTpIbXlmEJMU2FPtzMr
	zmdmnqqDvtcXGcTZp+hfXskr5yNfxq9h1tmSTOM4RVzB5PVxMaIRZjB6cTHL85n7/Us=
X-Gm-Gg: ATEYQzzqBqyTLGgkhLJO82lIzWXXB3vwukCA0iupMZG8NpO3bbau3JyEmtAZtmjQbIl
	gQIPPSFgIRg3sj5cv7GzTyE7uG6PT1EVs063/FPk5C90PRvRuawe/t856Nj7OV9Dy5HG2GPpSQM
	VpTDeFZy4+jPD3lXsuAhyqktrH+793AdDafxfVasPS0VSsPPi2qULWuB56eAvYFgNsfs4G+pu3W
	ugXMiQMgFXDzI6NQNJ7v/jhqbkjF2J6x2ZU9A5jIGV7SzIv8eHC6zE69IcvKq3porpPaKbtiDq0
	/XaIJlcX/A7B7A5CPZtUWwTyjtg6yaxwvuM38jViC9cCrjgFL11/OYikz1Oapk8UEgfCdzzBl7m
	uRDJxlcSDYL4bWA0aU1gL+Dlk2H7qmyxjWjsrvW3/0K+L/cGpKQyvCLZW8YLID1Kw4j337o08Hf
	QMsfrJh7ju2hr8+jkBtscTPe+FJCSFxTU4Gexa3kfJh4uyWbRVbjBMbK7EcBLuiA==
X-Received: by 2002:a05:600c:4594:b0:485:3b00:f93b with SMTP id 5b1f17b1804b1-488835cd3bcmr45259145e9.31.1775034501270;
        Wed, 01 Apr 2026 02:08:21 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b25ca51aefsm82227135ad.16.2026.04.01.02.08.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 02:08:20 -0700 (PDT)
Message-ID: <4259c965-af46-4fb6-b7b6-514e11f34bc8@suse.com>
Date: Wed, 1 Apr 2026 19:38:14 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix double free in create_space_info() error path
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Jiasheng Jiang <jiashengjiangcool@gmail.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260401031339.1418417-1-lgs201920130244@gmail.com>
 <aa8c074d-fdce-460f-a9b7-8644880eebb5@suse.com>
 <CANUHTR_ZgLHj8COyE8S_J+nqUUunxMTH9TcOMsDuN=Y1hPXPEg@mail.gmail.com>
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
In-Reply-To: <CANUHTR_ZgLHj8COyE8S_J+nqUUunxMTH9TcOMsDuN=Y1hPXPEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


> 
> So the call chain I had in mind is:
> 
> `create_space_info()`
> -> `btrfs_sysfs_add_space_info_type()`
> -> `kobject_init_and_add()`
> -> failure
> -> `kobject_put(&space_info->kobj)`
> -> `space_info_release()`
> -> `kfree(space_info)`
> 
> and then control returns to `create_space_info()`:
> 
> `btrfs_sysfs_add_space_info_type()` returns error
> -> `goto out_free`
> -> `kfree(space_info)`

Please add those two parts into the changelog.

Otherwise the current one fix is good to me, for this particular call site.

> 
> So my concern was that after `kobject_init_and_add()` has been called,
> the cleanup is already handed to `kobject_put()` /
> `space_info_release()`, and the later `kfree(space_info)` in
> `create_space_info()` becomes a second free.
> 
> If my understanding of the `kobject_init_and_add()` failure path here
> is incorrect, please let me know. I may be missing something.

Furthermore, there is a similar bug in create_space_info_sub_group() and 
all other locations.

Personally speaking, I do not like the idea of releasing the space_info 
through the callback at all.

It breaks the common scheme where who allocates the memory should free 
it, now we have different handling before and after 
kobject_init_and_add(), which is causing all kinds of problems.

But I'm afraid that's the way we have to go.

Thanks,
Qu

> 
> Thanks,
> Guangshuo
> 
> Qu Wenruo <wqu@suse.com> 于2026年4月1日周三 12:34写道：
>>
>>
>>
>> 在 2026/4/1 13:43, Guangshuo Li 写道:
>>> When kobject_init_and_add() fails, btrfs_sysfs_add_space_info_type()
>>> calls kobject_put(&space_info->kobj).
>>>
>>> The kobject release callback space_info_release() frees space_info,
>>> but the current error path in create_space_info() then calls
>>> kfree(space_info) again, causing a double free.
>>
>> Can you give an example call chain of where such space_info_release() is
>> triggered?
>>
>>>
>>> Keep the direct kfree(space_info) for the earlier failure path, but
>>> after btrfs_sysfs_add_space_info_type() has called kobject_put(), let
>>> the kobject release callback handle the cleanup.
>>>
>>> Fixes: a11224a016d6d ("btrfs: fix memory leaks in create_space_info() error paths")
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
>>> ---
>>>    fs/btrfs/space-info.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/btrfs/space-info.c b/fs/btrfs/space-info.c
>>> index 3f08e450f796..d7176eb2fcbf 100644
>>> --- a/fs/btrfs/space-info.c
>>> +++ b/fs/btrfs/space-info.c
>>> @@ -311,7 +311,7 @@ static int create_space_info(struct btrfs_fs_info *info, u64 flags)
>>>
>>>        ret = btrfs_sysfs_add_space_info_type(space_info);
>>>        if (ret)
>>> -             goto out_free;
>>> +             return ret;
>>>
>>>        list_add(&space_info->list, &info->space_info);
>>>        if (flags & BTRFS_BLOCK_GROUP_DATA)
>>

