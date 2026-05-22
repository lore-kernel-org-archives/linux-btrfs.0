Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D8B388E42
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 21:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779487083; cv=none; b=S56CLTzRCCwd40BjqE6+SK4qSG4NxvrEHS5hC0HiawP/ZZfUGMRDZc5pq+SSXz+IsCiMFgIJTLk+18AdRSgQkqg7jH6cW9gmX8QPcOTleYwI+xeVIY4VPH/rlgnTnmQpsnJe7xEiDIVOTNQo/1NYua9lyiz5IBflEb439LWoUS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779487083; c=relaxed/simple;
	bh=quTMPpuiUP82HK2XMM3P2P90NpHY7J5I3M0XbAv8fQU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kq6nyjjhlHZ7sdAKeskl5P0yZzfFXnlpm1plPG/zIPBEqLN7f2IeYJkfSBmKt5gBEYYhTQOVAWslXiwk+T+enAMy97Aqhi85Y/Fz0Pu8je2lvExHV2uIZDSmQDtMajzuLvRTUMlF3M5VTi/A1oqLbA6tfWC3PwnTe4u2vQ9zHzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CJ0ChvBQ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CJ0ChvBQ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48fe26a177cso58916365e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 14:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779487080; x=1780091880; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=F35gZy0hhFhgnoqVcU8WKTswmWAzOxuZZgYHpfPLqvQ=;
        b=CJ0ChvBQKV8y58k6EfKqDde6heP1YILHh5VstUm8ziPQuJ4nRafxor8eah5g8nfBpL
         CJ0tLCsp2Z4QwoYJukcasILSlfe3j+gqt4MlXwn3pW1yTZs3BkVjXEQGFUPcw2h11gAQ
         WkiCVoz+o3S9QaYB97VCztATR8AdrCgiKiLQj5UMUVqVniMGdg5DXpmoHyLop26RFVkL
         nIR0k55WURwZAXhejMH8RWxDZTOPAYI144zahpCYKmYJts5WLTn+VAGCQuIVRbHJwpYi
         713iR+mhwyzXOX0dHBZDVrj4aOJ16QS5/wJhXZ6/lSpBUH1YAjJ+O7tuqXI93rngbmlR
         2Kig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487080; x=1780091880;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F35gZy0hhFhgnoqVcU8WKTswmWAzOxuZZgYHpfPLqvQ=;
        b=UZcG7jqy9EdJoz1BguOhEds6jkPnMfcaOiVM1apwbxPHQwu12bStEBvHTL5TtWD2u9
         wpc7Pv/3UIiDUiivAIf4H/e1RHANhF3vgANoEh/4rmbFXJyBvaSDym0bAoogMSWVZJ6Y
         mFGJA7PavL13n1YJEA0xnZM38gMPl9qetkoYUr6UjU1Kl7SZdyHV4ok3RJDARHEsx03A
         qDCnfwuybw96zBnXtIucCB2rn71R+ibvpYEZgfhbcPd5v42veBpefy3b5w1aUnZAp06W
         Rpu79Ljicff4tm3VmIZv6jXB180gQtb/h8gb0WjESf9Fk38HF8D762HiWwOf5EBuy1Ew
         2RFQ==
X-Forwarded-Encrypted: i=1; AFNElJ88Jrkx9/u28X4qipYrvP9mmnuFt+WvfNDzIH0DXjJbyzk+WwOW66X/4aR+LSmznH3zbdGsd6Mtp83EIA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzij9kx/ygGSOxl3HdIzpb39UdcK47xkctnfTQxY4QA0akUlteX
	pEKQMShFtTQB5EmCjRc3AkPMXt8FSLf8OsPxZdPd6UGE9N8XH90RHxQaFubVLzKSe64=
X-Gm-Gg: Acq92OFvgSqhRwjfpvY1nc3j7OjuckRtAHlTFLy11u0DbUG35PmqRni7ScRt9SvVqSL
	hNxJlihvV7GFwTgnUqOdys6FW36JHLS51sEnHAZpSwQiNk1D0QXCHPGiHsalJFduTxI6jlVnbQZ
	xPggKfl7m8sqK8Dg/nvjdY8P00m17st8q90hknPwuorTxlGHF/c4aBMRpvJS2AEMX1qUwJS+7qW
	Lw4ktZU9ZZEj9zlZmc1GlGATGZPnsCdsw95mCtGJLY3X3jULObzmxsRs9djETxZ6mlmLMKL3UVQ
	Tyg0ZQ2DVJJyexBoau0hZDrXcGNTB0S5qFWJiD+o3MyeFPSDxeWqaeLf7IrY0DooOERbyQYPEJy
	/7KGjp6l9iweCuGTOM9jVAUfzuzH2MFs2mPzen03Iiih2zU1yeM5qqvNbZPYp22DfilEnQjh76j
	Cc1dtELCegcJ0oNmbeDOrdzq9ne4bWHmtuot2pfEfyV1DNCW6JXVFd2Q8fqTNVQp5/t+4Ql85Qw
	DgfoK8iARNaPT1Vdf4oCr62jLZikV7a7i+hmY1WOCwRgew=
X-Received: by 2002:a05:600c:1d11:b0:487:1108:48b8 with SMTP id 5b1f17b1804b1-49042487f40mr76313225e9.2.1779487079882;
        Fri, 22 May 2026 14:57:59 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84164e9e7a5sm3589484b3a.33.2026.05.22.14.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 14:57:58 -0700 (PDT)
Message-ID: <09b6756c-b750-4c73-9aaf-5eaf758c7a52@suse.com>
Date: Sat, 23 May 2026 07:27:53 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
To: Boris Burkov <boris@bur.io>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522212020.GB3282973@zen.localdomain>
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
In-Reply-To: <20260522212020.GB3282973@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/23 06:50, Boris Burkov 写道:
> On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
>> All of these were discovered through auditing the (mis)uses of the folio
>> API throughout the kernel; I haven't been specifically reviewing btrfs,
>> nor testing.
> 
> I ran this through my btrfs fstests setup and observed no regressions.
> However, that is on x86 systems with 4k blocksize so it was not exercising
> subpage block size directly.

BTW, on x86_64 it's very common to go large folios thus going through 
subpage routine.

E.g. just doing something like "pwrite -b 64k 0 64k" will create a 64K 
large folio thus exercising subpage routing.

Although a 64K page size run would definitely help.

Thanks,
Qu

> Which means the revert is still relatively
> untested. I'll try to get a proper subpage test done if Qu doesn't beat
> me to it.
> 
> With that said,
> Reviewed-by: Boris Burkov <boris@bur.io>
> Tested-by: Boris Burkov <boris@bur.io>
> 
>>
>> Matthew Wilcox (Oracle) (3):
>>    Revert "btrfs: fix the file offset calculation inside
>>      btrfs_decompress_buf2page()"
>>    btrfs: Use folio_put()
>>    btrfs: Remove use of bv_page
>>
>>   fs/btrfs/compression.c | 18 +-----------------
>>   fs/btrfs/extent_io.c   |  6 +++---
>>   fs/btrfs/inode.c       |  2 +-
>>   3 files changed, 5 insertions(+), 21 deletions(-)
>>
>> -- 
>> 2.47.3
>>

