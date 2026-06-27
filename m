Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA091355F53
	for <linux-btrfs@vger.kernel.org>; Sat, 27 Jun 2026 06:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782541204; cv=none; b=Pc3rjPR4Mztbq+xnlC5xPvhiK9gYO7QIMDgdt8xVkr6X8+WWKb2DYnOB0mB9XSVKrnWkPMIfE3OgRmVa/vMRTek8EuICjfVgY+c+H7Gq3xshkdUYBdo6EY+WPTMx1ENd2E6+z4Ye9ym1xqjG0mqQB+TLbakEuX8OkenhtvdoflU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782541204; c=relaxed/simple;
	bh=A5jEu1rvbZVgSztBe/T0LpVn0XDU3LMREyFyPC9HROA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cAimOalz6p4fkhPz9sANk9Z3+xWiFLuVUXtZE7KhNwFhz6nlZH+tex3yVsyLGhhCKHRfgoqAZM+njShGY2b0Iopa8UYTAmmrCZHv1uN4Vp14b2U8cV7+ot2wBREzHsHd1WnqG76Ao4+9J4OhvP8YLJHqaQk29p0R3NfXzh9DtmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Y7aPDJlL; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Y7aPDJlL"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so19653195e9.1
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jun 2026 23:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1782541201; x=1783146001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=SFzdlb27/MpaRmEwRFHERvB6j30+IAbPz8fBlXt96Ik=;
        b=Y7aPDJlL82JnsFs4PekJmcpcMaYZW4H+03vdNcS2A5iyKf+17/JOBK+k1eqEv8wWy8
         dF6R7KppuVY3z/5Dbn93f20xjiNfzOLTJ62SWBu+/ejrrtoZQiPL/pi92QZvO0amz6lP
         ZoCK6oNdnB3Cgfd1Ev4iolHoBozssxKr+3I8UuMJa8iZKL6GWW83JfzA334rpaXbkoke
         dQP7ZKVdbbAOzAKDUJHjnCuhQzKEQ5fgS5rMQGKtnenCnEMM67DSsMSEq5SgTLEhFaJi
         DAXM6sbSoKbwTIKQ9Cnu+AMlYivg83XMKaMWIkqsd3ekVSv9kdYJ716KA9X1ApQjID4R
         n4CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782541201; x=1783146001;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFzdlb27/MpaRmEwRFHERvB6j30+IAbPz8fBlXt96Ik=;
        b=iDV1gS5lF/Lsjq9GBKVwGyTH8zH/8bz73lP9CSnm2aZBGlj1uFXIDwntvDjsIyrIGA
         x0tKjqdEd7NH9+lHtMd4pS4iEUVI5qeqABjVTgfEayOyMQVHzSCKTVUsQ0XaAntbmloB
         35NWnf5Z/sRCIn1GHrQhhX5+DxpEn/mw+a67/g7SRdYznbgPnrpjhtIRfWsRhsidIjqV
         k0ignbECbjc1rRqMjoI7WgQtbRlD3DUkVST9ri2nDftjO/Ip4PgrJcTfZ8hkjODJ72s3
         Rz3C1ePwSe9WZeA9WJsIovpCq9OZqOmRxnnD/aFZCDepg6LfO8rKgjTTF0lYBwfpM3EM
         kwog==
X-Gm-Message-State: AOJu0YzQoq34K7bo2ApFxjLC56SBPwFQV2qDtiC2V5T++x8TpeBrNafI
	Df5tKxe65Kki64zUwvc1VSLcHxLMaiXUUaE7epseTqhd0xhaO4fFyY6Hxa8o3p7D0x4=
X-Gm-Gg: AfdE7ckceJgidHBb92kmcjUtc/WyFYxPUkSNr/lCTbvr2QiE0QWV2giz4VvmLy5WHfZ
	Q/qsXTVNzYCw9WMnlw/s/NbSdb7GWbTY2I0eGGmTBLwz1LKiX1OZavmrr7GrenctnImytaEoVD1
	ir1l6ekJxnRT1zsI4jYEbNJqzduBDgZ1UMSbdwNfA1/e/NHASC1egUrxMoQiXnEa02kaZfgP4BH
	rZhKsjxJcmzAvUUkpPRMxVkGj1WqnZDbJJtZ1CFzlRN7HwaGiUbh6U6bNJj425TFdWtW/xMA73k
	2U95cdygRBbUWFcYpHlmvT1KZW/4E0WzHzH9M18TAaw8Mmg3pEEuzzkb6BOfjiWzPRQqx/AX7cg
	/+H8AhkFqNDvqCTbvafhC/pYOztDxL6MW5dYwps6xyt1OQ+Qgxfl5FuMsAO/2MYeJrInFFEvlpx
	SpqG75EHKATzgFJO7PXK1ZIpslUe671+dx6SXLNtQ=
