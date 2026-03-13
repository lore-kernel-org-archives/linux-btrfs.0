Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234D5382392
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 21:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773436401; cv=none; b=Gio/w9je4Y8s+t7+UyIG+P7B96OKsUQU67LdegJpGkaae/UjZaMBBN6YWrRGKNDhXbTkGyU8eNhxRzP7YJb19OW2RW3OxuQ5y4Kj6WcoMjx5Wpjqpr2HF5gkuVnFDkSDtvVQizSYnM4LWaq+QMmtSZyH/FBjuJhFy6xfQLJ1AN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773436401; c=relaxed/simple;
	bh=TRCrN0LvTLbVYn+uQhcjcd5AjD7Dke+okf0Za9UeZpw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AN7LFaN3Gy9F5PkQ93fHbh1KNeHK/Yhq5+LU1Lpws9OAdNBEQ0gtIcJn9gDu9aAF1/LL3qJdL5vPG7awVP8/IcXIfFpBNbZd2Ia1oCkOzXROawvojhG1ijulXyFJbMms2SQpvhUtCdxc1LEu/rsbzhGUiJ7kzZgmwsnkDOSs7bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NiPiBAd6; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NiPiBAd6"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48535a0ef86so21819225e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Mar 2026 14:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773436398; x=1774041198; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rhZc4u3pbqODB7oTivHIB5tOwR6xc6+a8ijONTmr6ic=;
        b=NiPiBAd6gCSdiUda9RNLzHT+L6bWsd82+7ecxjyJGK5r9FU5W24ELEU7dDd2qRj0Ru
         D/3Du1Nel68dCdYiATCeIqiEPEcP0mpgPHqW1INR0gP+MPz5guDrQYzocRAL57QzFYeJ
         MkA9CeQr/Ics4ujWiheiktubcUtU8bFtKUeE1KnehlVyIL00uV+vWZJ5S82aLC5nc9dd
         DTtpU9aMrt52bUttLxvHn9rZuuU28xRHytJdQfL6CM3Babu8Ow72a0yxaKeuCIzsOpio
         3lkL5jHVs0GjWe+VVvL1unnN81NVqo2K6me/5v2ZVSCYMERohXEmTvNaySi4WUQzky9I
         fHoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773436398; x=1774041198;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhZc4u3pbqODB7oTivHIB5tOwR6xc6+a8ijONTmr6ic=;
        b=Wno1HDHZiWiqk6hIrHqSLQodvXqcZVFFi0tgQ9SK6p+7+rof1q5E7eVGepaWJaKzPX
         3EtUoALN3f4zEdZlrvFbbFE5qvEfcTlH0N2pAQt+tp3fdGPzYRvTQC/i2A7TyCSUnkT3
         I4Cl0UVS4b5C4Eyx+50c8KnFYGEIK4YJrvWXImL33OIpWywPewGDltPzoPhd2YKj8RCV
         Af2hRG2M9qEG4SDPC8o73FaeDD9olb85zpsPGZP3LjiywrHgT3BbhofoLh0Z5brN/3Al
         fJRQaMGu4yRhQ58RGkOm//2wcCmO7Pzo6I8h4bAZe0m7YZYTpfDYCP2Y099gdh0j9L5+
         ppNw==
X-Gm-Message-State: AOJu0Yw+e+2aGsdtz2KY7ey3hCCBPfGKbeq9QFBJxuzvejWWCmQ+4J3K
	omPtXhmhIQedSmHVoFrL1Iv6RaE2wjn3t4FT5+SIbBPF/hykL/aM1ZEKCV+1ntKZe6I=
