Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC3A2E401
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 23:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786317654; cv=none; b=OpYC105yAKf2gHHbKNQL/lG6hOorAsf34fzT7/Bio3DDhRkP1Qc4GO9wVMxlX2wr3lJS/Fzuxek7Zv4IsvKaTBPazXuh5y4LhVc0N6StyTVB4NtlSWzZ8Z0QjuWGwtWvifcncAq6XSr37RQsBFXr2tR2rKwXgKV5iXzqHsGBiME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786317654; c=relaxed/simple;
	bh=Lsvf6IKkqu/NL9lp1mJRDtKi6V57GE6+6+5jb++MvEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=COxjuGw/YRNcZicewC/iCIQGvFjt/brC/ohYXhaOuVyox/uN6x4YBi876xW5h6WuqyOljmmUzbeXDJ3JIkE/4HRy0N+StBYYYCChYAUd4O/y7MBQX7fmr3XXz95fFjH2n1cYLn1T3uQk3yYS96qhsli1Ao+KlJZK4ab+yQcHfks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cgFAgK+W; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cgFAgK+W"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495590dde14so15210415e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 16:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786317651; x=1786922451; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LUEo1bGHiOqGIHO1DERhmsKYyQo0Jri/tKdxuQlYmp8=;
        b=cgFAgK+W+2O1bhSDl9LfJsQlfWH8gAFRnsjIlLFx4Bjfr+XMMATqyPSirZ9DFi1d23
         3nAVYZ1IE1xS6CKX8TVN11dVQYwwF75WMuHOmZOz0aWgBK73fdreJJVLNxH4pxxKc12M
         Irg0vUMhc9j6xApr+jYXNqv/rkhfcN+5+j/axGnUvMT6dBYkWiNpsIx6bnugxAc6WSHc
         jLQEOTJarrm5Pb4TOIY/fPpSIbcA7yDQ2RpJTP1G4c8aWyao07f40LY78hXKVn/kCHX8
         8fKbibm9vgTonoFrjBNEs+XpzfngpXDXnLyWOOeDFIh/3ZUbNc9ZhCGv+twKFv+9WcZw
         MNVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786317651; x=1786922451;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LUEo1bGHiOqGIHO1DERhmsKYyQo0Jri/tKdxuQlYmp8=;
        b=RFtk5qL5f0l0Ije5TMfHKEMc4AyItK1S3fwh9dLOq87yeH5DkoXXRY9zqe4FxnCP13
         BO9kmUjBnWm0a+tsZTMRWGnZGsJW+9cjOWhS8DYoK5gEHXs9lIDWGNkk7ER+HgH3bt0J
         bkdCBmjFzAJafw5R+/LoQL15XpdXN922Dt4JYfWjyuWtlcQpIeKKbxBa/Jno9eclVR4F
         lkqXOIjYm81Ifk8QPw9th4lmqNIVb/AvSE1pKknrFQtkBjKQ6yPaXKVP1pbccaldhvH7
         Wsj/nsXM0Np6N+KHqf8JIz/B5h+7/UmnWiHOXZHDXrgFcUpimIe2GZHnKyskxbEhj1oF
         YfjQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr93bZ4xVALqQ8/Zxj/QTwii5XwUyFMrQ2e8lHUWiKcqeBmFw0Es3o+GaXoCl2ayfsK1YOgtyW4YaZ6LQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxoWuIH6ccpCYqaVVTb9bSOMU81F8TLGcVtwho8OG1MCpWWuBwK
	aHgTz3qWBqzrgOttCC1FsmY5aZcWyo43mYYSZXYBXjcnyfowap+soMGjWgdaY3bbbfw=
X-Gm-Gg: AR+sD12S5akozYeA2G6QhGNShO9st2Z6PJfH1K3/DSUKD7ooTvWXbWXfdR8ZUdaZMEj
	t/KZd/g5+fHyBET42GZULo6WkvlLecKC3DZMKqajm/qz3VFrfKgo7wVRzn5hyfb+Vnvk5zuLPXs
	i9zCp/VkHkysPKRioT9LAeG/7JzO4ZMpwmj0tbrRVpzSmoKkNofQdmGJD0ZmHPuG/s8oV7Z9AEc
	TbIo2pG5UQMus5nPA07hnmBrazoMWHblMN2+CjAUTV9wfkAvbQ15yEAnfwGg56WQ9uTqvlZBdYx
	kWhn9YoEKO2/AWhylEcMSA0so6fUU9D2B5Ve0tmt5/e7NCxv+LSkOsDTso5TKVLY3bl4/LqErWV
	UuLhz3ScnFWNOEW1sbglGuIcGMCjeoP1zAIdTGI28bfp3u1loSJARbmOqf5yGx2tzip1H+Pw6T2
	BTfszx7aUvlrYQ4AoIQLkS9fHA8v8mBvW+nJL9WmPnjNVSoBkNoiWZkA==
