Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7B3125AA
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 01:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777338976; cv=none; b=J08qhhA+05et1+MpkOgdvkD+NNsbWeobFI52dY9jlWvA2YwtPY9QdWLfTVhk+T0Cwb3eqRW/v2jS7QGAMFR3Uud2IrEbBecMU9cmsNY9UKUC90onmxkap8/xJKB3A1LymMBGUFRjPVIveA4kKP0vS3cNNnEUJOwZErHA/tp5FHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777338976; c=relaxed/simple;
	bh=I25gt/6apiBHYN+XjQmjND7k+anYvpw5JBmByr7GhzY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jomx2wHNk7xG9Lnutpm+HUG1kcqxauM60LEl7fIpJ+4mGdnm2gbc3lvM6D9ZXe7vdsTnVuUuOHG8/Cn4mw/mvQqu5gtZT84PlJdgvG1d1ioWTaqW6VHL8jDUOSy4sL/NdoADGzn3UKafo6aZnoBhCFQnyQ5nJPnYix3pJ4T7YfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=fKPMGIar; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="fKPMGIar"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488b3f8fa2bso109877075e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 18:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777338973; x=1777943773; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VkLg16oucaQn47k+6HCOyMbNus+Rx2POo0KOMFtEleo=;
        b=fKPMGIartzvOISdfjnqj/2/8+t9MkSfzUIRjkudNPeXz1pPyopL3/y5jzKUwssvuB9
         BDiERiXXz3cH76b7wVKQzfMaNdEpezCUQJDuEOGv7TrJSUNzop5lT0osB+jy+NabOHoD
         1oYVAVKK3IIipqpTpyrsIu5wQFUXjoFjkd+1xkybCWz3cskwjM5NG9IJ5CqJiu6MwC11
         wRWV6M3YEnTYKxXxcRd93kI4CtPG9R2t+lktDNyRLNxHbuWFhbH9axidxnQMkNKmHxIL
         rfZt8JPoDTQtjlGhwivWMDY5eQo1WdZnb1O5RdbIv61q/VJ1uG8UDpjldSL3Vf0QdYaJ
         sk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777338973; x=1777943773;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VkLg16oucaQn47k+6HCOyMbNus+Rx2POo0KOMFtEleo=;
        b=NQTVUpvxekYgtdvw4bwrgAC6bI5FbmtGSG6e3x8IxOTtnsJkjYDPKqU/KYWPlJQ3kQ
         BHmxLfbE+ErBlveZF8Etkc2Lzq0/NgLZ7dqUf6ZEtbyNQW+/dU+At8Oh1pbqzOfA1vwk
         2q6O9Yaw9EglArC/+gQqOJuGu/lAGdtzG7bYdbUr281vZMe21O+61ju+DRmRrneCpgHT
         XjU+e+wY8IJkQSWmXduu0GZWZ9Fqld+QxKyjs9KVf1allbN58zDpDBsRIo0nZDBebc4Q
         7yiZffjk0dOzst7fbdz6IbcTD4bHnSGmaUXEJTuSwSfazmloohQKDPN9PziS7Vg01tM6
         PCOQ==
X-Forwarded-Encrypted: i=1; AFNElJ+xdjhN6doOzvVXwqsNNM+1KbIp99kGeC6dxC4yOqF7e+0a60znPmPDgah0+kP91acJmkbjpOaVNoCIDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtLuD2+2tpmvH8gsEcWmWQP+ktXFOoKOynpaXe/ZYr3H81TsT7
	G7kRwK2MQy9PezxQDTHCU68QpYRnA3FOwRoZVNkE+SjY6vm5e1+848f8RtYOYnJ0yw4=
X-Gm-Gg: AeBDietPXd9J7gGoixFhg/380uwWESaMI7XL9yapCfJxPTQF0F+UrrXcFnxL4zXqDCv
	9ZM7RQBmjThA1ZP8Z/XTC6Zn4yK0PeIBIVHfPKyEOU6m24nxg0gBHQY7ezqlQ4+0vh850GCLjVw
	gkNGHnisqXLnIw0gxJ6cY+K9DDjAfergzQB69VoS5DApUQyOcMMp+aTd0mSlMiUP/8+XPexwftB
	/00VokGR7/46aH6CyFfIg6LbYydn4rXGJch499VFMjtVk25e037QOTMogq1nD1X1sZnPxlzYmOL
	fk4j73btmTeu+QZWhsxCDPyxr67PUeeI2xF4Xvnn1athnS620OIqQ7Ckm/zZnDA4Iy6iGDmkraC
	XZu2+VTLaZTkwG5hz2ENZy1bPoq/WA6QEMS1ZwF1IC1B5pErJoVxkZMxBekPRJvK64HGLfy/bZ5
	mx+/Dnm1/3AFM8i1qmAiKaC1Uc+LdmYdqCIg9SqYoisNu871zPOGsXUXAHPLKYBA==
X-Received: by 2002:a05:600c:897:b0:48a:5ee0:7781 with SMTP id 5b1f17b1804b1-48a77b0eda4mr8133835e9.16.1777338972623;
        Mon, 27 Apr 2026 18:16:12 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36490f9a30fsm782618a91.12.2026.04.27.18.16.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 18:16:11 -0700 (PDT)
Message-ID: <b86d2b52-5536-447d-9a63-be7f67effffb@suse.com>
Date: Tue, 28 Apr 2026 10:46:07 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild <brainchild@mailbox.org>,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0dfb1998-e951-4db7-be8a-987da3a8f471@suse.com>
 <20260428002217.Horde.5h6SZuQXFy8tGMhc9x7qKTM@nextcloud.brainspace.site>
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
In-Reply-To: <20260428002217.Horde.5h6SZuQXFy8tGMhc9x7qKTM@nextcloud.brainspace.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 09:52, brainchild 写道:
> Just as I was scanning for the name of the particular inode, the volume reverted to again insist on being without any free space.
>   
> I was able to extract the log for a new scrub, as requested (begun after the switch to being unable to create new files).

