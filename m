Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 953E53559DF
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 22:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777330717; cv=none; b=J+V72AaWuRssgSr3yWQQG1q7rq9Xhp+CfXKKsVeECxIPNt5F3yq/f3m/OweYoUCsONEvhGFPWS9hSwdsNr7MSZbnSwLRn+tJAM+wlNO/IoeBoujEMAMROvK6iiLVYLEitl+i6L9qjrNF7hI8gwzNj/4twqxLXLbfMeC/OnuLPq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777330717; c=relaxed/simple;
	bh=JfzSETa2zPwqYJR/2DK6T/OZrn4L6qQuAXvJOfwbTcs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GGpRliyI5YFT0lHJgmpd5Avo7DCXlfHD5bqWBZJAdV2dD1hXzs6pmPsPWAcGb/3FzsH0BFOTBvWZpj1FMtr/Zdz9G+TDXz9rn6fmSnfbzw1Q0lnZLIYn5v6vDBVV9/wtpZxssDvyeMtGKsG+Rjce5Aypbh9sDQ0AJrRjLIuft3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Js/K5uIo; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Js/K5uIo"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso99978645e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Apr 2026 15:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777330714; x=1777935514; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=vFY2TsBopnrJcj2INiDa1BFq90MwchE1PM9ttSBoLV4=;
        b=Js/K5uIoiTy3zdoxXq31w6OnViJfRqG1lGa/CWVfjotWgIcpbMn416mGvmPQR9VLdi
         NsxDJYKq8caZwfehCIZVTMTWoOXSIZiw6a8eFX1WFJHobKXNVZRa3cblAw0mqTnXfH51
         vxx9f8sN26cxPUfzID/orue4BgODLTEXL2nUyFxcBSAYK7xuDC1l2W6w4+Cb/h/+jlp4
         Qq02A3FAm9Zqiw3ipVlbEaa8awbsYBSRTIFX1jReD6kroATQsFYKiEwWOCuDkFkuchZY
         GeviSHPKcG3nVQlfPrIxPWgj/cglsImKWidWms+4E/gThMfE/6c3wcJguR07JJeTvI81
         CU1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777330714; x=1777935514;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFY2TsBopnrJcj2INiDa1BFq90MwchE1PM9ttSBoLV4=;
        b=KmMgDZqe3oPWPtR5HIxTIrh6KRdhwGQ0xnvAR6mGdQ9Ts3Memb0ARmFbSEObYrumTK
         er+NgJpQFF2ZIAwK+9rAY4qWihsSh4H9B4EjPJ9wipckwvw29sEZurE2ma5e2Pl8eMy4
         ZLSY9Wi3wq14rK09M/FGAwC1eqsMfNHGa8pA54gdhXY+bTPcdqDhmvkYmQaNEEjDZiO8
         kDss6EnPNojdxaNbyf7ECbMtpNkh+G0NP/9dbhYft8e5i6k6TUkCsHLhJ5DOGvKOGbf6
         BMAIQuGu0Y8i/hQZ2+INTS8uZkxV0jS1BflZgGshKybeckfIYVJ2XBdacHP6aPX6yYho
         8Z8A==
X-Forwarded-Encrypted: i=1; AFNElJ+FDf/rMROm/S+9S0vr+x/ZWbsAajNnhc1Y6OH6RYdNMdH8sLu0q+8AdLqfZt//+aMQjqq4XruFyKI51g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy19w9EfBA8kYNeL43mzAJ8ynCWs8FMf6l7DkswlGZly8fbPbH+
	7jszEDuaz1kqCsVbfcKfABCfve24QewIlxFp4jmcgLyFc3viPN1zUzz+hkSKyWO7RTs=
X-Gm-Gg: AeBDiesYhOX669HKUVVaxxQ5XSV14vSNR8MtN8XMsIdHvjkGbxhgjxfKiOheUOWlSAC
	KZSbUKbi0vzquw0tO1YgIN06+MFi4L6+UEG6pHxbiNw7d0/YiW+WK1a3I+nokg0sAmit77nGBVW
	qXCwJaHsVTkY76SJNoZEYEdzjP6Yt/fVSDNPNkOuL3GbdmC53rolyAZpGXzGycnM/wVmB9FCQ8E
	0nxHCRsmYQjw9G6iv386sBec/dU2u2XSjfbDg2RFhFZqRR6lF9+afB1+0RbDJwfcS+kjcmQwyLr
	aUPwGPWdIDAxrGhM1ImIcpj23DEFomAAltsNgJE5OXB/1hjzD89rRnoBTX6HUsOMR4iqycwaIx3
	8K/LdcOYuDvU5i3k1j2hUND9mAo/pzQsFLTg2wgbnNQROEB6imFybmrFgML50nBIK0kFtmV6EwX
	rAu21eelY++X+Txn7lnh315dEi7O3xwYqoSPALOx0s3cVsicMzT4i0XH0osjlE9g==
X-Received: by 2002:a05:600c:8b8b:b0:48a:568f:ae8a with SMTP id 5b1f17b1804b1-48a77aed44bmr8438555e9.8.1777330713811;
        Mon, 27 Apr 2026 15:58:33 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36490025b20sm707610a91.1.2026.04.27.15.58.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2026 15:58:32 -0700 (PDT)
