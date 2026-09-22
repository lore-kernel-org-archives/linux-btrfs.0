Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D30EB4F5E14
	for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2026 06:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790060252; cv=none; b=H+jxUCfqEjlTdsWMqAtQ2Y885JBOIUv8MFrVMZexdVD2pvKtJke6oHqdxfAicBbnERox+6vXTfrw7tN2NnztowvuKxBIqjR+FobWDG8KYaAXlk8BG481SjYtwkYJEplLnWTzaOCcDx4BM/ihqcPBQeeroPzg9qiB4dpyuO/P7WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790060252; c=relaxed/simple;
	bh=rjUkqpdmCDNbTJ36ZmgD0b0TthN1UfVLHgZeG9SFEk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GDws3fXitU7vBLrUIYj4o7hpdvErtT8gg/iIIF3/MpU6H7J9zBqoh9qJwv9k7U4iYUUksjkVyTbgt5JXrL3MaDkmu1FWidr4NhZeJKk6pHT0+Q4TNirfOL2e0xIHobLCQortoj4CQPrSXPdYsb8G0rWXAPB+d9YnKCpdhR8UHoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ShZbGcLY; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ShZbGcLY"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6056ac81fso6705282a12.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Sep 2026 23:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790060244; x=1790665044; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qs5vnmcW7ufENCJw6xWJktWdvbYCaYahYenY7LllhG0=;
        b=ShZbGcLYQ+NBV8i2HCIwkSrfJGe1203WJc61Zf50nLIiXv64Y6HBsLjT/j/l7dPELB
         N8QcQkBWEeRBlTYxyZ0IsZypAKQpDNL081M1nEq/NH2iJj502bw9nLs6Z8U0eGL0RtBL
         hIW0zLmstJD3uTjPxAwy9O6mrvqP14l5PkVAYXHChShGtMXF00KZ8yCFTBzHNK4hZvJ7
         T/9JRZ0MMd11Knv7VGsZXdPttVTOz3kkLs6hGQLo96LZmQp1Qqh2+lN1PQxQzQsQBwgV
         hWZ6Gg6lsOBjD4SwrCcZJtAvwfAIzrJmBDGP17R/TMcyWQudWIa3Y43dTSnUseoiEidw
         v+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790060244; x=1790665044;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qs5vnmcW7ufENCJw6xWJktWdvbYCaYahYenY7LllhG0=;
        b=NwEkw1csetQXb3NbqNyROPd47AticD8xClCoukhx96GjHyhjc8z0NvEtLCbhYIiPWA
         +140bIq7WEq5M2yXp1wUqyaAyx9i6oUOzWD2DwU/5tPDm8WYlHKmgYeOeMEBQIKsLQUb
         V/xg8uKNDuMG/vvxbQ4ZDUCDSMDGM3zIbXj46tYNoNoOXu6YB+PGkn7j6Ni56Z6pWja6
         btC5uHNFzHZrRpbM9G/yQrsHb/GqkShEUVshivDBKNBlMNYbRovKaoLEBexPM0T50CCN
         CkbttshFxekwVvBWxK8F76wHKqcFBawmIIt6wchVPE8+rjFA26F4/YL6VUs8+YmDiV/L
         JbvA==
X-Forwarded-Encrypted: i=1; AKwUvBxBdETCwNqGe2p4CjAYGSZ6JNYddPDOGswxSm0xMVLlE3tKau0JImzH+IxRF/E+Cf1NLUXk8LPZdkd/rg==@vger.kernel.org
X-Gm-Message-State: AFuF++n5In38pJCVPT3mzLOIZk0J4dU/LZCxG1s1VHfgSnEv0gkF3nQD
	3+Djg943ZPJOOHCTvy2I+flZ6tNusNnvWYBk3Cuca3yv+2TDB1oOXSCTBdYlJIfeCGATUFQ+bYb
	W4N0DB9Go4Q==
X-Gm-Gg: AYBFou3IFUeQ+zM3QUDwTZd/M6JOdXJ4o9KE64N4qThS+aFrLPV0hhtd1CZlaYUS/ET
	YRPz0NQTJpTDnd3l4E0p8XoV2Tdof9yzhn/FdGUbmz46hYW5onFz7dZy6T8mqdsFN+QR/2t2y9I
	elFtrQ1PHMKK+6xxz5h7Sn5JGAWek7PGoPjzgdrDBQ0EcjTjoM5n67riAxLhxwqF6lr5xQdjfkP
	jBiOpuTPQMWDv2ONn+XNrPJnki46KtLOMuN2hD6X2k6inajvlFQIfTxhHBGa/rFnmw+XNApthkC
	W64/tu5FUe56kK1TQVU3qqpUD26Pd8dPB4y7S+cuEDBuwW2muHpIJ/1t8KD0LxJV8r1g18wUYVF
	G6oUy/p0uiBfOVvrX7uRDRVynYAWsOHlRj+SwGiAw61VNmMADO1s2IP3Cvd3iTpAYissdWNNq26
	/L8jRYxMs+3sztJQco8vTR9EGyyQOWD/Hi2VnFaGte231kh0rdz6iqInnFJ781YzU=
X-Received: by 2002:a17:906:4fc9:b0:c29:4b79:e41a with SMTP id a640c23a62f3a-c2a157097c1mr1059927166b.20.1790060244204;
        Mon, 21 Sep 2026 23:57:24 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87c331b0629sm371060b3a.51.2026.09.21.23.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 23:57:23 -0700 (PDT)
