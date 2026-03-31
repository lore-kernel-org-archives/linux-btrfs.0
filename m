Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0787F4534B4
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 21:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992718; cv=none; b=jYsPjwqf8k0gnUXt9TkYpmgpQDlTpqhH0oDDeyLZbHpfdFjzQDb20RJRlNaAH73WnBASyuVbhmvtuywP+fHd0+/qLXznfaHS2WOfMUAXVTmncc0AfuEkLRFXXLN4GKjWuSIN6ukYSq39rm1B/SrOV2MFD9/AM08nQiaoDf1Z4xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992718; c=relaxed/simple;
	bh=n/vML0lIDPY8gs1qRevl3rJUAtFn/AGrS84ZwHiCioo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dbpiqzt7qcvUt1f6w4cQVXLBfMEs8Zykrzwb/4LMmabqOxvOUheKCerPEQSVr9C+wwE9oKzBg5aXJKOhbQekSqjgY9KpfQTPspafzZdhH44Zksy1HkUHhzW04aQugfL/zxZDPpy8ftQnWTUgLoB/KTG3NG7zO83ZAZcTaC2qjp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JG0aaW1V; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JG0aaW1V"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-486fb112c09so57092035e9.1
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2026 14:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774992715; x=1775597515; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=rVP8hjB7m5YmygF07yEVqy4UbbUcLu19KOolDgM/EhA=;
        b=JG0aaW1VQ7KnstCEVpDMRXQHke/Ok1ZzYftPehiKDwAFZnE6vAU6tibIsAd64hyDKM
         9z00nRy6QWHhX+KsQ6gUSWmnij6MaiPtiGBKowwe4KhEVLSTF/SqDCE50M9SxPXplVEs
         2E7V2/FvlCCoASASY00bFEPNupqan+Y3N4jqfzWTCKi4ZXJvGd8eWU3CbnMr2ADiDPj/
         AZI55HsPFZ9C0to4MS31uoXz+x7Bk55VS5pYP9VCRNjBJxUB3y+k0Obu3fic+QEnFlIU
         HDpaQaKzm+xRv1FDh+GXnRANrx6d4ud0VtqXvAQqS/IjTUk69/KGPve5D0/nfIgL3pVr
         Vfvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774992715; x=1775597515;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVP8hjB7m5YmygF07yEVqy4UbbUcLu19KOolDgM/EhA=;
        b=NpajKRD4IejWNtUfM0tVOwG/NGjN+YJ3E0k+vkHpusHESQPqtwt6rL8ndCq2OEOD/X
         npmS9jfl1J0UjOrWxKRZ146FmxJQLsxySa0mTh2wegl2BOMNdjZT4SPuXJN/718eaovd
         w76i3drfdD8GtZXMQG556p1Yd17/9Mm56Slnf9RHmKIiJaIyyRI1hR7om/2wXBAyEYBc
         hQrBT2rjn29dT8nYxC+dqPXXSxr6lKoWjCVsvusjnBTCHGzCMdN9oCGhfm4G8RkylqWH
         FckOyrt64Sy5ZpF/RX83bhY8dUaKIqZAliHYAy/u5+ZQFk5rPG3qv/3ly6IEtthR7YV4
         dwaQ==
X-Gm-Message-State: AOJu0YzU7cptBSzmpGk99iitq83MJnYcYMVBx3VIlh26t0+4D2pL6ZE8
	pPibSTicvKz3d69PNGRg4+oj0gzvQDuOTj+AH11LaCuGslItTMmgkHzGMFhcH3Qvl3haXcWKMEl
	CgpgLX+w=
X-Gm-Gg: ATEYQzzInM8ncOB0zPxAVUVS0t88HVFKTGLrG8E4eSn7SSldmvwnew0xLPcGJq5wNMt
	rcB0ysRwroRhsTGjWm/WPfdZlN0sk2m46W45OyKamAayYIWLfgK1jjnJmpLfx8TO3KapINTpzUH
	0A0TAvD+O/gj+2/XNWQFoFaioWLGKKlHMb6rBVZylnBJxqZblD6zjmkM+jgT+LGBQToFLCCr29U
	Z27hGHliL4JqZexxKoNCzI1QSEe++JWhYakG0IfWPaGxyjUPlulvV6WrfOdRYFLGOzzVUlL8gy2
	rjshdfFYuvre1IpWH8ycJ57Ca/NSh5rxXsgP9ZwnZ0iNmhlQ8dDfblZp9kr96gB2auuQFT4ZzRy
	rc61YxiN9YsqQZr1F4NT6QIyj8APA3AtYmZbWOswXYUgwbd+GVbhizC4XU8EztoI7OWF3vkExHS
	ZLfbjW5+gwYvvAJuu7FwiD/9tXMvMoa5/vSoGP9xZmFT6Fe/0PrVN4ZoUFSdjflQ==
X-Received: by 2002:a05:600c:8488:b0:486:f4d2:eac6 with SMTP id 5b1f17b1804b1-488835682c8mr16860555e9.13.1774992715258;
        Tue, 31 Mar 2026 14:31:55 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c76916cce42sm9952327a12.9.2026.03.31.14.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 14:31:54 -0700 (PDT)
Message-ID: <d470a043-72c0-4124-800c-385c19007b9e@suse.com>
Date: Wed, 1 Apr 2026 08:01:50 +1030
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
In-Reply-To: <CAF1bhLWJuHjf8e-4o9y-hhFqadpQ=13P-PZSJLem5Q_A2T-CTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/1 07:53, Jaron Viëtor 写道:
> On Tue, Mar 31, 2026 at 11:14 PM Qu Wenruo <wqu@suse.com> wrote:
[...]
>>
>> Kernel version please.
>>
>> And with all devices (including the new and failing disks), and "btrfs
>> dev scan", the mount still fails with the same message?
>>
>> If so, mount with "degraded" mount option, and try to cancel the
>> replacement, then try again.
> 
> Thanks for your reply!
> This is on kernel 6.19.10, the problem (and start of the replace
> operation) was originally started on kernel 6.18.2 - I updated in
> hopes that would fix things, but it made no difference.
> Yes, with all drives the mount fails with the same message. Attempting
> to mount degraded (or ro,degraded) also gives the exact same message
> as well, so I have no way to cancel the replacement (that I know of).

Then please provide the following dump, just use any device is fine 
(maybe except the replace target/source device):

  # btrfs ins dump-tree -t root <device>

Then the following dump for each device, including the target and source 
device:

  # btrfs ins dump-super -f <device>

I still remember I handled a similar bug before, which seems to be a 
bitflip in the devid.

And just in case, please also run a memtest to rule out any hardware 
memory problems.
You won't believe how frequent such problems are observed, especially if 
your NUC is running DDR4 memory.

Thanks,
Qu

> 
> Kind regards,
> Jaron
> 
>>
>> Thanks,
>> Q
