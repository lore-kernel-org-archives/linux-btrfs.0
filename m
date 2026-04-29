Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26521CEAC2
	for <linux-btrfs@vger.kernel.org>; Wed, 29 Apr 2026 01:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777425120; cv=none; b=QYTDhj+nCU8qfoV9Cf5Jb2nBzx1Ce4Zi++8Dlm2zfmgHaY+Dkwe3QVKO174jfoACOBDRjjvviHm+tAJ7Rj9HB+puCW3ecralqwYhR7/KPHz/naX8tmkUOeruB9XcIegGUzWX2h4fCj34m9WN9sceCBEGwGQ5UNY2zGdgpA2+wic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777425120; c=relaxed/simple;
	bh=rECaz3z7/LajCqBR0oLzDhq0D8KjMFSjKluN0fiREg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZvrBHz1BcTLfAcR+DmPFOtrjQ+mJ2D5srLicnOBjiHD18pnSRZ+TCLTd+pnFAmRYU3wFhD1F98gCillKPAGDI0fj5XicCWE2pQFg/jS2D/jZgXBCJj+BUmXAKaZBAKOdmvtIaj6ZHspWRRgulFu372fwgG96z7eImifAOLbTE/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=PjMe0t4C; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="PjMe0t4C"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso61631885e9.3
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Apr 2026 18:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777425117; x=1778029917; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0QN2nVR9+RYZL51uT1EIrTjIEPL2U8ktEq24OZlfrm0=;
        b=PjMe0t4CNOavQzr79ilVAklmz30qSmbG8Fvmul3yFs+uM4Io2Mq8w0m9x8XpANbrYu
         l8eQL6OYCHDBdOKkNI1/aigqDTxllP6WotsRRwNGBVXjuDyVxTdzYFEQjsduxs2pwrVO
         QjXYs8WD4c4JfVetF4yWFHOTxt+VstvdfbhJAVLLQk3ITFd3YrhTILWrmeOnhIRTFCWn
         a0+eib0HPvdof7xgVSXz7uxQkR7/7VUndi35VvXI2cIQqN6iRD+Y8njUiyeBNKeWP0ie
         pl0XMzvXydkz/ZFDlaP3X1if0XKvySv1QHV1brW730naHp+hEIgabjceq6icTde5OTWT
         q5lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777425117; x=1778029917;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QN2nVR9+RYZL51uT1EIrTjIEPL2U8ktEq24OZlfrm0=;
        b=GPkh7qZhtHAGpaI4qoI+EwAkuQ4/taVDc6aESUHYP4yPc8dkebO5VyQFMImcZZ/Jwf
         z3iOzATI6EnOtnKPQaR4WPqyjzrrxDc5q0dAMQJdgy3vuhlSLJAJH6iw+IWwT6ULHC12
         6fW/2hUlYXklu1iHnuepyiRGcUigGOtoLBOHNoldMBIuYvZ13c6W5uivgA6OZsoBpLUl
         VBcBqFQe8qt6CMnSf+GjNEAA4NnyLT/Z7VlXyr/wMVwIL3nTIQa/wrAG+NLlvGW/FDk0
         gY7SL8x/GLH5o0Un4fJ34mqzmf55Y5gAI8yUkthlorkcwiunAtSiAzPpKjBrT9T8zKPh
         Bc+g==
X-Forwarded-Encrypted: i=1; AFNElJ9a4eZMVL5iGD1vWEkgrLjiaQQGbj8/+yji1Ev+QpfdrZ5Hy12nbk6+u7daUrOr+HlvEgqXjwejFKjyCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0P3K/FKdvjg42eEN+ymH1cm0hJ+rpaZVKdSEWF302dNFNp+/b
	MZF1756nsKeUeYcgskQwPIMvDwN702xEN4yP9l9wTXGlzR/5Pbbi0Q4VzQAUsBSyVLI=
X-Gm-Gg: AeBDieunj40UEdIV9NaPLeXbkm7kLVx1kx0Jxx06hCcsg/8buZVcuF+f72T9XIwrQBG
	e3iB5RN28EoQvW1fr8kxsPTI+6i5xs6J54Rtcu2+MYvD1nfleQUEcu4oNlBUjg9cjWMSQszW4gX
	rvJBTJOi2fd/2n2TBInC2qnsUQR1V6EsQeFFDxhKtd00zAs4T83WtbD+6VeQ82djJ9p/vdxNHe5
	D5sNhM4I+3axyFgh9KOJqm0DXpHKs7O3gidZr6Gqxj3MDo98MdRsp4IDAwdrGg2caWdZEmO3yWZ
	oVA/JJQbsxxvJ7EtrX1oZwgO/7+UPKuDA2r8bmypb30bqdw7NU8jtam1kFlDRQmAUcNlKvYk2ZY
	6o/3Tm7zeiLhB+iJIZ4FqZmAGj8uIC7+44bnxkFemnP33qmjgcugqLKLq2enrpg0akBvQ3EDz7J
	IThL3vfDqh0E0iFdldwsgrURhsxjjDF8LQxGinAeO3WXLKb17DM0AxnJk0m8AV1Q==
