Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFC94B0498
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Aug 2026 02:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786932984; cv=none; b=P7qvzNiKBS8ztvleVsrP0SWCDajNuEClKaSpM7ZpK+1dNnLEKGgKG7tZgyWy5NizQaC6QKgjp1RTrKpdO0cqhAvDEL9oCMOZkxBjW4AjdHd0qnPlCudRQbdoNSZcsEn3W9Zfhoz/ONZ578okgKAJSH7Hl5WwRm9cG/5yotymE/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786932984; c=relaxed/simple;
	bh=PPIilJMuXQQgzxJZanfJ6yCDNlDffmSPOPlk36npJQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qeWnqbyHPnvTCyZ18R7A+tD+3Sc4wOUEI8CnaWZgp1v8UxLu4NnOUTEEqPOO0DqFu0Ni0ADGweMSZd1fF4XE1jttDPpi7utbT2QBJ57bI9D0ov3fYF5bY4twtTnmCvndVBsEe/+AcZgZ954r2sRWLl/fi+awyAC2PL+oakDmE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K9DLu62L; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K9DLu62L"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so14307075e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Aug 2026 19:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786932981; x=1787537781; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+NNcOLY7gGWpzrAGD2lqbQ24aJBpWGgF4a4YeR+kJ/Q=;
        b=K9DLu62L+Nk8gbRSwj5sVWl9IfXdDnWYXwa8iKEhsRTMHtcZkaNafn1IFuaNNoCWdD
         LGEFx0pfTkJsSoFklOxdsEtwDA/hmJxqi7pwlaPRA+zW518yxCxrJ2dQqaBmb7Q9RpXo
         q8CnBiqLvazFcU6mmNMPDxCLejaHCSdFJ2I+ILjeBi4vZIrCy987S5U4scgDVKZOhBCf
         3WrcF4Pj1+3Q3DFb3RPE+hXDyNCGW7R71zIda9sSDemintLFvtpVX0UDpAV8EN5T0mw0
         lA4toKlCOeecY7REwDgCy++FVcFxR5JZXrwWepMTtYjQfHlU9wk0/UX9masVoHOf8646
         RQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786932981; x=1787537781;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+NNcOLY7gGWpzrAGD2lqbQ24aJBpWGgF4a4YeR+kJ/Q=;
        b=R8cQanZIE1PZygXV+R/WvRreBSIvDnnP1N/xYoLMInJ1zSffQ2xXkNnlfjfR/MpTA0
         PGH8pwY4rXEUGcfCFuAr1/TS2IhnGOqkK4gWFt+4KzAKX0NJt5tmbDsD9ndnvbUF4Fel
         bfxaMxitUq3TSZxoc4d6fdlYquiUhggPAdLm4kqyrj8vVbeicGPd1jKKBnx9zYKxhku4
         3LwfrA+zh5+lavW4rqcH4NLAh2zOIBJzjoXZjx1CCOJKH7FYoXh4x/w9x6AJSyy4kuwC
         8BrLbZ3ysBzc5m1MEN6xIc6zVvXmxhpykgg0YfIwNGkP2xzXm1aqhbbl+usQKMpySyHl
         L2hQ==
X-Gm-Message-State: AOJu0YzBzVLJaVz4ymcv0iamoi5jF11T+F/xe2RnGQk7nElEoby1oRY3
	ziU7jOuUdDSIpeeW3gCaM9Nf6+TBYRHvT/J+D5zp3cuTpkj7XGt5IB4W7EWIo4K2jzjYG+rZ6uk
	gfPl84yYayA==
