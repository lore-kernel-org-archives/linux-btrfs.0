Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3670274C14
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777415655; cv=none; b=h5QG8KgP3uGJ9Bi27qfRbuShv2ChvNkZq0Xb8ScJZb5FfEj1IjB2fflxLblvhPYqCd2mp5hLWeLNSu9riHHAw+L9npHu1qsvONHyZt+StxnqSKkzVuYeq/StjVuXbtDbrtOnXlzYjPaKNPXIyjau0yY03SBWcWszlSRN7v7cC+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777415655; c=relaxed/simple;
	bh=smTEI8Nvk4RbpFIBjH2hUgs4ffszPDCVdpLZUuPJMmk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Jzc6dNCEPrSdF4tzxFk8aMqN9xg0LfE2LCF1pXqxcLAS+5wuV0XiFxsNuNGMW0yzrGk7P/B0XxxC1ZBxKwaBNkOU4dGvpeHhCKYHtTQmeyW6sTPANv/Xt8HgtAovGNQE3uF2K9iTBMAe+gQSrFp4tfP+h65wEroNaCnUbzLvEBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e6enKRMd; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e6enKRMd"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so146268855e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777415651; x=1778020451; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E0ZmwsUWVZw7ULuO0KZSa1cGEHsCk5NnKQ2s4cLc+7Q=;
        b=e6enKRMdbw+DYFZVUNakQFL3PQmqTvmpJ6swXNlgTKcAsemMK7qPWCnlK/8ZCjLS50
         p5dW1nQq9Gr9LhCe8LhO2Ag37vxPJJfgMzBLQwpb+39YwvvXKg6imUJD9gQDlWoP9ILo
         oM1hNLZ8v7umw+bjD/Ynq9s5X4xrMyBixzfhkBlHPO2FQf5vIh12GDD5cCd+XujMgUXr
         8FmVJ1CayJOqQ3X5RlAMjVCrKKCXGbBY+q8M2jsAN7TgxLRL7dd2qY1xHz2pxDvBxfV2
         7VYswZg4tFbACKgcj3Ofsx0p0B16UOGYwwBKCwMV98Cy6lyVLnQDy9afeybwulsd4o6E
         9wvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777415651; x=1778020451;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E0ZmwsUWVZw7ULuO0KZSa1cGEHsCk5NnKQ2s4cLc+7Q=;
        b=ktztjfvZy4yqilnTeTfh0WToPNeNBihDuUm51KvBVurTkVaOb08Hc0eCYUt71HMfDv
         VyovUDw2F7JS6wT4CNJBYWhyZwrDTWEZxB1Y0wtf6Iunym7cCOp7i2lZVnfD7NA/4/t/
         Z+PrPnmHoDIbXSeQNPmjuyJBfEQwEiAkJZs1Jl3M+Uxzk2Rd1Z7leFG2NpBBOoAk8SU+
         0gzx9yCOio3vDQVBa7edSTkqQ304yJ8t86CBiIscC78IFc3Ja4K+EUi5LMoGCx4ZFJBi
         scRVtv5bCVC/ETA562fh0Zxe+BKxq+sppbO6ToRtPO/MukokFrd783v+zHaBArg9A94O
         TB4g==
X-Forwarded-Encrypted: i=1; AFNElJ8tg4jNaVIQnQjZt9NeBwlgcMxMcumCvvxyj23TXFHZMpdnbhdubzc8vDWyqch3+lddmQJGLsQeOkHrxA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxgK8wM2o1eX/+xQtBTYGDQGHYFY+x5cU157/Zo+m1xxBQivbBZ
	/lomJ9fMagWulV4w0fp+GeeUMXjDCpBj94QPaoocghQygylFy/HPIOkqAfAAr2W6xyh8ocp0Wl6
	Q2SKrNsk=
X-Gm-Gg: AeBDiesH/lE4wkFONxIX/pCah3SMWRNwtnTEv2VcfxEtll2iKbQc8TUvmEUL6o6o+cF
	Nx9fyqxEFa7fo0t7rBrVlkGXwWtG9cNDctvpjWhfDv2zzmplwZwLOT6lr48A7rNkxMFwuWr1KIY
	uRRXNsiELFUKNcDpntmlHC48/IXpaPUXLvzMrQJfIzBoG41VvgpiNMMUs3hVzie/FGQvniVov9g
	oejNjUueaYG8lJmz9OViuu2RlQCVRUKgnfsD5ZQc5VO+b+7Iwnps3PfKAZirN8z/pbQaSZGd3qb
	r1PECOuNC0o8osjJFBl49uGkJSprm0ASblq27T/5f7Qxojlc5YvDZgSTJALaIq4iDZdMBr+uopC
	KGedaPuXU5b0g2MGZcRNap4ywzs798LpMagCWL3hXAA3D6E2femL1BApLk4psCJiUIeRtnmuYSx
	q7jogAgTnm3viXsTOD+uYyG2bCt5KSucYGILqIkFmgZ74dFqb0BSHXP4yhvS4AmQ==