X-Received: by 2002:a05:600c:46ca:b0:499:53c4:1daa with SMTP id 5b1f17b1804b1-49953c41e18mr367753365e9.15.1786317651048;
        Sun, 09 Aug 2026 16:20:51 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec26a5dsm35079657eec.26.2026.08.09.16.20.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 16:20:49 -0700 (PDT)
Message-ID: <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
Date: Mon, 10 Aug 2026 08:50:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: koraynilay <koray.fra@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
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
In-Reply-To: <ankKjqr72aD8Ka8w@hungrycats.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/10 08:47, Zygo Blaxell 写道:
> On Sun, Aug 09, 2026 at 10:30:45AM +0930, Qu Wenruo wrote:
>>
>>
>> 在 2026/8/9 10:05, koraynilay 写道:
>>> On Sun Aug 9, 2026 at 2:17 AM CEST, Qu Wenruo wrote:
>>>> I'm not sure if this is the correct behavior in the first place.
>>>>
>>>> As you already mentioned, zstd and zlib have very different compression
>>>> level range, using the incorrect level makes no sense (and it's being
>>>> clamped anyway).
>>>>
>>>> I think we should go the default level when not specified, which makes
>>>> more sense, and that would definitely be something worth fixing.
>>>
>>> Yes, I also think that would be best, but my main concern would be it
>>> changing how chattr +c behaves (I'm less concerned about the btrfs prop
>>> set file compression "zstd" case, since IMO that implies the user wants
>>> the default level).
>>
>> Mind to explain more about the "chattr +c" problem?
>>
>> IIRC "chattr +c" just set the btrfs.compression XATTR to the default zlib if
>> no mount option is specified.
> 
> chattr with _any_ argument resets the btrfs.compression xattr _every_
> time, even if the caller changes a flag something that doesn't look like
> it would affect compression, e.g. chattr +A or +d.

This is the known problem of chattr.

> 
> That can lead to surprising results, like changing compress type from
> zstd to zlib, if the original btrfs.compression attribute doesn't match
> the mount option.

This doesn't only apply to c, but all other chattr options.

That's why proper chattr should always include the full attrs, not only 
the one to change.

> 
>> In that case it should be no difference compared to any existing XATTR based
>> compression setting.
>>
>> Thus it's just the same missing level handling, and IMHO since XATTR
>> compression level is never specified in XATTR, then the behavior is never
>> fully determined, and users should not depend on it.
>>
>> Even if we changed the behavior to option 3, it should not be a super huge
>> user affecting change.
>> In the end, it's just compression level, affecting compression ratio and
>> speed, not really a huge behavior change.
>>
>>>
>>> The options I considered were:
>>> 1) keep the "bug", like I did for now;
>>> 2) keep the "bug", but only if the compress= algo is the same
>>>      as the btrfs.compression one, if they aren't, use the default for the
>>>      btrfs.compression algo (e.g. compress=zstd:15 and btrfs.compression=zlib
>>>      would compress the extent at zlib:3 instead of clamp(zlib, 15) = 9)
>>>      (suggested by Zygo);
>>> 3) fix the "bug" entirely, which is what I actually accidentally did at
>>>      first, by just setting compress_level = inode->prop_compress_level
>>>      without any check prior to that (which means that by default it would
>>>      use algo:0).
>>
>> IHMO both option 2 and 3 are acceptable.
>>
>>
>> The only extra concern is, if we have a new level field in XATTR, can older
>> kernels handle it?
>>
>> And thankfully the existing prop apply handler is checking only the first
>> several bytes for different algos, thus the existing code should handle the
>> extra appended ":<level>" correctly by just ignoring the level.
>>
>> So either option 2 or 3 would be fine to me. Although I personally prefer
>> option 3 a little more, just because it's much cleaner code wise.
> 
> Option 2 preserves legacy behavior that is 12 years old now, and it
> costs a single comparison in two 'if' statements.
> 
> Option 3 makes an already confusing situation worse--it makes the
> underspecified behavior change depending on kernel version.

One should never rely on something not documented in the first place.

We're to make it more clear, not making some undocumented BS to be the 
common case.

> 
>> Thanks,
>> Qu
>>
>>>
>>> Option 2) is probably the best compromise between breaking existing
>>> scripts and the behaviour making sense, plus it shouldn't change the
>>> chattr +c behaviour, since btrfs takes the algorithm from compress=.
>>>
>>> Thanks.
>>>
>>> Best,
>>> koraynilay
>>
>>

