Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7A3309F1D
	for <linux-btrfs@vger.kernel.org>; Fri,  1 May 2026 22:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777676368; cv=none; b=bHFNa3/AtEvDnoM07LssEdBCIsHbVK8/W+a54LmfmlC0K2kQKbrtW95NHqEshNG1+9csKqbljKqWDfk95fG+H5R0LFtsZaD3AaCjRt002TF1u6/GQ2AB+A9nHL2LoJx8Jl+Li/497R1HlYti+OWsG6vHbXtxbBC6Nn3hgbeXY1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777676368; c=relaxed/simple;
	bh=rJzdJ0nJakCdcdLt2Cz3uGK/YnyLnTAgdSLLvujVM6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lfzopTplmiYtvs1jBHoJeRHlPNgnXgsv9+dQg0z69N16xooTgDNoLCOsWwLdDbDhRF0zGyCbgiCFJKlZ/LVYRDI7xSC+r5bRgGDoK2aEnMLLBw+k7jWM5TlMrkkqk8fLB08gjlqOyMfXaRahk4iI+P7lWC74x90r5z0VKnNiOsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ov5yiVh8; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ov5yiVh8"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488b0046078so18531065e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 May 2026 15:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777676365; x=1778281165; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PCvkgenE7sHtNfAdRg2v/zuU1vPAludwGPHKFZQLt0g=;
        b=Ov5yiVh8X0O3HNO63sXNCsBr9wOn+XL95SkZQ+p0q7a5M2SOxu8zKu2tdDtJ8m6Sjb
         KkMQCTMMavlxZqsyA+zE/mu3YmnPi8kK8aIcl+oH7eyWSohoja7XYcVDE8PeGQ22+ODr
         MBf3iI6/whgj8TsPAXk4WPkB+VHfFJviS/b/SQp/vWN3vfgX2XZIQ0XPRvz+xee7j1Av
         v9J0mRmMJcJ/SNRlAflwB9DJ2jY4J6hNLHuFBq1RlmPesTn5nBfqHYUQ6eMyD6Tp0RPL
         AUFhLQz+VdRJz6UqIuitsj9FXgCVW/GqlazFmc+2MbKhxR4IjJUtpMr9r6lnosVlGpLZ
         mD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777676365; x=1778281165;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PCvkgenE7sHtNfAdRg2v/zuU1vPAludwGPHKFZQLt0g=;
        b=NXAFph5fXAoxIeJdnCn8+LMv1HKGL9JeY4QYvOskcjcag3+gwPK+KVOmuLyTnr0fqe
         GvNqyuU7ejwOkz2KJsj9ghESwyQQGvhfw8CtiAC8elWbydAzQBIrdhelgcNGpbav+UpV
         2aoWgXOPbS+wyIZ9qfh7zm/ABO6Oy3qYMinC3H9lnR8urpMJKC1NNcOqnHspgBh8ElwY
         yuAvqvsR5KwkkOt5D7rB4ftqtBVq+F2MF2Ng6f9QlLAdTOWwuxOMobIhEyehd7Hx9+bK
         1TkAfe5jqqYRF8EjM97cVTOUBNhCqtUbpVQljQPCQWM5XBnM3mTSQRfLg0eyLhpKH+3X
         /Vrw==
X-Gm-Message-State: AOJu0YzWeMsJNXEhL0niqlS1uENnZRQNU60vCJrPqqczP0z8rmUgWrmc
	o7h48lxz9y2GjsXDy/xi9zOtswe9JD1gjAL84h4I2vyqpkRVt8bnjenWay1LreiX0zRFldpjIY8
	lOXJuA64=
X-Gm-Gg: AeBDieuOmxfT1AXqQVWzvpF34Tuc5Ea562+fjuq7tN9QxFp6kLEWGTt1uP7I3xdWndK
	adpVQCbT8qYzMUgRem8HsVABaQ5S8DZBnFe/WbZsOoRmB9Ac7gn+vZinNn7kOhxhu6xPBT7PDJB
	JqSj/Uld07ClBTXDkU6V+0d1kEWxvrWikC9ChaJo/SNKDrTWp/eUhfm7FqGdbzACNSga47xryzR
	RmHORTNqo6AiB6gV1JNmi/NuvZ0ft6THIa3gv3XcmhvPao03RYQLbXTECuJf4A39tSXVeT7veEr
	CbJxe1HXOd28VY7f5NRbpCXdv9ck0+LaEwkDZVrcZDksJDqL3pVQMdKYm3Jf4ZZUSdw+pTkRVf7
	YhbE6u+FrfbIomInFyiMdPpiboUJRSotNaspldAp/OYuEN3J3QoZ9beKiwRmc35s+dRQCL24+5p
	PKXjKDka2Aas4fju1RG7A3oCh1gCongoSbp+jxUvEgcqfATR5hich0MrEL5blsFpR1IU7yLte5V
	ENGLGsp3pKZBvu2YbbPUSUD5JbC09gIaajsV3a2Ps5+iaXsXl1r0HTNuQ==
X-Received: by 2002:a05:600c:444c:b0:488:a824:fdff with SMTP id 5b1f17b1804b1-48a9866dcd9mr12560065e9.22.1777676365437;
        Fri, 01 May 2026 15:59:25 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9cae4fd16sm38798165ad.69.2026.05.01.15.59.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 15:59:24 -0700 (PDT)
Message-ID: <368cc782-c5c0-43b2-8174-b187089ede42@suse.com>
Date: Sat, 2 May 2026 08:29:19 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs-progs: docs: update the qgroup performance hit
To: Neal Gompa <neal@gompa.dev>
Cc: linux-btrfs@vger.kernel.org, Max Chernoff <git@maxchernoff.ca>
References: <313118e97b2a5c1fb3bf0bb2f3fccfa2663e42f5.1777632200.git.wqu@suse.com>
 <CAEg-Je_E3f_Wy-0M20rUp5Zd7Yg=s6SuaJ2==08W1C7EOYscBQ@mail.gmail.com>
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
In-Reply-To: <CAEg-Je_E3f_Wy-0M20rUp5Zd7Yg=s6SuaJ2==08W1C7EOYscBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/2 05:51, Neal Gompa 写道:
> On Fri, May 1, 2026 at 6:44 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> Although we have mentioned the qgroup performance hit, we have never
>> explained how large the impact is.
>>
>> Update the documentation to:
>>
>> - Explain what affects qgroup performance
>>    Including snapshots and reflinks.
>>
>> - Explain that the automatic rescan can cause performance problem
>>
>> - Add extra warning to avoid qgroup
>>    If there are too many snapshots or reflinks.
>>
>> Reported-by: Max Chernoff <git@maxchernoff.ca>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> 
> LGTM.
> 
> Reviewed-by: Neal Gompa <neal@gompa.dev>
> 
> That said, is there actually anything we can do to make the
> performance not suck with qgroups?

If that's easy to do, I would have already done it.

Thanks,
Qu
