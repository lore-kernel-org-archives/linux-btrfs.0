Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D823F39B944
	for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 21:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779918298; cv=none; b=ei0CYr+xxiGOakvo0QFCAWEzMTX6CP+O1pZbmJZSZqle8SIvolCbDap1PLwENCsKQcUJVIiYCT5CZZMAeaarmTbJn9g4ElsK1dzi5Yg+WD8pTpDbWzRQg3Jk5m5BC/Ej69gOW4k8ivuLOD5AaqSgloCJuLOp/Opqu1tKMmsh2Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779918298; c=relaxed/simple;
	bh=wOPZOylbzn0EBb+XtnLCNG1tMnlbRxPcbU0fsqJ++/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rudrPHweMj+rshFT5DVvm6GgDU2X0F8HNjVqP6MVBRhkgMcK/CUqQGhO2MeVeO0+oBOS/4XbTGPxOcpcgebR98xSW9ythGr9c9O3J7geL3kitFUBoQhO7BBN/bPPWDnMTGHMVTo0KI+x5hRSr4vxifDr5m7OjojoDIXlrEn2oU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ThfTl7c3; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ThfTl7c3"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49041e84237so47844235e9.1
        for <linux-btrfs@vger.kernel.org>; Wed, 27 May 2026 14:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779918295; x=1780523095; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YP9NVQw6x17ijgF84UUWFIwb/egC2GyQ6u7Q+lRWOqY=;
        b=ThfTl7c3rQI7xHlSDr3Lzp5/GhefpcBvOUZfGcLcwpb+XarLtTBCKp8aHMDWTaHaCR
         nx08r1G8nH2eV3/bHU15C02v+5HbxE6StzoAywhmmdO6bKuS9R18BN3gysxijWhE2IcK
         i64p/fIoZtRVod/DggHRO1Avzhq0M6jlSXROdtjGJ/w0ljd0a9As5BzJhPJJ0lPnEnKM
         Ob1DhCVdwBN6oRwJUy8TsACnEH2SNJdfrPATG3ugle5/pZkISe6NDg5knSbfX7zog8Sf
         9C3NolPe+bDlgx3WZkeZxIiFzYwyqeVU0r0tNkRu0dAHH2zzVsCTbworPz8ojxghxTAK
         74mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779918295; x=1780523095;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YP9NVQw6x17ijgF84UUWFIwb/egC2GyQ6u7Q+lRWOqY=;
        b=i0hw7AgFcyMkSmUodcweL813f0SIxOrXf/e7gmslq4+SgoWmYbOpYba6Amvn9xc4lo
         o50Y83/yBfxmtd2jfXQqL3sHk5oQYet67zy1affk4trazijIlbGchT6scgS04ic7Hu1F
         J/QMidA4nwC0DVIg8gywO5hJ+9/54Wz1LrINrz8FnKKkdwLcM1g1s9gJWl8AgosS0q04
         BNZ357iGRBzdCTk4VDTJUIZesObt1h3Ufss07LgcHnyuwqClH2pLanjQxqhaDmuqQ2C6
         PB76G8lYnIU75zwiq7GI7RCFPe9B/sgbcGFldO1wD4ado7c+bmHksH1maz3TltjGL2bs
         nbKA==
X-Forwarded-Encrypted: i=1; AFNElJ/T56oXS4+Gu/2G4eO4BfEhXkVKCZdswhiHGfB3LEsJsFitXbL3r2f3YaYmQU+4NOJKXT2yOxGKexagEg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzrGWLl+DOJpY871Z3RwMVdYFEHVwsbViBPlyeM6qXH6sXf+cot
	AN8W1L301JBMHErsB9gXu9cqn0vO9xQHa+0x6qXM07eS+DOuKTsMDo7Amkm5Bej9j8L+yaKk0cn
	c84lp
