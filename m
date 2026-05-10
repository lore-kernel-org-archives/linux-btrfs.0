Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D302F8EB7
	for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 08:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778401104; cv=none; b=e9QM8iq4ifY8HYWDvXLunKgr3ZNAigA/rI2l3pPB4gCsHZm1s7pnydQSiIHoHKP+hCbHZquGn4m6OU6I3dCYlaC7b7RGRFSB9XR4PjJ41gGipLlcBj7Y9y+O0/2GaGkhA17k+tu491VGV+OvyT1nbkHSgqXmVEj/hltfqFhEWcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778401104; c=relaxed/simple;
	bh=JAOFGxagWphsjSoBZ3dgyHdJsmtnQNTAN6e+f5Vc/h4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FVTmjP8aer2I2bkngeYnCBUkhcHtHOGButgqsGvwlQ9rZlp8MSsAVIHPO41Jy0KeMNi5tXzK358teNsfE96oKK5vePxNKKFDgsIB8J7oMjE9w6ShCUeB9dyd4NEaC9DPf51okb1iQF9++7okJl/BSxMbF+wws2J5CF26s5WAGUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=TId97z+H; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="TId97z+H"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-48909558b3aso36220795e9.0
        for <linux-btrfs@vger.kernel.org>; Sun, 10 May 2026 01:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778401102; x=1779005902; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZyvbhqF5OJW/qs6W9esBbuCrNwxMCrCtXof7UVVfGw=;
        b=TId97z+HqrbYjmitiq3cEhrCJKjXkkPdXrsAlp5C0A4ZwT5HcxxaGI5kx0AdWEYqmU
         XXrzUu2sQb/3H+g3NrsFj24kRxtpKOtFAo5LhhVjgYGGSUAnKlL407H6z4505RH19GsY
         E47++ERRQfqcmwImtIGGmi6chiqsZOR1sTdoSN0d0UWg2N4XQdXPTRThLJivs2PC8LcW
         R5tVBrO+w7MgnosUbJlC2U5OqgBiJzSy4+S61P5fQDQ5j+NoQ0DP7MaSwivdE98wUet4
         DTiqYg8kRAsWyPBKRuV34cqieR11iUNjafXUuKiRhue9349ePGaOiHSXygPdRD/bvTS/
         EHnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778401102; x=1779005902;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZyvbhqF5OJW/qs6W9esBbuCrNwxMCrCtXof7UVVfGw=;
        b=QXu399VyPS0qv4GEvj4dbnJPUWs8rNa2VQBy6FNJIifmjFjjXMI5yVbuLlsszunkbd
         B68M7BwbTIhiu7uO1qJ0iCcTwj5uec2syhtkFfVSWJQSXlBJX7UejQ6H6RJoVBIwaX2j
         s6hUAqOWLXErIJfoXStKR8n5PUBuVeu8pb1SoWWkgjsy6Y58gw3WMeynCwY3J8+FVlhg
         S4PCypk3hUpz2UlrdbqBy2Z2eiKqvVXKjiOCoXS3UmFOpuEPYacZbZkOs01rTa1POSHu
         F5ToucTyHBCwnJxiyHJ23sghQf3FiLWNxLm8Y1tqUg5kyomxUWaM+/RpV+cJYJJeN0e4
         aFfg==
X-Gm-Message-State: AOJu0YxcTwcuWUiatrKrZV17bo91fFkISUd84v+dXXxBb8vBGQ1RVZF4
	uJ1AH4aw3CLEgi22oQLVsahK7GYNL2xBVHu+GSQQhbgRguUyu/VcDT5PWiFJDLQHyIo=
X-Gm-Gg: Acq92OGnYizMDMnIUCEEX+E6Y5IDQHaUIxQQQ4uFSAXNU3xSqBNY3raPo6bFhkKxbkH
	E086KHImGT0PE0mfBe9CH8/VEd0JjXS9xKEENfmhFqiBP8RWUKTyuIudjecBECBq7ouKgBxPOK9
	+wC+xSvJRkE6dH42pDiGMDmkEvvKQjb1AtpV7tC02WfEkDy7QaOmrxqf/h7wmRtHDqRHGFUQnwF
	42KV+OBxG+mP/6pdLGmdzjcqLqUA/iGmp6XiZm6mcau9eQPqpsIZR+SwZlXKJCRNb/gOxF4+VNW
	L+Gbk71go1+4MHsFzEJ85rjfrAZxYXowH0XKiHoPYVDPTtKFWWeL/mGRDE7cAydBfH44AW8zwQe
	OtAVoDrKL3aRlOB70lwEXRZeFvvKkSJIOn3veABEscs3V6ekrf/THr2vtf/YEu0kLR6ARqr5anT
	AEDDVgNCX4iCzSXzxyb3yAmbmD1Pbbq0sGevsw76p/YtzJQS7Ghxvipr81NsLjZLjnXMtQLD9zO
	G2ZfqItiGqplQ0kwBW5gBGID9YW9wf+oiCqghOFWKBNU/I=
X-Received: by 2002:a05:600c:c094:b0:487:5c0:671f with SMTP id 5b1f17b1804b1-48e51e1a7c4mr226956885e9.9.1778401101626;
        Sun, 10 May 2026 01:18:21 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e35494sm67917865ad.49.2026.05.10.01.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 May 2026 01:18:20 -0700 (PDT)
Message-ID: <e66d9473-796c-478a-b88c-ab0fac5e119c@suse.com>
Date: Sun, 10 May 2026 17:48:14 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: validate ROOT_BACKREF name before copying
 subvolume info
To: Zhang Cen <rollkingzzc@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, zerocling0077@gmail.com, 2045gemini@gmail.com
References: <20260510074943.2644335-1-rollkingzzc@gmail.com>
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
In-Reply-To: <20260510074943.2644335-1-rollkingzzc@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/10 17:19, Zhang Cen 写道:
> btrfs_ioctl_get_subvol_info() derives the copied subvolume name
> length from btrfs_item_size() and copies it into subvol_info->name,
> which is only BTRFS_VOL_NAME_MAX + 1 bytes long. A malformed
> ROOT_BACKREF can therefore make the length underflow or exceed the
> fixed ioctl buffer.
> 
> Validate that the item is large enough for struct btrfs_root_ref,
> that the on-disk name_len fits inside the remaining payload, and that
> the copied name does not exceed BTRFS_VOL_NAME_MAX. If any of those
> checks fail, return -EUCLEAN instead of copying from corrupted
> metadata. After validation, copy only name_len bytes and terminate the
> result explicitly.

The validation is too late.

btrfs subvolume creation only accept BTRFS_SUBVOL_NAME_MAX + 1 (for the 
terminating \0).

This means a subvolume ref/backref should not have a name longer than 
BTRFS_SUBVOL_NAME_MAX in the first place.

Such independent checks should all be done inside tree-checker.
