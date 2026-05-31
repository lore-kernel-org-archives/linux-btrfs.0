Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A2333E351
	for <linux-btrfs@vger.kernel.org>; Sun, 31 May 2026 08:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780216051; cv=none; b=BNoUVp/QxxALvWx3SJ3shPau3aH0byBHFDQKRVRLf01ENpIlJVjDrS78LV7gs3B1ei08q7U9X3zguJg47pb7bsxCZ8tJiSKiin1Et+LDnYEQ4RdQx6YP3krENcGBrZBmt/rbquBvnb6n1D7KiZgUmMiXDEhzgyOyX8Z1AggzbM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780216051; c=relaxed/simple;
	bh=ASpfQ8n+93TciOtz2mcmPx6yRj5Vrq4fpmd0GzWY3s4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DaY71+Q1eA7ed6pyfkgvxcs+ogia7gXeVESupVIs+nFOkw2Z3m8nFVbg6/3GFNrfVukdwxsQJVfNSu2wQdnp2ATuL2wC66NltX9MOwLU4SFRCaZGdAl9svGYTMzM4ad2CUkCEFOKcAEnqHZeUUeYlYlpqTB4Cr0X9pbs2C8R98U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=dQBlSqzj; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="dQBlSqzj"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bebb72b845aso84657166b.3
        for <linux-btrfs@vger.kernel.org>; Sun, 31 May 2026 01:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780216048; x=1780820848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=K52bAWeaWwdcX0c4QFdy1lYV8fwYhCY+k84CdrMh5sQ=;
        b=dQBlSqzjs/+IJoXtBY+KvJupcla9KPwi/OapuX4yaDNnWMYaXuhSChCeN5pQv2JPrw
         ROWYutjMUTdE7lIVj6X+DFup9e6Ze5k6nxu8gDEaQrcm3nsdPakxAhdAaQLctmNwkDWd
         /WaH2p8c4534YRon5IpIQyDzrluwcwu040XEqoigXlKkLToPkoDmkgBcZEfGJOYCh2DW
         tOp29e6wSsm4FM6gPYjDGAY/ANF6NCRUVqBKZ7ETlhtBSHb97n6MTubghAmnb/zw1dtO
         Gg+t4gk/gNSnQRSZMppLAgtq8s090b3bAupweMnii5LAkVmrFdNcYThaz36Ny62s6T4y
         9Xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780216048; x=1780820848;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K52bAWeaWwdcX0c4QFdy1lYV8fwYhCY+k84CdrMh5sQ=;
        b=BW+DN2ArJm9XQbc+7lTjFtYK/PSSdZrY+kCui/3DNw49H0KSoro0/SmrVP7vs2BE7y
         Xk9ucDHZQ9EONtQfx57ie2ZAcQruFT3CQ/3HBeGuxWizRnj0kszF/WpxPDoOtzum/8YE
         4D8yxyUylfqpWtmk2iG1AbWgZktfxGAVCP7DQr6iSmpUitdf0QsuPt3NpK9i79oACMpy
         fSNcSsMfmVwe4IdWFYlOFTjWg2gxNPmv73TsjvxeYJwINrBiOm0p8VLUHmpopMp43hov
         Fpj3J29EpD7ommw5qLB+6LTahm4+yoJSZta1OW7xubLh2u1HWVntrUWREz6zjLbI4S+H
         d4Hw==
X-Forwarded-Encrypted: i=1; AFNElJ+5PxPIlGYC5IgF7Sfg55FAd9N6O4vJMdv1RmJRDWVG1EQivQ74PNH+NtWL9J1AtnDRBRQX8xkBqiz3Ag==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT+NUfnAcFIqQqsCcYJqnTBAlA/B8UbcvTq/KqB4dW5eNtE9iD
	tBMgbFTIkVLzTD0QhNx/JlooqcMgbkE6OPe0q5sncrOZ2SDS3PI0DiAd7TuKr81QkxMe/lUE1zU
	5fMmX
X-Gm-Gg: Acq92OHo/ouBdRylrU59PMn1nWhx6SMZ8bC3ksno3SFMrysRlMZTvxcIqbtx4BHpBhG
	Qcqja4JRiInGmHawJyK1y9kq4dMNHS5KoId/fJ2rDSOfXHRSUAFAIfMITulTbVAWKTz7p5MpVhS
	paBeFDg3crXNINMEl2ech8TdoRckJyuxhhBNxKB03NcTtxCTHYl/vsPSd0tCRF5CDfnmyJjlB0u
	uMxkSX4iUqWwkbx/c8aoQO5udL77RFlO9YdbSqKw5BNU07rOM409Dqotj/GUD2bAnsirOGIzflT
	4hfy2+Siyfn2takRfQaU5czQCbWRxZS+9ix9XlR/umanjCNGFb/VUrzD/GU/tEpX/XRTG6J6k+F
	u3DudNA4SDhi7BOZUF4Y8hg5HCdj6WkRk0oYqAv3IUElJR0ImY/d6SluqAhwVAxMMHu41b0AyAi
	IPGl427R5hAAwtQ5F25EBhgSPFjxIY3LvzboYrflAdF5hY8X9WdIh9EXldA8tW6RI6qwX3V5YuP
	PakjfurTmg/ksg23QRsck1g26prP05RyvymAKaJmsRFrZ3jNyKcAe7fpg==