X-Gm-Gg: AR+sD10wNP76AJ87peXTMmJsOvUAPDMzW3G7H/BHkVPF+Fczi1EIoRkUzR9pzv52m4T
	B3EZved+zMxNzg4531trOBTgmhEOYws1RXDi/ZqXTDvGGUaF8J8OBOPXdDVhJGWXzzhwk+J1c+W
	CaEXObHGw43LVxLR+vfJDLh8PBWox2V8MAHVNN828x8lcu3BFQR51Jqu4mifH0u0O4qXCTlyQPx
	OtFsWH8DCGm2ZXo+Qzs1yBJiQhKoWy4WBvkNxl3ZnJZf/wO9FVXEPSJ3Or2WjEJYQjjYNQQEEoe
	depCBDTjWJvzMMluYjqd5Hix8svoq6Ojoc54d1+bBVr31HN3It2oESNURPlfCRzYELzE2MUuWaM
	HzyMQ7ZHQe/8Cygn0dvs7+ykoPHgvQnC7/slhYQtA76zfItKqWzUBVrMEZ9xD5rEgfkryleZ12P
	02NaUWrNpXB8shNWUWlH7Z6qaj1xKuUY0mULn5yS/2Qmn2gBtMQi1bIA==
X-Received: by 2002:a05:600c:4614:b0:499:858f:2653 with SMTP id 5b1f17b1804b1-49987929193mr219076085e9.2.1786932980820;
        Sun, 16 Aug 2026 19:16:20 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3267c8972d2sm405653eec.29.2026.08.16.19.16.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Aug 2026 19:16:19 -0700 (PDT)
Message-ID: <f599c558-ef49-42d5-8818-839a273c5994@suse.com>
Date: Mon, 17 Aug 2026 11:46:14 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: fix transaction use-after-free in raid stripe
 insertion
To: Shuangpeng <shuangpeng.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.com
References: <20260817012733.2962781-1-shuangpeng.kernel@gmail.com>
 <267b4f65-9afb-4997-ad26-d1ff5addce9f@suse.com>
 <501EF29A-2130-40F7-B369-F94A9F3DFE52@gmail.com>
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
In-Reply-To: <501EF29A-2130-40F7-B369-F94A9F3DFE52@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/17 11:39, Shuangpeng 写道:
> 
> 
>> On Aug 16, 2026, at 21:58, Qu Wenruo <wqu@suse.com> wrote:
>>
>>
>>
>> 在 2026/8/17 10:57, Shuangpeng Bai 写道:
>>> If allocation of a RAID stripe extent fails,
>>> btrfs_insert_one_raid_extent() aborts and ends the transaction before
>>> returning -ENOMEM.
>>> btrfs_finish_one_ordered(), the production caller through
>>> btrfs_insert_raid_extent(), still owns the transaction handle. It handles
>>> the error by aborting the transaction and then reaches the common exit
>>> path, which ends the transaction again.
>>> The premature end can free the handle and drop its transaction reference.
>>> Transaction cleanup can then free the transaction before the caller's
>>> second abort accesses the handle and transaction, resulting in
>>> use-after-free.
>>> Keep the abort at the failure site, but let the caller's common exit path
>>> end the transaction once, after it has finished using both objects.
>>> Fixes: 02c372e1f016 ("btrfs: add support for inserting raid stripe extents")
>>> Cc: stable@vger.kernel.org
>>
>> Please disclose LLM usage.
>>
> 
> Hi Qu,
> 
> Thanks for pointing this out.
> 
> I used Codex to help generate the patch. I had confirmed the bug with KASAN,
> and I also verified the proposed fix with my reproducer. With the patch applied,
> the reproducer no longer triggers the KASAN report.

And a full fstests run to prevent regression.

> 
> I will send a v2 with the appropriate LLM disclosure tag.
> 
> Thanks,
> Shuangpeng
> 
>>> Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
>>> ---
>>>   fs/btrfs/raid-stripe-tree.c | 1 -
>>>   1 file changed, 1 deletion(-)
>>> diff --git a/fs/btrfs/raid-stripe-tree.c b/fs/btrfs/raid-stripe-tree.c
>>> index b210371ce91e..89e259a47d8d 100644
>>> --- a/fs/btrfs/raid-stripe-tree.c
>>> +++ b/fs/btrfs/raid-stripe-tree.c
>>> @@ -337,7 +337,6 @@ int btrfs_insert_one_raid_extent(struct btrfs_trans_handle *trans,
>>>    stripe_extent = kzalloc(item_size, GFP_NOFS);
>>>    if (unlikely(!stripe_extent)) {
>>>    btrfs_abort_transaction(trans, -ENOMEM);
>>> - btrfs_end_transaction(trans);
>>>    return -ENOMEM;
>>>    }
>>>   
>>
> 

