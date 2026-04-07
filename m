Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C3540DFD3
	for <linux-btrfs@vger.kernel.org>; Tue,  7 Apr 2026 05:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775540471; cv=none; b=OJLg5/wxBW8NBgpUB3Paj8CGzMnx6n3UJ/rIUXPEdvhv7hQ1SZfUtLwWd5Hl/XUVTf5fNYnZn6d31EByhveX/XekJv5imDSsF8WRaEH/BJMgwcA4b117XtZ3FywqGcpd3B04TO3ZgnuECLEZNTm+DUDv7AVrOFwLCEoKvbKoeVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775540471; c=relaxed/simple;
	bh=/q1RsTxiEPcwdrpuGURG+2sUtp4D4+ijQwuabBalZqw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZEuXjD6vyG+uTF09vTO91j1KQVbaV93kpQbm0o41CMuytUh77GtVtU5lTol0mtrgV35ZNo/Mk4/8DGH+pl//8QnpdxOsmQ4RDZ0Gxbdxjj21kR5sDYSMykSULdo9Ehm+tdCQEwJgJYtm40sDk2wmkIYD1gmo16vI26Mt3iDPyW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V+1fp/i2; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V+1fp/i2"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-43d04fc3bf2so2589654f8f.3
        for <linux-btrfs@vger.kernel.org>; Mon, 06 Apr 2026 22:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775540468; x=1776145268; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=OkYgqREkN7lx7yean2dwhC7xmMHS4WLLHaUxy6T3W8E=;
        b=V+1fp/i2ZoO8ECIi4GaaxlC9pfkVa5N4bHJIpmNdLDcJkxYI9fKNubES6zpo1ffg0f
         0HL1SJkKvESkj3C+ILSJdbMH2VL+7uRkwOYOnX9vpaxbpiU+CFgUiOjNGhhvOSvHieJH
         JerNfO4wOhxVUudZnNwrvI32r+93J0eoyLfgX6vauIR+rGcErCITRsq2oVyrWj/pbOhs
         n6Ckc3j+Fr+FhVycnYA9BgRWDzXyYoI6ASFc+t1dPNpSHuTHkdpFapQKf8zHMn5ebXtN
         p8V9PJznjVWJBb/Ny2IbwrRPwNZYo1foj3yafhYEQeDiHQq7m2nR68cIe0wONrhcbyEF
         JwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775540468; x=1776145268;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkYgqREkN7lx7yean2dwhC7xmMHS4WLLHaUxy6T3W8E=;
        b=J2fnonZMpwPnRBydnVZ0gTXuAhxKvkt0Chakf2FTFzni7FRD6qMRfYZRjbVF7lpkwP
         UmJCVAQDSkpGWpyn8A+KfN8BZ1lJH4YZKEdoaO0ehCIQOefuyNn4cUkRGmCNfMyZfgjM
         W8k371f7sMYfZl86+VCBKSnvI+DYJdtRqZK1mQD9nPvvHBxqD7ZuHle57wlL6L6S2hzw
         x6Zc98R+6zqFdhGu8N5SXTL7SD4Mm1E+qWxreBOThJL8ZePIiG6MfEa5HFafCQY5z+Q3
         8FPk57Z08N8UnR0tdL30wv53ydeuNFE2WzG7Tt70EogEQQbeZEX3EfpqodCd/FaKmUwJ
         vMrA==
X-Gm-Message-State: AOJu0YzSHySDYyksioLDhcaAJh1s/N40AH7CEPuNBD26UTAXi6zg4zni
	PXFKWPRXaFqoddYH7p4a+OmZ+9pJzUVkexSt88wPseDltWzXMtbQNvuNCjNAo3ExyRGnw4VLpkk
	Hql2T6FI=
