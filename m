Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D4542FCD6
	for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 11:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787137730; cv=none; b=QHOKKzlxPtSyWmAz1iOHRSkAARXG3wO0rqsOOQfoGC1paZB9RydQZYbdVAA6IKnYKFNjTmag78VnTSgtLWNRfWPe3ss98xNxv2IeHYu5w1OMar5BRcyDULorPJE9mMp89jcNUEaRTKon8FFe5jojcRoX/gfcWIMZlIh/ntG9jjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787137730; c=relaxed/simple;
	bh=Chay9CbOtK7UDh/MIIipCiyDdsy/tGaRdcvqJdmDsUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ohURtYQ05iO3Nr3aCywNuxum5DUY8CyeXVOatQVvdKno3RNsQLx+gcj8f6m6u13vQPhkNMCNO28arkel5xRbqvxjMXrJuB1WkDZc+oLUnXKs7kCb26P1m9EKt1SaJ/SzRO9HBdCikThF8OzsEjxUqSlNnUk7vf+jb3ckHQLSvVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AklI7bie; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AklI7bie"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a38098734bso939143a12.1
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2026 04:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787137727; x=1787742527; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KN+Agp2jzxs0UoJZB7F3SrdDoUz/54GOpQeSta3r0OA=;
        b=AklI7bie/mvyuqVd5FEzO5ylB7Ixk5Zn8j84sYfG28XpWRKJXQ0tO/pWMAd6Ru0btF
         AYHQGqlP4jl1Y4N/5OC5q+9CF9+aCYic0IhxvvwmhP8ynw66ZetAZTMqDoM2e3d8ije3
         McYn7YwRqFpQ3GwgWxcbY6bcTUHsy1FOLdku40JrjB/nPhBxGXX6AG7pCXoxuymDQRVX
         uqqeTMrK1flNQ3Fqd/V19zGkxqMnGyL6Y12ncsDBgy703QmMr+wiPF6YNJTfxj2JxVeC
         PHD2uuSLEVTaPk0G/sNEZCUqGJ4ckVsqHa3MAhT4aXw7K5hX/UjznejK0TQef91mPIJN
         SsqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787137727; x=1787742527;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KN+Agp2jzxs0UoJZB7F3SrdDoUz/54GOpQeSta3r0OA=;
        b=QriNOzxXhCnvV7caOHaSZzt4v99t4GKv4hTsh771bL2FrgcDm8n7xoLFXuSnbDuXug
         k39Ea69fOqEC+BRty5yyl2tcxfkzkqPNhG3DwjtyGhxPe9+dZHmV0Byr4t4zv7ET2dcS
         IvobHjXT4dDSbyLY1jXBM3JghcCpV9mk2WW6OmJo1utH0f+/hcAPT40pMVCKAfGKpJg0
         HbzfCEms2dm/ki+ie+7XnhDeu3Q0FisD/WN/BXDUi7+R9cENfpAeaeci4yLWCRzcBl+v
         DdRUcOntG3CD9yUxYvFM445+MGxF4AOOzPVjKOs6Z7zr2efYXxU/IYcD3Q2dJPSGKCCi
         Rcxw==
X-Forwarded-Encrypted: i=1; AHgh+RomhxI4eAhNvGqYdsh0E8yZd3RE+ZhoGboIHTjHp+CSaIYLgoCYsc+2ntB6kv40WYcz1xogZeFBE/F6NQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd4mWQDKR1FjBIVaie6kO8Y7dVxdiVG+g2iwqz5MEPI6O4SCIE
	Hc5uSzoqsdpWp+sRJ2zQN3Uff0sJCHXOghPtzUOM4ElD5RRLcWlrNfzCUIxdI09zPLE=
X-Gm-Gg: AR+sD10ER2T8TXk6dTeWi30dXx3MYfuGpafi7OGuqC6cS4WMtf4oMLSbOOCawook2QD
	zzv/VJIFr72Po4CU7/Vy0GJSA1bxASxvNRK7DdsNWHGsIVBxrqbEEklxAo4dQEnj8EI+o6lrr0u
	zxR/Wvo31y87z+FzGPGu0npyTci35D46qE8wo4FECSgYOrBV5q8JDIQkU5wX3Q/2WtsCD3nXKYS
	1p3Y5f99z0suDIOVwvAmfkh/MedPc2ZmJN+mYINE6ciROnZ2yE89W26JcMDBtyqOSbls183eVT5
	6Bpckm+dhVFVP/TP70Nm3lRvAZwR2nVYMtvrRdZqp8xBaCNcOpBtlg5LeMrZLtzy0IUZ8xDm8BQ
	ZKnvLvBRk6ENA9bHbIFJRx4vGwohniX4xcP9PrraVWNUnaOL9e2wAoNcL21EMX+vn2sUJxkuSFS
	bSTG18VKvvb7XipuSrxTPAPOJNPtBlAJhdMYSL3V3WsDkqjDf4CiDv8A==
