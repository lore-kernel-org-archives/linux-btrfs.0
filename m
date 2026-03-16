Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84E8221540
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 09:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773652570; cv=none; b=I3Em7hxzRUFn9TZUDRJ0PHWnNGA0mDe9mZ55Asq7cc0IwmDl/N8fdOdkxwOGLpCeziCmg/rvKLjpt6Mb8jYAAIpyVCjtVCdVjgxKcr9KdH8K8KwjlsCDKWVvAW5aFs/n38WI9Y5OJmWRraBy062lK4kpuZA4FpWD5JKefcXPWck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773652570; c=relaxed/simple;
	bh=pWnwZ0Su5651P2WkDIDcPLluYKUQqRIGgEhm/OAeOs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnuYjGCak8xyRmLOa7MUAKYRiGIVexrPWWf0+whF3RFWqu9SdM+MEBWmLzUZTy12beGeL2iQEYhgaEf7uKelIbrd7w+L/hT0cxe8NQpGiKvy7tire9DMD5tU7s9vobBrD1u2fu3X15UlY407AagYHqpBkYe9fTgjMryJu10/vF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VbMjgWBf; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VbMjgWBf"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-485409ab264so29714455e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Mar 2026 02:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773652567; x=1774257367; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dG/DOYJMCxdZLinfQNIwkCkskPXk/oHzt01oCJ+Q+fQ=;
        b=VbMjgWBfOh+QZ8x8Ifmj4XlU0nRAfDkYh5lfxziammeYb3VssyaAs/ICkkAt2c54PL
         yZWJFCB3eigvGVvlasc+xsoQXP4QSTO6nIMw5h+PmLrTPKzZtJi0UWXzQWRiqrPwZaZZ
         87MorG91/ubyxKt26UN9A0bms485Ja+HIGtuw/9GkZ+Cd/4yRKf6Xg+6twGwBAK4s6re
         iYgytitZvJSSs0sFZSn/07wNyWVyhyKFRc+9Td292xqfKDly5TDQF8IRTtL83jXl2jX+
         JZuPtdIKLuvnKI4YsdiIMBloEApoWbY1g38+xwzwqDtvUrICIccNHuoqXptJWxoofNpH
         1Zow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773652567; x=1774257367;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dG/DOYJMCxdZLinfQNIwkCkskPXk/oHzt01oCJ+Q+fQ=;
        b=g3FVARVomLDxHpawZekjq5B4SEG/mjbcccT2+0jp77Ag4tAoIQ3ob3K7qR1tJZN0s9
         4OYZEZH6Wne9kTrDi8DRpVaU+P5JnaGqUJGUscwY7vtK/cd5rbstdq5D+FR6U3eRwuPW
         Y3aiV1b17UMg1Gn5QV2kKC8+mtSjtjhdnonaN2Zkz4xL4II+DkpqKmgVra82iZfHng8x
         LzYUsjHX5jaCzqot6BbKTGx0eD3rviFI+WzNngmMkdfoUe3ZhNGYwjd9KhDZ/Yju6EIb
         0xLnwNtgZ75BO4VL0XDOZx5M1c9AkxBrWX1C49xtJHOc3GCrdM6ZyMUCRGHyCm3IZwAq
         Loxw==
X-Gm-Message-State: AOJu0YyRK5RoybHrkByZn1+Ty45R9rTHueo5qaE9NnPDCQCPLolI0ikZ
	7XWHkDJXLZALDeYO+ulI/m5P/qNlWAj4ZIlknRxlbiW29tIn4uw7jDhJR8Dx2YD36xhBoJ1/9QT
	lyqUkAtE=
X-Gm-Gg: ATEYQzwpZZlV5t9RtUpNtZQeCfX3DtJcDiWEhDjBMpyUCf3Jvreo0KjmNFRKd/kmnGq
	qHhS5JQSzs3+LtaDNeFXZMtzelOm+x+3+D3KVaIT/GKDGf2igBnrJu9VVJxSJcAKzxiTrjFPkhm
	Hb0FvPX2xorx2carjOvXF+67rN1u/j9nvkDfIdXUQ4UQEyk43yYgwZX5fZu3hpcjnNqgcA9Ot81
	gcSl2xEfmwj74BKB5+yG/mmgy7Ztl9eb81ikbyrYxARySuL2eTi3Q76WrRhdcEa8eTzYDsKwu6t
	cuAZNuBL0CayEDfTcIaHucJH7gQpqmmh+e9/67kEynIzrlhzPymfcSzaUFumAWejrMHqjGW4EU0
	lsR+OfCJ/68e/PZnVg7MN99HJLhNsHXlUwg5LxV65lDe8YuBUJZL/SMqZxlItHpf4yGJRQszExI
	j6ciemkHLN6jSihYNVEaAScuteoFmqUiY+9USijfR4EQJtHi/1gg+MNsDfXPfmcw==
X-Received: by 2002:a05:600c:3b08:b0:47d:52ef:c572 with SMTP id 5b1f17b1804b1-4854f561af1mr259819715e9.1.1773652566869;
        Mon, 16 Mar 2026 02:16:06 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b05bed495asm15418765ad.17.2026.03.16.02.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Mar 2026 02:16:05 -0700 (PDT)
Message-ID: <65027062-03c6-4da5-9e22-dd1b1395b30c@suse.com>
Date: Mon, 16 Mar 2026 19:46:01 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] btrfs: move some features out of experimental
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <cover.1772162871.git.wqu@suse.com>
 <20260304035752.GH8455@twin.jikos.cz>
 <a19ad870-a52a-4e26-8ac7-cfabfb4a5e4b@suse.com>
 <20260316085810.GO5735@suse.cz>
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
In-Reply-To: <20260316085810.GO5735@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/16 19:28, David Sterba 写道:
> On Wed, Mar 04, 2026 at 02:34:32PM +1030, Qu Wenruo wrote:
>>> Adding all of them at once feels a bit risky. I don't think that it has
>>> enough exposure and testing because of number of the possible
>>> combinations.
>>>
>>> The shutdown is orthogonal to the rest so this can be enabled by
>>> default.
>>
>> So can I add that shutdown one into for-next branch?
> 
> Yes please.
> 
>>> For the rest the bs/ps is namely an ARM thing with the 64K
>>> pages,
>>
>> Thus I'd say it shouldn't affect most end users (if any).
> 
> AFAIK the 64K pages are used on big machines with lots of memory and the
> support for 64K/4K combinations was needed for interoperability. Yes
> there are users.

My point is, the newly added feature (bs < ps and that bs is not 4K) is 
not going to affect anyone unless they are intentionally creating such fs.

As all existing users are only using 4K block size anyway.

For those big machines/main frames, they won't suddenly begin to use 
8K/16K/32K fs block size, thus it won't affect them.

But if you insist, I can also drop that all bs < ps enablement patch.

Thanks,
Qu
