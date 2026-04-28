Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D851FECAB
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777414991; cv=none; b=OZ4lqG6tMRZd4+gXPyMLfU/4mG1Pr1vwdBBcQQRjpWYHLmqCGdPaZ1fXC3rmH5Re2ufwxtc/9sqAX9EqNnwCWxwNHO+YFkU0GM3gkEqhlQRKHSquDeKryOYlHbODDs6UPxjElKVgKiTvQzg0xkqdqfIktsTRSx/nk4Kt5NOBO34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777414991; c=relaxed/simple;
	bh=MBAfrw16XB1cdsCBSzGKbONSSAcbBLBnge4nfXPaESE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ugAlzPTzfoNYpwUbtGf+k1eAmtNzFbqdOtFCbv4cJ2Y9aKl6qo3Ou70fYlc8xd3NiLlYA/DZhVo32n4hcmtt+oR/w1O8SzQdJafGt2h56+spG/K6sGTXNxivMGvhnO5hfCJKpANVkq2p4O5QnSdYC5sE0rOL/LJWu3/eqn2V4fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OKuP75BD; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OKuP75BD"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891e5b9c1fso103635105e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 15:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777414988; x=1778019788; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNSAwy3zF51D3jyHYD+FnOAb7Iu0jF2sruUGxExYa3Y=;
        b=OKuP75BDsQDLTzWCSe+hU+Msk8c+svmTwENeJ022yF9UV66ch3VYuIbIgLbZBsTHyw
         Fs2ls3vOy126t9CXGvtoKL2Lujj7T2FLlNuJFbS+RA1cYPst/npoqaQhS9f/GfraS2XG
         7dKxqcwMCkI+/uI9aiHdJwEVmCFNqkqtTpTgC4kzNaTFMsPXT4JaTxAk3gxr5G6/N1+l
         l9bjU85Ycy8u8zgnLywfO9a8M9bDkuCXLYE7gRy+25jHi+9pthKFtlcysYIGDFPsSwFR
         zKS18Mblnp85D5zTzde/oyyypaJgcrYK/U57aqCLH3DjKpT651VYzgU2wkRcJVOWiGdF
         sBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777414988; x=1778019788;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZNSAwy3zF51D3jyHYD+FnOAb7Iu0jF2sruUGxExYa3Y=;
        b=LbNYSRefS+rtb9tFmQayz6vhdHFj8V3OjovEbk7tk6yNLLVBCS/7nLaP8fxunJuSjW
         A63BiPPJsDbaBsUEQhJqZdOoF09e4CyIqNW1McRDNtmL5p22zdg+iqBJXaSz0A4clPRA
         xF5BTQCKGb0wqYi2m0z9s8v4ddtLkvmqLb5J0UaF3gSFHmutPxUN+L5nZM6pNQyu0da4
         gwi1ThTOWv83AVRc8M8sgpDLayJNCvSXBYlgjk9kX2dYpXbShbE/ag153WQGVygY71Ae
         uQAZVBsIVi1mrpyx7+M+1Cq16wnHA95+3VmnEfp/lShXnginVRx+hFA1N4g+VwBoZumU
         0fWQ==
X-Forwarded-Encrypted: i=1; AFNElJ9/WFi5tgD/0AbCt6xhKgguTbXhXQq55dlinP/t1BBhThSpbVKnKj05YQgqlIlxxRpIqwgwxcdaZwwNVQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3lsosQd/yWnYr6ZpflWentw7WvBA1vIs2Ota1iU5p4FWIbDrv
	vfakv0ELFW5+nH0No7o5RznOW1nWt9by/dXT9x6IbOs9uetRN97aaFTwYBPliqYTn+X+b3xeZEM
	zkBrmY+Y=
