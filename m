Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423F2156F45
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Apr 2026 00:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775088922; cv=none; b=V7D/x5fCFHwL2pWiZXrl8pEwd/7850jnFrKjRZaBGvlJV8OK7Dptfc/RNqDdMoMIHR/iBw/kIM2FEuWHmPx37B7G5ux9qV00pP6lN5/2XuLmFbf3veupRUkgguWgucMKK7DZT3uNZKLlmb5c4rOmBAFzf/iKDBA1GoSnG/Oaang=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775088922; c=relaxed/simple;
	bh=A4H+K6CoCZm/iNMj45y5e3K6i6MjrwFDaw7bRiGzaHw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=KJanmoX6JPQYXPjp9BRolU3r4Nv69f0XMX0ZuMtFs3GTPRWatwsEP2WH1atkDDsMB4tDARt9HvElOVhYggWxewKsiyt4LIH99P8sZS/wsqA17lBDxrZoyD3iA9yH3Qcm5QPlgpZRgJn/uYG7xgxEAduvKrugWqkpSS4xiJ3FpD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PoprTHry; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PoprTHry"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-486fd3a577eso2164815e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 17:15:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775088920; x=1775693720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=6RGj/woJaQ/hBTYj3X9awXRvxSE6kw2GnlBiID8Wk78=;
        b=PoprTHryekTKKLe7asZcdcW68rpPFW5p7zjec6UOcrhdCSBAXedpErJtd7UDOQf1GF
         em/f597PF3vIZKrqpbF+GSlkre4okw8uPXMwbSsP9l0o7qTunWrlsQqbBzra6G2FqnKr
         O4GkTqRMSruzPd9rJCWwqI8flfhv70n3e3TMd15MI6VdREb3fHQebm9hlOvLKFbnQ69j
         DM0Kwr4SGyNOav87i680yeCbda7iUix2TASJ5JFC3Gk8FZKr/xcp750+qcXjVOXvfpPg
         +3VTieX+C5SVz0JNU4nXWPNO6UlxuJVdzO2iw7ml+sTRVxJC37LnnqsT6mkkdhfs1dG2
         bY8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775088920; x=1775693720;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RGj/woJaQ/hBTYj3X9awXRvxSE6kw2GnlBiID8Wk78=;
        b=ohPjYhQjEpG94qAvmOXeSXi+HFgIOY1ADR5OhNJTKMb5eSXokqc7eBnveXpPLU+78d
         0fWBegYL0+d1D+C33IH23l2k8JLFBmd+nvC9iYW3KRWShgKrlH1o9J0SaL5qyFBuP4Bf
         7tJH9gtCxrhK/QxuVfEuStEgYpP31JXKEVssKc6qQ7eyh1s2vqbfNONB1FD5n9bIQSaQ
         V8+vu3wLjdSJNf5G9D++rlHhAtU09co6lVWPtQYhdZCi3rKGa6TWVk0Otxnko20yGEy2
         9YgUJ1KUYQrzGEbyFN5tJwDBqCEMHrnvlKkvDz9ELFZt40v47WHXpDUkwZ1zhYlkfGHB
         QydQ==
X-Gm-Message-State: AOJu0YxpJE0NxsgWNQ8R4581cbwb/P3IocCQwBZdaYIw69xG2J0xHFcX
	XRwYqhg83ydxk04K+Armza3SmDc4CFH0r6JPOVKWZgZNtR6rmx1/asWX0vrQFUeHYtdsonxa9kM
	tBl4jVYE=
X-Gm-Gg: ATEYQzw4oiM4kDt/0l3+IEybS/WhKrc04qrUmVPfuE4CltI10w6A+EN71OEiGxo5wYx
	+xktV1ASHHe2uELZPStBYqous9bdmqy02JOqGQUTwR31PhYYdjXjtdKgRintBC4svHDc2zJGxLW
	QilRnppH5IVEUcHy7D2Deh90AMmAyN4Yd0qkG8NzfR7YbHYFO6rWL0A+Qvn4GnY0dB6Lhg3FboO
	DhSfKv9ruD4Zud2AKXOSMC1Xel+GDAvug3b3nS+2DHtwiKPy4/Is0BrVDeaxzxrJeCBo4HU3X5r
	ss6jM4/78lF0cLUadHYCJfAkm45PZH23mYUMnkZkDUBOtgQiBjirfrYMG5+crSFZSQfsUzyMacZ
	8UODUTmCzbkIHa0+FJ+AVrSHm6nJc0veY/s6VXep91qUG2dHKasM+GtQrVUzgHPrxGsc957ZnD1
	7vqnbWl16/JojpBztvJ6mZ4A16Y1gUZFdTU2iW1vavqagUMO0r00/MrX8kesQFPg==
X-Received: by 2002:a05:600c:4510:b0:485:39d1:b500 with SMTP id 5b1f17b1804b1-4888359d2f7mr98722075e9.16.1775088919495;
        Wed, 01 Apr 2026 17:15:19 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76c6563ce5sm949479a12.21.2026.04.01.17.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 17:15:18 -0700 (PDT)
Message-ID: <5f86e25a-00f9-4d48-b046-8ae93965f07d@suse.com>
Date: Thu, 2 Apr 2026 10:45:14 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] btrfs: delay compression to bbio submission time
From: Qu Wenruo <wqu@suse.com>
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1773953307.git.wqu@suse.com>
 <20260401225257.GA826348@zen.localdomain>
 <987d1e01-50d7-4877-b55c-62191b12754d@suse.com>
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
In-Reply-To: <987d1e01-50d7-4877-b55c-62191b12754d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/2 09:59, Qu Wenruo 写道:
[...]
>> So
>> we are breaking the contract "OE <=> allocated space" to allow this. I
>> think making the absolute core of the improvement more apparent in the
>> descriptions would be helpful.
>>
>> I think one thing I still don't understand is the desire for the layered
>> bios/OEs instead of creating the same delayed OE, but then as we do 
>> the real
>> allocation/compression and discover the actual ranges doing
>> btrfs_split_ordered_extent() like short DIO writes, which seems quite
>> similar. Splitting/joining feels like a much more natural model for
>> ranges like OEs than layering into a tree. As we discover the sub ranges
>> we actually use, we split off the real OE.
> 
> I can definitely work towards that direction. Although my concern is the 
> OE waiting/start part and error handling.
> 
> But so far those are only concerns, I need to implement the code to see 
> what can go wrong.
> 
> And if no major problem is hit, you can see a v2 with the split solution.

Finally I recall the challenge using btrfs_split_ordered_extent(), that 
we can not split the OE in the middle.

E.g. we have a delayed OE for range [0, 32K), then due to whatever 
reasons (e.g. memory pressure), we are forced to submit range [0, 16K) 
first, then range [16K, 32K).

Both go through delayed compression, but the range [16K, 32K) win the 
race by failing the compression (bad ratio), and fallback to 
uncompressed submission first, before range [0, 16K) even finishes its 
compression.

Furthermore, for the range [16K, 32K) we do not have a large enough free 
space to fill it in one go, but can only allocate several 8K sized extents.

So we need to split the [16K, 32K) into two ranges, [16K, 24K) and [24K, 
32K).

This means we have to split the original [0, 32K) extent into [0, 16K), 
[16K, 24K) and [24K, 32K) ranges.
This is not supported by the current btrfs_split_ordered_extent(), which 
can only split range from the beginning of an OE.


I'll try to implement a version of btrfs_split_ordered_extent() that can 
split the range at any offset to see how things will work then.

Thanks,
Qu
