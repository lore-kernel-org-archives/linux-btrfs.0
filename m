Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269362F12AB
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 08:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104590; cv=none; b=qXxi3dvucY5PWKElml1g3hLZyu57f1afQcufvWIT4vvyZel05nL9TOfWlXJaPWegn3OyJaqGQnW7zG8Vv1zpQqcxYECQbh/eKJkZUn8WI+XqEscV+di2aFhVa5koEuDgEbiSPniaF+M8YVSFq/t6aEKkoZjxvhGRByIvqXG1rik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104590; c=relaxed/simple;
	bh=GAa37XiTfPVeownbQJR3Sb2ocRzPWWO3fIquqgvpPuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=huPgk8kgo3tgCusz+eB94qdzuYSs8deUNlMiFcRA0SMGgm219NJjKNDntSbwRKx1Xt7sYiZqZp1tpCmCZtBkyE58+rdkgvB31jC5rEiLNtQX/CjsDB8tPap4bXpTF2JH90lrLbD/iM/r/iLk2iqrnz7mm0XroJzNKPv7HeNjfBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UylaNxsb; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UylaNxsb"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15b509c323so675429366b.0
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jul 2026 01:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784104587; x=1784709387; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=k38sBdLMbGONuypYtaNK+jTJJBRsToY/SEh6Oq2yFVY=;
        b=UylaNxsbXSrWMtMdDJPj4a5PQXuV2K57CCCQ9Ci6oelfO0z9FaazGg6AmA4PaQBXXX
         rFFn6SAXhOjC4LfJkjSNr1DT0Bo59IgreKOXl4Wd3zZevMKiHTuUCvw7qwZGFhRQJLyW
         YwUBk7AsJQjwjqaCLLm3twWP0DAryBZW+/L47OE+m5hMbSv+bONZrDRmnRFEeiOzTKr9
         magejcxZUhexYGbBC3Urv9uzC6WTMJ7+LCQYftHRqY10o41H7+z/m2k2ndxbqfBzuPs5
         MDZAbPY7VN2Wdf7e7u7uzGjKiWhUr5vCedoqEIZ0yQ/LBIcsmqMs9xLsPwXs92S3Ig+u
         j/+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784104587; x=1784709387;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k38sBdLMbGONuypYtaNK+jTJJBRsToY/SEh6Oq2yFVY=;
        b=p4MNenrC0aQPCfIeiI0W9fK4R3Hv/iBZE0hu6jcWC1t2IsDbCRWMkaKv0R6BzgdbVr
         XLUkl5QAdFAuOh/GQUkVDAs8JGv4CscMIt141qN0bShW0Nz7WpHqd8YfZavRxezlcx/W
         wp54PiB1DN1BR9kblqVaE3ebuznFzjM7hwArzlQtDIZ4AMqXTA5sqF3Fk6wMC57jN9Cm
         AA6IWdzP0e5GQlftv1rMTbWLxxKgccA6bpGkImsv8D9yDrdra/DvyK0BNQvAwTfOCcLC
         xi8mvlkW8isTb/uz8A5Osm8B5inZWzwW+geBheXMabEbMw72S52ko8hBfyEoJBCY+Acp
         lPkg==
X-Forwarded-Encrypted: i=1; AHgh+Rp1qQzQAT0ecbZeG0dwCJsgocW4UBNQvpNPNyc27aD5voBA9Ejg2hTf/IANOWIXcqJIypnHzt40rrwlXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoDs8VkAZnVtrezeDwGdsYuqy7J+XNinacERR1vuzQRfSqOzz/
	aXSLTjIPYoMk+SItTou4aJ9l2mnaPac5yEDsmD4iglJEY7KokCORlavK3pi4pOw53W4=
X-Gm-Gg: AfdE7clkWLtGRmR386+D/kW7A77xvOoEhh7r+JMeNZSsi92Tav5icAAPVqYYhOmI4at
	YF/oDdm82Cs2zad3aHSYEryUy4Z2yZjv6z3NNBS8yLzQDiNffas1ePmUTS6N0I9sPZXAsGOnVxz
	ZlBGtmUppDT0TrB0FUmn6lR3MtKMGtbSPcwuPzMup2oemuiA3/JN9o57WG94hV2XrBkyjLUhTzM
	tR7pgEdu0tZjHgBv9vwtg5G7JJSpYmOOHIlcx+vBEaJ0ISPW9sO7utye8GpHdbF7LAWGUKW1G6v
	RHOj5A2WJbMyBNb/yW++YgEbYl7QqDyhnGhabXpQZ/fIq9HQZNIfTixRisy/E6IGxZbrN7AdJtA
	NsEbt66eHAyHDaEzvl56PbwAk8pZKcMvNf/g5EebpWvqWHn/KCs+g3Q/hZy2UNYVYbXbfr6IVYy
	i2Hf0p3w==
