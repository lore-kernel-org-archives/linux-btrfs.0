Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5024A3E8C6A
	for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 10:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782468842; cv=none; b=XI6DvVXNOuq+iPnS3oE8gEnFRG6rG4RwkLA8vnHp1MEBnd5cM+YMZZCrL//R87ybM9ZGGE1v7a+b7VwYoVpg48J47I0lftNwxZZvJj9V4z/2O54fVztXxyFxQX1ZoE634tUhCus077Ync+Rz5L9ZzDm+4PTLGeGj4dWDN2FCoVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782468842; c=relaxed/simple;
	bh=lwjV8g5q3dIj/fCumNwNnPJU15rZozRbzBdwZWXllyY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wr/+9HL/nuD8roai/amDWVIziCRQNgunW+NP2GUSDDqnKledBjvPPuXS5Hs5HUltoY+dIMxxbfmiGcIh7pW4NMcjWkJC3UJ81tfi2je+Tl10WPJcgKRMOtcGjfpQKOeeqSRQ+FCEaJm/33g3OFSVFbRfuElssoDCBHV+m8nRA+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=U3P7qqSG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="U3P7qqSG"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49258ac7294so5206165e9.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 03:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782468840; x=1783073640; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=IDyKzV3FvBfX3LLit3ARjtkce+2TqYhVo50jSpJhGxY=;
        b=U3P7qqSGHjKCeal5WyCQnsa9gQV3ZBByCCKKWMVlTYh9ZnkcDDdEYJkpuUrP3WlSHA
         yhe/EOnDYCNMV7mXZ3Pvm8+Aj7kV8CuECyJH72i/uiA26TwdEU9XfYu2XtpwbRqc4P8J
         x7tweoQVuuRIEUcUVhbGo/AiJkT0kGNCBtA6bgBoUJXZrRrEoeG9hZVnmLjy1BRVYfeU
         DKN8DzVLkPW3rfMrOIuXDTT7mV65YwqVhjmhkH2FDeOsNeyukc1rTWWtrVhzlyCOhYWL
         UTLNE5dBzrpEDvsiYQLu0mFXr485c1ZuEtXdhQ1/B18GduzivH4BjvNvLHCarkvawmnh
         /OIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782468840; x=1783073640;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IDyKzV3FvBfX3LLit3ARjtkce+2TqYhVo50jSpJhGxY=;
        b=erpFWX3FWEAHV3UYIsGZIqfiChKTC0qk+/LDAHZh0OThHUoXPVK7k4/3P1dcoRQIqA
         dKtaIrab069y+G7WYsYeUj5/aRP1qP7tkcxKClLyXdSKw4m1lOk3D/7I1J2IvNGFNLbx
         AjZZKWLEDurirmTZBDUrtFyYo2QZlVuoinTZGGDNsaXX9aVMgOirUFxEeAuny/n5a6Ug
         ednzhSB6asBI2+xoJEn5iJHICcVB52Q3XY0wzzv5c2q7BSU2cpXHiLm6uYMWcWwH6V56
         hRT4vGO5iICwJolDASHGxzlzDcF4ZFYNj2EP7Gb/V0cbiAh9uOKMvg+kLjf4by+mxLpD
         IAjw==
X-Gm-Message-State: AOJu0Yxnd62NHA9/9Ugv3QFchIHK6t/K7v2jYXeaidl28WOrqplEIpSB
	2JxXVh3nz3C8bDBJUoPDTAFDhGl+c++5GV5Yr6ND6O613mqCd4rNTuyda6mOttptRF3X0JNDYjq
	6zI1jdDg=
X-Gm-Gg: AfdE7cla/E6i6km1Py10WWL8ipfFV08PYe8ygYKx1kGfasd3XchW3E6c/O9w1/2DK2G
	7vgtFX9w/4Sa4aYLsxRSo1jf5zzhBwFJa6KIkA2TmsXJVpJvdHuv3Q1z0pK5UHjNxGrNcPsKFMW
	uYPdLLXC+bEU3CSNorVjGRxInUd2SFmB2Qgc9YjcW1C3gWXwovxLvg3OdG/oIbqsoHT1IOYo/6i
	653ofEnIlbVEJe3k8n+y7Bkdft38AKxKxJ1+Bac7o4Xnj+vjSR/R75ZwpDoE9mFbm0FzGjn2j3r
	MA6SXJEHS+pKcYJy61CG9jl4d8LlIdirnxbSGmp0TMldqR1pVDZEIche6qvyE4R0G8Gjd5vhCio
	2JX9zsloXAWeD+pb7S9FPJ1PZXANXKETNyJsaqc8zSUsCmpU8FttIZR7SK1xoUcwMC6Pp8pJJCp
	4GnbuAODfpmTykWHvpPMaV5plLQysRYHis0CBdx1lr/yhFXxM0Dzk=
X-Received: by 2002:a05:600c:8b53:b0:490:b294:c652 with SMTP id 5b1f17b1804b1-492668857demr82651345e9.20.1782468839549;
        Fri, 26 Jun 2026 03:13:59 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c52c591sm22444045eec.7.2026.06.26.03.13.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 03:13:58 -0700 (PDT)
Message-ID: <4ef4df7b-6ec4-4f6b-9e17-25432a3c2870@suse.com>
Date: Fri, 26 Jun 2026 19:43:53 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: always wait for ordered extents to avoid OE races
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org,
 syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
References: <aaabe0f2bee07800fb0490d24fab5cd162e5241d.1782366056.git.wqu@suse.com>
 <CAL3q7H7+WAQMV76+-AuU=dR_qoe6Gu1_CNmwUFD=zW81d2Hz0g@mail.gmail.com>
 <9efd034f-fa6b-485c-aca7-a38f526d4083@suse.com>
 <CAL3q7H6sNSPqkE+h7PgX+Vv+7o5zTokBi52F5SooMmxEEH-phQ@mail.gmail.com>
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
In-Reply-To: <CAL3q7H6sNSPqkE+h7PgX+Vv+7o5zTokBi52F5SooMmxEEH-phQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/26 18:45, Filipe Manana 写道:
> On Thu, Jun 25, 2026 at 11:39 PM Qu Wenruo <wqu@suse.com> wrote:
[...]
>> If acceptable, I'll add the microbenchmark into the commit message in
>> the next update.
> 
> Instead of this approach, can we wait for the ordered extent(s) in DIO
> path that reverts i_size after the short write?

OK, I think that's possible.
I didn't see any special context requirement for iomap_end() callback.

But doing btrfs_start_ordered_extent() at the isize revert timing has 
one extra problem, it will break nowait.

As btrfs_start_ordered_extent() will call wait_event().

At least the current one we won't directly sleep (the wait is happening 
on the next buffered write).

Thanks,
Qu
