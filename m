Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590073C0A13
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2026 06:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782370275; cv=none; b=sOonWkGb7dDNBrK6eQ+4fShtY4r0yOO5Il3OV9btLW0lMsw8ualeRpUx47CjK6CYIDR2NF8yOn/X6fSl6XRQg5vJFaB2hCaiQxVrdY1Jj5zcY9OAWIwMnwgr5xZKfGgAZXHPfoqsAeP+V/ro5f/ViPcRwc8P1gYdsni/gkb0Ikc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782370275; c=relaxed/simple;
	bh=0aJq5AvCNmx/tVs4NpCm2sPY9d8D1RCNmj0pah4uK3E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=irfuJbv1dK265prvh7UOBj6qG3tBa6wbOzazYM5LgZ5oFQlg91rm6YraGkNgE7OUFqptAb3z4W58LErFyk0JA0SbN7wLrFJ8wzBrtXGP2lTMCHQ6/ROkCGIct1nzGT/LDB/ArsuL4KPEtTVG/EYI5533TGlgB9YFOca9etSlnAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NWug5JXx; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NWug5JXx"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4923139e940so11551435e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Jun 2026 23:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782370273; x=1782975073; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=mSaR1flX2hmelJOtLCUzSJ8gbOzzDK8LPhDuawsgajU=;
        b=NWug5JXxOvUm1UzjquT4qey6Rpul8uVvw5TkcE5bG/m/immr3zGzcMMlY01yibbamT
         Y+KFtBckTwFGPEXAcjDyoOHerdlM+rlfBvRw185vFSFY8rINfRIhRo18FFWA5/3k8zMS
         jgmCReGfu0SnzN97U9BNVuqjt7xXUjcaJjIbWTzLhRWewhKfljqh0TMuwVYh39+em3IJ
         sfAXvT6+V8VFF5NWbCLtOXf8ulgaN5V/t9hhgsaCOMa5XXVIjDAE7YHlEh/c6ChSzhkg
         3U+4OI7GTWD8NAFcq1tP1AlwcKaMLHkcfCvurfh+GgKi9DpbmEVP11tq67HsNqP032j5
         TT8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782370273; x=1782975073;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mSaR1flX2hmelJOtLCUzSJ8gbOzzDK8LPhDuawsgajU=;
        b=JaEpx+hvq/hGHaUvl6url81fuWNpH5EpsEp1i26sY0suSEBaICf3Dnr5kATgYS+4tm
         LumFTKrmwKaHg/OI3fA36nXb6XPC6PAPoIrGrpFAGhc5dLbA6C/dgpxRrtiFwo0iTUET
         nokco+wu9fZA9ZqKqhbidqcIRHeVwGT3eAgNz3GGTQzF+yWxZBmAN+AI+lUNjresUtFX
         exePQKrgatLCvgW6mnIc3iHmr/FOAycOpYIMOomoEyo4fPo2KVElVKkILQXeb7hrKhiZ
         hfWIi31ivtMbK+qlisOHMYYh/0F2MC4Z6zzyJwuEnf9DZTQecTuHZQE1OTtqsDlc+J1p
         rsdw==
X-Gm-Message-State: AOJu0YwYdwFEG/IWOPRKN0cEj/LVJiFr8YIb75w/NmeuIh0Oj/1jwu+W
	AWWx/AKzpgASarR8ywbEqCd94WO9+U4/ycil7a4l2fwPPwXxr3lHgUZjxXF2PDRUXDk=
X-Gm-Gg: AfdE7cl4W+/dfcSVaGOBfvUSRs3ReQOB8K7j86spGWmrjik2Uws8eQvvpqUuoBdJZO6
	ggLmEppHm+YdayzgcJzscTlmELINh4WW8ad6jriWQiXdaVYuu8vLLrNQdhrxUB9QfJoxbdbP6oU
	JwJAfr0N+x6v1oXNO8qNkVj8oukB6PasDcbTKgBHAHYp8m7tqx40veF2EdyOy8UnIhxDhdHIdY5
	GqJ0tQQUlUgtfGqB2Y4lz64/zzX/DP2nIshgnuTQicdyTQR0GyeUWCLh7KSrVeKIgMH6SLZf1Pk
	8yStyKfHBsZrIpMV0cvDmT42zVoJvVeYaidUvb/5nPQgms/L0QvCJHtXqv5B0ZhMWnJyN4ARGUQ
	M0SSG63VdgJ24QQfEg166ZXcOcgo3V1xLvq9ZqO5HrhxDtnypClGJvo9INR9XNb8SC/7kzmG+LU
	ufQqwDZ6ycV5twuK289LmDKF7PaVtEaW8vRqFF91Y=
