Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C891394496
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2026 03:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786418495; cv=none; b=XSFwAw4g38wpT5NoH2cU/+7E8r7FoPL03X+4l630cyPN7S4MKp3s05nJHDp2t3jtPwhbu0ZSGVsCqBnqybmvJHD2/QMtHQ/h+BHP4/zfpeVDTrN5CEmG7oSpLhsFnTopOWHCGoH6Q3USs1H89C7Jw7Ilt5rf2AK/xpKaGuEHwa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786418495; c=relaxed/simple;
	bh=hvHN3mFvKeCBP8FSb19NuYGrygGLH7YFACGdHkMkWm8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fHGNwjwtVwPjM6Lby6LHlqM/uz2CwI/dk7kXoyNEgthtyQV9qdeBL1lZ5ab5w5JukoolosK9cR7x/rEWwgJUtNpuampLcEJlmIjaQEAzceURDSgGbTZSk8VZjI4DmvSGAA0nMue3tP6lPR3Rgw22lYxxetrmAk/+ER5gpLHTt1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KyjzsbgH; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KyjzsbgH"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49800c6a846so24070415e9.3
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 20:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786418491; x=1787023291; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y20PBA7WmWlkti1qvfauRJlSHXkfpv0iLvAyqiLcTL8=;
        b=KyjzsbgHZ5/d4+1MYlHD+gILaMzONX4nIvA5juwnE+hwUd0VS6uMNYJQcKO0veG7uO
         8ZlmIk5Cok4M1q+eRxCsmLoer9e9NK66VjQyGGm24expMXZI1EFR7QlHsAiVPk1y5/1Y
         B85+L9R5b9WXTwJdcBlan1X1FHLhImbmqcaFVuDpVZBRiojKC/alnEnJK3X/IgOXKC+h
         c2MSeYy1VG3O524ZR9M4FOOlnSJYSRwO0BHxY1apCnR/CNmS14mrDmbbatIs5nIOLEFq
         1kJrDJIjCQPCtxwuyjtVCLQrb78BAVJqHb9fBL4/1vCePeFLODqnYdOON3x0/s6cZ2nb
         AZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786418491; x=1787023291;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y20PBA7WmWlkti1qvfauRJlSHXkfpv0iLvAyqiLcTL8=;
        b=RMPb7CgMnB7+Wyu3P+o4P5k34Xcl8doA2D+vFEaBGPqSCKOw3ZsgHMcvAEfzuC/qSt
         0ZPbyv4DbcJejtXCDqwtkhlUioiZSxqXfU4n7vB/GRT4AFPUH+1MKXNV6ARIWegPAlbl
         kRDJn0YNvOZVvcyZ48g5Gz+ublYXRwqrWAVMZqR1GTkM2xiUf+PiEmMblF1swe+XA+QM
         j2AtPhrPU0Ii//CPlfxOBEbCyTOj9wEUXEHkfQWTgNar2JLbTf9opWWr9ug74WNqH+6M
         o3hcoPPPi2Pd1afKKfqXorVgRuwoTBQ6ZpWya2ogoT//wtFlio3DyMR3+1js/Q3GcIDZ
         SjxA==
X-Forwarded-Encrypted: i=1; AHgh+Rq5kdu2GcjRDNZcFqlECtPuf5OAYbDwEf2P3oss3C4f4xxjZrxeeiCKb2QWWOYlAEPpVcW9wbkYhnZkLw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzwDz2bke8rmSU54ouLKTwzAHAvNQPC0SE2hCW+Bxl0fOqeWKg0
	FtIRnjB88QE3zQL/EIx8JEySxD1oZ5D3M0bUrOygSSqhyKOvZ9fzhzOlJqoHfATuYNA=
X-Gm-Gg: AR+sD12/+HNFRItP2XuAcz98+OWsDIgJas0C28YXeCzH8uz9OS6ndiW2qbxIpew0ChY
	G+LMRiswgB3XkPqyEBv04hHnIO2Qwf7ImimAFlAR7qM+Ao53zXjz0cyux/rR8ht1KAbcv9n3KNo
	6R6X/jSGaLrvaEqXBd0fvNxX5ReG70YzDyWF6iIeHOzHIGQg7OK5JLsRAlvsCTbA83j7QLDuZhS
	yN17YskONcyQ7UFF375FKsmBDHLMCYNGf+CaBOQBdHs8fOepJVa32gYTQvRSwXoD9GBhD3FAgbZ
	7CTczYJtDs8iHdv1Apt+no3PKF2x6ygfpBQsDP1sU6LEnHcEVWYGGdh3J3CCmSnwm9amK8U8xcv
	u3hm4wjeanfpFzi8u5wpyAY2HZLXSuWaqWLyX0iWYS82WkbxlIyB06qCO4aNOo9XdWbCplqcEgP
	V+++Vkwaw6X414Qb0NKoaHVjXpxfK2aFbPV9Eqp5wuBRidlTx8xP+FUum7gCaok/+y