X-Gm-Gg: Acq92OEXL0UMw41Yu1iutE5A+8MaHBYWiS6dmZCvYVE7844qrWlg7RcX9ScM845K1YR
	Vq6WEgk2ajFtUKWIKr5Z2RNVJ1xWbuAwcGhbBy2nnB/xTxcpnTnhH/5qzv7GGK4mQB5hbTfIvsD
	uvulUhuomepL6UDexbawu1uAbAyGEq3Luav75PVMizxwlxS55hsAe0nbQHQceuglXMcEnY5f0y3
	5ypwMcs36X2Iv/Ctih9lo8D+JjZytpFqKCtEW9ssp5gGnCjRnOj/rS63Pm+LmgdE5TKBoE/RvpV
	30vhdPHGZcB0XkbFc0O8Hjy4c2Pl6LYOO07jIqwR1CxElkeCyCbTqyVv1mslm2c781oL9Muj8Er
	qyJd84SrXEToCHBvElN1m+ofxkcEA09lVDosrIat9qjUG6OOO3E32v3pfO9vV9rdZM60sNjfhGe
	piTJfjK1qBENpP4ByOFDysaxWGeqQP594wcFtIxxozZ1SmF8sJwh1j6bpQbyjXFinNwhGXpIaFV
	FWu5FSJQFGAIq6ixn5bN5yY5NbOlkxQr439v38kqBVsgwpjb5OYNqKqa9mkkiCikpop
X-Received: by 2002:a05:600d:108:10b0:490:53b0:9e5a with SMTP id 5b1f17b1804b1-49053b09ff3mr218036005e9.5.1779918295188;
        Wed, 27 May 2026 14:44:55 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb5903bcasm170980565ad.77.2026.05.27.14.44.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 14:44:54 -0700 (PDT)
Message-ID: <6edf7876-0e3e-4528-b18a-232c87245921@suse.com>
Date: Thu, 28 May 2026 07:14:50 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of O_DIRECT with btrfs ?
To: Roland Kletzing <devzero@web.de>, dsterba@suse.com,
 linux-btrfs <linux-btrfs@vger.kernel.org>
References: <a56459a9-0d23-4fcf-bea0-e16a2d6245cd@web.de>
 <4a00615e-7515-4bed-9cf0-e01b62356018@suse.com>
 <9dc28403-c294-405a-a9e6-cd4e32e6e327@web.de>
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
In-Reply-To: <9dc28403-c294-405a-a9e6-cd4e32e6e327@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/28 03:11, Roland Kletzing 写道:
> hello,
> 
> thanks again for the patch.
> 
> i just build a recent proxmox kernel and applied your patch and it 
> indeed fixes csum error from happening.
> 
> i installed several win11 VMs and and also did virtual disk live 
> migration and see no checksum errors anymore.
> 
> any reason why this patch isn't getting merged?

Performance drop first, it will reduce performance pretty hugely.
At least 1/2, sometimes even 1/3 of the original performance.

Secondly unlike direct writes, modifying the buffer during read can 
easily race with the data read from disks, thus it's a more serious 
problem in the user space.

Finally, we're closing to use IOMAP_DIO_BOUNCE flag, which completely 
resolves the problem of performance drop.

Thanks,
Qu

> 
> regards
> Roland
> 
> 
> Am 23.05.26 um 00:09 schrieb Qu Wenruo:
>>
>>
>> 在 2026/5/23 03:54, Roland Kletzing 写道:
>>> hello,
>>>
>>> i was under assumption that with recent patches and my successfully 
>>> testing
>>> from october last year ( https://bugzilla.kernel.org/show_bug.cgi? 
>>> id=99171#c35 ) ,
>>> i was under (false) assumption that O_DIRECT support in btrfs would 
>>> have gotten much more
>>> mature now.
>>>
>>> my latest findings reported at https://bugzilla.proxmox.com/ 
>>> show_bug.cgi?id=5320#c14
>>> tell different story.
>>>
>>> is there any official statement on reliability of O_DIRECT support in 
>>> btrfs ?
>>>
>>> i'm getting these types of errors when installing win11 VM
>>
>> Direct read can still result csum errors, as this patch is not yet 
>> merged upstream.
>>
>> https://lore.kernel.org/linux-btrfs/ 
>> aa09b68f159fb0de4864de151eeba9250f2e34fd.1758840406.git.wqu@suse.com/
>>
>>
>> Furthermore, for your compression if the direct IO block size is only 
>> 4K, it will never be compressed except for inlined ones.