Only 10GiB of data is scrubbed, meanwhile your data should be 600GiB+.

You mentioned that there is a swap file, how large is that file, and 
have you tried to disable the swap file before scrubbing?

Thanks,
Qu

>   
> Thanks.
>   
> "Qu Wenruo" wqu@suse.com – April 27, 2026 6:58 PM
>> 在 2026/4/28 08:17, brainchild@mailbox.org 写道:
>>> Currently, scrub operations are not completing properly, so I certainly
>>> think it is important to try to repair the volume.
>>>   
>>> Which error do you expect is related to the particular problem,
>>> concerning scrub?
>>   
>> Can you provide the full "btrfs scrub start -BR" output?
>>   
>>>   
>>> Is there any evidence that data may have been lost,
>>   
>> Not yet.
>>   
>>> or concern that
>>> 'fix-device-size' could cause further loss?
>>   
>> That should be mostly safe, but if you're concerned about it, please
>> update to a newer version of btrfs-progs.
>>   
>> Ubuntu is pretty bad at backporting fixes for btrfs-progs.
>>   
>>> Should the operation be done
>>> while the device is mounted, or only while not mounted?
>>   
>> Must be unmounted for btrfs check and btrfs rescue.
>>   
>> Thanks,
>> Qu
>>   
>>>   
>>> Thanks.
>>>   
>>> On Tue, Apr 28 2026 at 07:40:31 AM +09:30:00, Qu Wenruo <wqu@suse.com>
>>> wrote:
>>>>
>>>>
>>>> 在 2026/4/28 06:02, brainchild@mailbox.org 写道:
>>>>> I have the run the check command, which reported a variety of errors.
>>>>> The output is attached.
>>>>>
>>>>> Are any recommendations available to attempt restoring the volume?
>>>>
>>>> The super block bytes mismatch is a minor one, which shouldn't affect
>>>> normal operations.
>>>>
>>>> But still you can use "btrfs rescue fix-device-size" to fix the problem.
>>>>
>>>>
>>>> The nbytes wrong can be minor too, but it's affecting all snapshots
>>>> containing the inode 16523863.
>>>>
>>>> You can either fix it by copying the inode to another location (can be
>>>> inside the same btrfs), remove the original file, mv back the new copy.
>>>> This will need to be done for every snapshot.
>>>>
>>>> Or you can try "btrfs check --repair", which will do an in-place fix,
>>>> but will still break the shared blocks of every snapshot.
>>>>
>>>> Overall, I'd strongly recommend to remove all unused snapshots first
>>>> before doing either fix.
>>>>
>>>>>
>>>>> Thanks.
>>>>>
>>>>> On Mon, Apr 27 2026 at 11:35:28 AM +09:30:00, Qu Wenruo
>>>>> <quwenruo.btrfs@gmx.com> wrote:
>>>>>>
>>>>>>
>>>>>> 在 2026/4/27 09:22, brainchild@mailbox.org 写道:
>>>>>>> Hello.
>>>>>>>
>>>>>>> I am struggling with a poorly behaved BTRFS volume.
>>>>>>>
>>>>>> [...]
>>>>>>> ---
>>>>>>>
>>>>>>> No errors are reported in the kernel log, only warnings about
>>>>>>> skipping the swap file during scrub.
>>>>>>
>>>>>> If you assume the fs has some corruption, none of the above is
>>>>>> really useful.
>>>>>> A full "btrfs check" is strongly recommended.
>>>>>>
>>>>>>>
>>>>>>> Second, within the logs generated for Timeshift, a concerning
>>>>>>> pattern recurs, as in the attached example. Further, during the
>>>>>>> periods in which are generated logs such as the one attached,
>>>>>>> the entire system lags considerably. It is clear that the
>>>>>>> volume is not healthy.
>>>>>>
>>>>>> The lag is mostly caused by qgroup.
>>>>>> You have a lot of snapshots (shown by the super large snapshot id),
>>>>>> every time a large snapshot/subvolume is deleted, btrfs will try
>>>>>> to disable qgroup to avoid such lag, but if whatever script/tool
>>>>>> decides to rescan qgroup when the snapshot/subvolume deleting is
>>>>>> still under going, the lag will be re-introduced.
>>>>>>
>>>>>>>
>>>>>>> I was using a recent 6.x kernel, I believe one of 6.18.x, when the
>>>>>>> problem emerged. I upgraded by to 7.0, finding no improvement
>>>>>>> in the operation of the volume.
>>>>>>>
>>>>>>> Also, I tried initiating the scrub through the most recent static
>>>>>>> build of the user-space utility (i.e. btrfs-progs), with no
>>>>>>> improvement.
>>>>>>>
>>>>>>> I would like some suggestions for restoring the volume to health,
>>>>>>> to avoid the need to provision a new volume from scratch.
>>>>>>
>>>>>> "btrfs check" first, if no error, disable qgroup if you have
>>>>>> frequent snapshot creation/deletion.
>>>>
>>>> So your fsck is mostly fine, the lag part is highly possible to be
>>>> caused by qgroup.
>>>>
>>>> If you do not need it, just disable it for good.
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>>
>>>>>> Thanks,
>>>>>> Qu
>>>>>>
>>>>>>>
>>>>>>> Thank you.
>>>>>>>
>>>>>>
>>>>>
>>>>
>>>   
>>>
>>   
>>

