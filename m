Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F0850276
	for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 22:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779576427; cv=none; b=qLd8NlScopfddIMJlNAIijpSvvGsmsCjeqqU56Z0VjcGQvkdW4PX80fvpEKaVKhsBPNatpsBTJ+7xqtbobyzYXFqJ/uJeBoExIya6eDBkt0aDN1nI2+ym+nV7eSjpHhUa60W9b3+3AuBYuj0F31ieZZ2FENe1nYyo1lmWKLeloc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779576427; c=relaxed/simple;
	bh=MrQoh/EfmVdVKlBkhuV93gVYhJJ0ceMp+MEgn0RMivs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sNNBhg5lYpElcG24qUdCle07RAAid5B2/UZQxwjec7ygY2l/egO9CSED8CUfcDEjrjbJtvUBtnyenBapkBcTrvOhdbjfpScLfZf6uubrbexaKXMsKJ1G9yrWbZDV74opzF5hPyXnk4N+xn//259wYRqEa8EG9WrVFTCyWrPDj/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ESHEu7Bl; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ESHEu7Bl"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48a3e9862f0so46012175e9.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 May 2026 15:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779576424; x=1780181224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=8Z1ek8TezGhOn7Xz7zUAnL28o0hfZqT/5T3cPIcBsjI=;
        b=ESHEu7BlmvE0PYE5l/ts4Yg8iUFaLUnTkokvPDqyaGGgCSCq1BTRfiCOyD+8EwV2qf
         EX4XrW0oU9Yg7b+DJWbrn3mtvVsEujsiYGQJsMEA+vz/A9MuPS45GF8pcM+Z7MfJeBkV
         KquyOlRUyxqs/1dxEim2iTfqfoctSNqoI//0AkkEPYmpxvs2aD2YDYmDm/xh6pAv/oBn
         xEeUf+RvQdOxLEr6ZYZtpsGNNemrslSak9e3Eyfq38dhCJmIge1FQ4VgcbxpzD/Qv4oI
         T0Bt89SetbYAxUsPa2iOLQKk1yolmFX90vSs/zQ1iELgZ6sfm79MgNCn87GB5GD1gQVg
         e1Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779576424; x=1780181224;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Z1ek8TezGhOn7Xz7zUAnL28o0hfZqT/5T3cPIcBsjI=;
        b=bN5n84BYAPgaqneeMWW2wwva6xvLx+bwItmUu5Oqz9yZvTGFb+38GEzoFOXP7+2jvK
         2WCWzXW34R4qQ2mCjP9STeWhcCWX9ysAxlF8L3pmcDmkdD7vdv5d9RuosiXfAO80J64i
         TccpJxTB6JPcgc6KzZ+/U7XwkUwqHHFIMCu3yJg+34DEic1+WogPEGcqjAmzhmhVXlXE
         pl27OqR7m2X9Tc58Y9b1fboKYrJ8TiScibyBLs5CXfRShMjZV21UN34kdHwhRYmRfGuX
         e9JdQX/yyPHOZS9+wPc8aO67SreSr6DStinGlQQRZ25A0iP3Feef6X7fn+WPLwxM56Hq
         FTYA==
X-Gm-Message-State: AOJu0YxenTPwANAgSfyhC+q9IiPrpp5iVgRBfwdLCDrAg9me6aWo8Eiz
	VFW4Se6TQBEmiMkxRLhWnz7rnyaNtS2Zi3E4/11WmhQC1cbhK1qOnxJ7+rWBi5aYj5E=
X-Gm-Gg: Acq92OG0+yYlirTzhJWretBVqEexMwpLhkcXs6+ijBulccz2RrnkJ2UQC8w/FtIguw7
	ISUK9+q6bMtPtIDG00p9aXkiGHO4XfC07H5lzk9j1fIWlSsep3cSIFYfNBsDjRsJJyvAa7bIsOo
	Eb7lralSsasiXHXrPkvuO08uVRdo3en5tnnkTWXb82ra1kA7fKeJTI0eg7ar7RXddxurFHMqk1H
	mFnk75+2e4KW7HeRgY6puHCG0JP7E3ftCX1D8XCruljPoiG6p3PaNebcDw48DaEO2etqBkOZ54E
	nl8yx7ppHyRjV5+mp5P+3WGQX0tN4Tbh7wfvjZSdoi770OL5rmOQjx3Pv5f8RQbz8pcw2H9seyd
	SBvNuBgTFtoDV8x0GEov7EEEPdvWqTC1k3JsKV1yapgAaa2BO3VEUbHhfvAcMuIpY0P3CitqmUV
	3MFIwouxLs1kqvPyfMFroQO8QBJTbJDsf5DcbR3NDJEPE3WJqgq+HN8lTQ4QrNClIyh9o57L5AZ
	jGIsHsP+SMMOZwstcU6nfnQlopSAjEFGCsRonKNDPtNzoRwJmwHdGPCaw==
X-Received: by 2002:a05:600d:108:10b0:490:53b0:9e5a with SMTP id 5b1f17b1804b1-49053b09ff3mr33788005e9.5.1779576424144;
        Sat, 23 May 2026 15:47:04 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56ce2cdsm53850345ad.29.2026.05.23.15.47.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2026 15:47:03 -0700 (PDT)
Message-ID: <e1961351-d563-4d73-b9f3-30063bbe7c4d@suse.com>
Date: Sun, 24 May 2026 08:16:58 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] btrfs: disguise single-data-RAID56 as RAID1/RAID1C3
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, hch@lst.de, linux-raid@vger.kernel.org
References: <cover.1779412152.git.wqu@suse.com>
 <ce02ebf8a9a6f5e2357b838df9d7ecce1f0cfd4b.1779412152.git.wqu@suse.com>
 <20260523142344.GC183694@twin.jikos.cz>
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
In-Reply-To: <20260523142344.GC183694@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/23 23:53, David Sterba 写道:
> On Fri, May 22, 2026 at 06:53:53PM +0930, Qu Wenruo wrote:
>> Recently kernel RAID56 lib is trying to remove the unexpected
>> single-data-RAID56 (2 disks RAID5 or 3 disk RAID5) support, meanwhile
>> btrfs still supports such setup, which means in the long run btrfs has
>> to handle such corner case by ourselves.
>>
>> Thankfully single-data-RAID56 is really RAID1/RAID1C3, since data and
>> P/Q stripes all match each other, rotation also makes no difference.
>>
>> This patch will disguise those single-data-RAID56 chunks as
>> RAID1/RAID1C3 chunks.
> 
> I don't think this is the right way to fix it. Calculations are an
> implementation detail and should be done at the time of the xor_gen or
> raid6_call, not touching the upper level structures related to format.
> 
> Instead, please add helpers that take the same parameters and do the
> switch if there's the edge case of raid5 or raid6, using memcpy. Thanks.

I'd say going dedicated memcpy() is an adhoc fix, and not any easier to 
maintain.

Now you have two paths, one from the raid56 lib, one from the btrfs 
specific handling for the single-data specific corner case, and that no 
one else is going to review/utilize that corner case.

 From this point of view, reusing the existing RAID1/RAID1C3 is way more 
reliable and sane.

