Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A377D383C70
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 22:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776117798; cv=none; b=MJNos6WYNIgJDg8lHYhNsxfugR45L3YEZ+QHcX/v0y/dFhFrYbPrUQwRcwMxeuaRvfC9wFzErj9NvsuUfKbRgatbu7FOYQJxRI7/XPkwrhrq4WsRYHYstqC8NX7tecqTjgsJb34rXQ71MANLI4lsrXN9mjn122h4SiVrIsx02vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776117798; c=relaxed/simple;
	bh=sZS6DnmjipR85ft/Er1YeYxWoNkh+3f9i5lPS31G8Ns=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=MCavKaRYJ+2zq9H3F//WEl/kgmgc/JtL3NgXIOKE3oyKb13A13uO8wgaaE0NEuHYJcEdBaG6buW3Ap0aWLUbS++5vG2jmyYrRuHDF8lwBEIvNEFEVAkbu/+59zci4kHtgltdoHJoLcEoPnlbp0RYq9RWiHziqbGNjAQVG9ONtXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E4TD0bD3; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E4TD0bD3"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488b0046078so48571345e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 15:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776117795; x=1776722595; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=osfo5jYaBQFN1KhZF15eNE0NSeTUu4oAy3k89/LKO+0=;
        b=E4TD0bD3YHMMy/Gc4Yg7ZRMjMKwTRlB+hC1j+Cd52W6Zn5y1I70UyMeROe+nmGwT9Y
         Jo1Rh2CqvlIWTMgGUSpdQXxCzJnFau1b1Buh2U/4DOgcxqhJEP9pxFTzRN7Nwdm9M+Pd
         ad59/BpH5J4NgwTkiEaS7jK1pKKhV44CSOmJe7YatyZn29t2iGFjs5qNld++dA5xPmiu
         F79wGoZx2iQA5wzpU49jjJ0FKtg60SAtCHdM6TVFCPYDkJvJN77u9zE4Ux/3gatUF+b+
         k2xLaOZZI/IXuKcz1gAzHsYKJ1vN85SCyJ8S/8RPIKkYcB/uCZV3Z+XstDglufj3TZii
         e82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776117795; x=1776722595;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=osfo5jYaBQFN1KhZF15eNE0NSeTUu4oAy3k89/LKO+0=;
        b=gZ3ydfWKdsF1VGGQPBBhyCxGNw3KQVi3dFq9CxtBgIPMv+gkw9OMRZKAYibkVpH7oi
         M7e2e40q7KC+XuRrgvB0Zry5T/3QPOBRM6d2m+oK7KjLVg/BH0AkhNzma2yU4Z3Oxq18
         KiSCCqcebKxDp+0D2D8F1WWeJJqapIhZGH0/Xqd1DEtXLVxgY9J2jMitQ2lQQwXlbZON
         3oBFKYBWaGfCJZzhewHH5JdQ/GbRHlOVPGHjSoYkpUUwa+XZHCObYojMW43g89AQweeu
         i6eEFcshp3WBoMtpgIjK1uZsdTpN0KOH6ykx0ZXCatvLYYp8MzhIKDmBWlC5Nz9l55wl
         ROeQ==
X-Gm-Message-State: AOJu0YwTlYTCZ+B++DO4k2V2M0ujFd8XiO0jCXRjBeEypXc2l5GMEP9C
	OTArZdiR+szoY2t/wp5BAEktL8g1WOn8CCGP3u2UZmSQa0g75/4q0e1ZaKO+E2Yc2pM=
X-Gm-Gg: AeBDiese0m4J45xIUDG04Rhatpr8MIzgfY84xtk8YFFqFVUGffxRM0RZYMs/euAl3LF
	9JPTbr4paoD/Obza04PpFcsKvP1oV1p1500c+gDtja8LVxfrA/02q5Lqg8uPIVh9uR1K82OD4dz
	IPNEAvijVR0Cymx/dY8HAAuMJhPywXVP6hahtJbQVPwqmzvqCWL+rq8fNy6L5FYYFFmqDNS8cjV
	09D+XitY4VVsZ8YUdeH9O7HH6LGK1TNmra0I0A9zOFJNzIKHHtwSNkkcIJUYNDq54p1wRkUZ0Cx
	khCqqYe/ePEvU11CE1+rI01RbgSUO0nk9I2FqAw/hRnAZuV0H/lXLKCuubsgt6uMrMzYo7vmMbb
	e4BD/SE+FCpSDRHO8mBO0Efwi4mT8JDjg1WDfzMWc/kQ5mLA1B9ZfBNRU4y81ZH7xBfExUVlsrG
	Gk0nfXZs+g/S0OPqW5k8/KjfRkF3uol1wdwc9r6GWvuJVzpivmKpYzBoXz4BZITJfJyFoV/XZO
