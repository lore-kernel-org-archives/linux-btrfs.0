Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC563793B3
	for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 08:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779956911; cv=none; b=FQ4uGfC4x/7GxR/ijN6d//IFmOmQ4vXCEb0NNhASBVdnTXLuJKsBx11HVFkdtk5y3EsXbc0RxHwNSvmJv4MQNkJ68KHr/+lxKFW5dLNmpSMJPQQ+W3Qn6SH4i10MUwukzlM6pEm7q3mC0vRp/NMRhev0nBqa8zzMSh9zJpcxPtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779956911; c=relaxed/simple;
	bh=rXlQMaq+XfbaMZn+lFfZKCIJODi6o8lSAau26HR46iM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=b1cmXHH0KuztpZLucSBhmRXrUYELofNpeuiqwcbmz9nexlyOIX5r7hwrP0bwPwA4ZGt/cLwOMXu4OfFnLZ339H62QcQ9cTHOuz4h04DUnLM/QP9sb7t3OfrWudFP35oCfcZxOHXOa258moSaSc26gbqnJq2JcrjOkDXtjhfPbdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GEaQM02n; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GEaQM02n"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-49056b9f04aso64439525e9.0
        for <linux-btrfs@vger.kernel.org>; Thu, 28 May 2026 01:28:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779956908; x=1780561708; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YY5kLMlseI4i0ue1xXuo6XDPA4DpWq1UIP4vFetgSHY=;
        b=GEaQM02npGXEVxWbKHLVbliOJ9bOnX1mAgnbryz33DApPeRUBMU0fY8HUCTZyzAMRA
         GjnAqovJxGkNvyMXu7XBo4+4Xk4dm3aSKkRrrxUkAwbBQqIY5LsxhKL/oZuQ9bhUvm7p
         ub/Hh/vPWKK33zm6Rm8Zhle8YNVpjgFy0pzgFWnUJJdA5i/xYxS7pyNre6N1hbZg2uJ9
         Mh0MT8nTzOOKh0yZV5w9uSlXzuawplyLdkVYII6ZaPCQa/kuLl7mh2MVe5xrjFnb8iRx
         8qR1VDZlLJ8Hm/FUy6UwKhm5UCiqNvCFlofD+ALC5o0TINU4whSEebQMFOHHU+S2UASC
         +ueg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779956908; x=1780561708;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YY5kLMlseI4i0ue1xXuo6XDPA4DpWq1UIP4vFetgSHY=;
        b=HxlI/upbB54B76F9Tq1Yn1L8OnfaJSOAYYzTSvNeZbjkkIC2fmMUJSAph1yObSz0qG
         zV5n14sXpgSLxOjPx1JGgQykterrUCsQvi2/wjF4/sF2jyfwwiN5cqGwmtcxk/xqMnTM
         +eRj75Ch6t9CJUbqxQbtKnmZt0qDiAA6QCD1NqCqUEmmScq6cxGTlgF/vkt0nlq3dZaN
         X2j9o7VJkUBVVph+a8ljj86g3/G24GFXx2gmof7BMP/b6bUS7tJ37jCuNTsjCpEpiRez
         8f/JbI8Oh4yTRhfLJ5y/mspuJaBDlpvUYu+YuhnsdAAdBBTG3j7PJ6ipZdubX9/oIdD0
         6LlQ==
X-Forwarded-Encrypted: i=1; AFNElJ8aqyTHPqR+u7WY0xJU5TLSSkKW7Y33Rn9dNfKuLfBYY5C6wSt137f/vf6okw3NOam2REXa6kv97XRPEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJJWmzq24DrwDMbmHUsrdIbUxGU4377z3Yx9l+6g5CQ0yZ8eCx
	7GjReTKIKknvvv5wVTWvGWMejWyj6ik72EbFjQJwVsN6Twq7S4lhaGvYhEjd5IU61r+xRBPBrt8
	4aYaG
X-Gm-Gg: Acq92OHVSbXcN1B8b3fK+fuSSSnt5hgd3QMr67+POFqRgKm0x+RocsNG5jkWfyKCxdG
	H+Yx5Rha7hpnf853OPpjbjECN9AN+Svb0jcV2l0wt3i0iOTzOXi5d7RBesbag8Y8511naYsDJs4
	Bqx2u/5iqvsYQRIbwRN6rl9wYlGV1+PjddaJcYMUACY068mr6x2f8YaDnLMYuR87f6Ea3e3t0sm
	h3EnAuaAreerSUwdky4Q4kN1YLAUOH0OIR+YZIeT+5s4QCSl0MNWtU5494nBEH4cx1SsPYH1p+D
	ASPys4W4UKSIsi5i1/JQQVOgc1jo7H6B7Kpge2+iMqG4FPaz66uO6TgHKwIYB2cvgpCr7jwArOk
	zlHCja5KPa0it5r4tBGBz+GBnMd2bFqS66Z+clTXktdlYBsbgi7md3FNPHPQSgYDoy7J1qK4VW4
	q9J3SiO2KGZvPBCgyXVgIb1RtVbXx9M7bI+VHcJnc18h+mmYn9gNGRDnKkMl3DN0dIkziDF2mvX
	NlSEdCoiHEZPFLltMlwqPtMlUZ+l+DwOZ78JpYTz80Z3chB0O1z4oHtdR85rssTW/rW
X-Received: by 2002:a05:600c:3b02:b0:48f:e1ac:c94f with SMTP id 5b1f17b1804b1-490424b3938mr447379215e9.10.1779956908201;
        Thu, 28 May 2026 01:28:28 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d71f2d45sm5199476b3a.47.2026.05.28.01.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2026 01:28:26 -0700 (PDT)
Message-ID: <b71f9fee-42a1-4357-b13d-214c2d2fab4a@suse.com>
Date: Thu, 28 May 2026 17:58:21 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of O_DIRECT with btrfs ?
To: Roland Kletzing <devzero@web.de>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a56459a9-0d23-4fcf-bea0-e16a2d6245cd@web.de>
 <4a00615e-7515-4bed-9cf0-e01b62356018@suse.com>
 <9dc28403-c294-405a-a9e6-cd4e32e6e327@web.de>
 <6edf7876-0e3e-4528-b18a-232c87245921@suse.com>
 <7b6ee84a-b466-4273-acde-cb6b921ff7a5@web.de>
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
In-Reply-To: <7b6ee84a-b466-4273-acde-cb6b921ff7a5@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/28 17:04, Roland Kletzing 写道:
>  >Finally, we're closing to use IOMAP_DIO_BOUNCE flag, which completely 
> resolves the problem of performance drop
> 
> for not having misunderstood you - you mean you're close to that with 
> development, i.e. this patch is going to be obsolet and replaced by 
> something better !?

Yes, bouncing will solve the buffer modification race, but with only 
minor performance drop (95% of the original zero-copy performance).

But don't be too optimistic yet, there are still bugs related to the 
IOMAP_DIO_BOUNCE flag usage in direct writes.

Only after the conversion of direct writes to the new bounce behavior, 
then we can start working on the direct read.

Thanks,
Qu

> 
> thanks again and have a nice day
> roland
>
