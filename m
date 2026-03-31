Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7661E378D68
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 22:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774994858; cv=none; b=Ev8HBkGeiHSRaSU2H5uxfnWyiLRVij+NqwE3qh4WA+KcXogrAmll+FB+3c5FT1ptI3Jj28uwSdg4cxlkl9xYmfXJeLOLlPNW3UzYo3cRMWVQ49sBRAR1fHR8NENCAk/IuLDg6Fpc1RkTI0injyCYNtMQHY3whAZ/y3CX0+ywd5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774994858; c=relaxed/simple;
	bh=OQ8ifO33E7I/IC07HqMARQa1c9FmkbjFdBTnMb7Y4f0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A9vOHSrq5b/W7I1M6smO8iusOR41lcu1R8QYkpClIYzJDMD283jfL8XGUwou/ML1Nex+RaJn1NHLUH31C+PmmJIkmaBuSlz+9rxCy7kffxto5IdMtNooi4ta63GfqPggNsIR/5YmClVCc4mc8jXn7PiLVun2056RM9m81gBMZxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FBKHZb0S; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FBKHZb0S"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso55519185e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 15:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774994856; x=1775599656; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtWdgP0xoa+D0hEN1wsoBAZ8IGBld57eBd7ys5XzaOQ=;
        b=FBKHZb0SUTLAboFiKqLGnDjf9b5FjRMNNlN0I0gQQTTYknLH1Zzju5o3wburhHmmyH
         dFMfqqAwJfUu98YSTTD/d2K2RbOMLn61IMTC1L3NkMZHMrPf879BXM5OMs4kzuVbKErl
         4/BBL8DuCINmJBRvSvwtSVrVz1HS5IaIegYkqJ+ipfOr7Adj+uuoH5acr1kgS02iu19B
         02d4kVmt2Q12t3ERj5yWoXVnN1PwjAjIwt3Xn/1YAaRPv+aa9Ff9ZyRI7SQNvkTzkSG9
         gLQbEsZRE0o08YiCsAPGfmfj5TbpUu/P8vPmthfawofJNQd2jaKpeqEkrLxLkxHZG8Gd
         oAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774994856; x=1775599656;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZtWdgP0xoa+D0hEN1wsoBAZ8IGBld57eBd7ys5XzaOQ=;
        b=HCTpJyGkW/01NQj08RdWTcy2KTRL6qLC29kTLz77e4teiwVIM94FbAC6Fud8wIVZJY
         rx7cfH0vLhhrbmp+kml6Y5NtHp1CKLZjifhw3n36fFWueKPXHwQ4R9KRNJ0xzKfTp9os
         hfpUOMH2/qMHe7OLqDkb/zA7C/4MtRP4vnrODVuhrt9vLcfJP7JlAjQCfiRUNHpvgbQH
         yV8nQNok8VysX272o/REuEDG9p0qXJL/IywzzIYcJdCXdcoekF7VoNlApA8lSQpNSO9y
         yn69V/DLJWPlOpCfTZqW4vIg6SPUXWTzqEPDdwZc/nNoLvDmTFGOUEpgmofKBJ6krrC0
         HWCw==
X-Gm-Message-State: AOJu0YzLmy/+NAKFcj7VV+KyMUMBwrThAeM25DQy6lW6Fhk4HfthQZZ6
	aQ674vdSdQ25T8NkJxjsciccwU3lMTrquFIQLLDBcEtE3Peb01iStaRZQ2tVp0feJIcd0vMySZU
	lPIZvjeY=
X-Gm-Gg: ATEYQzwWRYFA4WGAwYR/rKPKEm5iI91ATXCts0f09w23c3F/VzN8997mrBq2r9/jroN
	GQK6KYu7OwGND/A5Vn358Sj31WgrB3KyUvxf7qohHR8puzcsqy1FuXMcAhWMd+FWHvbwfCGZG4R
	ViIG/fEA18XH0tQNCrin/c0UZzPYg7pru7ifLSLGDfYjuM6JzLQE3Km1XDRUP+YARv1NbNW27GV
	rUmnNU8vIAPlQS1czSBsEPNBl6YlgYkuI4GQzN3soiQBO6u/8m569kWpAJsrqGmcQPYRXEkF3Kh
	qDOlBtXDSn8aZMJ+RcppuQ/OrRryGvss94ptNV+9ZzGpeawDZJGVmd2KTviDjBRUiY4Bv86WGXx
	UkS+otJj4E8Ky1Z7ay21STb+wSMl4lPK/OclwBFsUgQ4d4ohb+RmzLmYMwM3jZ8FsumxDxsAg+o
	GEzUyHG07VtHOJZHR5b24BJcS17NKrwCjuyP8a7dIQqZoantIy6B0=
X-Received: by 2002:a05:600c:4594:b0:485:3b00:f93b with SMTP id 5b1f17b1804b1-488835cd3bcmr18075255e9.31.1774994855772;
        Tue, 31 Mar 2026 15:07:35 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76917db47esm9802227a12.31.2026.03.31.15.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 15:07:34 -0700 (PDT)
Message-ID: <a2e56b07-b0fc-485c-8a68-2136e595ec3b@suse.com>
Date: Wed, 1 Apr 2026 08:37:31 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem mounting 4-drive RAID1 fs after replace was interrupted
 by kernel crash
To: =?UTF-8?Q?Jaron_Vi=C3=ABtor?= <jaron@vietors.com>
Cc: linux-btrfs@vger.kernel.org
References: <CAF1bhLVYLZvD=j2XyuxXDKD-NWNJAwDnpVN+UYeQW-HbzNRn1A@mail.gmail.com>
 <2aa4a94b-1f10-4b17-a78a-2a58efb56522@suse.com>
 <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
 <d470a043-72c0-4124-800c-385c19007b9e@suse.com>
 <CAF1bhLVahaWzAk3xXLdDSgacHjnMZLutbcP05zuxfTc3JuK-4Q@mail.gmail.com>
 <4f99d0c6-42a8-4d23-8cc0-48ff64cc8f4b@suse.com>
 <CAF1bhLWnf2CLnZ=BbBVS1je8a7LYacbKDAaLYNgFzY+Z1=L2=Q@mail.gmail.com>
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
In-Reply-To: <CAF1bhLWnf2CLnZ=BbBVS1je8a7LYacbKDAaLYNgFzY+Z1=L2=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 08:31, Jaron Viëtor 写道:
> On Tue, Mar 31, 2026 at 11:58 PM Qu Wenruo <wqu@suse.com> wrote:
[...]
>> My bad, I forgot to ask for dump-tree of dev tree:
>>
>> # btrfs ins dump-tree -t dev <device>
>>
>> Again it's fine to dump it from any good device.
> 
> No worries! Here it is: https://transfer.ddvtech.com/pY3LV9yw1L/dump_tree.txt

And the last one, from chunk tree:

# btrfs ins dump-tree -t chunk <device>

So far the result looks fine, nothing wrong so far.
All device items looks correct, with unique uuid and correct devid.
The dev-replace item in dev tree also looks sane.

The only next item to check is the device items in chunk tree.

Thanks,
Qu
