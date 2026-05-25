Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F7B1F4CB3
	for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 22:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779747629; cv=none; b=hr0ZaJmlwRdzcRvDa8ZVOTvieXMSwqKRRBOzE6NTieGa6Y+CZnDdG7Lyx7z3bpkDrI/50icj0a86v056MFIQ6YgcIWC+P+NGK8dTJ5gXH63boOG54BXzVTIqh9uDn5R3C5bIWfw67NArxbysX76BV+WVBpmvkzLYq5EUe5G59Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779747629; c=relaxed/simple;
	bh=RPAa5PjoyAsFglJjJL+GGBXL7WzPsdKIRb8dJsYsSBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=BaEJkHJXNltQByeYqoDGhcCVei+pR5s90QKraIjnH+VGusibHJj8P9f5QasjB1yJ2fsK6WCrw2LOvF/O4jXfu1Gd7yldJg7zs3MtJCXh7bN/HbQQocl+UaB2nyg/X9wsaLze/l627k1RYpZMNlKYJD/Qw/BHCq4Gs3U5wQVQ3g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HfLzBYLY; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HfLzBYLY"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49048e043e5so24344525e9.1
        for <linux-btrfs@vger.kernel.org>; Mon, 25 May 2026 15:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779747626; x=1780352426; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VynYFYhYrXOoan1FnDKpSXvMv5VKvQ3MRzJXfHj94ZM=;
        b=HfLzBYLYaFa8GS8DK97FKBZbV5ZS4qHRYr4ehImOejfX51JDVS2HBU+Gk32zPl2Na1
         CxztIYfnq/BM64lb5Ut1+E44pfEJewWHC6UoLRCKAR5WWKNtr8B/nis0pFJ/wLei52jd
         JKQ0hYopVi7OQzjPsWu6jVzEEjnZrcIMYs2ow4Pv+h0ri+fvjJs7pqw+WCtHlLtnqNSl
         2um3EaI1mXrPkHVa+mHb0JQl51e14YYbkNvsV0Z5PQJLn0DKxXMSI6ELsaSH9c9Yh6oo
         u6kgCVW4u5Kscr5+l5PdFm4tzyltsmaz7012sHMJYplQsREGjwUrfzENMHCUZ7aAZ5FS
         Rj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779747626; x=1780352426;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VynYFYhYrXOoan1FnDKpSXvMv5VKvQ3MRzJXfHj94ZM=;
        b=d6OxOk0AV3NqbEC+hSJuhwBzBF7sfphOLPDjllX1YV2yydu3HIzUAAHX1R4hyVBDxX
         kJ17h0aKNYaAoEP1my4j3mmmDXbO7/olJ7FGb2Pkvfo8+NOl5/zB7WiNmnrgwxEW8I5j
         iXV9YGzXueRhjRWyAxJzGLw8DexneTOb1nFy+I1NeCFVB07HL7qmXf9teTwp6nj6EVyV
         ug4S2U9+GWN0atciqIJsQLnD37Hjktd4v8irvFDlQSLuNFr5hm8BbuWNF/BHlfoYgMbM
         iM+68pKR1e8BuyNJLq7LKRogbvxp3/wxrX7sUpFHU2GYSR908FEdW6eWrfGaRe6Q8yxs
         QR4w==
X-Forwarded-Encrypted: i=1; AFNElJ8uvFcg8C/mORinuKRAvKDXSqBJTWy9URU5v6NdGRnLUofqNN5bZn5tsUDpWYVKlaMsEqccvUi4e6waXQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlVYXnm6HuY55AxEDGpFLKgQe+nP4CTg/VyNrkUhFlQZP44JZg
	jh7PiQJIIVzjAAE94BFkd0X9j3WtWu3Uppz2Lw7RPfuTVWlCjVC3icCJPuOTDWY9uI4=
