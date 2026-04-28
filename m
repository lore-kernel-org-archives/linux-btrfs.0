Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6734372ECB
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777416649; cv=none; b=JJ9Lk6UpYrWXizBHG4eb6G985frZFArsz2j4l2EvZnsGoIM9MigCgMr7mUQtG1RLtUELW/zSfuG8fcE1r7GCerkXYPQTajM6+D+ZAUzBR/SSKBgK8p05QvUxt/7r5KFf05+wrcsjAxPrC+IwyIh96NBBNT5dIRQHy+ERsrdwMRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777416649; c=relaxed/simple;
	bh=vZn992v0NLbPdcKB9S65GAKPyWVgx7glcrUpnc3a3nY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=qAV4GdTLMclpCZ7YKDOJdU+acYM/29JPC9CtE/qK+6LLH5lJfDDeMWpj5ijPtq65lKmg4lGypFrJ8M/aeCWSAQ73E51vC59SkgCRPtbxFIsNvKaS1TtKKpXB4jTsUXGJoLEj15gEaupbBBf5aIb+PsjKzPLYS+kkl5NUbFKH0OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JakrkZL3; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JakrkZL3"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso164155075e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777416643; x=1778021443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TOi7+c5S9KfgFFREHImV9lgradocUSjnNYEe7+V5hNA=;
        b=JakrkZL3Lbngd+NysJfunL2C3ibRLwBZ+h2KZsSacdb/v1LtbM0vJYj4kmqRRJUTwL
         pb295SZqNC3/aT0P8AUcnrYmhXiwNffV5lkzgfvy49DWLPfan2RsdS08vB9AxWPSJ5xo
         UKmnTva+VB/rbbVuEmBopV9Eg4WgcKDcwLOnILeO+9QDHNdR/ho2ENf3DSLD2eiUyKN7
         RQo3r3MsexVVg9pg+6ucWWpHBW/WfxzjCl4z/6GTNI91KNnnZW6HwxySZoDr0LXaWu43
         diVuzitgLGaE4M+x3VJBwKALuVXhDvGdwFEJ/Thg26afoqqHU4bIlyVW/5DEjPkS4ywG
         fSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777416643; x=1778021443;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TOi7+c5S9KfgFFREHImV9lgradocUSjnNYEe7+V5hNA=;
        b=bTiWfuyHKAk5bmfBd5M/vyNISVT5ai50Fa8nHn+3GTOFNHiqJvfil52L8NEevtsDzk
         44yRvn8LxCwyNoWsISxrPHejqgQ6jJyTJKzqZT58oH89cab5RAX5BnqMN8IpBClsmBo5
         DdlcWr/Cm2RfRXwCknjJ7nVbWwanyAhoCBE8BIhWYGLJocOW1r5rE42IrL4ncQajgo45
         9b8FWD/YzBUvFY/dr7AfNy6viOCEcEN70SB7mnRGBeX68MYQe779Qs75kP+YabzN7Ml7
         nkfI06ugAOjAZmgY7RIOKoBRl7JST7g4WhI1b0kSPp1dIjzQcWmFpaPHvsHu5wE29jrT
         w7eA==
X-Forwarded-Encrypted: i=1; AFNElJ/L5a5JpvHL2LMehTpY8MDjFdyUCGdrKyQVMXuwDlYvZeua/l5LnFDN220FY191WGuhoHoESTBm44n0dA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjusotWMUPGCNyYOo/cQWy8RuDynt3DzIAuAqCBnmmT9rF37hj
	PqijaxIbraH84RVSg0ADjW8sh8FSo3bEnrR2DejKr+lExK4IsvuuWbS0sUnZOpvH6sA=
X-Gm-Gg: AeBDiesLMsWOMTxhtyO9BDszN+cI3TgptUAQoEJdEEZqljwCdRX5q67xjbHLqhhjVTx
	bm9xVPXpSjrKoY35AhimCNxdzM2MxZd5KqXc/jKbJlofO/hWbSxrFZniGesoA4BwgDVjbbDI6Er
	L4/IorBMnEeDXY4OeiT9uN4ggoVA5HAv6RwFrFbEDm3k16VhwuBUg1tFOGeF03eZjYBYkQFF4cJ
	nvdGcIRl7ACQ6bEYwMiBRyOYpCrslTip2h2vAOXrwHHrghqsrqVd/ymNRGGZ685xGvpJBWIZ5BH
	WcS5lyhrLTeUN8pbuaBbK/pd9FaYkptGi7OV6WerAlZBQO1kjjYCAYx61lLuo49ErLo0mNaSfES
	5aDWl68AuCE97DdAqjw4fNPmQLOxeiy2YrBvKORgWLZ1ZqQ2xkTZbd7OPuNOG8K2q0Q6cTuN383
	FSm+ysKpa8PGk+XfBtyS+USO7kGwb8BnmaQ2CUmucHs4iRgb4OZb3qjiETmjsjqQ==
X-Received: by 2002:a05:600c:2e0a:b0:48a:5574:3a48 with SMTP id 5b1f17b1804b1-48a7b59d1camr13418175e9.16.1777416643279;
        Tue, 28 Apr 2026 15:50:43 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-834ed6dd628sm115740b3a.37.2026.04.28.15.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 15:50:42 -0700 (PDT)
