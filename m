Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918F31D63F0
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 21:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776894248; cv=none; b=nNbN0ybGzW1T1pegrSW4Ma26Lhblod4EsJGmeX+QcJS+gRMD2BjQDMOE3Xe5Hzs9LlWH2T23Erms4HI/JnJf7S3EFIRQ5h2l+xvLjdryPrxU79+zP5DtpqIVfRJ3gMGlexUC7TflCTVau6tFcRtk6V8C4YgU0/ff9JXYWvv5S8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776894248; c=relaxed/simple;
	bh=b93BhIYXBWgnNLdhOyglugMH5ocs2Rk/28DsLHDS3EU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aGv0BB1YhAYeKQ/DEJSGbusf7qn3ZOn2xDPPcpDf3B+vgvuhRTjlnBwZ6GYDP6p57DtO93sXKp5C3q/Hm4hRNQA0WaE7F39u1RKKMYF6Ghqytyg7TFqBvn5eV8Y+8ZMB2ZrGWmRUTSH4g0zGJNMp5Vv/aJQFHH7GIuPlFkap54g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=e3jvkjDU; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="e3jvkjDU"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so42419655e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2026 14:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776894245; x=1777499045; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2SvxjJpfRTu7sPdYZeY5km1UBq5Aq4WZnmsToxOhLhI=;
        b=e3jvkjDUzvVcz0cKzzJdUXJL1NtLQEnYz9p8eXqfcy8IDaprqbkLok0KG5mf/tXZx7
         5z8MPAv5wXVoa+ihQLZm6b5aOClzgKfbCiFH4BARd/W7GKlA1/PzyoRZ3WKwsoRrWhGb
         6NRYIWbg7wvXsG6wQdN7d4knlT1lUFs3OBzLJnds9ndJMPe1RgUeWyxPFZgj7BJ2LOfZ
         vXxkLSUYRKjqg0H5RYoZ7Na3yZac00Qfaf1lrqT2TUuR77gHmb1iH7QR0LyH5pkoFxf1
         mfL0+uFOAZBpRk9G4qkYP+DZCSPaacff/g8+cDqAIO6CSuO50IbXoNKbytjVSAl58A5J
         5nrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776894245; x=1777499045;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2SvxjJpfRTu7sPdYZeY5km1UBq5Aq4WZnmsToxOhLhI=;
        b=AybxfaPQUwq8nF+cn6DdkULAv682DOWwVzxOfoUdMIPmR95cipwI1uuBNc04K2JOW9
         wdFm3y1pmTUlTEoV6fs8vv4dnAyK21EyWzFFGh1r+YeLJV09iVO956itEsgS5HNO+y/p
         I2HvWh4CKwTB9m7W6ElNHnWqvawFhATBV+6L/j8ClBQNcbrOF7ihCRIoPh9iMNbVsNSt
         T8Fg6hdkFWRX3oEOiWZc4mIOImeO1CLhNrlXmKTUtSuA4upDhp5fZ+Q1LCfnjQWVrA8a
         QVmxV2QF2K+s2j+jqe6ryavKTpsQmzRLgL/bJb3kh8c9DwVsglAWKZ4aZgt+sifcZRjs
         aJKg==
X-Forwarded-Encrypted: i=1; AFNElJ+uA6skixP183sN9PtVaIrvjqyhLIhopIaTBt4aX1nKS9EKtvBAL+cIIiN/hgYFSQ9ZUF0IX2igoTt0ZQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd10aQdbiOsCXrUy+QjGzb1PGuGo7gJpsZAQahBpNsFgPvrtOJ
	YOdjMpl3lmMGkoZo87J9EbPh6vTU0ydIz4YEqULVvwhGsXORnMyV0wK+FJvUV2ksl6Zk5H9dJwA
	whmFQQUo=
X-Gm-Gg: AeBDietKQQg1x8uBnPAyFXSaad4/wNkerDNL97iWYXY/ydDBn2WVXEGC7/PzGCt5wHr
	EH9resg6h5QDTGTf3cZOhSYbkO+bGVze3Q154ypfOxjkR1Tzc73LGaL+SnqydTlPxJz4/npS4Ph
	xmh1mfMfkVOL5Ma8e8yDxtY0/NE/eGLPhWIfeFIFBbUDeha1rlqEMNXOqPbvstjNewgY6S5tEW4
	/VGcFYE/qDiYkCICDLp7sAmpPtwlo+0ED+G7Ih8dex4AKxDDriEVqr/ulTdICH0RCyJBw/bIqpc
	2pQb6RwwnGoIi9wJ2Kdok62dJUyk5R5cYrg0iz9+2N1k+7GVBGpzg4BGpC/tQ8y9Um840uCb5OP
	KPAXRaxtYXxW1easAmcrzxK5w2QxppoY/XGYiWrGvv1OGKah2O4daNwRDta2zoxtgjVNNI56t+H
	S+JofQD/QSpO/Mb5DZBRxDQvdpbBOKDCZNmP68g/MMngpxdLPJPgRRXunCKZrbgg==
X-Received: by 2002:a05:600c:a08c:b0:48a:563c:c8c0 with SMTP id 5b1f17b1804b1-48a563cd176mr120614505e9.7.1776894244892;
        Wed, 22 Apr 2026 14:44:04 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab40786sm187417425ad.79.2026.04.22.14.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 14:44:03 -0700 (PDT)
Message-ID: <13e12285-329a-46d2-8182-b6e8568275e6@suse.com>
Date: Thu, 23 Apr 2026 07:13:59 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: Limit size of bios submitted from writeback
To: Jan Kara <jack@suse.cz>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20260422094255.12672-2-jack@suse.cz>
 <2f467264-0f15-4ced-858e-bbfdad4dcefa@suse.com>
 <kfksarpckjgqr52rk2p2uhabgb666rfrp2hewnra7mbzbcujqr@5pwsegezuzuf>
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
In-Reply-To: <kfksarpckjgqr52rk2p2uhabgb666rfrp2hewnra7mbzbcujqr@5pwsegezuzuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/22 22:19, Jan Kara 写道:
[...]
>> Iterating through all chunk maps may take some time for huge filesystems.
> 
> Yeah, I was wondering a bit. But since this is done only on mount, I
> figured it doesn't matter much.
> 
>> Meanwhile the device list is way smaller than the chunk maps, what about
>> iterating through all devices instead?
> 
> I was thinking about that as well. But as you can see below, we also need
> to know how the devices are put together in a raid and AFAIU that
> information isn't there at the device level... If there's some better data
> structure to iterate to get information about raid configurations of all
> pieces of btrfs filesystem, I can certainly use that.

My idea would be just ignore the detailed RAID configuration completely.

One point is, btrfs can have more than one data profiles (e.g. during 
balance, or canceled balance, or degraded writes), and even there is 
only a single data profile, we can still have different optimized sizes, 
e.g. RAID10 on very unbalanced disks.

Furthermore for real multi-device btrfs setup, it's very likely the data 
profile is at least striped (RAID0/RAID10), thus the huge bio will be 
split into 64K stripes by btrfs before submission already.

It's really affecting single-device profiles like SINGLE/DUP and 
mirror-only profiles (RAID1*), where we directly submit such huge bio to 
each device.

With that said, it will be much easier to ignore the complex RAID 
profile iteration, and just grab the min/max optimal io size of each 
device, multiple it by the number of disks and call it a day.

Thanks,
Qu
