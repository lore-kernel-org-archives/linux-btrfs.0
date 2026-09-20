Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF9B3CF21F
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Sep 2026 05:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789882123; cv=none; b=TAQfDsVkzYFt72Vv54l3AU3vHb2L+p6f4W7EAMF36xsigI+P/QS8rGpS9MbefdNs3RIGjFMh0jL9loQoQWxeiVGjYsI/EJrEJb5ibeBp8mWvpIY9VhU960FjMxCnZ3Ur5OSYiWo0s9bRUQ/YCZiYlBbkKUlDA4a7T3qkzSNHhHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789882123; c=relaxed/simple;
	bh=dwC8Ee/qa/ioKT+QSMigPHfYmwrkI0v9VZvjdovbHik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oYwTvx6YNbo/32sIB8VFvKNkL/0ObEcY5M2qfKGXuQ/9D/QLbqxCyfVC2MuYfHKGc0LrBfFvXpQQVNHMfQWeV8YeSU4GKAdPZGlzdToo4kMiE8qN62qAvdg6JYpMfVIw4PxlDQ/jpJkDxVoHUxoPqt2AdnZPBqvqprkEHBJcnq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LHfGexap; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LHfGexap"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a803458ba0so2537527a12.0
        for <linux-btrfs@vger.kernel.org>; Sat, 19 Sep 2026 22:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789882119; x=1790486919; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tkoP3AdozvkmYOBuarNd9gzkTLs6rDB7qOkrI4BxmLY=;
        b=LHfGexapkoFHHW/z8AHWEYSfL5G6fKT0cjum4QJZ+Ly8RxpB1O2Jq2mFoP09d9Hw2f
         wk9emku/O9dKSDmgkGMYYEsPr14BfAQqkKV2Bp2g4VJg1W+zWfCRdtVyozrlEe65KpcH
         a0JfNviM8MHOVckr09JMO9a8mCFBaVAVE0fl5/BY+0xAkr5GR6E1KGPSvcLn9XjGRIeI
         fff+9eiUnXYxU74r0bcKhK2PbQcymCxJqWIePpm8L2bnEDrXqMCohGpejId/0bnuOq5y
         NY2AKZvOK3lfrNR0lCDQtKiLWhnP7j0aBtS+iIgKnt8VSerkvjbdulJ0LPfyMv7EH5/g
         hMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789882119; x=1790486919;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tkoP3AdozvkmYOBuarNd9gzkTLs6rDB7qOkrI4BxmLY=;
        b=sY0mSwxtHVQPwUqzbP4zax84dAnfFCY0aEeqG3ML0fSZ5ZHyauENdmbFadXgfoDLOC
         MtCmUvlMGqwTIJC2P2xesUKj6t202F3jLOtNkg0nH/AmTFPtdmargHS3IuCsqAzEu96x
         NXZUMeyXNW86N49RkRnS/t2ATIwpvvRUGecuRhOWYqw4m3tMywHHC/n78A6SUoabMuaB
         Zoel8h6yTPuyYQSxrlD2jPjxbFkJHrYOVjoyj3c2S5eMs0Xw4LgvnEdKTbA1x4Gs2oTy
         Uogtp3z1JXGYDqOlbd4MonYFSgwP4mDfkvOT42VOT+75H1if5x+qwbpBe9b3OkmeSRB9
         tJzQ==
X-Gm-Message-State: AFuF++n4UcX5BpDhyzNK1NBRmkI/LLjLcxKec6pFKcyrx3SKYkrenWGQ
	K9ggfBFG1JLj0DmqJGG9njz2+ZlAmdQwva8YXQpUiofdeQoPHc64sRsDtwu1LKHQD0L2gP5IGEG
	04u/Pd3I=