X-Received: by 2002:a05:600c:1d1b:b0:492:4caa:e2f4 with SMTP id 5b1f17b1804b1-492668ad885mr14185765e9.36.1782370272737;
        Wed, 24 Jun 2026 23:51:12 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d91006bcsm5372158c88.13.2026.06.24.23.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 23:51:11 -0700 (PDT)
Message-ID: <68a6def7-20a7-4bce-bb79-aca32c48b7f7@suse.com>
Date: Thu, 25 Jun 2026 16:21:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for ordered extents before buffered write
 fallback in direct IO
To: "Zhou, Yun" <yun.zhou@windriver.com>, clm@fb.com, dsterba@suse.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260625021456.724803-1-yun.zhou@windriver.com>
 <aa009e0d-a629-44ed-bb68-202ff2dc5063@suse.com>
 <c2afdc0e-6e63-42b8-9a8a-fc77d2ab7383@suse.com>
 <f192c12e-135f-4f98-a1a0-df2470eb8a86@windriver.com>
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
In-Reply-To: <f192c12e-135f-4f98-a1a0-df2470eb8a86@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/25 16:16, Zhou, Yun 写道:
> 
> 
> On 6/25/26 13:17, Qu Wenruo wrote:
>>
>> 在 2026/6/25 14:43, Qu Wenruo 写道:
>>>
>>>
>>> 在 2026/6/25 11:44, Yun Zhou 写道:
>>>> When btrfs_direct_write() falls back to buffered IO after a failed DIO
>>>> attempt, it may race with the asynchronous completion of DIO ordered
>>>> extents.  This leads to a BUG_ON in insert_ordered_extent() due to
>>>> overlapping ordered extents in the per-inode rb-tree.
>>>>
>>>> The race sequence is:
>>>>   1. DIO creates an ordered extent via btrfs_dio_iomap_begin()
>>>>   2. Page fault occurs (nofault=true), no bio is submitted 
>>>> (submitted=0)
>>>>   3. btrfs_dio_iomap_end() truncates and finishes the OE asynchronously
>>>>      via btrfs_finish_ordered_extent() which queues work
>>>>   4. iomap returns 0, retry logic faults in pages and retries DIO
>>>>   5. Second DIO attempt also fails, code reaches buffered: label
>>>>   6. btrfs_buffered_write() dirties pages for the same range
>>>
>>> btrfs_buffered_write()
>>> |- copy_one_range()
>>>     |- lock_and_cleanup_extent_if_needed()
>>>        |- btrfs_start_ordered_extent()
>>>
>>> So your explanation doesn't makes sense. As if there is the direct IO oe
>>> remaining, we will wait for that OE to complete.
>>>
>>> There is still something missing.
>>>
>>>>   7. btrfs_fdatawrite_range() triggers writeback
>>>>   8. run_delalloc_nocow() -> fallback_to_cow() -> cow_file_range()
>>>>      tries to insert a new ordered extent for the same file offset
>>>>   9. The DIO ordered extent hasn't been removed from the rb-tree yet
>>>>      (btrfs_finish_ordered_io running async in workqueue) -> BUG_ON
>>>>
>>>> Fix this by waiting for any pending ordered extents in the target range
>>>> before starting the buffered write.
>>>>
>>>> Reported-by: syzbot+ba2afde329fc27e3f22e@syzkaller.appspotmail.com
>>>> Closes: https://syzkaller.appspot.com/bug?extid=ba2afde329fc27e3f22e
>>>> Fixes: acf9ed3a6c00 ("btrfs: retry faulting in the pages after a zero
>>>> sized short direct write")
>>
>> And the fixes tag is also incorrect.
>>
>> Without that commit, we will directly fallback to buffered write without
>> retry faulting in the pages.
>>
>> So by your explanation it will trigger the same problem, with or without
>> that commit.
> 
> Yes, my previous analysis does seem inaccurate. Commit acf9ed3a6c00 (which
> added retries) merely amplified the window for the issue to occur, but 
> the problem has actually existed since ff66fe666233 ('btrfs: fix 
> incorrect buffered IO fallback for append direct writes'), which 
> introduced i_size revert on DIO short writes, causing 
> lock_and_cleanup_extent_if_need() to skip the OE check (since start_pos 
>  >= reverted i_size). I will correct the commit message and the Fixes 
> tag in v2.

That's right, and I have already sent out a fix based on that isize revert:

https://lore.kernel.org/linux-btrfs/aaabe0f2bee07800fb0490d24fab5cd162e5241d.1782366056.git.wqu@suse.com/

> 
> Thanks,
> Yun