X-Received: by 2002:a05:600c:a119:b0:488:b8bc:6a32 with SMTP id 5b1f17b1804b1-48a7b5473c7mr21984035e9.23.1777425117151;
        Tue, 28 Apr 2026 18:11:57 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a1140ef0sm281106a91.1.2026.04.28.18.11.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Apr 2026 18:11:56 -0700 (PDT)
Message-ID: <ac3e8496-26dd-43c4-8ef8-6f7223c1c61a@suse.com>
Date: Wed, 29 Apr 2026 10:41:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Strange behavior with scrub, quotas, and snapshots
To: brainchild@mailbox.org, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20260428012128.Horde.f5fqQoIpJ3QCuz9LBZNU3Qz@nextcloud.brainspace.site>
 <20260428023344.Horde.ACdhtTWNQo0yzpeKOd7keUl@nextcloud.brainspace.site>
 <2bf2013f-ecc3-424a-b6b3-deec4f3b74e6@suse.com>
 <KAR6ET.BWL8BEMZPLSV@mailbox.org>
 <0f6f3f32-f0b3-4c61-89c2-6f931592f122@suse.com>
 <d580bc81-71be-4153-8d4e-58c4f6261085@mailbox.org>
 <19c6157d-235e-4174-8865-3d029f9a2de7@suse.com>
 <06Y7ET.5XM6UHU999Y21@mailbox.org>
 <70b6a4ec-8ed9-4f41-adf8-93eb06f24eb7@suse.com>
 <2CD8ET.98SA563QWYJ71@mailbox.org>
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
In-Reply-To: <2CD8ET.98SA563QWYJ71@mailbox.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/29 10:27, brainchild@mailbox.org 写道:
> On Wed, 2026-04-29 at 07:53 +0930, Qu Wenruo wrote:
>>
> 
>> >Then how did the problem of failing to create new files happen?
> 
> It began suddenly, with no clear cause.
> 
> The Timeshift snapshots had been causing serious lag since a few weeks 
> earlier, but investigating had not yet become a top priority.
> 
> One similarity for the two times the problem has occurred is that I was 
> running file searches across the whole system using 'find'. Perhaps 
> something about these searches triggered the more immediate problem.
> 
>> >Any extra output when that happened?
>> >Just returning -ENOSPC error messages but the fs is still read-write?
> 
> Yes, the FS is still RW.
> 
>> >Because you have no unallocated space so metadata can not be expanded
>> >anymore.
>> >
>>>
>> >Meanwhile all the free space is inside data block groups, you need to
>> >balance *only* data block groups to free up space for metadata.
>> >
>> >Not the opposite.
> 
> I already tried balancing just data, but there is no longer any benefit. 
> It seems all of the data is already balanced. Otherwise, balance is 
> failing to do its job.
> 
> Attempts to balance data now instantly complete, reporting nothing to do:
> 
> ---
> $ time sudo btrfs balance start -dusage=95 /
> Done, had to relocate 0 out of 833 chunks
> 
> real 0m0.059s
> user 0m0.000s
> sys 0m0.013s
> ---
> 
> The only hint of any problem is from the kernel log:
> 
> ---
> _btrfs_printk: 788 callbacks suppressed
> ---
> 
> The other messages relate only to reporting blocks as skipped due to the 
> swap file.
> 
> Earlier the more aggressive balance operations were failing, reporting 
> no available space. From this situation, I started with -dusage=5, and 
> then reached 95, in increments of 5. Each of the calls lasted no more 
> than a few minutes, and in total only about ten blocks were reported as 
> moved.
> 
> I would consider removing the swap file, but it would require shrinking 
> the Btrfs partition, to make room for another partition dedicated to 
> swap. I wonder whether it is safe to resize the volume, considering its 
> unstable condition.
>>
> 
> Also, since the swap file is so small compared to the size of the 
> volume, I doubt that it is causing the serious problems.
> 
Nope, just disable the swap file.

32GiB seems small, but you have no control on how large the real file 
extents are.

It can be 128MiB (the normal one), and you still have 256 extents.
If each extent is one a different block group, you can have 256GiB data 
blocks unable to be balanced.

Furthermore, your scrub is already showing that only 11GiB data can be 
properly scrubbed, the remaining hundreds of GiB are all skipped.

Now you tell me if this is causing series problems.

And this is the new docs update to explicitly warn end users about the 
problems with swap files on btrfs:
https://lore.kernel.org/linux-btrfs/357262c371343c6d6919b7827803194cb46a5e40.1777420050.git.wqu@suse.com/T/#u