X-Gm-Gg: Acq92OFtVcSLc8wvHZ1O667y8kwqo0Dz7RhY3xre9yn29WTZNBvqd4+K9aYJJETClNd
	blWI6DGYYSo2/1Y5aU7uHkRI/Gb7Gi0ww/KKeKGu+g3Gy0dsu3C7MsU30OBzuR1L17RmRgR+kZc
	ErtdI41C7y1GegGlAawqJF/uT0qaWvCXbpwoxtMpWPGVnNh999E8LakCuJ4aadURrb5D1ErzW4I
	/NVCk8Qft0VoyCEYhxI7AhE7em1mqZsb5LQbB5ZFJWgxkQi1qW9ioIwk5OnIgtajYGX9wNLPaZt
	lGJ4kcXMcl/Eh8C/DHzIYCwhKksXT824kpSAdUq/Ua65C/E1N5CCTunDG4HnIfTr1yUt2RqLkzj
	ixNODxyFf+ZKtAqWEqUEdjgCIO3fpXY0oZJ8TCbz5tiY2o0dT70qoyn3ZCabt7+m2XpZb2dLAZv
	dS+XNd14VgqNczpxz4v9YS8/blLlyrML6HJ6GwTanv0iru4NOpdTW0LLf045aIatqPo7/1oZzDC
	FlhWxHnFAechrmYg4qjJRlXzSI9kvPMvNKRTv8ZdivnjAM=
X-Received: by 2002:a05:600c:8b84:b0:490:5466:8576 with SMTP id 5b1f17b1804b1-490546689a7mr210679215e9.1.1779747625923;
        Mon, 25 May 2026 15:20:25 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58d9ce4sm100987935ad.64.2026.05.25.15.20.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2026 15:20:25 -0700 (PDT)
Message-ID: <c4a6d71b-c4ca-4c98-80b7-4aa32fa396cc@suse.com>
Date: Tue, 26 May 2026 07:50:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: I Need help. can't open btrfs drive after power outage while
 copying files
To: Brian Thompson <brianbthompson@gmail.com>, linux-btrfs@vger.kernel.org
References: <CADcHvwf1-hdAkE=kOJO0AQkr=8=si3X0jc8Jrrctc+_YboJ6fA@mail.gmail.com>
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
In-Reply-To: <CADcHvwf1-hdAkE=kOJO0AQkr=8=si3X0jc8Jrrctc+_YboJ6fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/26 05:38, Brian Thompson 写道:
> Hi. I've been trying to recover a 12tb  usb drive that I formatted
> using btrfs. The drive is a WD 12tb USB external HDD. I was copying
> files to it from a different drive. The problem all started when I
> paused the copy, and then lost power on the drive. Now when trying to
> mount I'm given
> 
> BTRFS error (device sdc1 state ES): bad tree block start, mirror 1
> want 1065746432 have 0
> BTRFS error (device sdc1 state ES): bad tree block start, mirror 2
> want 1065746432 have 0

Some writes didn't reach the disk.

Again, a strong sign of incorrectly handled flush/fua.
Considering it's an USB device, the USB<->SATA adapter may also 
contribute to the improperly handled FUA/flush.

Or are you using nobarrier mount option? If so, the corruption will be 
more or less expected.

> BTRFS warning (device sdc1 state ES): couldn't read tree root

Furthermore, the corruption is in the tree root, which means almost 
everything relies on tree root.

> BTRFS error (device sdc1 state ES): open_ctree failed: -5
> 
> I've tried mounting with
> -o rescue=all,ro
> but, it still give the same error.
> 
> I've tried running various btrfs check and btrfs rescue commands to no avail
> for example running "sudo btrfs rescue super-recover /dev/sdc1"
> results in  All supers are valid, no need to recover
> 
> I'm at a loss, please let me know if there's anything else I missed or
> can try. I just finished making a dd backup of the drive, just in
> case.

The following dump please:

  # btrfs ins dump-super -f <dev>


And you can try the following handling using different tree roots:

  # btrfs ins dump-super -f <dev> | grep backup_tree_root | sort

It will show something like the following:

		backup_tree_root:	30539776	gen: 7	level: 0
		backup_tree_root:	30605312	gen: 8	level: 0
		backup_tree_root:	30670848	gen: 9	level: 0
		backup_tree_root:	30785536	gen: 10	level: 0

Then pass the bytenr, e.g. 30539776, into btrfs check:

  # btrfs check --readonly -r <bytenr> <dev>

To see if any bytenr can make check process the furthest.

Then use that bytenr with btrfs-restore:

  # btrfs restore -t <bytenr> <dev> /path/to/restored/data
> 
> Also, i should mention I'm running CachyOS with kernel  "7.0.9-1" and
> kde as the DE
> I should also mention this is a fairly new drive, and should not have
> any bad sectors. (smart status shows good)
> 

