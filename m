Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4692DCF4C
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 21:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775078520; cv=none; b=d4bUoXrWJcdMbnqdVggGS1jDqjbsghjIdY9N8q99aAtV9ATDBE1yKqvK8Q+AA4H/vEwrYzg/fy1S+aGGVcwOElSZvH53A0Nhxv/Iafo48RPu1Vfqx43pXt7dyc2msNp4tOVJ50aNxqZiy83t5W1O+cNlp1oXl7MyCY1hKHaoK5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775078520; c=relaxed/simple;
	bh=VXs5ca/7z+uZf7UU00wKh4jUJTAAipqkVQfcKhHBawY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rh5Qf/vGXNH3Z+9jvlFAO4balr0NbBTwUxEoB7rnoJf3JnC2pAqPlwi6m7W0BSMf1ruKb+ZkLEgDECzgOdUDAPURtcxCl2/qYZ7n5vH7XD3IFsQQFWeeAn/TZL1/ChS7ZfKS/ye9aUjLrF81dZH3nkl2KJlo2gy+GdupR//E+P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ft8YuKCv; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ft8YuKCv"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-486ff201041so1475775e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 14:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775078518; x=1775683318; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=In76OWER/pvOG6Nc/Ux94bh1AWJbyWHHXQr+bnXLXKA=;
        b=ft8YuKCvbejuBQS7O9XMf0th4c/kt6tThN5M5xMw/ORdbx5wOqhKUYxbR373YMkHHD
         ZVJiTrEdNls9TXVOfN0f6B9CIAoew6MGrLkdsBqbdwNHTfr4daytTClFlqZKrYecHTR/
         Jwz57O0pxpSy1LGGiPSQLzUAZo3JwXoYjrcBoAh6+11cmi6cXtCEJRAmyJ3hX7Lu0wm3
         1OcPN98B+xxVJXkfsVSWRgbfgSWdoivYA2+Juv4WfDJgF6iBwwTOcE25lMev5Wp6RWZf
         fx/ZwKYfMP8MyOsgNZQP+abfXe11jqacd7nhMrh366vXPlHmLJMhJu8to2DQ03AXHJpH
         hERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775078518; x=1775683318;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=In76OWER/pvOG6Nc/Ux94bh1AWJbyWHHXQr+bnXLXKA=;
        b=OBWa3fAViXy/uTRJQDT2nhkE8b2infTOHayzY+fw8VLYtkLI7YnzIIgKzikJVeNSFI
         Em1qbnMhdghxbBYQSQ3+fJMKz7Vox7R6iA/vjv4bIiAcfrYlMGekCu0QjHkg0aNeOZEK
         zCSQ5uueUiWi/yazVIvBlfLopqFjzwjq+rkMNdY1rwgih0EaUHBMEXcIrw5Km+HhPVbz
         Jnh0QGdUI0vHUOA4Vw6qbAn+Xvdna5bHS3kJFphko7k0EgRPIju3IYtVXvxiyQQQu2/y
         F3z5zz+O8PxuAZNo+QU4OBpkeAQ9rVBKv2pjEy2JMQTb/JFT78Px83nNxqCvoQmbndGw
         Epjg==
X-Forwarded-Encrypted: i=1; AJvYcCVHAh0jBp08kBy204EnlDapfBpZvIgmEmp4+P+kG3qqZFYB9Z+LaZTJqCv8alQgiPWRhosqU5hxSO1WlA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywb49y7bAP08WiD8mJ9S0w0Akc+9qGJVNdG7i+RT8pmcYctivWD
	ud0wIavwgKEUhJeID1VUF1QBWTVW9Y0LnjqWKMGV3P+7yUSr9F+CqWCJZBnY9LtXuok=
X-Gm-Gg: ATEYQzz1C9C9LFC1icmBYZS7oDYk9LFtfOfQYnmsxhdafQ0KcbdWZOsfX6Z48nPNVAr
	eFLzeVmAXMVnNoRmdzpqRzD9eiXZQc1ATHK2EoA+H6TtUpIeEXIqoqts8XWS8XQIxeOBqbxIEka
	bG6oZVXCmPjDbk0T7ja8ASqcVzE8KtrYmfO75NdwC+LTwNkVgsz6uDSaA9p0V/gk+6jFRC3RAzf
	0OwhCvnaV35oKqLDqhF34g7iPXzvkDUEyTITG0UJpRnvIzP0gkC8drSrFn0vDaUqNPkuG62RPe3
	YfcMBq+G2ilw0v+MWA3snLdxLfH7PAOSTpf3Jr4qbTWzCiL/yoyqjM2nBMHNSfkJ3DAhmd7eLxJ
	JnNAGlGNx++j0qwtsPjpPNKVRQ+zw8Bg+HZHyX/ELq9KOh9/YCSmCl0cTjDt/6Z+dUhVpobmpfE
	3nASmcxdgvafprWsD3Y1EfFrp9h3seepuQjr2FF7ZQIWqFrLsHINI=