X-Received: by 2002:a05:6402:13c5:b0:6a1:c908:1701 with SMTP id 4fb4d7f45d1cf-6a40335fa9emr1964509a12.13.1787137727001;
        Wed, 19 Aug 2026 04:08:47 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1416ad3dd20sm5592984c88.3.2026.08.19.04.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Aug 2026 04:08:45 -0700 (PDT)
Message-ID: <acce0131-c494-4560-8661-a3e1a69a40ea@suse.com>
Date: Wed, 19 Aug 2026 20:38:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: zoned: finish active block group cleanup if
 call_zone_finish() fails
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Naohiro Aota <naohiro.aota@wdc.com>
References: <20260819102636.1423347-1-johannes.thumshirn@wdc.com>
 <cd693c05-8b33-4888-a0f2-318183625633@gmx.com>
 <9893c77f-eb82-44b6-bfe7-ac931be762b5@wdc.com>
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
In-Reply-To: <9893c77f-eb82-44b6-bfe7-ac931be762b5@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/19 20:14, Johannes Thumshirn 写道:
> On 8/19/26 12:36 PM, Qu Wenruo wrote:
>>
>>
>> 在 2026/8/19 19:56, Johannes Thumshirn 写道:
>>> do_zone_finish() clears BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE before finishing
>>> the zones. If call_zone_finish() then fails it returned early, 
>>> leaving the
>>> now inactive block group on fs_info->zone_active_bgs, leaking its
>>> reference, the BTRFS_FS_NEED_ZONE_FINISH waiters are never woken, and as
>>> its alloc_offset equals the zone capacity btrfs_zone_finish_one_bg() 
>>> keeps
>>> selecting it, spinning btrfs_zoned_activate_one_bg().
>>>
>>> Fall through to the cleanup on failure too and return the error, but 
>>> keep
>>> the block group read-only as its zones are left inconsistent.
>>>
>>> Fixes: d70cbdda75da ("btrfs: zoned: consolidate zone finish functions")
>>> Link: https://sashiko.dev/#/patchset/20260818100037.1366563-1- 
>>> johannes.thumshirn%40wdc.com
>>> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>>> ---
>>>   fs/btrfs/zoned.c | 10 ++++------
>>>   1 file changed, 4 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
>>> index 82c2394dd43c..9d448cdd60c4 100644
>>> --- a/fs/btrfs/zoned.c
>>> +++ b/fs/btrfs/zoned.c
>>> @@ -2628,14 +2628,12 @@ static int do_zone_finish(struct 
>>> btrfs_block_group *block_group, bool fully_writ
>>>       for (i = 0; i < map->num_stripes; i++) {
>>>             ret = call_zone_finish(block_group, &map->stripes[i]);
>>> -        if (ret) {
>>> -            up_read(&dev_replace->rwsem);
>>> -            return ret;
>>> -        }
>>> +        if (ret)
>>> +            break;
>>
>> I'm wondering should we continue to finish the other stripes instead?
> 
> But then one stripe would stay active, leaking that HW resource.

I mean, if we have 3 stripes, and the 2nd stripe failed to be finished.
Should the remaining two be finished, or only the first one be finished?

I guess it doesn't make much difference, as for one call site, we will 
mark the full fs as error, but not all call sites are doing so.

That may be something to consider later though.
> 
> 
>>
>>>       }
>>>       up_read(&dev_replace->rwsem);
>>>   -    if (!fully_written)
>>> +    if (!ret && !fully_written)
>>
>> Not familiar with zoned code, but if we hit an error, the block group 
>> will stay RO.
>>
>> Is that the expected behavior?
> Yes. If zone finish fails for some reason it was probably a hardware 
> error on that zone. So my take was to leave it RO to be safe.
>>
>> The branch for bg with FLAG_ZONED_DATA_RELOC case, we return -EAGAIN 
>> but decrease the bg RO before returning.
>>
> But in that case call_zone_finish() hasn't been called yet, so we don't 
> know if we have an error from the block-layer/hw side.

OK, makes sense.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu

> 
> 
> Hope that makes sense.
> 
> 
>> So it looks like we should always decrease the bg RO even for error case?
>>
>> Thanks,
>> Qu
>>
>>> btrfs_dec_block_group_ro(block_group);
>>>         spin_lock(&fs_info->zone_active_bgs_lock);
>>> @@ -2648,7 +2646,7 @@ static int do_zone_finish(struct 
>>> btrfs_block_group *block_group, bool fully_writ
>>>         clear_and_wake_up_bit(BTRFS_FS_NEED_ZONE_FINISH, &fs_info- 
>>> >flags);
>>>   -    return 0;
>>> +    return ret;
>>>   }
>>>     int btrfs_zone_finish(struct btrfs_block_group *block_group)
>>
> 

