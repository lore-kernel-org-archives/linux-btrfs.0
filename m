Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634AB38D007
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 21:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776117505; cv=none; b=bduniq5BVx5+EQfYnbJN6XeMDgZYReildIcjQy7Em9qJB9Db92+lwbW9yCsWIi29IdFyIMtiEBeD7Nw9xLusRoK4pzoWRSs1hDVNwlXzCykk8tx0At+3iRDcZePLEuiI7UaoOnws8bUVeXLkvlBA9ZAgzGZKTk4I9w4OOMSgCs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776117505; c=relaxed/simple;
	bh=jrpJV6LDpcWtq0S1af3baFmHPncJUqfxl1UKK1l/Cak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NzX/Devty3Gp4BnRuAopPLgjlzNBVNULH3ZocH42WHZdB/DtMktqjHPoD8bRBg0/hCs+INpcw1gkhEimm5iVnjOrDnzG1sXKK1Nj3+KyyYWf9JOdisd8X0EZbqy9yfjS4qyT0iDlgUISij7sQ18tQji3jJOu3WJRDfhShPfvuEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y+1duNbo; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y+1duNbo"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48896199cbaso52685925e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Apr 2026 14:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776117503; x=1776722303; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=jNovRodygoNbnpN8FawYFOryUhjGLirybcLwFmNeJGA=;
        b=Y+1duNbolIV21BMLWeyAwkmP+e1CMicOKWv+msXWVCFMM//6XPm7En90dpcVPuJ3vn
         C/lQg7vxkG+Cn/OpRxnZFEXCyFbOsMsfPtpbkZ/65KvKtlk5Nxs13janE2KpKd3dHNj+
         o4eb6K5Q+dRSylDim+MPAaidaTWQXZWzkGxiDqaljtbE+/NCPxRUOgg3YPCxd2j517oh
         57sktO1VG5YLfxJoiWYZNlY2ihznMJmkQjE1kxpPDvg46xtnhyoxyTcuzFfhT4pysxuN
         vtFSRylF/TC+CITtro+52rtjl+Bey4MESB8kV1qAbNXo8B+EoLi3uD2PN6QUdbFXthpH
         p3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776117503; x=1776722303;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jNovRodygoNbnpN8FawYFOryUhjGLirybcLwFmNeJGA=;
        b=TxcZDcpYtTl8TdNEt+Hwa/bWM4/Qlqa+5oHOVy/n9kzDxoyE28BYLfKp4Bw20yOwOh
         jycIGiR8YuMcHxlXG59pSuLxKVKjVvqwXhV7wHz6DhyssWeecHQ9JHj/G7+vAv0Cte/1
         c+WTyurlkJMY5mARm7hN0FfJxZtubJ3e+ZqEtAEw3lleDmV1221KCH4C5HRxBqkPrQ8i
         6KSdAN2sayrDknxm0dxAyWWTE2OFqhoKqIe/icoqGEXmcSTzqljN3rcrKZ3IkELHC876
         YjvlHBse4P8aKQiB/HH8rY5HObhscLjV9Olly1MEncC8mU909e+ULBp29RJZyOgerKrv
         mrFw==
X-Gm-Message-State: AOJu0YzaF7xliTZ/6xJgwmioV0MAGJnupVaeVxLLdWLm3E1YZXy6MKUj
	Ob15IJHTPGd9rABCQwS04aXZDh4Fugab1QdfO2nYfh9disNtR/TYNk8oE668Xsn++AI=
