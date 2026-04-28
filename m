Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D298366823
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777415185; cv=none; b=a9W106tn0vQboBQf3kNhIM7Z2LZcNFZh54tDhuZXfZXRG3BF4bdtLhi8m64evrKWf5vy8ZRciwsqHxhrPnfbOI6j8KGgbAQmv887QtdH6kjsIHVor0PUjpHfsAsxnWYA1HpOU+BtPJUrcUflZb3YlCtmyUAieNiwqjFa/hfiXng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777415185; c=relaxed/simple;
	bh=o4+QeUl7/jv1Lt0ljGBvneP0QCldoph0PwpfpXCqsZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mo/WcTg5Iu/C3MuPYMGKDzdtaP5FC8qlbRWhyVQW4uWPaG0yikzfbxZ5t35gmWZWnKrzZHCzviJPjDTf2NOR/p7GQpYGZ3+T9vB/aLERVQRj3NNZwMzKbzIuIpCtkw7nvVjCEzB6HlTKO2SDezlNBhK+ykYPBCpnDfep1UWDzek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VMduLaOZ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VMduLaOZ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso98949465e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777415181; x=1778019981; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zR8kkKsoTZDBRZ4jGT8i3ui420C8gQKeaHGJ7lN00C8=;
        b=VMduLaOZD99IV+k7Ec3IJICRRHea8MfxqjQKBXO5maPI5UAfLbRuBm9zY9Qpaj706j
         EHOBN5+BvXmSYixGYXvSG6Pcp1VgM1iTXm+5Px36tmqAGjXyxa6wjQPOZgxnoU7e06fu
         kkf3R6mN+HDFdTF/4vQsroIrVlztNQmkPdfrF2TEhYaL72M9dGQsT/JzlwK+xNcEY31K
         8uvkziha1xujGysZ/zV5PyvXuruLNd2ubyvt+VFoNPiRKlfqpHUj8rchFlRI9J1PyNlI
         2T3c6SSGxOyRGtnVFY1GyLPpKDOIlErPUnzYBktrS9MUlE0sjVM3xCOt/Es4gDAajD5x
         D9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777415181; x=1778019981;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zR8kkKsoTZDBRZ4jGT8i3ui420C8gQKeaHGJ7lN00C8=;
        b=A5NCcjmWljgg0kI7lXssG2RyID8W434Y33vd8wKxx4LEmyfVx8Syf4LoqgqscB22wJ
         x2ytI0cmjs3gGtqf8PgOBc73ldL7g9Ez6SXiJWEQnENTxUwKB4NNtEvbQ9nTdWeIXkSx
         p6ghyIsd06ogGMvnkGsN8pv6B+pSxxkHo6l9jxyLPCwdvcahpf/Rd+NF6lNWvTNIr3t8
         smv6If0LlS4t053UbnQEmTfogveevFS66Sdr6NyQM/eibeZcjhQ4yXi/D/f7U5hQGI9h
         Y8WbQj6JsFwM8LzuvSkt7v0/uOOPaZPihYlBDaRr+eeyTnweKfElaQJnZ7TyQfLlkhqr
         5lNw==
X-Forwarded-Encrypted: i=1; AFNElJ/CCANHQob2IJ2nENH4dH+ggW7uK29KkpwEgZOaVyi4Ooj7nzPiIx39iisFaLXSC6+etqpEeH9s31phsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyE1Wsyi62gjl/R4R72K9QqT76xKc3Uzo47XtEKKrXJODHuXEM
	rRFhRa8yenMLtP/M+WS1ORHkksm07D/y6k6oJ2kYVsK489ke2Oge+cl5P1tstTtJ8w8Pp/em0cV
	6YFyFeHU=
X-Gm-Gg: AeBDievpH8zLoj2jKYmDwltas99yeHzlgtJ6WgHZrwNkBX+UOU2Zcry9YPjGL+Yr7xn
	7y+MssS6eiBL4amQvfRPlE4YYgUFahxcc01qVLLbsUJUQPs2kwVIiNcKhV9HI4RzlAdcanUn8iT
	ftunM5yXJPASnCU3U3C8sNMwhAT7t4Gr+gj6iXBcBJFwh9txwcSTdB8XVAElswM7Z8Y7TVxskOd
	XB/1hvLH1luYzWAObdw8HYk8oX0GRC9+7cU8yDGQwi/wRnH1XQsR588+Cw6kE3MgHvYjssj7PYO
	WYW0uwr2mG1/JJq602LESG6H8QlBbkhYH++M3s4dKlaXK0Phy/m/ATPPKSShwPktq6EuArAG5Xw
	FVd6adsbLRl+qpw1FXBddjkU2ZPUMb0P/6Su9RYxBHvYu4X0OgVUHttWnasEsJ/AShFGG/Rziby
	ysmlfIpADSwB/Gvg78hbBP41cM7myhy/SjLQJ/VpjCvvmF/oBOxWKVle9hNerRYg==