Message-ID: <0dfb1998-e951-4db7-be8a-987da3a8f471@suse.com>
Date: Tue, 28 Apr 2026 08:28:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild@mailbox.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <SYK4ET.WNV9390MEC881@mailbox.org>
 <b53641af-f231-45b9-9d4f-21e1ee8132c7@gmx.com>
 <ID66ET.91J1PP272KJY1@mailbox.org>
 <3f28ce8f-25a2-4972-97de-b995799cea40@suse.com>
 <SNC6ET.5NSSU3PO7MKD2@mailbox.org>
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
In-Reply-To: <SNC6ET.5NSSU3PO7MKD2@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/28 08:17, brainchild@mailbox.org 写道:
> Currently, scrub operations are not completing properly, so I certainly 
> think it is important to try to repair the volume.
> 
> Which error do you expect is related to the particular problem, 
> concerning scrub?

Can you provide the full "btrfs scrub start -BR" output?

> 
> Is there any evidence that data may have been lost,

Not yet.

> or concern that 
> 'fix-device-size' could cause further loss?

That should be mostly safe, but if you're concerned about it, please 
update to a newer version of btrfs-progs.

Ubuntu is pretty bad at backporting fixes for btrfs-progs.

> Should the operation be done 
> while the device is mounted, or only while not mounted?

Must be unmounted for btrfs check and btrfs rescue.

Thanks,
Qu

> 
> Thanks.
> 
> On Tue, Apr 28 2026 at 07:40:31 AM +09:30:00, Qu Wenruo <wqu@suse.com> 
> wrote:
>>
>>
>> 在 2026/4/28 06:02, brainchild@mailbox.org 写道:
>>> I have the run the check command, which reported a variety of errors. 
>>> The output is attached.
>>>
>>> Are any recommendations available to attempt restoring the volume?
>>
>> The super block bytes mismatch is a minor one, which shouldn't affect 
>> normal operations.
>>
>> But still you can use "btrfs rescue fix-device-size" to fix the problem.
>>
>>
>> The nbytes wrong can be minor too, but it's affecting all snapshots 
>> containing the inode 16523863.
>>
>> You can either fix it by copying the inode to another location (can be 
>> inside the same btrfs), remove the original file, mv back the new copy.
>> This will need to be done for every snapshot.
>>
>> Or you can try "btrfs check --repair", which will do an in-place fix, 
>> but will still break the shared blocks of every snapshot.
>>
>> Overall, I'd strongly recommend to remove all unused snapshots first 
>> before doing either fix.
>>
>>>
>>> Thanks.
>>>
>>> On Mon, Apr 27 2026 at 11:35:28 AM +09:30:00, Qu Wenruo 
>>> <quwenruo.btrfs@gmx.com> wrote:
>>>>
>>>>
>>>> 在 2026/4/27 09:22, brainchild@mailbox.org 写道:
>>>>> Hello.
>>>>>
>>>>> I am struggling with a poorly behaved BTRFS volume.
>>>>>
>>>> [...]
>>>>> ---
>>>>>
>>>>> No errors are reported in the kernel log, only warnings about 
>>>>> skipping the swap file during scrub.
>>>>
>>>> If you assume the fs has some corruption, none of the above is 
>>>> really useful.
>>>> A full "btrfs check" is strongly recommended.
>>>>
>>>>>
>>>>> Second, within the logs generated for Timeshift, a concerning 
>>>>> pattern recurs, as in the attached example. Further, during the 
>>>>> periods in which are generated logs such as the one attached, 
>>>>> the entire system lags considerably. It is clear that the 
>>>>> volume is not healthy.
>>>>
>>>> The lag is mostly caused by qgroup.
>>>> You have a lot of snapshots (shown by the super large snapshot id), 
>>>> every time a large snapshot/subvolume is deleted, btrfs will try 
>>>> to disable qgroup to avoid such lag, but if whatever script/tool 
>>>> decides to rescan qgroup when the snapshot/subvolume deleting is 
>>>> still under going, the lag will be re-introduced.
>>>>
>>>>>
>>>>> I was using a recent 6.x kernel, I believe one of 6.18.x, when the 
>>>>> problem emerged. I upgraded by to 7.0, finding no improvement 
>>>>> in the operation of the volume.
>>>>>
>>>>> Also, I tried initiating the scrub through the most recent static 
>>>>> build of the user-space utility (i.e. btrfs-progs), with no 
>>>>> improvement.
>>>>>
>>>>> I would like some suggestions for restoring the volume to health, 
>>>>> to avoid the need to provision a new volume from scratch.
>>>>
>>>> "btrfs check" first, if no error, disable qgroup if you have 
>>>> frequent snapshot creation/deletion.
>>
>> So your fsck is mostly fine, the lag part is highly possible to be 
>> caused by qgroup.
>>
>> If you do not need it, just disable it for good.
>>
>> Thanks,
>> Qu
>>
>>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>
>>>>> Thank you.
>>>>>
>>>>
>>>
>>
> 
> 

