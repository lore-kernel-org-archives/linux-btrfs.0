Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED9F737F8C0
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 21:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785533115; cv=none; b=d0g/mc1OGEm2iPi0Gf9hRR8F3mipFN6woNvcjX8dI9dPeCkUSidZQ8gz0sOqPNuODk3z0qICTz4yAksfq2D2XDYYhMJ/DbX+h1GvSvCR32G52LyHIS8/eKDvX37iCbgpo3V0gQfusaclYFSNi5VnsBiyzSA4GV4voXbTWZ+RKzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785533115; c=relaxed/simple;
	bh=WZzs3ggZ6TpYKopsSnLCMfyT0/lF5tuyyAPNJEnaeNw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aigVkhpYSDEfePqnOntCzeytInTuSlyz3pz2mav1zMHUWR9KE9JDMXtrWRy07r3FTsSMCdk6TjpFZhkeThHDFWJIUMSNf4gC5+xCApj52kCoXsz4hf2rf/QiCJVimKotok2gLeHroITCqF/OgGVwfNr94FjWVSpA8i7HB/Wjvo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eZ/SHztW; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eZ/SHztW"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47fd66a094eso321085f8f.3
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 14:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785533112; x=1786137912; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qwnnl6rP9qnjMvhn5jD74O4m/9T7mCXz4j2ffIU9ClA=;
        b=eZ/SHztWzyuaeCyUzeQgxsgoqHyglmgO18Fkv5cM2VJYvLEICFto0ooE2cmMki/ECB
         tPamHGP5D9gC5cR5trNRHBVJuxKIy2KM2DYLngf+DL6P3LUvoyF08YQyvuA0fmEdh+jm
         zMJIWMfFr9gra+z33RbQWgF84xkteO1HSXgEkLKoHgFQaBZ0bE0xkkf2fa45jQ2cfLdU
         6+KHLLEYYIbRGp2GPhFJxiuxfP+A2pwpoaD8SzzEv4+rfB88RHjV24WdwfIlScKcKawT
         nC6VIDli6Ry98IC22s7uGxxeO66cMK9ymD56tHiGOsB135ZLdxPMP3D+Z6VOkAECjyH0
         vSvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785533112; x=1786137912;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qwnnl6rP9qnjMvhn5jD74O4m/9T7mCXz4j2ffIU9ClA=;
        b=N6IqYi1VMsi+RdV8lWA391R2agU2kX/ZxdBgbAgWZGZ/GkCUDOBKoet8DgdbTh4LGn
         xk4WwaG9o0nxWZc8FGQwadhOSNCNqse9f7JCmqxiv2G7T7i8phOOX6rqE9NILnHSntqq
         KuQVR6rbP441pb6CRQwXNrGZIRx8YPq+AnZVCbpgSeMo0hCcH1PoabM8g7+AJHammLJO
         yZvn21LtroKWdjt16RnoFqQ7Rm4HV2Z+e8VmDINe75vJVtqBTWMbNyc+fpVj8FwAXLbM
         HbJPuV/UB0fQPaf5pRawS1jVaJ0mWcSrXMtf1Ps3HQsCORHApi/cL48Rdjabg3KrMt0D
         Ppkw==
X-Forwarded-Encrypted: i=1; AHgh+RrDaLampePWDDG+EFB1+aEXRVHqxt8G3NW6ClFxgehsroZY4Ut6WwXvj3PonkMAS9hlb3vYYBO+jlRCPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxWacBXM4U7BJjKk1+yIaHDG0WQd/vz7jchriGN9zHxDXLhPsl4
	pduw7mf34A+AU86HQBCxtd8a4pzdmEMdWPAEksdoYw/P/MZrfSi0ovV5O/9GCbgT+rS5SSeG5hm
	/pAtUuK8=
X-Gm-Gg: AR+sD10T5GpmV5ncfGsgZpRwo20ykSr1jgcLfTKapt0K+EY2UNYQs+ikvYAMVfr2dCa
	ZAFjTO13l3WX8Hu8ZrBf3ktF2/NKYiXqUiRqt9IeqyDmNIEJst4z7btqLoQUb4rMDMFKLB5Qx5L
	B04oM6G6qMjN4m/9/o87hRAwjQkmJ9N1O0ZjrE8dVFzVUNu0rK6ELBoPa0IsVySMNYseqGzbVX/
	EuHIhBqxZ/fPQvtSm35knmMADXUKtFEb6H/Fdvv68lvoi+zrw9BmKEAi4Wqa4sKZOUgrx5IYwF/
	4KLDYjDUy3h8gKL8TxQBKOzVbxQj5xwOBE7w2O5ksIJR6VK/Yykr79jq5Ue745xnD4LpjXh6MKV
	AQ4BU6vfNq31xqhP9L+j/HmQ6ptHMBKGrPh/Xr+ZL9gNsXbrnu402QIuGa253fAFgET3tPtjMGx
	HWQ+2MoCDJ/nytfCX0eeCC+sopxI07gAKm2M4isfPyOUNwBIEuLG0asQ==
X-Received: by 2002:a5d:4992:0:b0:47f:81fe:12fb with SMTP id ffacd0b85a97d-47fd7307a2amr1538179f8f.47.1785533112024;
        Fri, 31 Jul 2026 14:25:12 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e06f88fsm8816478eec.20.2026.07.31.14.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 14:25:10 -0700 (PDT)
Message-ID: <b741686a-d101-4529-b74a-4e1277caf84e@suse.com>
Date: Sat, 1 Aug 2026 06:55:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] btrfs: implement a new compat RO feature,
 data_io_size
To: Sun YangKai <sunyangkai@fygo.io>, linux-btrfs@vger.kernel.org
References: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com>
 <647fd7cc-f948-4260-b26e-122a61ca7a16@fygo.io>
 <5b91fb7e-479d-4e6f-8d34-40eaf1d675d2@suse.com>
 <ca3eeaeb-76d4-4a23-a019-d3a5f4ceb431@fygo.io>
 <110adc02-4e4e-437d-867d-c8fd3a50aba9@suse.com>
 <0758b840-f48e-4693-af9b-04793319382d@fygo.io>
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
In-Reply-To: <0758b840-f48e-4693-af9b-04793319382d@fygo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/31 21:10, Sun YangKai 写道:
> On 2026/7/22 18:03, Qu Wenruo wrote:
>>
>> Full stripe 16K, then the new RAID5F chunks will require power-of-2
>> disks, and no more than 16K/4K disks.
>>
>> So no 4 disks RAID5F chunk in the first place.
> 
> I've got your idea and got the following 2 concerns:
> 
> 1. the device count is limited to 3 or 5 device for RAID5, and 4 or 6
> devices for RAID6, losing the flexibility currently btrfs have;

Why you think 16K is the only block size?

You can go as large as 64K, which means 16 data devices which is more 
than enough for common usages.

In fact, I do not think you should have overly flex design, which is 
contributing to the write-hole in the first place.

> 
> 2. On each device, we will send a lot of 4KiB or 8KiB io, which might be
> not good for performance;

It can always be solved usings blk plugs.

> 
> So I personally don't think this is a good way to fix the write hole issue.

I do not think so.

As I have already said, at least I know XFS is planning doing something 
similar. Although not to solve write-hole.
