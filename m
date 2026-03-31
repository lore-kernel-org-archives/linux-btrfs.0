Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E506F3644D5
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 21:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774994313; cv=none; b=Fk0P6+sZoTkIFbqzi1K7NMH104Q4m4QqOEDYsxwvklrIyCUZ+X5b3jw7t60+/uXmUzTBjrRs/fQfF40NQDQqgayqpsIdlWYssZiToNcQxev7yi3nymvleZhMeGnkKqDqYyapG8D37dMjy8yV4GUnZIFantOwsBYFsITeoPzvAGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774994313; c=relaxed/simple;
	bh=jdw78YfJxyhOXMaqWz07Jh3altkgn92hGVRMqmfwMQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=asJBliXCaabfZIYNRvzyzQ/3DFTX0oJOBLXjB5nbSV2yE0vCGeZ93aZapdSpz8q1kibLyYB09eXEGjMF9OyYckyiHmCnU96IFQun5WswKJR20opdj0xC+6ffUVHkCapiFOzsXOneZUfOdM58fQRasDL5lPDdNn/2+j1yXsObhwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FUs3aXFy; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FUs3aXFy"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4887f49ec5aso15163995e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 14:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774994310; x=1775599110; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=RJfepOPv8BfoL3B7X92noNRS8pgrmqgsXDgZqYNu3Vw=;
        b=FUs3aXFyy/hA0EIl0blU15d5EdH7zAfZZmjSk5Rp3Z3Cl2oZ7xn9niZJh2F3w/PuJr
         poY92c7ZorHmNst/vyo0kIIWP5wkBvGfzhHASlqFLciMZ5jkax7ibQh7w1XNDehTEQ+Q
         7lQtl7ELqUse7KQ+Bp4wBzKP0qjtvfADlQwHm1ZXNC9BWg+mDSavVrzrl58Pvd0xKQb1
         lWE+n1Va962VYlFi5e1mrE3pGatp3Op/calouOtXQISPYctfmhUBF2Mf4N+JIwRSIxWr
         zqrXBRrk7dGZ8uT1wkoBg1Qyfb/7g47I1E0a7rw7MTm5zJN6HCRUJ9lrPFgJ/GTVJ9dP
         n/pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774994310; x=1775599110;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJfepOPv8BfoL3B7X92noNRS8pgrmqgsXDgZqYNu3Vw=;
        b=KrV2JAYtcPcGLkIzIwhc+EZbMr1u2S/qpIhLoaV3/rh86XlNvMS9bE0mb73KFfgMS6
         Y+SgFSkCO/5WVV7UztN9p74V5DI0NUulY/aAvFaWRx+glamgRNM5a/nz9Apk8GakGxbk
         XZelw4m8NXIdPj7hgKn5halyI1gaw1G0UjRS7I6kP4i4qKIpRdbmEncg4nYi7GhcySDo
         m9xECOUlZrgWnit55NSZRw4f5K2ccApKzeAFlqzHlIxWBGhgCqWXC0i9jvKtcXo5McXi
         Asiut6Kxu8cffxx/tPnD+CXT9uu7zkGMMXla1sngSZgrJEcckL1utvSa9TAauF+Ssr4M
         6zoA==
X-Gm-Message-State: AOJu0Yw63a9B0yRcoOBdUj3X30FKFACDTvzmfFsQHWwJQGzxLhBcKJc4
	mHTkLH9V0F9gBBnTpLCBTiQ6EpeGRMa1IGK8v/8W1wxOjnKX86kr7Dixyss1Y20hURGLT7uc14b
	bycAtpuw=
