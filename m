Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F16638655D
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jul 2026 06:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782973200; cv=none; b=dpWfw2e+Xcf53hS8GfotXySLYLStvnVstWls+bnmeftgGv0QAhiAQwAnQzMDL8o0pLSJ7Xpn46MKtqsx72e6KiBWbDrPdOvS86vLr7PxoNSFiSgCOEH7HCsouQ17qm3LRRqhirCzYnagI8IA5Qqvnfu1CR/wV1qro1MFn+wjEKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782973200; c=relaxed/simple;
	bh=6asIS1kdosYI3hJjie83OOnmP5nV/dvRv9ZKme0rVCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aWrBpSJrZ+tpyJfT0iUGu6BccjzQhJF/UtOwOP5ray1UO9HgTZzUwDoWSUWnTPQIs+pAHbb6RwcPvam1t/729iKBB/L4zLqeJ6e6e4YyE3dK1As0TQwkZJXlaPmuT5fvifqaaNzuI6vUzaj5ah2rcRAcKzyCWNflIyk6xdaMUeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RSAtWAnR; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RSAtWAnR"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493b779003fso6954175e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 23:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782973194; x=1783577994; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=N9Kk/Q1G7DG2Lf8I5bwAQLC8TgAuIECL4GsJF+QZ+WE=;
        b=RSAtWAnRIL2mziYfBBWnjHUjzp3lT1Sejys4chMzQ1Yi/HoCqvj/xbJ6H9R/Hm9brs
         SmTIemlHuOrbkT28KqCtN3Z6jOh+g6xAtK/lMEvVQUjIOOn4PUK2m5QWr/noEj9cOkN8
         waP8s1BPSROxmrWR6Truo35kYMejZoMhKX7SpqGdLkMDGRWgo/6rOhB+h/nkCjND6nI3
         9AxX1dK5p80pUIik0m3rK0drKh1so5jbzZgT+1GUvm/riv8HWRdAG16cWp+Qfy5Je0EL
         15LxiukjTLxNoBNSMj+G2OiR3YG1xVqde1S8aDI0xUwIdnnYWiJWLKbmcvoHzuiKv1Rt
         Uz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782973194; x=1783577994;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N9Kk/Q1G7DG2Lf8I5bwAQLC8TgAuIECL4GsJF+QZ+WE=;
        b=eTR9lT9NhDNVCP2aynjUEf7WZbtLJLxAcRZTC/Yrh74CUCRlxAirX3SQ1HcyNUzem4
         TJ/tmHYBdzxNQHhU9nc5Xcy9BkCHkJCB/tjSormhmqLq2kBYrkEA4i73AtBW2rlDK/0+
         6t5wp3kaFzoN7gb8i9x8noEJBYOvlyp/J/lqwT7Djm/bL8iid3aZHlcSu7YmeNS2Q9eJ
         gH9RIAsI7qDxZW3xkNzM7atGmfEwUYaL8G1P1cPGAYlnVSX8o070HBO0TPdg6/JLU95m
         aqGomuwSjGtuGRyn9YnBK1ur/3PwGDcHVAA0g93NZTL6oUkoMsbVLzGTO86W+W17Oonz
         iecg==
X-Forwarded-Encrypted: i=1; AFNElJ8RIgkBzd8HkBR0fD3ptIzBpUCF0qqHgI8Sb29XeOULGwQvVS31vT9vDPDgO/V4hdKJzdEMkBUZwhFeoQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLPiFGe+BIU/Qy19aBwYfltz5U7A1hSLNLHJ2secLwCzuFXJP1
	3OMK0SB7K8rWc5Zp+vqwsepoMyAVLjUaVdBO7Rak2uQCmIMolXSCNsM+xj2q0qhjAHo=
X-Gm-Gg: AfdE7cm9mtEzmiB+oZOwjIIFzebiiWe3AOU+gb6ZLE59N/tQOpr37UVOaMCTf0YYirO
	iHGsKqp421bwnPX9+9dowH7DRVsmDlPpdbm17t95HxGm+54nI3MUkF4j00JK021EGsMmnrQt5pM
	JzULyJeTNRQO+xCI6QzudzYm4u1W4KYKo1zxF1VfUFLADjxW+QFzvi7YEWRf59FFBpyZV5ZV1eR
	zAs72cl/K1tp0h/WCgh5uItAeuJWbJZoZ2ejef7/czVVFhkgNhy+MojZrsAdikGChcB+4itFU2R
	AOGyO+YBHsGkjvrdasKu4sN6wxF2B179VTtmgldu3ea6Cpy24qy2Jfje3GHo7GofZCv/mj57Ym1
	i12dkrZ1A3OZYWSw6HGe+OmTx3HuI0TSY97o9DnFy+0iLzhl8MiLh7S7QGqJLDS5WdNL78SWj1n
	YSZ3mjSRaj3vQm+CjbT5J76KZox2Bd5Ie58rI+gaE=