X-Received: by 2002:a05:600c:a47:b0:495:4a22:d684 with SMTP id 5b1f17b1804b1-4997845f6afmr3610325e9.10.1786418491442;
        Mon, 10 Aug 2026 20:21:31 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbed970200fsm119927a12.7.2026.08.10.20.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 20:21:30 -0700 (PDT)
Message-ID: <a27ce424-d3a4-4a8f-bddc-40757b1d40a3@suse.com>
Date: Tue, 11 Aug 2026 12:51:23 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] btrfs: add per-inode compression levels in xattrs
To: koraynilay <koray.fra@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-4-koray.fra@gmail.com>
 <870d7e1f-3e87-4eac-86fe-107af7336101@suse.com>
 <DKLRY9Q5SEI3.VUDASVYPW9MY@gmail.com>
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
In-Reply-To: <DKLRY9Q5SEI3.VUDASVYPW9MY@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/11 12:25, koraynilay 写道:
>> I'd prefer to have a dedicated patch to set compress_level to the
>> default value 0, as a proper bug fix as the first patch of the series.
>>
>> As you mentioned in the cover-letter, this is in fact fixing a bug in
>> the old behavior (mismatched algo and level).
>>
>> So it's definitely worth a dedicated fix, so that we can backport the
>> fix without pulling in the full series for older kernels.
> 
> Ok so, after thinking about it more and bouncing ideas around (with Zygo
> too) I realized one thing, that while it *is* technically a bug, I don't
> think it's a bug worth backporting.
> 
> My reasoning is simply that there is no use-case where the current
> "buggy" behaviour would be damaging, as the levels get clamped to the
> supported range anyway, while arguably there are (albeit very rare and
> probably not very smart in the first place) use-cases where fixing it
> could be somewhat (limitedly) damaging.

To be honest, if the current behavior is not damaging, which I agree, 
then it's also not damaging to use the default level.

After all, it's just a level change, which is never damaging.

> 
> More importantly IMO, doing this would allow us to explicitly explain
> the currently undocumented behaviour in the btrfs-property(8) manpage as
> "just so you know, for kernel versions < 7.x cross-algo level leakage
> from -o compress was happening".

Which also applies to option 3.

> 
> 
> 
> As for how to handle it after having support for levels in the XATTR,
> option 2, aka leaking the compress level only if the algo matches, would
> be the best imo:
> 
> Example use-case:
> 
> - /fs has various types of files, from media to git repos, that would
>    benefit from the normal compress mount option;
> - /fs also has big virtual machine disks, that have very compressible
>    parts but also very uncompressible parts;
> 
> using only `mount -o compress=zstd:7 /fs` may mark the vm disks with
> NOCOMPRESS as soon as an incompressible extent gets found, but setting
> btrfs.compression=zstd won't, as it will try to compress every extent
> anyway[1].

BTW, the default level is 3, so 7 is already trying to compress harder 
than default.
(At least from the official man page)

> This way if the user intends to change the compress level for the whole
> fs, they can just change the mount option, knowing that the new level
> will apply to the (new) vm extents too, like it will for all other files.
> 
> In this example "btrfs.compression=zstd" and "btrfs.compression=zstd:0"
> would behave the same, which means the file's extent will get compressed
> with zstd:7, but when the user remounts with e.g. zstd:15, they will use
> this new level (only for the extents written from that point afterwards,
> of course).

I'd say, in this particular case, user should specify a different level 
for VM images, after the level support in XATTR, other than relying on 
the global mount option level.

> 
> (I'm ignoring the case where the user wants to change the algorithm and
> let the vms inherit it, as for this specific use-case that would likely
> require a whole new feature/property to say "try to compress anyway but
> not as much as compress-force" and probably most people use zstd anyway
> nowadays).
> 
> 
> 
> After coming to this conclusion, I'm personally pretty satisfied with
> this solution, while I wasn't as much with the other ones.

Since my idea is pretty different on option 2 vs 3, and I do not find we 
can persuade each other, so I'll leave David to do the final call.

> 
> Thanks again.
> 
> Best,
> koraynilay
> 
> [1]: https://github.com/kdave/btrfs-progs/pull/1152/commits/7ae9e2aa7a35af5e7b656424957a558a9d0dd676