X-Gm-Gg: ATEYQzx/d7XTqe7AMzUJsl/wxUw4Mgg+l+iLq4Uvw83CtRMmXBxqZrX6OPbuo6i/e93
	hgl3j/Ny2phd4Yb8uZe7fJIzbeBjzCtoNjpH6TGmhmH+4ySKlmdr5q6gH3CVcrRB04zbggFlUjC
	dGs27XX1gnWJhI3aT4dqpOH7USsu3+cKm8EBWtIVb3EW+QeJeM/8XBB+2uffV8/QmFYlanowGqz
	3bNrFB5yI+OGa0AbVClify1YeZ334gB1bFtl2v28UeCon0lakVgkm4TFzOBFd78u8fHAj/3E8it
	WULOIKNd81UR/WJOiAZf+15jNhMngvz7kF50tTM4qhNSl6edrf106dYSX24gmoGlN9oesAZmUTy
	TDzkyWkXMgRZ7ap7GV16D/zDEBzciqM95Sn9u/Ql+WxI1PKjeDyhKG0FLCS/A0lNSpcOkDdg2rm
	JoJApXSf+VF2LJvJV3hk+Qs14FHtmthvT2T86VgtEE7+xbIuKzLBQ=
X-Received: by 2002:a05:600c:8708:b0:485:3dfc:57d with SMTP id 5b1f17b1804b1-488835a59bbmr15134895e9.30.1774994310244;
        Tue, 31 Mar 2026 14:58:30 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbe6953a8sm2806340a91.12.2026.03.31.14.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 14:58:29 -0700 (PDT)
Message-ID: <4f99d0c6-42a8-4d23-8cc0-48ff64cc8f4b@suse.com>
Date: Wed, 1 Apr 2026 08:28:25 +1030
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
In-Reply-To: <CAF1bhLVahaWzAk3xXLdDSgacHjnMZLutbcP05zuxfTc3JuK-4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 08:24, Jaron Viëtor 写道:
> On Tue, Mar 31, 2026 at 11:31 PM Qu Wenruo <wqu@suse.com> wrote:
>>
>>
>>
>> 在 2026/4/1 07:53, Jaron Viëtor 写道:
>>> On Tue, Mar 31, 2026 at 11:14 PM Qu Wenruo <wqu@suse.com> wrote:
>> [...]
>>>>
>>>> Kernel version please.
>>>>
>>>> And with all devices (including the new and failing disks), and "btrfs
>>>> dev scan", the mount still fails with the same message?
>>>>
>>>> If so, mount with "degraded" mount option, and try to cancel the
>>>> replacement, then try again.
>>>
>>> Thanks for your reply!
>>> This is on kernel 6.19.10, the problem (and start of the replace
>>> operation) was originally started on kernel 6.18.2 - I updated in
>>> hopes that would fix things, but it made no difference.
>>> Yes, with all drives the mount fails with the same message. Attempting
>>> to mount degraded (or ro,degraded) also gives the exact same message
>>> as well, so I have no way to cancel the replacement (that I know of).
>>
>> Then please provide the following dump, just use any device is fine
>> (maybe except the replace target/source device):
>>
>>    # btrfs ins dump-tree -t root <device>
>>
>> Then the following dump for each device, including the target and source
>> device:
>>
>>    # btrfs ins dump-super -f <device>
>>
> 
> I've uploaded the dumps here:
> https://transfer.ddvtech.com/obowqfcDsl/dumps.tar.gz
> /dev/sdh is the failing drive, /dev/sdk is the replacement drive.

My bad, I forgot to ask for dump-tree of dev tree:

# btrfs ins dump-tree -t dev <device>

Again it's fine to dump it from any good device.

Thanks,
Qu
> 
>> I still remember I handled a similar bug before, which seems to be a
>> bitflip in the devid.
>>
>> And just in case, please also run a memtest to rule out any hardware
>> memory problems.
>> You won't believe how frequent such problems are observed, especially if
>> your NUC is running DDR4 memory.
> 
> Ok, I'll run a memtest overnight just in case.
> Though I should note this system had been running for several months
> with no observed problems, so it's -probably- not bad memory.
> 
>>
>> Thanks,
>> Qu
>>
>>>
>>> Kind regards,
>>> Jaron
>>>
>>>>
>>>> Thanks,
>>>> Q