X-Received: by 2002:a17:907:c29c:b0:bed:17a8:4c95 with SMTP id a640c23a62f3a-bed17a8505bmr8845966b.45.1780216047939;
        Sun, 31 May 2026 01:27:27 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842313512a6sm3693647b3a.58.2026.05.31.01.27.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2026 01:27:26 -0700 (PDT)
Message-ID: <73bb7567-45d6-4ae7-8fe7-e6df5068840e@suse.com>
Date: Sun, 31 May 2026 17:57:22 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: scrub error & discrepancy
To: Michael Zacherl <ubu@bluemole.com>, linux-btrfs@vger.kernel.org
References: <1552EE44-BE29-452D-BCAA-DAF750F4A2C7@bluemole.com>
 <bc9c0c4e-8f13-4e9f-8bd4-6c624d2b0a76@gmx.com>
 <B1D486C3-CBD6-4ED7-B0E8-D49EB89F7DE4@bluemole.com>
 <d62f2b0a-0a7e-4fb4-a060-1ecca874fb74@gmx.com>
 <B4EBB648-A6F7-4F78-8785-C1DFA5F682C3@bluemole.com>
 <f46ed6a3-ef42-458a-b469-0a841777fb1f@gmx.com>
 <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
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
In-Reply-To: <736ED5D3-31F9-4AFF-BBDF-EAC4DD4EDAF8@bluemole.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/31 13:27, Michael Zacherl 写道:
> 
>> On 31.05.2026, at 04:10, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>>
>> Indeed looks like some random binary data, but at the end there are a lot of padding zeros.
>> This looks like some kind of compressed data.
>> Does the fs has compression enabled?
> 
> no, but it sits on a LUKS partition:
> /dev/mapper/cryptroot on /mnt type btrfs (rw,relatime,ssd,space_cache=v2,subvolid=5,subvol=/)
> 
> But this should be entirely transparent.
> 
>>> $ sudo btrfs inspect-internal logical-resolve -o 20316160 /mnt
>>> which returned
>>> ERROR: logical ino ioctl: No such file or directory
>>> Is this related to https://github.com/kdave/btrfs-progs/issues/724 ?
>>> Trying to read the file when rw-mounted throws an error stating the inode. Obviously this is easy to correlate:
>>> May 30 23:46:38 EndeavourOS kernel: BTRFS warning (device dm-0): csum failed root 256 ino 12433739 off 0 csum 0x6bf0922b expected csum 0x70e27ee0 mirror 1
>>
>> It looks like the backref walk is not doing its work, thus neither scrub nor logical-resolve works.
>>
>> Despite the csum mismatch, have you tried "btrfs check" on the fs?
>>
>> I think it will report some metadata problems.
> 
> yes, it did:
> 
> $ sudo btrfs check /dev/mapper/cryptroot
> Opening filesystem to check...
> Checking filesystem on /dev/mapper/cryptroot
> UUID: 44cb181f-faf6-48c2-a462-904cfe493576
> [1/8] checking log skipped (none written)
> [2/8] checking root items
> [3/8] checking extents
> [4/8] checking free space tree
> Space key logical 1048576 length 4194304 has no corresponding block group
> Space key logical 5242880 length 8388608 has no corresponding block group

This is a bug introduced in mkfs.btrfs, and fortunately it should not 
cause anything wrong.

You can completely ignore it.

With that said, your fs has nothing wrong, except the csum mismatch.

Sorry, I have no clue how such corruption happened at all.

At least the corrupted gai.conf fail should be able to restored by 
re-installing glibc package.

Thanks,
Qu

> [5/8] checking fs roots
> [6/8] checking only csums items (without verifying data)
> [7/8] checking root refs
> [8/8] checking quota groups skipped (not enabled on this FS)
> found 976759910400 bytes used, error(s) found
> total csum bytes: 929500256
> total tree bytes: 2828288000
> total fs tree bytes: 1379106816
> total extent tree bytes: 309182464
> btree space waste bytes: 468318874
> file data blocks allocated: 2798421090304
>   referenced 1533778432000
> 
> Thank you, Michael.

