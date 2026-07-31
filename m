Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B482037F730
	for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534182; cv=none; b=F6t1PHMSoI44XBOCDZp0rYI+puVlBbBtyCobSZZMPE2cZFt1/mw3NjTVYeZx6DsqcklH3pKCbL7lr4uMQz2v+nzWkgXFvYo0+7oFvXCyTV13cUzth64QndKmDZClwpgkebmAKrIMYVqt/LmmZ00o4k+etPM5BlpqLaRC0MiGGxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534182; c=relaxed/simple;
	bh=jPYlAzxLWHXcdSjRDHMxg8typewUe+qx/NOKOLVn7fg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=B4uxjSfqlkBeQEWPyJEgM3PH4K40MyUEvifZTVFDZqs/rRDoLJBGRrZcmkpOBVpXQ4ASW21/gx6xdCLFtEYJmKsESwIb16M937i2xFBAkFe4UUbaKZN9//vL9+fiUAulszMED4LRPy6jnYdY3A7A8S+9oJ6MAI8kLhjOwizgbVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SeMfOFo9; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SeMfOFo9"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47640541585so1151687f8f.1
        for <linux-btrfs@vger.kernel.org>; Fri, 31 Jul 2026 14:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785534179; x=1786138979; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d98RldLH1ayA405FgCHv1XO/889KDmH4oW+87SPMZZw=;
        b=SeMfOFo9TULTEAgwy/zLYcKue5s90Sr0xFAr23AUx+VDc6j8rMPz5V4dwHdaZW62Sd
         sW9reIFEGu9Ayv3Ow75vn0MrzizU08MAK0t02wW3HEOf48JLvfdmHBR4EAp2Bk2G42yC
         jrKw8gfjWvW4MZfF9xuZ9zCG86UVRlV7rRnLsgw0LL2qyC5HrUNbnWRY/OT0F92Ivfgg
         GpbbCaj8LNhvFYvzZswbACglvRjE7llEIBwUtgxUV1O90mAXmU8AUJ0wno3/G6pTlmUQ
         KL6LeBMsZlxoXxadmZFdCZcgY6tQrwGlS3fwJZeQn86tJ3ol7D0rT/ScV6HlpZAKw6cT
         DhkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785534179; x=1786138979;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt
         :content-language:references:to:from:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d98RldLH1ayA405FgCHv1XO/889KDmH4oW+87SPMZZw=;
        b=Y4/vbV9/hmKMUV8ZtnRduKQMlIEiqBCAoJ1Hs/mNCV/aJjuGGOzQk+1saJt0IJLeMw
         VCbrJbVyOvbY7m4JCM2CK6HHcVRhB8uQijSOj9Hv2Z5YN34KWAZ93dxTqTGg/vUfA+bL
         4M0LkqEfPbRZE5tBPWX014eBXE6ddr/0D7nAGejHwXEFOWyN0zGSSZhSuFlCooJtKHvE
         rUC4odAF0CDerI5qwyJQYeXnJbxVHKhfJizzA2xTtuaL3abqUr0fGM7MQUQDLQAt2TrK
         3zCBIWalA0AaMpB51sWI6OOgERTP44WT8C6WWqjpJdKlYRcR5SlY/GVOuVWrg0DtcyjA
         kJcw==
X-Forwarded-Encrypted: i=1; AHgh+RpPobVRhuCuGjwElQwIPGMxEuIxyFy4Z6tEXnOM9pbaBVAnlnlWhBD8SReQHLCRqYtLZ2D71OxLz0DqJA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx806cDhZbatZCLii6IqDv/lrB3465e5FQp/h5FjRFpq5jyPeWM
	MSWrOOF9WGHwoFjSM9Bs2jzgTqEZ8Ab1M74H8i8UptmRvWFGZu5CiXkmfi65uzViicso0cxI82F
	MxgGtrbw=
