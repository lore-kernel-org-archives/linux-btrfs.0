Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1480345BD5C
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 22:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774996410; cv=none; b=QyuuLZffx+ztnDKJGAcfvftiZM3QcQ/OFDESnVCVuUBvE0sQY1dDSpO5kSRRnQhhk6PfuYztV+AVjCZKnaaXlWN8VpHJRbcdh2Th0arHbILoaHXrqxUoWIKnJM6Kk0IonNutgMJFE4nL9X/x77lgiyHUQL+QUP88NdmFK64/nTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774996410; c=relaxed/simple;
	bh=7Ffc0+iOnoq+6Y0zteIxohHVabiTRsLkaXAO0th8XHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pFAFg7VLID36LIL/USfBpr6n8n+n+pdllcKbAt0/qItPTgbO8U4TpYYc8L4PUsipxBbO47GLKz/lQVZs+aDyPiZ9yjtpEAT0EMc2xswwdHL5vlTjpdVZwdsUFMGlgMGUiAWQYiJ+yHmH5jbeNmcml5lvsXa4950OrJzVWNV4rX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gYmncqRo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gYmncqRo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-486fe655187so80816435e9.2
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 15:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774996407; x=1775601207; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=H25HdvIDpLtHE0cFccJU5fX4vvYi5WPd+r7mc1m7KxA=;
        b=gYmncqRoS+dhkXEqIfxcSwEvkMTO6klFBMw8ypUvAcspItjaSKc1ARdMMDsaiy2C3n
         otrV4LoU/hv0tQU83JqwC6V3xIH5MxmpMRzBCs1Y9JI6WqlHvcmCEPiSRO67yJuIEnAm
         JDkHJxRGEGzRg5Erlhb7njmCyoVPAlwiLLOLNh+q8ytvwPg3/zHhtPa6+AOvvmXkEUZ9
         FyQINxGF9AxI6isxayWBvNdcBvTsYAc1/VC04MAZ+OJidNj9Bmyfzk9IT/2krmQ5R137
         MyLbd2y05D/OTVn0e9an/E046C7ypp02lV/xGoo1/zlRaaFtWjB4Hhax64kqBpQ3KY8Q
         Ex/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774996407; x=1775601207;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H25HdvIDpLtHE0cFccJU5fX4vvYi5WPd+r7mc1m7KxA=;
        b=hmTtzk4OGMikGqIfrfgBiVU3M0QaZ/A/FuJ3aHSJHcnN/0YFmrfk8xsadQYLHIbrsq
         C9Vdp26CM9T7wZBBrvaNOngfG64Cq9erznoFgoNXP09YVMEYSutakeXOoDdWfoQR2FDK
         qUWkHZ6mMm7WqwFsPmjHJi3EpfuElnAcaDwpOBtq54QdD4lHNJHuBS4Ye/O63Q902goH
         z1nJda9y7lpdwnsQIuTbJ9Gx9+womVdTZb35YaB8qKFWgvaa2qI4thnIYEe/kTPGRR/p
         JEpyj47F89be8yXCKwWxNR29257KPPix68dow1+sDI9iwskuWoKvvB6k2xz9uiV0esyo
         IAiw==
X-Gm-Message-State: AOJu0YxLRwcvCDXHPqrGBvt8cZnkaMiHMyO4HNi6js61feRpx3cPI6oE
	JncZtXZoP2gJ4PA+Z3C0XpWMsPZENoz0XfKz26yQc1d6PAJdAH35YWty3NOXttOUTFf5b2Ue5XR
	lMVbAsMs=
X-Gm-Gg: ATEYQzxU1dJIfsaP/sRZc2sLbYLX3kjoVcNPDee13PE7iuSPLEvNVD5dXjqYLg87m/A
	rYJnkCxa0QfU9mLNZco1uS5eA1ruGFyKf15UocguAej6yLoNIRM77fziGKrsMSVy+aqBAzb06iB
	NEfvEfTcOWep/2h7ihoS1gNfG6UL+4whhKe+JIAcIYdLmqu31hsKB+cFz5+7H/rgzHW/Q/6nrq8
	amN+5PvZlWtA3yI78zPuV5FF4E2FnD8L8qV3/agiXeXXK2HciwhkOuxabmGeVIB4fc+jlx/5y4o
	AvT7MqYIRA3UTVw1LBQ6mqn6kFwYXe3D/GKANVvhEfPDxj5v8yP1t7Myn8PDytNs99+HVSHBh9L
	yVfdbAUTGwk2j9GSFlX89s5t/Zf+76vQ3+h9UOfWjetEwH+ySdOIp7jJsLmfl+nSY/5NZrWy9Uk
	CayFYtg2Zz6ipXUBQ30XX7Of6OJLsu9ophhD6dfNuyYqIEyS8B/4c=
X-Received: by 2002:a05:600c:a11:b0:485:2c61:9457 with SMTP id 5b1f17b1804b1-4888356294bmr18802815e9.10.1774996407150;
        Tue, 31 Mar 2026 15:33:27 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dba33bfb9sm1974165a91.0.2026.03.31.15.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 15:33:26 -0700 (PDT)
Message-ID: <22009c9f-f4cf-499f-aad6-70e94874dadc@suse.com>
Date: Wed, 1 Apr 2026 09:03:21 +1030
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
In-Reply-To: <CAF1bhLUGwb17jVD-7cVqA1OTRRRYbt_ow1+GZYbFgChN8mdKtA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 08:41, Jaron Viëtor 写道:
> On Wed, Apr 1, 2026 at 12:07 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>>
>>
>> 在 2026/4/1 08:31, Jaron Viëtor 写道:
>>> On Tue, Mar 31, 2026 at 11:58 PM Qu Wenruo <wqu@suse.com> wrote:
>> [...]
>>>> My bad, I forgot to ask for dump-tree of dev tree:
>>>>
>>>> # btrfs ins dump-tree -t dev <device>
>>>>
>>>> Again it's fine to dump it from any good device.
>>>
>>> No worries! Here it is: https://transfer.ddvtech.com/pY3LV9yw1L/dump_tree.txt
>>
>> And the last one, from chunk tree:
>>
>> # btrfs ins dump-tree -t chunk <device>
> 
> Here you go:
> https://transfer.ddvtech.com/FAXxEEq71p/dump_tree_chunk.txt

Thanks a lot.

All the dumps show that everything is fine, except we do not have a 
device item in the chunk tree for the replace target device.

After some more digging, it looks like we didn't really insert the 
device item for the target device into chunk tree.

So it triggered a false alert from btrfs_verify_dev_items(), thus 
rejected the mount.

Thankfully the check is only introduced in v6.19 and should not been 
backported to older kernels.

You can try to downgrade the kernel to v6.18 or even the latest LTS 
(v6.12), and try to mount them again.

Meanwhile I'll need to address the regression properly.

Thanks,
Qu