X-Received: by 2002:a05:600c:8b04:b0:48a:53ea:13eb with SMTP id 5b1f17b1804b1-48a77ad5a7emr76923515e9.5.1777415651535;
        Tue, 28 Apr 2026 15:34:11 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed5a0482sm102718b3a.12.2026.04.28.15.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 15:34:10 -0700 (PDT)
Message-ID: <2db03a4c-7af5-486e-a921-56145087a3ac@suse.com>
Date: Wed, 29 Apr 2026 08:04:06 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
From: Qu Wenruo <wqu@suse.com>
To: brainchild@mailbox.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
 <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
 <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
 <KAR6ET.BWL8BEMZPLSV@mailbox.org>
 <0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
 <d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
 <19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
 <06Y7ET.5XM6UHU999Y21@mailbox.org>
 <70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
Content-Language: en-US
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
In-Reply-To: <70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/29 07:53, Qu Wenruo 写道:
> 
> 
> 在 2026/4/29 05:00, brainchild@mailbox.org 写道:
>>
>> On Tue, Apr 28 2026 at 04:11:05 PM +09:30:00, Qu Wenruo <wqu@suse.com> 
>> wrote:
>>>
>>> I strongly don't recommend to use swap files on btrfs, as you have 
>>> already experienced the limit on scrub, and I believe a lot of end 
>>> users are not aware of all the limits when using swap file on btrfs, 
>>> please check the long long list of limitations in "SWAPFILE SUPPORT" 
>>> of btrfs(5).
>>
>> Is it expected that the scrub operation cannot function properly if 
>> the volume has a swap file?
> 
> Yes, scrub works by iterating each block group, and to avoid concurrency 
> modification, scrub will mark the block group RO.
> 
> But if there is a scrub covering even one block of the block group,

Typo, "scrub" -> "swap file".

> the 
> block group cannot be marked read-only, thus scrub will skip the whole 
> block group.
> 
>> I never before observed such a problem, nor find any mention in the 
>> documentation.
> 
> OK, btrfs(5) only mentions dev-replace, not scrub itself.
> 
> Something we need to update it.
> 
>>
>> The specific restrictions, as documented, for the swap file, seem 
>> completely compatible with my use, a single partition with no data 
>> duplication. I have no need for spanning devices or duplicating data, 
>> on the particular system.
>>
>>> Any dmesg of that RO flips? That indicates the fs flipped read-only, 
>>> which is a huge problem by itself.
>>
>> No. There are no kernel messages that are errors for the file system, 
>> or switches to read-only.
> 
> Then how did the problem of failing to create new files happen?
> 
> Any extra output when that happened?
> Just returning -ENOSPC error messages but the fs is still read-write?
> 
> Then it may be not enough meta/data space left.
> 
>>
>>> Especially with your initial info, there should be enough data space, 
>>> metadata space is less ideal but should be enough.
>>
>> I have read that the space allocated for metadata is expanded as 
>> needed. Why would problems follow from too little space being allocated?
> 
> Because you have no unallocated space so metadata can not be expanded 
> anymore.
> 
>>
>>> Considering how many snapshots you have (triggering qgroup lag), I 
>>> strongly recommended to remove unused snapshots to free up space.
>>>
>>> After freeing up enough space, then try to balance data block groups 
>>> to make space for future metadata usages.
>>
>> The situation with balance is quite confused.
>>
>> The problem with the reported lack of free space first occurred 
>> several weeks ago. At that time, I deleted snapshots, and ran balance 
>> operations with incrementally higher usage values for data and 
>> metadata. By the end, I had run the operation, without reported 
>> failure, with values as high as 95%. Normally, such an operation would 
>> be very long, but in my case it finished in less than a minute. Also 
>> by the end, only about ten blocks in total had actually been reported 
>> as moved.
> 
> But your 'btrfs fi df' shows the other way, a lot of free data space, 
> but not much for metadata, and still no unallocated space.
> 
>>
>> Perhaps my installation of btrfsd has been successfully maintaining 
>> the balance for the volume. The system logs are not extensive enough 
>> for me to know when it last performed any operations.
>>
>> Regardless, it seems that the general problems are not becoming 
>> resolved by invocations of balance.
>>
>>
>>
> 
> 