X-Gm-Gg: AR+sD13Ks//Pv/Mk8gdGMJ7pQk0ncCXlvfw/1+yiamzjY/5+EtfWOuAlHpwWzOJVMa6
	LpmsCcL3Bi6eu1Vsh3ZUYc52QfB75bAtwGHhHZJa9wD7ee11i6s8Ydl5qsRLHjpPyRnRINIZUDm
	27ZQ9z3NTWDoZNy6TlsQgOOi16CdBgEbkuPDc9o/iyDuLn5w1AqOjiDWkzRGR8QrONRtnnHypDl
	6c6nVKPbqoKAdqVKlsVwJKaUMk1J7ENgLUpvxZrZRUUfEoAhzdLyKRJaB4opk4sTpxCs8n96X9a
	/sOnRuxGsgK0mYifbv5eAlGycqNLzJn8UjfbI4zsqKi/OzgjNH0ZM9j48ErSUH54Py1/hjknZKL
	kbRDrDWxqaK/PTTP73OcGvu1Jvq+oYZbw8Yf8txe3X7c37UHk3V0kJMJs1l6G6JzPGM2UohtiA2
	xssBbhq/Oc1RI9AbCj2Pp7bBZztsfDZI54mMjZIBu+Wiz003/BmPBikw==
X-Received: by 2002:a05:6000:4202:b0:47f:6c6c:5301 with SMTP id ffacd0b85a97d-47fd731c93cmr2334554f8f.59.1785534178989;
        Fri, 31 Jul 2026 14:42:58 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab24ec10sm6468512c88.6.2026.07.31.14.42.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 14:42:57 -0700 (PDT)
Message-ID: <ff905d52-9c25-48fe-9950-61c52ce53f63@suse.com>
Date: Sat, 1 Aug 2026 07:12:54 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] btrfs: implement a new compat RO feature,
 data_io_size
From: Qu Wenruo <wqu@suse.com>
To: Sun YangKai <sunyangkai@fygo.io>, linux-btrfs@vger.kernel.org
References: <f67b00bbe7b5fb4c59a45a6390c98add303a83c1.1782627906.git.wqu@suse.com>
 <647fd7cc-f948-4260-b26e-122a61ca7a16@fygo.io>
 <5b91fb7e-479d-4e6f-8d34-40eaf1d675d2@suse.com>
 <ca3eeaeb-76d4-4a23-a019-d3a5f4ceb431@fygo.io>
 <110adc02-4e4e-437d-867d-c8fd3a50aba9@suse.com>
 <0758b840-f48e-4693-af9b-04793319382d@fygo.io>
 <b741686a-d101-4529-b74a-4e1277caf84e@suse.com>
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
In-Reply-To: <b741686a-d101-4529-b74a-4e1277caf84e@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/1 06:55, Qu Wenruo 写道:
> 
> 
> 在 2026/7/31 21:10, Sun YangKai 写道:
>> On 2026/7/22 18:03, Qu Wenruo wrote:
>>>
>>> Full stripe 16K, then the new RAID5F chunks will require power-of-2
>>> disks, and no more than 16K/4K disks.
>>>
>>> So no 4 disks RAID5F chunk in the first place.
>>
>> I've got your idea and got the following 2 concerns:
>>
>> 1. the device count is limited to 3 or 5 device for RAID5, and 4 or 6
>> devices for RAID6, losing the flexibility currently btrfs have;
> 
> Why you think 16K is the only block size?
> 
> You can go as large as 64K, which means 16 data devices which is more 
> than enough for common usages.

Furthermore, even with 16K full stripe size, you can still go less than 
(2+1) and (4+1), you can also go (1+1).

So I do not think there is any inflexibility.

If you think (3+1) or some other weird combination is a good idea, 
please tell me what this weird combination can provide that 
(1+1)/(2+1)/(4+1) can not do.

> 
> In fact, I do not think you should have overly flex design, which is 
> contributing to the write-hole in the first place.
> 
>>
>> 2. On each device, we will send a lot of 4KiB or 8KiB io, which might be
>> not good for performance;
> 
> It can always be solved usings blk plugs.
> 
>>
>> So I personally don't think this is a good way to fix the write hole 
>> issue.
> 
> I do not think so.
> 
> As I have already said, at least I know XFS is planning doing something 
> similar. Although not to solve write-hole.
> 