X-Received: by 2002:a05:600c:1f83:b0:488:b99b:4177 with SMTP id 5b1f17b1804b1-488d687bf61mr202012285e9.25.1776117794880;
        Mon, 13 Apr 2026 15:03:14 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c79219cbc21sm10050515a12.17.2026.04.13.15.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 15:03:13 -0700 (PDT)
Message-ID: <272312c8-f86f-4609-a4f8-0e71ee18ef79@suse.com>
Date: Tue, 14 Apr 2026 07:33:09 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: DEV_STATS item related minor fixes
From: Qu Wenruo <wqu@suse.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <cover.1775553952.git.wqu@suse.com>
 <20260413185907.GG12792@twin.jikos.cz>
 <e79dfddc-fcff-4e16-8964-9fcf777dd49d@suse.com>
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
In-Reply-To: <e79dfddc-fcff-4e16-8964-9fcf777dd49d@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/14 07:28, Qu Wenruo 写道:
> 
> 
> 在 2026/4/14 04:29, David Sterba 写道:
>> On Tue, Apr 07, 2026 at 07:03:57PM +0930, Qu Wenruo wrote:
>>> [BACKGROUND]
>>> DEV_STATS (objectid, not type) items are storing the error counts for
>>> each device. It's updated every time an error is hit, including
>>> the following types:
>>>
>>> - READ errors
>>> - WRITE errors
>>> - FLUSH errors
>>>    Above alls are all errors directly returned from the device.
>>>
>>> - CORRUPTION errors
>>>    Aka, checksum mismatch.
>>>
>>> - GENERATION errors
>>>    Metadata generation mismatch.
>>>
>>> [MINOR BUGS]
>>> Recently when debugging an error reported about rejected dev-replace,
>>> the device tree dump includes a DEV_STATS item for devid 0.
>>>
>>> I'm wondering if that DEV_STATS item will ever be deleted, but
>>> unfortunately it will never be deleted.
>>>
>>> Normally it's not a big deal, as the DEV_STATS are normally all zeros.
>>>
>>> But if it's not, and a new dev-replace is started and interrupted, at
>>> the next mount the replace target device will suddenly inherit all the
>>> error records, giving end users false alerts about a completely good
>>> device.
>>>
>>> [FIX]
>>> The first 2 are manually removing the DEV_STATS items when dev-replace
>>> and dev-removal finishes.
>>
>> The device stat item is expected by btrfs-progs even if it's just zeros,
>> otherwise the 'btrfs device stats' prints just 'no stats found'.
> 
> That's not true.
> 
> Firstly when btrfs is created, there is no device stats at all, it's at 
> the first RW mount we create the dev status item when initializing the 
> dev status.
> 
> Secondly, all device adding ioctl has the proper update to force a dev 
> status update, thus they will properly have one no matter what.
> And that's what the older kernel missing.
> 
> With those features guarding the dev status, it's pretty safe to remove 
> the old dev status.
> 
>> This
>> has a high potential to break any monitoring tools or scripts. So please
>> don't delete the item, and create it empty in case it does not exist.
> 
> Please give me an example where it doesn't work.
> 
> The only situation where no dev stats item can be found is for the 
> unpatched kernels with offline dev stats query.
> 
> After a new device is added, no new dev stats item is added (requires an 
> error to create), thus it requires a new RW mount to create them.
> 
> But before that, there is no such stats item, and offline dev stats call 
> will not find the item.
> 
> And device removal/replace won't change the situation.
> 
> 
> For kernel GET_DEV_STATS ioctl it's not a problem at all, because kernel 
> always grab the numbers from the in-memory structure which always exists.
> 
> Thanks,
> Qu
> 
>>
>> For the wrong stats on the replaced device the stats should be zero from
>> the beginning of the operation.
> 

Nope again, as I explained in the patches and above argument, the dev 
stats will be read at the next mount, for dev-replace target device 
although at creation time it's all zeroes in-memory, it doesn't trigger 
a dev stats update unless there is an error hit, so the on-disk one is 
never updated.

In that case, if dev-replace is interrupted (e.g. unmount), and there is 
an old dev stats item with errors in it, then at the next mount it will 
load the old records, causing false alerts.

Thanks,
Qu