X-Gm-Gg: AeBDieva3UQzUVzzYgHxiQn+yDxOKGbKqyOgK2az6kKMs1WrfWsMsbPYSxjGhLt9ZAM
	8cOOUsh9FjnhLy1HW3qmkmrXpJSO3HtMOLcL07yJXR4xVQHig/RvzJLSNbOBrzE1zK8HN67/TH2
	QwrYBeoZCqaSephBzWmfXHUx8wjp3A3IA8jGSV1M9DsN82zL/YdDBozhIdPCG+iv3Lb0z7zoghu
	nqvv+JlyRDKPVRMjHzUOmjjlzgc3azlAbeFdVt9fLqR9zMrSBK4CcUAzA9OKqbkOjlsy+uvzUE8
	0poUs9OE1yn28RadORFczA8jXJOLhk7VhrmiXIxQLQGVaESBjeg2nnbG5yGR1U00rESMT3BQs7u
	FaWZc03+Hdm8InOrkLbtrvv/BhRrSuqeDYCMiorq7GAykjzW4KBiPjr6S1jn2HT7CzKqdCsWLM0
	GYyhHqCUZugPwrJTrS/XskuTZjijrF34iQZic2eqFWxX7ovFULMoNWFu51JoKAOg==
X-Received: by 2002:a05:600c:1d0a:b0:488:a824:fe04 with SMTP id 5b1f17b1804b1-48a77b1e893mr82412875e9.26.1777414987982;
        Tue, 28 Apr 2026 15:23:07 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988989d67sm2153005ad.76.2026.04.28.15.23.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 15:23:06 -0700 (PDT)
Message-ID: <70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
Date: Wed, 29 Apr 2026 07:53:02 +0930
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
 <06Y7ET.5XM6UHU999Y21@mailbox.org>
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
In-Reply-To: <06Y7ET.5XM6UHU999Y21@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/29 05:00, brainchild@mailbox.org 写道:
> 
> On Tue, Apr 28 2026 at 04:11:05 PM +09:30:00, Qu Wenruo <wqu@suse.com> 
> wrote:
>>
>> I strongly don't recommend to use swap files on btrfs, as you have 
>> already experienced the limit on scrub, and I believe a lot of end 
>> users are not aware of all the limits when using swap file on btrfs, 
>> please check the long long list of limitations in "SWAPFILE SUPPORT" 
>> of btrfs(5).
> 
> Is it expected that the scrub operation cannot function properly if the 
> volume has a swap file?

Yes, scrub works by iterating each block group, and to avoid concurrency 
modification, scrub will mark the block group RO.

But if there is a scrub covering even one block of the block group, the 
block group cannot be marked read-only, thus scrub will skip the whole 
block group.

> I never before observed such a problem, nor find 
> any mention in the documentation.

OK, btrfs(5) only mentions dev-replace, not scrub itself.

Something we need to update it.

> 
> The specific restrictions, as documented, for the swap file, seem 
> completely compatible with my use, a single partition with no data 
> duplication. I have no need for spanning devices or duplicating data, on 
> the particular system.
> 
>> Any dmesg of that RO flips? That indicates the fs flipped read-only, 
>> which is a huge problem by itself.
> 
> No. There are no kernel messages that are errors for the file system, or 
> switches to read-only.

Then how did the problem of failing to create new files happen?

Any extra output when that happened?
Just returning -ENOSPC error messages but the fs is still read-write?

Then it may be not enough meta/data space left.

> 
>> Especially with your initial info, there should be enough data space, 
>> metadata space is less ideal but should be enough.
> 
> I have read that the space allocated for metadata is expanded as needed. 
> Why would problems follow from too little space being allocated?

Because you have no unallocated space so metadata can not be expanded 
anymore.

> 
>> Considering how many snapshots you have (triggering qgroup lag), I 
>> strongly recommended to remove unused snapshots to free up space.
>>
>> After freeing up enough space, then try to balance data block groups 
>> to make space for future metadata usages.
> 
> The situation with balance is quite confused.
> 
> The problem with the reported lack of free space first occurred several 
> weeks ago. At that time, I deleted snapshots, and ran balance operations 
> with incrementally higher usage values for data and metadata. By the 
> end, I had run the operation, without reported failure, with values as 
> high as 95%. Normally, such an operation would be very long, but in my 
> case it finished in less than a minute. Also by the end, only about ten 
> blocks in total had actually been reported as moved.

But your 'btrfs fi df' shows the other way, a lot of free data space, 
but not much for metadata, and still no unallocated space.

> 
> Perhaps my installation of btrfsd has been successfully maintaining the 
> balance for the volume. The system logs are not extensive enough for me 
> to know when it last performed any operations.
> 
> Regardless, it seems that the general problems are not becoming resolved 
> by invocations of balance.
> 
> 
> 