X-Gm-Gg: AYBFou3fgOJ/eS6vHa1zOMSVr2fV6ot+MF81ULj7pZXmRgqDd3s7sx6ika+Q5neSY+8
	D6HytoIgcackip6btBOuiWdYXt2GKtkyJc3aIcAQ/TkuBnDNCRmkHxiwoFFVD4WI3r5IJyPgVWU
	hlYKJPAoRe/T6qrvcyTW5gJLlULjifUM94ohqIqC6FKxzcJgz1rpE4aT9YhgyYLorQ5l/mtCkLx
	CUVY4Gnae0x9Ehh1MMyei94ecXbjLTSDZo7lhi7mb4KwtdcVfh/ojvDkJH9WeXls/dqvIIXNgVG
	vLJs8L9ng9QeLwSghsl8hEv49jqJfxnwQVA0bt1dEPQsuvbQZmg670ND6tcO8FPXDWfw+WXWlbA
	FwfwEmKtnm3CXQ+sL61MTWie6M195jPdwnQwbIhnR2FVq19miCxSKd2Q3WWv0uWrQvdENjuohG3
	uRSSnNAKRV4gjP/+HKWFnW/GDHbAgb0rdRthCWbvvm1GrTQcF/q1n60mrsbvYaoRw=
X-Received: by 2002:a05:6402:434c:b0:6a6:32f5:556f with SMTP id 4fb4d7f45d1cf-6aa562e21d2mr5125991a12.17.1789882119322;
        Sat, 19 Sep 2026 22:28:39 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72ae8eae3sm1615537a12.14.2026.09.19.22.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Sep 2026 22:28:38 -0700 (PDT)
Message-ID: <03dcccbc-35c7-4b9d-9275-17a4b4111b25@suse.com>
Date: Sun, 20 Sep 2026 14:58:34 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: qgroup rescan worker makes suspend fail
To: Andrei Borzenkov <arvidjaar@gmail.com>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Richard Weinberger <richard@nod.at>
Cc: linux-btrfs@vger.kernel.org
References: <mu8fq8a8.b9a9a1ae-dd6b-45a4-a415-5db853d61536@nod.at>
 <aq7HYO9SKdIaqvr_@mayhem.fritz.box>
 <38c0b7f1-a876-45ab-92e2-223e2f70d82d@suse.com>
 <bbec11f2-7ec8-4cf8-9d50-24681cdaf4bd@gmail.com>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJqqw0NBQkUl/JeAAoJEMI9kfOh
 Jf6o/xYH/3AaWnGSq58XnY/T3/YYjr6g+TUZxa7MPyiYTELNpNlvmNlbtbAL0nW0LNvkeiqf
 SmYA+xkwY4RbxnZYQK0H5iv2w1eqa9qqFZb4bIBRmTapu26GEEkpad0W0ZhoSPMO8bV2Bwkf
 YdtPZQLaeUKvHZqNqBKnmtRLQj2Cgy3kuXX3bEGvWjzUOxPUSCj/S++JWBewMdMBPT62vZM0
 3156gfn5mHA94s2p+NFJoWkERY+JPTMu9NISkpD7yuGhXN88qd/aqD0RrlhxvKsrQogdPwn9
 vP18FGG3CRlHtOvOLVoY5NKSOWTDc+o+8t2XEETFTGbKYTcqeTzi4SxhvBLtTinOwE0EWdWB
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
In-Reply-To: <bbec11f2-7ec8-4cf8-9d50-24681cdaf4bd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/20 14:26, Andrei Borzenkov 写道:
> 20.09.2026 01:39, Qu Wenruo wrote:
>>
>> To be honest, qgroup mode is no longer recommended, except for rigid
>> subvolume layouts, and since you need rescan it's definitely the not
>> recommended case.
>>
>> The current only well known user is snapper, and we're pushing snapper
>> not to utilize qgroup by default.
>>
>> So unless you have a very clear use case, it's better just disable
>> qgroups completely.
> 
> I am not aware of any other way to get true subvolume space consumption 
> and thus implementing space based retention policy. "btrfs du" is hardly 
> an option.
> 
> If qgroup is deprecated, what are other options to get this information?

Either simple mode, or really "btrfs fi du".
Or in the future, regular quota file support.

But neither will provide the current accurate "exclusive" accounting.
Simple mode is the closest one to provide exclusive result with the 
minimal overhead, but very un-instinctive values for deleted subvolumes.

"btrfs fi du" is also fine, but requires execution before getting the 
result, and can be very slow for a lot of small files.
At least it won't block other btrfs operations, and can properly handle 
pm suspension.

Future quota file support can only provide "reference" level accounting, 
but should have minimal overhead and should require no frequent rescan 
(except the initial enabling), but no "exclusive" accounting at all.
