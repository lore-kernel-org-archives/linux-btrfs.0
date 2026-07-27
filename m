Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19287175A7F
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Jul 2026 05:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785130302; cv=none; b=giXWkXkNW4GKWMzsocc0LLuYmj7Nz2eJXCGR3WDpNI6U7RpIhVYtYHb2fjAGvOj042qZqkOXajg0Se59l+c//jn490sZhmq+SxJZvo+BkYRL10rQLKGHMJF2s2YoMXQPtxcxQNyJuOZm/LMP9F5McRgUHtBuc9ozqceC6HvyNss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785130302; c=relaxed/simple;
	bh=h/YL0bWzYEgfr9XBzNabpfIj3Xx1ByScwmBgY5lQ8es=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRUR2x9+maqna/+/gsROjhrdfSUz+AgJLPB3DdPhqv/335bTo5KE9v49hXDP8/pCD19tAh/ghPgpNZgRE1fuIGHw19cPBLDPsTcf9EtTPmRF2n7PirOO7hIkUNjc9E0gMSWYvOi3gMc3MoEiZfNVnpfXTqt/BJPQw1bvztsIpFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GmZejt4x; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GmZejt4x"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4955de8797cso13402065e9.3
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jul 2026 22:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785130299; x=1785735099; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yMruQSgv1kdxoFQHK2U/teoihRWxOBdv1nYc0a1veP8=;
        b=GmZejt4xX1CUESDFFfrxdfl1zS2K7lv791UefP6e7FGucERqYVn8aP+71axoBWQFOL
         AVufcw+/XS1tpNbLh136VlzmGqjRShats5TOxVBrcNVMkNDKJ/1OC9Yg1mocdFfZi4WI
         olktsUbK+NhVwZhYrQFA0yiLJwwZh4OvnhhDFa4SDJGEPc4Sn95UYGynKhnatP9FSgeR
         tKCdGPwHPXpySBt1ixufyhuBUOkqoCQb0T6o2mxZNYZmsUGXKAPgsScc2GwtSiHKJxjr
         bunf2TK2rihPa02KLa65c0TLjYY20C4qFEeamvVYLvo2N/LR0JGA1uimzPkA9X2voPYj
         4VmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785130299; x=1785735099;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yMruQSgv1kdxoFQHK2U/teoihRWxOBdv1nYc0a1veP8=;
        b=FscQi45B8ALEXV7Zt9bg4rsM0IZZtcIvq21kwRSQ68fm0pRq3fH1TgwoO543Z7vxQw
         1s3Oaty2fX7hIRWeDs6ZTYxWatYs8l4fcfvQqQjpIKfRehmkt/rdNif706Z7A027bZk6
         rJdQcACca/9wibSkTNlmo+XdOHOCHtnSVBZ/MN0JQ2KqmE2DKxQFSOe8mx/ijoIZmICy
         172VQR74SLvEwZI+4+gUVhKtp8Xwc9AjTrW6Sg5zEbQF5A+D0QeZtPCHFDnrJZiSg0nT
         Oe152Ybb03XLcrlfKiRzW2QPBCZFoqG7kBDJ0r225CWU8f/QVU+fBYoRAghU9GmOZyYc
         77jw==
X-Gm-Message-State: AOJu0YxC3Y+xHQ0SUGJ+QN9uHBvqmD1TezjV2irV8wKHbkzXNEcDsRHR
	dyWWWK3DKrTPDeziA77HEdvPfQLGiklln3/AGQrnMllOFKxARqZIhDkHNgDd5QnBhAY=
X-Gm-Gg: AR+sD13RqckTGu5F/Mlb+y5o2KVPvHoYKOgyeyaV8QYpIzu8W9neJlpXKeTYr+qUTAc
	agWCsxk12h8bXB5i/ZLINla6nUxGVW6g3FySFt5uvjsmMGP5hxjo2srdmFOZWSKS+CEThZF3pjX
	C0gK+BMCYHdElipcR7kzoybrLUIFHNqXQLDgQAjvWUYoI9UdjLcf1OovQWxCjYu48frKTpdUFyy
	gsnrRKDulE/KEwrDRG80m0EwAyF9YwswMZ+EzbVQ7CmzrsPjElOhsxHe8pVcvC+QEwf2Zlt/PDP
	GVFt8of0lAwxyA9J0NShm/RX1U074xL6Wl4ufaeUPoibUBZih7XyF7N6un+SrDVaC7jOZypwVMl
	Hs+ytXyWyUFs2kY3EQ7mrMn3AHIdbw7VOK6Xs8USJsEF+xjuepGr2X3npg9TEaNBB26//Mt+xxm
	EcWACxtQ==
X-Received: by 2002:a05:600c:8485:b0:495:6713:9aa3 with SMTP id 5b1f17b1804b1-496b57281d5mr89135535e9.30.1785130299311;
        Sun, 26 Jul 2026 22:31:39 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13d130a8421sm46386692c88.10.2026.07.26.22.31.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Jul 2026 22:31:38 -0700 (PDT)
Message-ID: <eb9c30ad-8c19-4788-83ee-d282ddbdfd97@suse.com>
Date: Mon, 27 Jul 2026 15:01:32 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] btrfs: trigger cow fixup via dirty_folio()
To: Boris Burkov <boris@bur.io>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <6758d4f27be0bbdb865cee7dd5adc435c969f4a3.1784960646.git.boris@bur.io>
 <dbb0e4ec-cdce-4852-9c1c-21634cc6fa4e@gmx.com>
 <20260727035702.GA302657@zen.localdomain>
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
In-Reply-To: <20260727035702.GA302657@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/27 13:27, Boris Burkov 写道:
[...]
>> Shouldn't we also check if we have cleared the last fixup bit and clear the
>> folio fixup flag?
>> [...]
>>> +void btrfs_folio_cancel_fixup(const struct btrfs_fs_info *fs_info,
>>> +			      struct folio *folio, u64 start, u32 len)
>>
>> Why not let IMPLEMNT_BTRFS_PAGE_OPS() to implement all the fixup helpers?
>>
> 
> I think the level 0 answer is it doesn't apply to metadata and the llm
> also went nuts messing with the macros when it tried to use them.

Right, metadata doesn't need such fixup handling at all, thus we will 
need to split the set/clear into (data|meta)_(set|clear)_func(), which 
is a little overkilled for a hot fix.

Although it would still be good to implement something like 
btrfs_folio_set_fixup() and btrfs_folio_clear_fixup(), so that we do not 
need to expose btrfs_is_subpage() checks.

And we can integrate the fixup cancelling into btrfs_folio_set_dirty() 
helper later, in a dedicated cleanup/refactor series.

Thanks,
Qu