X-Received: by 2002:a05:600c:6749:b0:485:4eaf:eb54 with SMTP id 5b1f17b1804b1-4888b76486emr13976055e9.20.1775078517548;
        Wed, 01 Apr 2026 14:21:57 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27475bc2asm7049095ad.19.2026.04.01.14.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 14:21:56 -0700 (PDT)
Message-ID: <fc202c52-cb3e-40b2-a80a-6ffda886f76b@suse.com>
Date: Thu, 2 Apr 2026 07:51:51 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Fixing a corrupted file system
To: Amit Shah <amit@infradead.org>, linux-btrfs@vger.kernel.org
References: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
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
In-Reply-To: <8c8e2466574b29ba1da29c325a108824c8373a85.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/2 02:28, Amit Shah 写道:
> Hello folks,
> 
> I had a msata drive that started showing signs of failure - error
> reading sectors.  I had a single LUKS partition on it (for encryption)
> with btrfs as the file system taking up the entire space (1 TB).
> 
> I got all the raw data from the drive via ddrescue, and have dumped it
> into a second drive.  However, it looks like before I noticed the disk
> errors, btrfs tried correcting them based on the erroneous reads on the
> first disk, causing those errors to propagate on the recovered copy:

Nope, btrfs will only try extra mirrors, but in your case your metadata 
doesn't even have extra mirrors.
Which is not common, as the default btrfs mkfs profiles will go DUP for 
metadata.

So you only have one chance and lost that chance.

> 
> # mount /dev/mapper/luks-ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23
> /mnt/msatassd/
> mount: /mnt/msatassd: can't read superblock on /dev/mapper/luks-
> ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23.
>         dmesg(1) may have more information after failed mount system
> call.
> 
> # dmesg|tail
> [960464.502742] BTRFS: device label msatafs devid 1 transid 772442
> /dev/mapper/luks-ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23 scanned by mount
> (10021)
> [960464.516714] BTRFS info (device dm-0): first mount of filesystem
> 28fa4955-eadf-4f12-a34d-fb7405bbd0a5
> [960464.526014] BTRFS info (device dm-0): using crc32c (crc32c-generic)
> checksum algorithm
> [960464.534065] BTRFS info (device dm-0): disk space caching is enabled
> [960464.559255] BTRFS info (device dm-0): bdev /dev/mapper/luks-
> ad4cc8e3-17c1-41f8-8d9d-bb831bfcef23 errs: wr 0, rd 0, flush 0, corrupt
> 100, gen 0
> [960464.607016] BTRFS error (device dm-0): bad tree block start, mirror
> 1 want 1116258304 have 5031253079992706228
> [960464.617170] BTRFS error (device dm-0): failed to read block groups:
> -5
> [960464.626009] BTRFS error (device dm-0): open_ctree failed: -5
> 
> 
> (I also have the raw file that I can loop-mount instead of using this
> other drive, but for this experiment, working on the drive is simpler
> to iterate.)
> 
> So questions:
> 
> 1. Can I do anything to fix the metadata for this filesystem, and have
> it mount, recognize and recover the data on there?

Not really. You only have one copy or metadata, and it's corrupted.

It may be possible to repair, but it's definitely not reliable and I 
won't recommend to do it.

All you can do is try to salvage the data, by mounting with 
"rescue=all,ro" which should give you some chance to read out some data.

> 
> 2. Does it make sense to drop down the filesystem to read-only when the
> underlying drive starts exhibiting errors?

For your case, it makes no difference.

Your metadata is only SINGLE, and that's your choice, so there is no 
repair anyway.

Furthermore even with extra mirrors (e.g. DUP or RAID1), btrfs will only 
write the correct data/metadata into the bad one, thus it should not 
make things worse unless your hardware is totally screwed up.

Thanks,
Qu

> 
> Thanks,
> 		Amit
> 