X-Received: by 2002:a05:600c:8590:b0:493:b7a6:3dac with SMTP id 5b1f17b1804b1-493c2ba5810mr49868055e9.33.1782973194021;
        Wed, 01 Jul 2026 23:19:54 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b3c7fa33asm5650050c88.5.2026.07.01.23.19.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Jul 2026 23:19:51 -0700 (PDT)
Message-ID: <5a8f027b-420e-41be-b852-a27fb084c32f@suse.com>
Date: Thu, 2 Jul 2026 15:49:46 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/8] btrfs-progs: print encryptin type field of file
 extents
To: Daniel Vacek <neelx@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
References: <20260624165144.556908-1-neelx@suse.com>
 <20260624165144.556908-6-neelx@suse.com>
 <867a944d-3a26-4248-b0aa-f10247196502@suse.com>
 <CAPjX3Fc2tyPw6Fe-SEg+OsMhGiK+A+Y9qRTRfegcKwdK1WqfJw@mail.gmail.com>
 <589e24f3-e3a3-4a41-86a6-5f99ad5487f8@gmx.com>
 <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
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
In-Reply-To: <CAPjX3Fe0xAYM16yrUyPEWChBrS0ow0HCr_u8S2jR+XCnZzxC2Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/2 15:10, Daniel Vacek 写道:
> On Thu, 2 Jul 2026 at 00:26, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>> 在 2026/7/2 01:29, Daniel Vacek 写道:
>>> On Fri, 26 Jun 2026 at 01:50, Qu Wenruo <wqu@suse.com> wrote:
>>>> 在 2026/6/25 02:21, Daniel Vacek 写道:
>>>>> From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>>>
>>>>> Encrypted file extents now have the 'encryption' field set to an
>>>>> encryption type.  Let's print it.
>>>>>
>>>>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>>>>> Signed-off-by: Daniel Vacek <neelx@suse.com>
>>>>> ---
>>>>>     check/main.c               | 1 -
>>>>>     kernel-shared/print-tree.c | 2 ++
>>>>>     2 files changed, 2 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/check/main.c b/check/main.c
>>>>> index dedb4db4..a32247b3 100644
>>>>> --- a/check/main.c
>>>>> +++ b/check/main.c
>>>>> @@ -1778,7 +1778,6 @@ static int process_file_extent(struct btrfs_root *root,
>>>>>                         rec->errors |= I_ERR_BAD_FILE_EXTENT;
>>>>>                 if (extent_type == BTRFS_FILE_EXTENT_PREALLOC &&
>>>>>                     (btrfs_file_extent_compression(eb, fi) ||
>>>>> -                  btrfs_file_extent_encryption(eb, fi) ||
>>>>
>>>> May I ask why preallocated file extent would have encryption value set?
>>>>
>>>> My common sense says that encryption policy should only be set for
>>>> regular file extents.
>>>
>>> There's nothing wrong with pre-allocating encrypted files. Unlike
>>> compression, the exact size is known beforehand.
>>
>> IN that case, does it mean even a hole will have encryption value set?
>>
>> This looks weird. Is there any special reason for setting encryption
>> value for hole/preallocated range?
>>
>> Can't we only set the encryption value only for regular,
>> non-preallocated extents?
> 
> What's so weird about it? Since the inode is encrypted, related parts are too.

Inodes can have PREALLOC flags, but the file extents are not all 
preallocated.

Inode can also have COMPRESS flag, but the file extents are not all 
compressed either.

Inode flags are independent from file extent flags from the very beginning.

> 
> --nX
> 
>> Thanks,
>> Qu
>>
>>>
>>> Simillar to NOCOW, the encrypted data will be stored with the next write.
>>>
>>> --nX
>>>
>>>> Thanks,
>>>> Qu
>>>>
>>>>>                      btrfs_file_extent_other_encoding(eb, fi)))
>>>>>                         rec->errors |= I_ERR_BAD_FILE_EXTENT;
>>>>>                 if (compression && rec->nodatasum)
>>>>> diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
>>>>> index 0afa3696..159f0825 100644
>>>>> --- a/kernel-shared/print-tree.c
>>>>> +++ b/kernel-shared/print-tree.c
>>>>> @@ -471,6 +471,8 @@ static void print_file_extent_item(struct extent_buffer *eb,
>>>>>         printf("\t\textent compression %hhu (%s)\n",
>>>>>                         btrfs_file_extent_compression(eb, fi),
>>>>>                         compress_str);
>>>>> +     printf("\t\textent encryption %hhu\n",
>>>>> +                     btrfs_file_extent_encryption(eb, fi));
>>>>>     }
>>>>>
>>>>>     /* Caller should ensure sizeof(*ret) >= 16("DATA|TREE_BLOCK") */
>>>>
>>>
>>

