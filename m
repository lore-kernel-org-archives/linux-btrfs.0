Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 610614014AB
	for <linux-btrfs@vger.kernel.org>; Thu,  9 Jul 2026 09:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783588794; cv=none; b=ALMK02GDcL6d+/VvENY1Wi62YuRf0uj85ak1YX7oGs2LmSv4dstiTKuN4tlmblPMtclVmvyxkXUGdJrdkrUubztL48CaqFbR+/Fm4oZUibcYDD1pLrzrmm7p/WcFe8xXbx2WTglFxYyWnWTj6hkf+afg9rmd1VybU09SX90bJF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783588794; c=relaxed/simple;
	bh=xM/dTALX6XZZ97ndjXzIjWr74eRo9IcVRE8SSp5+n1Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=SdFAB9fBQFSyLjnOSPoAOr80yhIuYmmi5OOe2NRdTwUR1+OSVGy+BD4kz4x5cx9ixewRXF659Pfi4TQipF+zltWibh6NWMTRSEOkZoQogKl8cdkYRk3L128BKMSbQFgiBWUzOUk9vrLuDQgh/2VJyXxrSvTk9bubdCLaglp0YyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LzKJR+G4; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LzKJR+G4"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-698c0ff45b5so1158378a12.1
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Jul 2026 02:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783588792; x=1784193592; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4DZGZpkWnpKuptg60oQVBoVJ4ivwz4YbyXWNw4D3GRk=;
        b=LzKJR+G4y4WMqnjOIVen+nkk5CTl/vAGEV6xMK5U2zjfC8VLCgzj/P24svEvOfXjNF
         xdrz+6ab8Pn7mckbvhVoQoZokXUv+6umPAY/p+POz62SqxmdkaINbtN72j7Y5ssVI1Fv
         xCdTutwG2VHUTBY+QEpQEYFwuK1m/POui8rgsc2BFugR+C/YyeAZK269uCH3LTs1LInQ
         dR/fSq+luhhBhV1ZzcQ/x6UynT3qiIsx1dmFWiKtQ+SoZBe+HXnvVl9GW2QfmDQgoJO/
         wTkcuNoudkuy6MWX9wSEuLtERBwkyTNVtA3mdLNcNwM0CNQ+a4YdFJyKG195z9MibC5r
         PuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783588792; x=1784193592;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=4DZGZpkWnpKuptg60oQVBoVJ4ivwz4YbyXWNw4D3GRk=;
        b=Fp9Pse8QKPXJSjJkP9LZ3KICGAOEoksvs6DgSSIOnY+pKwRQu+NGVgLW+nPM/NsyR8
         gFFbpvtAz9xdiZBxtoonGSugs4E+jHIQwFIm7Rh8CAmbWveC4g8AKRdVvHa6+AaM6Dcq
         RjMVqu1Ojdkq4ATAFjSYMu7ggZ/9aj6mySOoQ1D/ZeWEw8HUZhnZvkezV3lYtJEwSov/
         DE2Q+oSz5kaYA8Qhtlr6F8EqdJAdGYf8rT5zaUIeEFIfXiOU04DOfql50jM1UYBURcYK
         JDzGDZQg5VLBo1DickQX7CnlM0kvUEUmexKn56AKGZcXGBZiy23c9CDnHLHlto629zuK
         AEPw==
X-Forwarded-Encrypted: i=1; AHgh+RoV3wG0jWLuqU5960SU3d9zVuFTXKzXohOUjQ9GNfVk0itOZ3i2Tx0wkfGFcmhH3Fh02LZRLcV0WVy9aQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2R5atHy/qiHA+G7Ev6Vqvk3JaVC7HDwtss/Z8v42Pn11zK71v
	nBitV9F19O0fobzyXOd29o/PaK8uiOFH+ysKrmXrM1crNGdxLMQkHP3MxOYUb6zFjbs=
X-Gm-Gg: AfdE7cmYV6r8nSqjzqDh3SzxfR+A04iihqFaw9gV7SxBKII/8Pg97n5naLCUNe2UCvS
	HRrm9yhcwhlbAKierOzU5U91LzofMQpRN7rG6Wc5gbMn+U/8AbCeU/vlCSACHrronoq8OM6Ai2y
	/1laN92ibsDCBALEygu5nnFjRDWVlTkpsu30yEt4S33KY6VZmq526+nWHWzSdfEBnmSZSScFGbh
	QKUi6kx1M4ShCHL/o7kOrnaz0J0kqhPT30CfHXkMPFVoowWw4u5j/Bt9EWcOmGmnL7bogVIQ396
	8CEAetcvcF+fQREnLxZm2z7gkbjQYewlmnBSUbojFpHJkIezFelIPeDJNlRL9PVP5ggcY29ugOx
	3eOql1iaJYsCJv6yEilOJkm6yIgcBmH7KUo33abUXo14cFC7McahMj3Meppf8D3b+WjE+P9pr3r
	5xRci10Q==
X-Received: by 2002:a17:906:9fd1:b0:c12:220a:e4a7 with SMTP id a640c23a62f3a-c15e7b234afmr87112766b.32.1783588791299;
        Thu, 09 Jul 2026 02:19:51 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9bdb75fsm40631105ad.8.2026.07.09.02.19.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2026 02:19:50 -0700 (PDT)
Message-ID: <220e9095-7eae-4129-a36f-53403df6fc8a@suse.com>
Date: Thu, 9 Jul 2026 18:49:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: write-protect folios during data writeback
From: Qu Wenruo <wqu@suse.com>
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org
References: <856f2a691977072386085d768b7929520e1022af.1783570200.git.boris@bur.io>
 <bc4b48c4-9d3e-40ac-82f6-d01df950443f@suse.com>
Content-Language: en-US
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
In-Reply-To: <bc4b48c4-9d3e-40ac-82f6-d01df950443f@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/9 18:16, Qu Wenruo 写道:
> 
[...]
> 
> 
> With all these said, this may help you to craft a more reliable 
> reproducer, by:
> 
> 1. Allocate a large folio (e.g, 64KiB on 4K ps systems)
>     By doing a 64KiB sized buffered write at file offset 0.

My bad, missing a sync here.
Other wise the later mmaped write will not cause two different dirty ranges.

> 
> 2. Mmap range [4K, 8K) and [16K, 20K)
> 
> 3. Trigger writeback with mmaped range being modified
> 
