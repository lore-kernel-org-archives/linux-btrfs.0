Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077143EC6B0
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 09:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144449; cv=none; b=BIiEiU0YzGYPNhuuPH6LQlFneEFY2R+O1+tvaevgcd/K4jIawzcl+q//dpvCTujIvRO9RILAtD25ImYY0XJHawspp1S/xw9wFI36+VSc9cxd3B9/oHaaHooOMGYz0JflyRvh7nV7jMUD6iq8MTIIpVYQ/HCSdyWHbzVqmomm3iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144449; c=relaxed/simple;
	bh=qahJq7BU1zlzJl2I9wBQStNp4Xc7xu8e3QIefUfM6xg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=diDtbSiLG6a38iq/0BV+QS9xPd4vNoEkPdOfifQOvDMG2K74zi3Qvk6ACQPNp7svNQxLwgjUuUo2jZtQMugMoSjN9X6bI88+3YZEJ5l020NBBo46UJCbF3IyZWJHZW0tAITI5Q7aHhTgwz5MXsMdal8halxFrCNwWRgnbwZGZHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GgIBRjfY; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GgIBRjfY"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495590dde14so26913545e9.0
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 02:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785144446; x=1785749246; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=akppgifv7/v7Y83JM0bcVzkMzStsYZWlZ76Hf99KRvo=;
        b=GgIBRjfYf8FinwV452g9osBztyo2YSBnxXQV8UTUT1ZFO+yGhE7o7GNJolZHkIb1pO
         pxMlflx3iv8nPLv/P3mtOmxdZoqQm0u2swvMrNOubVY4cFd1EOI2SsL3sC6BWi0B0ZK/
         z0ckoaAg3gRh0jEJ+lZbnSVFHbasbkMU6ImWMeX/TyxUwFQyweVKKquBx+pIZArRZfVK
         XPVmWjw39mIR9X85IZZT7cVmBKuqFhIhmPrzbQ7DV3nJDeiItgK8ssaJMxn7eJz3AJZ0
         l7pvtGcXn7rqrniMb3axxqABoQZ++rg3NbfuDLjgC/XZi+wPUDHd4e7p/Xwl/HCZow6e
         yRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785144446; x=1785749246;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=akppgifv7/v7Y83JM0bcVzkMzStsYZWlZ76Hf99KRvo=;
        b=kCk0/d9K7C3caEe4CmE/IvVHdEr/4I8XzhjgapNsYiU5V4FzLu4wRJiTPVnfM0xKDy
         2Mrh3eBTix49R8icW0ONPGbZbo56KPPyU6Ae9EGQ919oLxkGXdQjLqfHaT474DA90ZWk
         ph0CmxKj1CNiEXYNNF8th5Encu84CXPrShzDGd6JgQDcm8UE/6pJlhJApPNoiYsw9CXV
         vMituZJdHSuezso9DdSltQClPEqNrrdMs3AYEbnZZn5blvg7wm7t5A46M4Rd77LYxM6o
         z/lynQgCPr8XEMZ05zkO4ikTz+9y4bEJaO28irzWW1Cs6mHhuCsZohx2aD4avX44GRui
         mpOQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/PbCQdQRBgsUKsHiH1haeOeXQ8XMtigwRPjVVg70Ib0Lgc0HLymBbWmN5F/2fWPpuQRfnbQlFjpu8Gg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyog1vHWHGJyJTM3c6wxJP1quluthmvadleaoc0pGsG9MuSL34i
	iorPLF/yNK77OwfveC9gW/Vo/5G9fXJ858v7MmHLEnV1uKd8AABAQ6bzvowQNASafLA=
X-Gm-Gg: AR+sD12vnsn6nlB76cdn1GuJrmnSgwEPPusG8OeiegbLx1lO+G2YZ5H4c7Ehmniz63e
	V49R61iT1Q95DrEUkZyOJHy6dPQvP5PQQBX7DCRcRDaOp6dK0S9Pvn5M1eeq7gDoEWGCqRmCvF4
	bPVIgkK2X2zR4wPf9r7TtAfvf8iCD2S9hOaanW3v4DD2MgWAo2A4uL/50UIpDdOdqaxZp7roHkX
	oqgQUlmh4ECM/qtZqEjUWZ90DqbQU9Mi54IEzqL7rFD3Ser80O1ceO1KvVuAQFZb0rv/Pn3g1+l
	pmwhdLFuX8VSVemm5PysqLRoPpT+z2XsEjO8SCYMPBKdryL6LJ/u7W8gsR1l8Zj/dlavueRNaLN
	FjZmvlQpodh1SMWRK+Va9SIh7uCC6k93cDJFL2MLeiUb4VH+Sow8YmGcoSz+2XBSWQ8F1BR4=
X-Received: by 2002:a7b:cd92:0:b0:493:e365:7630 with SMTP id 5b1f17b1804b1-496b56f9850mr62167585e9.14.1785144445967;
        Mon, 27 Jul 2026 02:27:25 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e6054598asm10908277c88.1.2026.07.27.02.27.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 02:27:25 -0700 (PDT)
Message-ID: <805c2b93-ad23-4b17-9e5b-63f6bebf233b@suse.com>
Date: Mon, 27 Jul 2026 18:57:12 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] btrfs: trigger cow fixup via dirty_folio()
From: Qu Wenruo <wqu@suse.com>
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
 kernel-team@fb.com
Cc: willy@infradead.org
References: <9f7a81cdd022d9e3f69d347a17c0a25438ccec14.1785131713.git.boris@bur.io>
 <5b2694a2-a5cd-47bd-b225-8d7c74426e2d@suse.com>
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
In-Reply-To: <5b2694a2-a5cd-47bd-b225-8d7c74426e2d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/27 18:08, Qu Wenruo 写道:
[...]
>> +again:
>> +    folio_lock(folio);
>> +
>> +    if (!folio->mapping || !folio_test_fixup_pending(folio))
>> +        goto out;
>> +    if (ret)
>> +        goto out_error;
>> +
>> +    btrfs_lock_extent(&inode->io_tree, page_start, page_end, 
>> &cached_state);
>> +
>> +    for (bit = 0; bit < blocks_per_folio; bit++) {
>> +        struct btrfs_ordered_extent *ordered;
>> +        const u64 start = page_start + (bit << fs_info- 
>> >sectorsize_bits);
>> +
>> +        if (test_bit(bit, delalloc_bitmap))
> 
> Dead check. It's always false, as the delalloc_bitmap is initialized to 
> all zero.

I'm an idiot, we can retry from again label, so this is the correct way 
to handle it.

Please ignore this one.

Thanks,
Qu