Message-ID: <762ea596-a2b0-4e07-91ef-225a9298c3a0@suse.com>
Date: Wed, 29 Apr 2026 08:20:38 +0930
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
 <06Y7ET.5XM6UHU999Y21@mailbox.org> <A168ET.AOECEOR9CWSE1@mailbox.org>
 <d3e1af7d-fa08-407b-894b-46d6ba3626cd@suse.com>
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
In-Reply-To: <d3e1af7d-fa08-407b-894b-46d6ba3626cd@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/29 07:56, Qu Wenruo 写道:
> 
> 
> 在 2026/4/29 07:49, brainchild@mailbox.org 写道:
>> Further to the comments in the previous message, I have also found 
>> some messages in the kernel log, from the balance operations, which 
>> may be relevant.
>>
>> As the console output of the command is "ERROR: error during balancing 
>> '/': No space left on device", the kernel messages are as shown below.
>>
>> ---
>>
>> balance: start -musage=50 -susage=50
>> BTRFS info (device nvme0n1p5): relocating block group 4126692868096 
>> flags metadata|dup
>> BTRFS info (device nvme0n1p5): found 9279 extents, stage: move data 
>> extents
>> BTRFS info (device nvme0n1p5): relocating block group 4126155997184 
>> flags metadata|dup
>> BTRFS info (device nvme0n1p5): found 6365 extents, stage: move data 
>> extents
>> BTRFS info (device nvme0n1p5): relocating block group 4125149364224 
>> flags metadata|dup
>> BTRFS info (device nvme0n1p5): found 10145 extents, stage: move data 
>> extents
>> BTRFS info (device nvme0n1p5): relocating block group 4124612493312 
>> flags metadata|dup
>> BTRFS info (device nvme0n1p5): found 11487 extents, stage: move data 
>> extents
>> BTRFS info (device nvme0n1p5): 1 enospc errors during balance
>> BTRFS info (device nvme0n1p5): balance: ended with status: -28
> 
>  From the dmesg, you're relocating only metadata block groups.
> 
> Meanwhile all the free space is inside data block groups, you need to 
> balance *only* data block groups to free up space for metadata.
> 
> Not the opposite.

And forgot to mention, balance is also affected by swapfiles.

The same as scrub, a block group (1GiB) will be completely skipped if 
there is any extent of an active swapfile.

So your previous balance runs may also be screwed up by your swapfile.

> 
>>
>>
>> On Tue, Apr 28 2026 at 03:30:00 PM -04:00:00, brainchild@mailbox.org 
>> wrote:
>>>
>>> On Tue, Apr 28 2026 at 04:11:05 PM +09:30:00, Qu Wenruo 
>>> <wqu@suse.com> wrote:
>>>>
>>>> I strongly don't recommend to use swap files on btrfs, as you have 
>>>> already experienced the limit on scrub, and I believe a lot of end 
>>>> users are not aware of all the limits when using swap file on 
>>>> btrfs, please check the long long list of limitations in "SWAPFILE 
>>>> SUPPORT" of btrfs(5).
>>>
>>> Is it expected that the scrub operation cannot function properly if 
>>> the volume has a swap file? I never before observed such a problem, 
>>> nor find any mention in the documentation.
>>>
>>> The specific restrictions, as documented, for the swap file, seem 
>>> completely compatible with my use, a single partition with no data 
>>> duplication. I have no need for spanning devices or duplicating data, 
>>> on the particular system.
>>>
>>>> Any dmesg of that RO flips? That indicates the fs flipped read-only, 
>>>> which is a huge problem by itself.
>>>
>>> No. There are no kernel messages that are errors for the file system, 
>>> or switches to read-only.
>>>
>>>> Especially with your initial info, there should be enough data 
>>>> space, metadata space is less ideal but should be enough.
>>>
>>> I have read that the space allocated for metadata is expanded as 
>>> needed. Why would problems follow from too little space being allocated?
>>>
>>>> Considering how many snapshots you have (triggering qgroup lag), I 
>>>> strongly recommended to remove unused snapshots to free up space.
>>>>
>>>> After freeing up enough space, then try to balance data block groups 
>>>> to make space for future metadata usages.
>>>
>>> The situation with balance is quite confused.
>>>
>>> The problem with the reported lack of free space first occurred 
>>> several weeks ago. At that time, I deleted snapshots, and ran balance 
>>> operations with incrementally higher usage values for data and 
>>> metadata. By the end, I had run the operation, without reported 
>>> failure, with values as high as 95%. Normally, such an operation 
>>> would be very long, but in my case it finished in less than a minute. 
>>> Also by the end, only about ten blocks in total had actually been 
>>> reported as moved.
>>>
>>> Perhaps my installation of btrfsd has been successfully maintaining 
>>> the balance for the volume. The system logs are not extensive enough 
>>> for me to know when it last performed any operations.
>>>
>>> Regardless, it seems that the general problems are not becoming 
>>> resolved by invocations of balance.
>>>
>>
>>
>>
> 
> 