X-Received: by 2002:a17:907:3f22:b0:c16:64e5:1777 with SMTP id a640c23a62f3a-c166793e894mr321048966b.17.1784104587156;
        Wed, 15 Jul 2026 01:36:27 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bfe040sm130297785ad.31.2026.07.15.01.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 01:36:25 -0700 (PDT)
Message-ID: <8248f43d-d6ab-47e4-9ed9-65bb5c281f4b@suse.com>
Date: Wed, 15 Jul 2026 18:06:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] two raid consistency bugs
To: Zhang Boyang <zhangboyang.id@gmail.com>,
 Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@kernel.org>
References: <20260714161044.7330-1-zhangboyang.id@gmail.com>
 <67cff567-1070-4908-a253-a8907d237734@gmx.com>
 <4289be1b-285c-4641-a7b6-6b8e66f458c6@gmail.com>
 <5eaba968-b8b9-4705-9027-9169942e105f@suse.com>
 <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
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
In-Reply-To: <8e02253e-2bd2-4ca1-8def-f91afaac4cd6@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/15 17:08, Zhang Boyang 写道:
> Hi,
> 
> On 2026/7/15 14:10, Qu Wenruo wrote:
>>
>>
>> 在 2026/7/15 15:16, Zhang Boyang 写道:
>>> Hi,
>>>
>>> On 2026/7/15 05:40, Qu Wenruo wrote:
>>>>> At first power failure during transaction N, metadata trees of
>>>>> generation N are written to disk A, but super is not committed. 
>>>>> Nothing
>>>>> is written to disk B.
>>>>>
>>>>> At second power failure during a different transaction N,
>>>>
>>>> If it's a different transaction, why it will still have the same 
>>>> transid N?
>>>>
>>>
>>> Because the power failure occurred just before writing superblock 
>>> (transid N). The superblock on disk still has transid N-1.
>>>
>>> After reboot, looking at superblock which transid is N-1, btrfs has 
>>> no idea of transid N existed previously, so it uses transid N for new 
>>> transcation.
>>
>> Then there should be no problem at least at the next mount after the 
>> power loss.
>>
>>>
>>>>> nothing is
>>>>> written to disk A, but metadata trees and super is committed to 
>>>>> disk B.
>>>>>
>>>>> This creates a ambiguous generation N in two disks. Currently btrfs
>>>>> can't detect this, and can lead to severe damages.
>>
>> At the next mount, btrfs should detect device B has the latest super 
>> block, and use that as the super block to mount.
>>
>> Since metadata are all written to device B, even disk A may have some 
>> stale tree blocks with transid N, stale tree blocks still need to meet 
>> other conditions like root owner, level, first key checks.
>>
>> I won't say that's impossible, and won't say we shouldn't do anything 
>> to address it, but this is a variant of the split brain problems 
>> mentioned in the past.
>>
> 
> I think this is a very special variant of split brain problem. This bug 
> can occur even if no degraded mounts are involved. All devices are 
> presented to btrfs at every mounts. Personally I don't like to call this 
> bug as a split brain problem because I think split brain should only 
> related to degraded mounts.
> 
>> I strongly recommend to find out that thread and check if any of the 
>> ideas are explored before and if they have their limits.
>>
> 
> I did read some of these threads. If split brain problems are solved, 
> this bug can be solved as well. But I think fixing this particular bug 
> is also beneficial.

I do not agree.

You're introducing more and more code just to handle some very specific 
corner cases.

E.g. for your particular case, you will need a very specific write 
situation. You're introducing a feature that is very hard to hit under 
most situations, but we will always bear the burden.

I am not even sure if you'll still contribute in the next 5 years, thus 
I won't bet my 5 cents on that this feature will be properly maintained.


To me, if you really bother this particular situation for whatever 
reason, just introduce a special harden mount option, that any 
barrier/super block write failure will mark the fs error.

That will be a much safer bet than any of your proposal.