X-Gm-Gg: AeBDietIJmIASxOuuqvJhUzEgD1wkM3cstEjxJvELKOdMINpm3527uQKaF30AuBZCTw
	jnicXj7TL9drHsmJNleFfQJGvB5BwKQ+GPWnXLkY4uP7kQVYpczweYywxauAUBcuIOYB+Nurhuh
	cz7ysZwx4temnbln+w6CtwNjcr0ckA+UmwFk5JGiJwQbnhSFt6w9PVeXrdbjo77Dxp/3U6PfoB4
	/5rvyzfvmtrUElmFzAtLngDStdVTStwSH/KcjWenTPNBPcD6uixwcguNWDibh/I0sscOy5gpUqS
	stqo5GutW5dWQ6VpZEok+lcUPQNSG/CcVfnUqfL9+5eRnhua/qUWGrOPbndEJ/603REiwIx8l+e
	ja3RV6v7HqA5g98rJOe85SPW61qjXAZzprgxsPv+Q3uOM9pW99fNkh8qc25pFgmI1cS/g/m4zZc
	iNjo6viLDvov/BB8Tz0yqLJSJfwr/ZOfKZd+dB64/AoAJ5ra+HUqrS0gKg5oeZJtQWT82TKMo4
X-Received: by 2002:a05:600c:c08e:b0:47e:e48b:506d with SMTP id 5b1f17b1804b1-488d684b9d1mr148804935e9.16.1776117502694;
        Mon, 13 Apr 2026 14:58:22 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c34f789sm12801775b3a.19.2026.04.13.14.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 14:58:21 -0700 (PDT)
Message-ID: <e79dfddc-fcff-4e16-8964-9fcf777dd49d@suse.com>
Date: Tue, 14 Apr 2026 07:28:16 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: DEV_STATS item related minor fixes
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <cover.1775553952.git.wqu@suse.com>
 <20260413185907.GG12792@twin.jikos.cz>
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
In-Reply-To: <20260413185907.GG12792@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/14 04:29, David Sterba 写道:
> On Tue, Apr 07, 2026 at 07:03:57PM +0930, Qu Wenruo wrote:
>> [BACKGROUND]
>> DEV_STATS (objectid, not type) items are storing the error counts for
>> each device. It's updated every time an error is hit, including
>> the following types:
>>
>> - READ errors
>> - WRITE errors
>> - FLUSH errors
>>    Above alls are all errors directly returned from the device.
>>
>> - CORRUPTION errors
>>    Aka, checksum mismatch.
>>
>> - GENERATION errors
>>    Metadata generation mismatch.
>>
>> [MINOR BUGS]
>> Recently when debugging an error reported about rejected dev-replace,
>> the device tree dump includes a DEV_STATS item for devid 0.
>>
>> I'm wondering if that DEV_STATS item will ever be deleted, but
>> unfortunately it will never be deleted.
>>
>> Normally it's not a big deal, as the DEV_STATS are normally all zeros.
>>
>> But if it's not, and a new dev-replace is started and interrupted, at
>> the next mount the replace target device will suddenly inherit all the
>> error records, giving end users false alerts about a completely good
>> device.
>>
>> [FIX]
>> The first 2 are manually removing the DEV_STATS items when dev-replace
>> and dev-removal finishes.
> 
> The device stat item is expected by btrfs-progs even if it's just zeros,
> otherwise the 'btrfs device stats' prints just 'no stats found'.

That's not true.

Firstly when btrfs is created, there is no device stats at all, it's at 
the first RW mount we create the dev status item when initializing the 
dev status.

Secondly, all device adding ioctl has the proper update to force a dev 
status update, thus they will properly have one no matter what.
And that's what the older kernel missing.

With those features guarding the dev status, it's pretty safe to remove 
the old dev status.

> This
> has a high potential to break any monitoring tools or scripts. So please
> don't delete the item, and create it empty in case it does not exist.

Please give me an example where it doesn't work.

The only situation where no dev stats item can be found is for the 
unpatched kernels with offline dev stats query.

After a new device is added, no new dev stats item is added (requires an 
error to create), thus it requires a new RW mount to create them.

But before that, there is no such stats item, and offline dev stats call 
will not find the item.

And device removal/replace won't change the situation.


For kernel GET_DEV_STATS ioctl it's not a problem at all, because kernel 
always grab the numbers from the in-memory structure which always exists.

Thanks,
Qu

> 
> For the wrong stats on the replaced device the stats should be zero from
> the beginning of the operation.