X-Gm-Gg: ATEYQzwaiBNUKGbMId1vNuUiFSRIHNMSMZM9e9BpGW/2FO/qNnDP6AUqrQ9zO+d+cpH
	osyO8YTqH7EENgLzUaOZv9z7v2BjJ5iwYn2r9fYIPgr4iZUR72iLbZdsP8aWbHyW6ZLw/UxGPxJ
	3N9uZ4WWvVb43Ph+l78agmGtJGWrKbuJWoWJT2yDg60cu4wMyrfWA8u6R185fsmqPm1j97H4DVK
	38XmXHv9dPaDYa7LVHhgJZqY5zpilVQT2cB8aYLsCf1aUpGR5HOS8v5pvSoq/PT0wxhnHUWTUV0
	idF+Kfmn/SK2MFXOFBfRKoO4xFNiPSUx4CdTyerazg+aF8a7wc5ptMltsgXF0SB/7cTp64DnhRn
	z2B32tNYgsgYhsntKnCvFLKpQk08JlzNAqeouRo4jZXpL/u0w8JFM3lkNL/QM/ZAm42tBiAkSsa
	OGN1H1JdvxYuMT2iq2g4LO3pUmuXZh6L39P5A7jgLZK9EIVWGD05U=
X-Received: by 2002:a05:600c:8b2c:b0:485:4bd1:4c7e with SMTP id 5b1f17b1804b1-485567148e8mr76437915e9.33.1773436398136;
        Fri, 13 Mar 2026 14:13:18 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a17be605asm7630704a91.17.2026.03.13.14.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2026 14:13:15 -0700 (PDT)
Message-ID: <17eee229-5539-4d61-ac77-0ccc468a1f4b@suse.com>
Date: Sat, 14 Mar 2026 07:43:11 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] btrfs: output more info when duplicated ordered
 extent is found
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <cover.1772874800.git.wqu@suse.com>
 <9568c0c9f72806be005a8ab7c35201229518af2b.1772874800.git.wqu@suse.com>
 <20260313193847.GJ5735@twin.jikos.cz>
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
In-Reply-To: <20260313193847.GJ5735@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/14 06:08, David Sterba 写道:
> On Sat, Mar 07, 2026 at 07:43:37PM +1030, Qu Wenruo wrote:
>> During development of a new feature, I triggered that btrfs_panic()
>> inside insert_ordered_extent() and spent quite some unnecessary before
>> noticing I'm passing incorrect flags when creating a new ordered extent.
>>
>> Unfortunately the existing error message is not providing much help.
>>
>> Enhance the output to provide file offset, num bytes and flags of both
>> existing and new ordered extents.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/ordered-data.c | 11 ++++++++---
>>   1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
>> index b34a0df282f3..bc88b904d024 100644
>> --- a/fs/btrfs/ordered-data.c
>> +++ b/fs/btrfs/ordered-data.c
>> @@ -253,10 +253,15 @@ static void insert_ordered_extent(struct btrfs_ordered_extent *entry)
>>   	spin_lock(&inode->ordered_tree_lock);
>>   	node = tree_insert(&inode->ordered_tree, entry->file_offset,
>>   			   &entry->rb_node);
>> -	if (unlikely(node))
>> +	if (unlikely(node)) {
>> +		struct btrfs_ordered_extent *exist =
>> +			rb_entry(node, struct btrfs_ordered_extent, rb_node);
>> +
>>   		btrfs_panic(fs_info, -EEXIST,
>> -				"inconsistency in ordered tree at offset %llu",
>> -				entry->file_offset);
>> +"existing oe file_offset=%llu num_bytes=%llu flags=0x%lx new oe file_offset=%llu num_bytes=%llu flags=0x%lx",
> 
> This uses the "key=value" format while this is an exception in the
> messages. The tracepoints use "=" as it's main purpose is to print just
> a list of values but messages also contain other text. We should keep it
> consistent.

Got it, will go using the existing "key value" style.

Thanks,
Qu

> 
>> +			    exist->file_offset, exist->num_bytes, exist->flags,
>> +			    entry->file_offset, entry->num_bytes, entry->flags);
>> +	}
>>   	spin_unlock(&inode->ordered_tree_lock);
>>   
>>   	spin_lock(&root->ordered_extent_lock);
>> -- 
>> 2.53.0
>>