Message-ID: <fb95ea32-95f4-41d7-af73-c3201c877818@suse.com>
Date: Tue, 22 Sep 2026 16:27:16 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: make qgroup rescan work to handle fs freezing
To: Andrei Borzenkov <arvidjaar@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Dongjiang Zhu <zhudongjiang@fygo.io>,
 linux-btrfs@vger.kernel.org, Richard Weinberger <richard@nod.at>
References: <cfc34be50699e2e0e5c84e4d57345c7e0506caf8.1789974081.git.wqu@suse.com>
 <4c1c5779-5ba4-4c6b-9223-d48d1b1aad7b@fygo.io>
 <20260921131220.GE54722@twin.jikos.cz>
 <2c895064-f5bc-488b-8bbf-b6b9b7e842f6@gmx.com>
 <CAA91j0XXX-W5Robv2P_8n0g5mSN5nzskE7ukzjNpV7YzroWY=w@mail.gmail.com>
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
In-Reply-To: <CAA91j0XXX-W5Robv2P_8n0g5mSN5nzskE7ukzjNpV7YzroWY=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/9/22 16:00, Andrei Borzenkov 写道:
> On Tue, Sep 22, 2026 at 12:46 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>>
>>
>> 在 2026/9/21 22:42, David Sterba 写道:
>>> On Mon, Sep 21, 2026 at 04:36:51PM +0800, Dongjiang Zhu wrote:
>>>> 在 2026/9/21 15:03, Qu Wenruo 写道:
>>>>> [BUG]
>>>>> There is a bug report that a running qgroup rescan can fail a pm
>>>>> suspension:
>>>>>
>>>>>     [ T278489] Freezing remaining freezable tasks
>>>>>     [ T278489] Freezing remaining freezable tasks failed after 20.003 seconds (0 tasks refusing to freeze, wq_busy=1):
>>>>>     [ T278489] Showing freezable workqueues that are still busy:
>>>>>     [...]
>>>>>     [ T278489]   pwq 56: cpus=0-13 flags=0x4 nice=0 active=1 refcnt=16
>>>>>     [ T278489]     in-flight: 205929:btrfs_work_helper [btrfs] for 111s
>>>>>
>>>>> [CAUSE]
>>>>> Btrfs qgroup rescan is running in a workqueue, and when the fs is
>>>>> frozen, btrfs_start_transaction() will sleep on sb_start_intwrite().
>>>>>
>>>>> But a sleeping workload still counts as active for the workqueue until
>>>>> the workload exits.
>>>>>
>>>>> So the qgroup rescan item will sleep on the frozen fs, and fail the pm
>>>>> suspension.
>>>>>
>>>>> [FIX]
>>>>> I strongly doubt whether we should even use a workqueue for the qgroup
>>>>> rescan workload, a kthread would be a more suitable choice and can handle
>>>>> fs and process freezing way better.
>>>>> But that will be a long term solution.
>>>>
>>>> Hi Qu,
>>>>
>>>> Thanks for working on this.
>>>>
>>>> I recently posted an RFC series addressing qgroup rescan lifecycle
>>>> issues around quota disable/enable, error cleanup, and remounts [1].
>>>>
>>>>    From the recent discussion, I got the impression that full qgroups
>>>> might be phased out or substantially reworked. Is that a fair
>>>> understanding?
>>>
>>> Do you have link to the dicussion? Phasing out current qgroups in the
>>> full mode would be a functionality loss and we don't have a replacement.
>>> On the design level, the qgroups are general enough to cover the COW
>>> design, sharing. The compression was originally intended but IIRC we
>>> don't account compressed extents separately.
>>
>> The biggest problem is the insolvable nature of tracking the owner of
>> every extent vs changing all extent owners in one snapshot
>> creation/deletion.
>>
>> This means qgroup is only reliable with rigid subvolume layout, which is
>> never the common use case.
>>
>> And all the current workarounds are killing qgroup limit functionality,
>> requiring endless rescans again and again.
>>
>>>
>>> Reworking could happen, the performance hit of qgroups in full mode has
>>> been a problem since beginning, but I don't see any easy change there.
>>> If the sematics change we'd need to add another mode, like we have the
>>> simple quota mode.
>>
>> For now the only major user of qgroup original mode is snapper (for
>> subvolume cleanup policy), and we're already pushing snapper to not
>> enable qgroup by default (although no good progress yet).
>>
> 
> The major use case of qgroup-like functionality is snapshot
> management. Whether it is implemented by snapper or by something else.
> Without the ability to get an accurate estimation of the real
> subvolume space consumption (how much space will become free after
> deleting this subvolume) any snapshot based workflow becomes a
> nightmare.

Then let me give you a very simple example.

There are a dozen of directories in a non-btrfs fs, then one wants to 
delete some of those directories to free up space.

What would a regular user do to determine how many bytes can be freed by 
deleting a directory? They run "du -sh".

I see no difference between running "btrfs fi du" on btrfs, and "du -sh" 
on a non-btrfs for this particular case.


Furthermore, even snapper didn't need to use qgroup for 90% or even 99% 
of users.
Just disable qgroup on an openSUSE/SLE systems (and that's already most 
people do), snapper will still do regular snapshot rotation all fine.

You're asking 99% of end users to take the burden that only 1% users 
really need.
That's not how things should work.

> 
>> I'm open to new designs like simple-quota, or maybe "reference" only
>> accounting (making it almost the same as the quota files supported by
>> all other fses).
>>
> 
> I do not see how "reference only" is useful in any way. We already
> have enough tools showing us "used" space exceeding the physical
> device size by an order of magnitude.
> 
>> But I do not think full quota mode should be a feature that should be
>> enabled by default.
>>