X-Gm-Gg: AeBDievRVGGOUKabhQpTgbTS+Swvm/BneZNLF/9FC3xOO+bbO2xDCANMjUxdJ12mQJ3
	n7IEw96MUJ1sYwhIq0U/Rk+hkicAxTUiZwq8AJXo52gxyMv3ftWtU7trErQNv+Gm2w6ToEKakEm
	OjJQe0hEyue33YPGoiglo1yUwwZwNgJRmhWNUefZQyGsjoZUIfqLf4w41KZp2cXijF8GP4OTgK9
	+r6jMC1SEt1lxvS4jKQ1X0LBnEHKr9GJGHK5KiZK4M0ADkWusBbDAR92PlFJ7nvvwmMwVeBqkJF
	jd9XT6f1ApltwsxqZGxpcmJ3cNOf4V4sMQ1PQJZQ5mlrJA33AcV2tRCd/2cSzONSxY/TPaqjRQh
	P5KXwAu0COyEibor6HT5jNGZ9euxE5jtVihvudiiF0kkwUyQkhbp2+j3skyHRqfIGgUCDunq2pk
	vmkY63zjVCteWmKOA5C8er8HmhXaBoH6iqzn4y5hlIYK5MgH3Z1gc=
X-Received: by 2002:a05:600c:1c0f:b0:488:b99b:4177 with SMTP id 5b1f17b1804b1-488b99b7636mr41180085e9.25.1775540468415;
        Mon, 06 Apr 2026 22:41:08 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cf9c41bc6sm16393366b3a.29.2026.04.06.22.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Apr 2026 22:41:07 -0700 (PDT)
Message-ID: <04b365ed-0d98-417f-907e-892d18429be1@suse.com>
Date: Tue, 7 Apr 2026 15:11:03 +0930
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
 <a2e56b07-b0fc-485c-8a68-2136e595ec3b@suse.com>
 <CAF1bhLUGwb17jVD-7cVqA1OTRRRYbt_ow1+GZYbFgChN8mdKtA@mail.gmail.com>
 <22009c9f-f4cf-499f-aad6-70e94874dadc@suse.com>
 <CAF1bhLXNCeoct-SPoeLWXUKEmZnbjd0gXLmJqDdEmoPOg-FwZg@mail.gmail.com>
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
In-Reply-To: <CAF1bhLXNCeoct-SPoeLWXUKEmZnbjd0gXLmJqDdEmoPOg-FwZg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 09:17, Jaron Viëtor 写道:
> On Wed, Apr 1, 2026 at 12:33 AM Qu Wenruo <wqu@suse.com> wrote:
[...]
> 
> That seems to have done the trick!
> 
> BTRFS info (device sdb1): first mount of filesystem
> d18c93f8-d80a-4aa7-adc5-86d457ddde20
> BTRFS info (device sdb1): using crc32c (crc32c-lib) checksum algorithm
> BTRFS info (device sdb1): bdev /dev/sdh1 errs: wr 0, rd 16, flush 0,
> corrupt 1054, gen 0
> BTRFS info (device sdb1): bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
> corrupt 379, gen 0
> BTRFS info (device sdb1): bdev /dev/sdj1 errs: wr 0, rd 0, flush 0,
> corrupt 1652, gen 0
> BTRFS info (device sdb1): bdev /dev/sdk1 errs: wr 0, rd 0, flush 0,
> corrupt 1522, gen 0
> BTRFS info (device sdb1): start tree-log replay
> BTRFS info (device sdb1): enabling free space tree
> BTRFS info (device sdb1): continuing dev_replace from /dev/sdi1 (devid
> 7) to target /dev/sdb1 @7%
> 
> Thanks for the super fast response, and good luck patching the regression.

Sorry to bother you again, and I wish the replace has finished without 
problem.

If the replace finished, mind to dump the dev tree again?

# btrfs ins dump-tree -t dev <device>

Recently I believe I found another minor bug, that if you have a device 
status item (which records how many errors you hit for that replace 
target device) for the replace target device, it will stay there forever.

Normally that dev stats item should have no errors, but if not the next 
time a new dev-replace is initialized, that new device will inherit that 
old numbers.

It will help a lot if such dump can be provided.

Thanks,
Qu
