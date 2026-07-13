Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FC43B47D7
	for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 08:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783933108; cv=none; b=hzcuWLl9Buv7lNJZ1SAAgTMSM4sywTl0U9VZEqlHdmF/1MzFY0GnRzbcsnxR0LevbBSkcXc7p0CKQUbP9nM5SK8hY0jPJuEPHqNKVQLLA8gPi+6uuz1VUHlhm0q0mKuxD0o8nV4VlukOL2nmHdsBJIfRBRmBNQuM3ozEDXcc6FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783933108; c=relaxed/simple;
	bh=cfoXx2Gu6eWP06EQd9LIn5CZenTw6H1T3e0nWzxS/bg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sqvYKoRrTfXMsqEuvrF2jeaztrEzv+I5Or3KdoV8OShqFv6OBc6Qph6CsJ4XKpAAxW/8CrbWaTFe4SC5oAo55j2PW4Hn5Ne2oZS4lNxSsCFgSvXqyE3Cts9Umh0JL3QvFm81dyTeRmMLdhZlyiRRHpFI20SmDnYJXrxHOEQgn/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aRIfiYqh; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aRIfiYqh"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15e03c2763so574363266b.0
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Jul 2026 01:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783933105; x=1784537905; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=chzWcFRnD/TdaVAm5esRRzurRYbCYIKUX5eMcXQsoYg=;
        b=aRIfiYqhHFyPA76YxzeFZmfqCjUPvYV3faVJ/mU7OWurVif7tZxIXKXDhEquEoZcwd
         PfUldQdSmxnHPIbjOkkg6u3l3FyBY/QLnKtZmb0qfurjbAhKOg8mnZ1bXgWFbt5p9gxt
         woAkL6Xn5wVFsP5PHizEPglbOVbLBaprh4L5QScqjFEU8cSIDKvANZ330FC++ZQI8EON
         Wf8XEQNvLPaxxyY0UczD3oX3nTv0adXIN9d9rdhqzIRgx+uZOJKqduD6V8XP+thNu4VE
         l2VeF9Dt49tLPtwX16NuV7BdjvUaWjzKv/Zg7CnoG4ZIS1NAtEZzMMdCF2O9N4/W/5EB
         E3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783933105; x=1784537905;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=chzWcFRnD/TdaVAm5esRRzurRYbCYIKUX5eMcXQsoYg=;
        b=UWjtcrIxgyGimZK4R7nwKl0d7SS3BlG+1ND5FOfhz0/LCGUWJCncUX7bDwJTPNaZqW
         B4sKjp0R8Ds31wKPfw7Yx2Hc4wxWUq2jx53zW4N2jsDPbfSPszYaCRUrM67cpub5Dgzu
         wMfg9HnKEPUCMJDkpga5wBpbwoHhjfH5gtNbeLQDaMeenE9VXG+Qgzo7ScrpcS5kKFcc
         1nizidaayTtRv4robQUPCpNeVkIvjTWwAE+EOgGZCV5nihzLVSwqsQq+C6piMfPo3VkE
         xVVOyvwXodrcM3H+UoMd/demw/42pWFSS8dey7R6tWbedi29hI739eXyW48mWkvCZe52
         Er/A==
X-Forwarded-Encrypted: i=1; AHgh+RrrvI71zAD425MJPSvcQ+H/iW4ZchaAZ8mwJpYB9LwMS/gdNea58J4etBztwVYQMxx5yXpcgM8BBIz1iw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwfgpbhGN4bQn8ciE/I5+z/Y4GdBNa5p+0ftasNBx7wfxCCsKBU
	FYDOVwvJ8zrdRYKp/J6VDud2ABsFKjkOUdMu6YlWnjcBBk1Dsk6XvlBT2VxcQm7eL8mSeAqE9xx
	eZBb0C5JFXg==
X-Gm-Gg: AfdE7cm7tYUxmPKt+VWFHLT6pwOn24zMtVO1wKz8rYGZ9k/hZRrhFEh64BSyAzs+eC+
	NwPEgvNSVTk6A31YVbajZfKzGywKjqFDh6zt5nHuI0PDLgCPTeahJdLSEeqZ1rohFaWrP5/PSZ4
	q8ctZT9iNNdyNMwbHSirJPmdGrlLp92iTOeZpFy1ZFwqW9cB0GmlWrWetqzea14DOLxi/75SFdC
	1+mxK2OcUyQgIHADKDFap/+7uQAOYDwnFFTnih0gS8ro+TCy2fQbqjHQynkXi5ciw5iiUh8zc/P
	XdGrOIejYpRsiWGI3BoEutiw0sMkz2cf8BxFOI8r8PYCHfMu8zD5la+pFWPw9px7vLj3SDdFZ/G
	6alBt1gOORUtcV9XNnw0lShJLCilh5yo+IoaaP+BU5VZ2lcZJQJf/q4k+PYS8mK2rPw3GZmC7Dv
	qM5iVwww==
X-Received: by 2002:a17:907:6b07:b0:c16:e0b:bd2d with SMTP id a640c23a62f3a-c160e0bc2bbmr491896866b.27.1783933105418;
        Mon, 13 Jul 2026 01:58:25 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1f030sm95717105ad.51.2026.07.13.01.58.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2026 01:58:24 -0700 (PDT)
Message-ID: <8179a878-729b-4298-80c9-252d51df0f5d@suse.com>
Date: Mon, 13 Jul 2026 18:28:20 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] btrfs: handle missing block group and raid stripe
 tree roots
To: Dongjiang Zhu <zhudongjiang@fnnas.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com
References: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
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
In-Reply-To: <20260713085010.1123273-1-zhudongjiang@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/13 18:20, Dongjiang Zhu 写道:
> The rescue=ignorebadroots mount option allows mounting to continue when
> some tree roots cannot be loaded. For the block group tree and raid stripe
> tree, this leaves the corresponding root pointer NULL while the on-disk
> feature bit remains set.
> 
> btrfs_update_global_block_rsv() accounts both trees based only on their
> feature bits, so it dereferences the missing root while mounting. Rescue
> mounts are fully read-only and cannot start transactions, so they do not
> need a real global block reserve.
> 
> This series moves the full read-only helper to fs.h and uses it to skip
> global reserve accounting for rescue mounts. It also reports a missing
> raid stripe tree root explicitly if a later data read requires a raid
> stripe lookup.
> 
> Changes in v2:
> - Replace the per-root NULL checks with a dummy global block reserve for
>    full read-only mounts, as suggested by Qu Wenruo.
> - Move and rename fs_is_full_ro() so the global reserve code can use it.
> 
> v1:
> https://lore.kernel.org/linux-btrfs/20260711051909.1313584-1-zhudongjiang@fnnas.com/

Looks good to me overall.

Reviewed-by: Qu Wenruo <wqu@suse.com>

> 
> Dongjiang Zhu (3):
>    btrfs: move the full read-only helper to fs.h
>    btrfs: skip global block reserve accounting for rescue mounts

I'll squash the btrfs_is_full_ro() commit into this one, as that is the 
only commit utilizing it.

I can do this at merge time so no need to refresh the series.

Thanks,
Qu

>    btrfs: report missing raid stripe tree root during lookup
> 
>   fs/btrfs/block-rsv.c        | 19 +++++++++++++++++--
>   fs/btrfs/disk-io.c          | 11 +----------
>   fs/btrfs/fs.h               |  9 +++++++++
>   fs/btrfs/raid-stripe-tree.c |  7 +++++++
>   4 files changed, 34 insertions(+), 12 deletions(-)
> 