X-Received: by 2002:a05:600c:1d1a:b0:489:201c:dc46 with SMTP id 5b1f17b1804b1-48a77b04774mr74856885e9.12.1777415180974;
        Tue, 28 Apr 2026 15:26:20 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b98893f053sm2432655ad.45.2026.04.28.15.26.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 15:26:19 -0700 (PDT)
Message-ID: <d3e1af7d-fa08-407b-894b-46d6ba3626cd@suse.com>
Date: Wed, 29 Apr 2026 07:56:14 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild@mailbox.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
 <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
 <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
 <KAR6ET.BWL8BEMZPLSV@mailbox.org>
 <0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
 <d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
 <19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
 <06Y7ET.5XM6UHU999Y21@mailbox.org> <A168ET.AOECEOR9CWSE1@mailbox.org>
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
In-Reply-To: <A168ET.AOECEOR9CWSE1@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/29 07:49, brainchild@mailbox.org 写道:
> Further to the comments in the previous message, I have also found some 
> messages in the kernel log, from the balance operations, which may be 
> relevant.
> 
> As the console output of the command is "ERROR: error during balancing 
> '/': No space left on device", the kernel messages are as shown below.
> 
> ---
> 
> balance: start -musage=50 -susage=50
> BTRFS info (device nvme0n1p5): relocating block group 4126692868096 
> flags metadata|dup
> BTRFS info (device nvme0n1p5): found 9279 extents, stage: move data extents
> BTRFS info (device nvme0n1p5): relocating block group 4126155997184 
> flags metadata|dup
> BTRFS info (device nvme0n1p5): found 6365 extents, stage: move data extents
> BTRFS info (device nvme0n1p5): relocating block group 4125149364224 
> flags metadata|dup
> BTRFS info (device nvme0n1p5): found 10145 extents, stage: move data 
> extents
> BTRFS info (device nvme0n1p5): relocating block group 4124612493312 
> flags metadata|dup
> BTRFS info (device nvme0n1p5): found 11487 extents, stage: move data 
> extents
> BTRFS info (device nvme0n1p5): 1 enospc errors during balance
> BTRFS info (device nvme0n1p5): balance: ended with status: -28

 From the dmesg, you're relocating only metadata block groups.

Meanwhile all the free space is inside data block groups, you need to 
balance *only* data block groups to free up space for metadata.

Not the opposite.

> 
> 
> On Tue, Apr 28 2026 at 03:30:00 PM -04:00:00, brainchild@mailbox.org wrote:
>>
>> On Tue, Apr 28 2026 at 04:11:05 PM +09:30:00, Qu Wenruo <wqu@suse.com> 
>> wrote:
>>>
>>> I strongly don't recommend to use swap files on btrfs, as you have 
>>> already experienced the limit on scrub, and I believe a lot of end 
>>> users are not aware of all the limits when using swap file on btrfs, 
>>> please check the long long list of limitations in "SWAPFILE SUPPORT" 
>>> of btrfs(5).
>>
>> Is it expected that the scrub operation cannot function properly if 
>> the volume has a swap file? I never before observed such a problem, 
>> nor find any mention in the documentation.
>>
>> The specific restrictions, as documented, for the swap file, seem 
>> completely compatible with my use, a single partition with no data 
>> duplication. I have no need for spanning devices or duplicating data, 
>> on the particular system.
>>
>>> Any dmesg of that RO flips? That indicates the fs flipped read-only, 
>>> which is a huge problem by itself.
>>
>> No. There are no kernel messages that are errors for the file system, 
>> or switches to read-only.
>>
>>> Especially with your initial info, there should be enough data space, 
>>> metadata space is less ideal but should be enough.
>>
>> I have read that the space allocated for metadata is expanded as 
>> needed. Why would problems follow from too little space being allocated?
>>
>>> Considering how many snapshots you have (triggering qgroup lag), I 
>>> strongly recommended to remove unused snapshots to free up space.
>>>
>>> After freeing up enough space, then try to balance data block groups 
>>> to make space for future metadata usages.
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
>>
>> Perhaps my installation of btrfsd has been successfully maintaining 
>> the balance for the volume. The system logs are not extensive enough 
>> for me to know when it last performed any operations.
>>
>> Regardless, it seems that the general problems are not becoming 
>> resolved by invocations of balance.
>>
> 
> 
> 