X-Received: by 2002:a05:600c:8b28:b0:493:72d2:e96f with SMTP id 5b1f17b1804b1-49372d2ebcemr7847095e9.5.1782541201028;
        Fri, 26 Jun 2026 23:20:01 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cac87dcsm27871297eec.31.2026.06.26.23.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 23:19:59 -0700 (PDT)
Message-ID: <b10b2e22-37bd-4b92-b999-d2403321835d@suse.com>
Date: Sat, 27 Jun 2026 15:49:51 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] fs: btrfs: implement opendir(), readdir() and
 closedir()
To: Alexey Charkov <alchark@flipper.net>, Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org, u-boot@lists.denx.de,
 =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>,
 Tom Rini <trini@konsulko.com>, Simon Glass <sjg@chromium.org>,
 =?UTF-8?Q?Timo_tp_Prei=C3=9Fl?= <t.preissl@proton.me>,
 Peng Fan <peng.fan@nxp.com>, Patrice Chotard <patrice.chotard@foss.st.com>,
 Yao Zi <me@ziyao.cc>
References: <20260626-btrfs-readdir-v2-0-7dd43f72d1b4@flipper.net>
 <20260626-btrfs-readdir-v2-1-7dd43f72d1b4@flipper.net>
 <09eca73c-1f50-46b2-a307-76eef0408159@gmx.com>
 <CAKTNdwEdonby8W9=iD54Fw1UVH88CBmjf+3L9r-jCUfhZrxzpw@mail.gmail.com>
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
In-Reply-To: <CAKTNdwEdonby8W9=iD54Fw1UVH88CBmjf+3L9r-jCUfhZrxzpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/6/27 15:29, Alexey Charkov 写道:
> On Sat, Jun 27, 2026 at 2:27 AM Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
[...]
>>> +     key.objectid = dirs->subvolid;
>>> +     key.type = BTRFS_ROOT_ITEM_KEY;
>>> +     key.offset = (u64)-1;
>>> +     root = btrfs_read_fs_root(fs_info, &key);
>>
>> You can save the root pointer into btrfs_dir_stream, so we can avoid
>> subvolume root lookup for each dentry.
> 
> That was in fact the first thing I tried, but turns out that it
> doesn't work because a root pointer created with one fs_info structure
> stops working once fs_close at the end of the generic fs opendir
> caller closes the fs and deallocates the fs_info structure, due to it
> referencing trees allocated for that instance of fs_info. The result
> is a synchronous abort.
> 
> Hence the comment above the btrfs_dir_stream definition and this
> second-best solution.
> 
> Please let me know if I've missed a more elegant option!
> 
> Closing and reopening the fs at every call which the FS layer does
> sounds like a huge overhead, but I must assume it was unavoidable when
> the interface was designed.

Oh, I wasn't aware that u-boot closes the fs after opening the dir, 
that's sounds very weird.
But if that's the case, the current one is indeed our best solution.

Thanks for point this out.

With that said, the series looks good to me now.

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> 
>> You do not need to bother the lifespan of subvolume roots either, they
>> are properly released during the close of the fs.
>>
>> Otherwise looks good to me, except an unrelated question just lines below.
>>
>>> +     if (IS_ERR(root))
>>> +             return PTR_ERR(root);
>>> +
>>> +     memset(dent, 0, sizeof(*dent));
>>> +     ret = btrfs_next_dir_entry(root, dirs->ino, &dirs->offset, dent->name,
>>> +                                sizeof(dent->name), &type);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +     if (ret > 0)
>>> +             return -ENOENT;
>>
>> I'm not sure what is the proper/preferred/sane handling of end of directory.
>>
>> Ext4/fat returns -ENOENT, squashfs returned -1, erofs return 1, exfat
>> returns 0 but without populating @dentp.
>>
>> Personally I found the exfat behavior more sane, but considering the
>> caller fs_ls_generic() doesn't really bother the return value but only
>> cares if @dent is populated, it should be fine either way.
>>
>> But still, returning -ENOENT will populate errno, which may be confusing
>> for debugging.
>>
>> Anyway it's an unrelated nitpick.
> 
> Happy to switch to exfat-like behavior. I was only looking at ext4
> implementation as that is likely the most widely used and tested in
> various corner cases, but it sounds like either way should work.
> 
> Thanks a lot,
> Alexey

