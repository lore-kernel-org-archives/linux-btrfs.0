Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE38314F70
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Aug 2026 00:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786323080; cv=none; b=cx43/h3QS+713afowaeJl9haHt8Tdj0cZGbvfHHBcqMASvIeBj2bBmb866sfOZVeUezyEuiTceMsydbolxhAbgQvzGn15VOxcgQ8AsXk5MOMFM3kZGFQmNpVs2gD/FrKLFsv8x7S6TUpMyBBaWBIufp8W25KajQrsIjkyDAMaFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786323080; c=relaxed/simple;
	bh=dJIadYArrO+wwYTx7qut2XpeoCssukuDJq8mrCtG3tM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k6UCq4bS4ErYcYu+WUVbuK9RefrFLr4EQ6nfyPE0o0JwG8p7kCE7Wy5zSbPon5b7gOXMgc5f1Lii7vqIhT9G2kGmcMUBbOX4Yw1x8WqPnRiNZEz/jIjFz18BNu8FJPVFMYzH7UOAVht96kwOzYw/toGLc47kveZz4aBL6OOZdMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OtinnHb1; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OtinnHb1"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4956869750eso8114485e9.2
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Aug 2026 17:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786323077; x=1786927877; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=85hzFgyocjtX4dYAu7Ufg87HXvUsenwd4K/l18uGL9g=;
        b=OtinnHb1Xs3Ata9MM9SpHpduW5z6Qzbhrt5AVxIcVRnx55UqwW9erVdUUMOY/QB+V4
         rO3cujzjcRM5zB9YjhjoEwXgY/hIHwTY1ViEqsF2zB8r7d7f/16YfTsMm/wdJkWUWaDl
         CFi4g3Yoy+L85lJIcfy68vskU8qxasRG2TYsfb3MVs8QJddODvFQmvn7g5HXzB5RU6Az
         3PfdP8bWpj5B3h6Hld6jJ1i1+158mzVMAUWCPn55Mzhtusk+ezTMuvnzCIaINo4D//7m
         ZgGW+YtbyAbGa7iNP5VU8rfg5uURiFPGN7KgwtPeH/qr4iOiSPSy3XVibh3B0Hlvs+vj
         UtDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786323077; x=1786927877;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=85hzFgyocjtX4dYAu7Ufg87HXvUsenwd4K/l18uGL9g=;
        b=PFyFrDYo/KvPB0m759+L4ShT1VprSc2VYjEWsVDyNTrtSsL1CgX2aQgeCgcMXz5lVn
         HxHh1yED76HGsz27F3hrYpWjzHNdZM1fODzsnNkOOb70KS37oveMcJw3V6GKBwb8BrLC
         HsuF9ZK5ZjDKPWRm698/FIvQfrb+gKS2bkW/IBKk8Cclt30t0Z6OL5/2hJuYQKoOOH7U
         o+042Ck1pW1vRYjPOFTK9CrwxC2sOoPFl9lAmK9HhevqyEk0U9UA+hO5e6hKtISsUd2p
         MXlDRVNThlpB2bWL2LIWQTxqBb+JvhSgCHHm+V3XUR5HHzXWd04orJkYgjwzi2OgR/Gx
         mLfA==
X-Forwarded-Encrypted: i=1; AHgh+RrtAFj9L/gIXOtRnFrQRVqUdulyJ73whj13/9Vuk7h5yHxl5Lu7Y5aH6rr6TQPaGyY4KNvwqSTklwxwXw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1tFEuzwbjemlFHuCWLJWeMR3X+WhCTQIKfXuAMudxXLj8Xjk3
	E/2gIf94KZ50Yh0jxzi3up834o+wXzmgf10MZpSlmuEvCJaq1AGQMs67BTYpB5xC+QQ=
X-Gm-Gg: AR+sD12a8oq++7JXRzz0XIjY7KCCY4GgV9OfwjueFA73ItDchddhLxMJEcUHWhjFg/8
	8ZFU6U8nLwlLgRog3PaaXGAaVAY2qSv6kx34G/NfHcOArfjdbh7TL9DNH/6ZF8Emf8OGyF80vCC
	DuVudfzQooDuqtH+DNKL73F89mc6SrY4ZhJHoqkKnRxO/MytKnUjMAatvhf7lVNExwtVxnjl9Q3
	I5o+uP5yhz/ge/YVe2SKQZkzVVlWLTaZTArf18W4SqmeI2Lq2zIDzWSFaVoyaoEGsZZ5RqrYRxD
	uAFaJ2VR+kC0xPSC5LIdSzW8PJNQDlQu+6ys+uE/SM87Hc/1+K+wCuD2vaQg5SShH9ui30PdpJb
	M2jrlCDxSg5UFFUxJC96fmWfC5jGuExFc6PtHKHbDdlqiHVaUv0xyDYFdUaGj7eqFdZNIqL4osY
	1bQ3lsYoAxqKxLJJs9RF9ElD/rZ8jKAcBXPe2jtOBOlehT4+N3FvrE0Q==
X-Received: by 2002:a05:600c:5686:b0:493:a623:d090 with SMTP id 5b1f17b1804b1-4994e7c60c2mr344984265e9.10.1786323077155;
        Sun, 09 Aug 2026 17:51:17 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec68468sm38740900eec.31.2026.08.09.17.51.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2026 17:51:16 -0700 (PDT)
Message-ID: <9995da33-3f10-43b6-aec1-0e90eae03c7a@suse.com>
Date: Mon, 10 Aug 2026 10:21:11 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] btrfs: add per-inode compression levels in xattrs
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: koraynilay <koray.fra@gmail.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
 clm@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20260808023459.1494928-1-koray.fra@gmail.com>
 <52e06b50-b888-48f0-a574-91e1192eda73@gmx.com>
 <DKJZQAFIRW7H.3KE8DKWO5E3TV@gmail.com>
 <c5070299-46ba-460d-9ff7-0b2e4878079b@suse.com>
 <ankKjqr72aD8Ka8w@hungrycats.org>
 <95bab93b-f0c6-447d-8bfb-c81b3d48f7a7@suse.com>
 <ankbNtvLr3ZnFjEk@hungrycats.org>
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
In-Reply-To: <ankbNtvLr3ZnFjEk@hungrycats.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/10 09:58, Zygo Blaxell 写道:
> On Mon, Aug 10, 2026 at 08:50:45AM +0930, Qu Wenruo wrote:
>>
>>
>> 在 2026/8/10 08:47, Zygo Blaxell 写道:
>>> On Sun, Aug 09, 2026 at 10:30:45AM +0930, Qu Wenruo wrote:
>>>>
>>>>
>>>> 在 2026/8/9 10:05, koraynilay 写道:
>>>>> On Sun Aug 9, 2026 at 2:17 AM CEST, Qu Wenruo wrote:
>>>>>> I'm not sure if this is the correct behavior in the first place.
>>>>>>
>>>>>> As you already mentioned, zstd and zlib have very different compression
>>>>>> level range, using the incorrect level makes no sense (and it's being
>>>>>> clamped anyway).
>>>>>>
>>>>>> I think we should go the default level when not specified, which makes
>>>>>> more sense, and that would definitely be something worth fixing.
>>>>>
>>>>> Yes, I also think that would be best, but my main concern would be it
>>>>> changing how chattr +c behaves (I'm less concerned about the btrfs prop
>>>>> set file compression "zstd" case, since IMO that implies the user wants
>>>>> the default level).
>>>>
>>>> Mind to explain more about the "chattr +c" problem?
>>>>
>>>> IIRC "chattr +c" just set the btrfs.compression XATTR to the default zlib if
>>>> no mount option is specified.
>>>
>>> chattr with _any_ argument resets the btrfs.compression xattr _every_
>>> time, even if the caller changes a flag something that doesn't look like
>>> it would affect compression, e.g. chattr +A or +d.
>>
>> This is the known problem of chattr.
>>
>>>
>>> That can lead to surprising results, like changing compress type from
>>> zstd to zlib, if the original btrfs.compression attribute doesn't match
>>> the mount option.
>>
>> This doesn't only apply to c, but all other chattr options.
>>
>> That's why proper chattr should always include the full attrs, not only the
>> one to change.
>>
>>>
>>>> In that case it should be no difference compared to any existing XATTR based
>>>> compression setting.
>>>>
>>>> Thus it's just the same missing level handling, and IMHO since XATTR
>>>> compression level is never specified in XATTR, then the behavior is never
>>>> fully determined, and users should not depend on it.
>>>>
>>>> Even if we changed the behavior to option 3, it should not be a super huge
>>>> user affecting change.
>>>> In the end, it's just compression level, affecting compression ratio and
>>>> speed, not really a huge behavior change.
>>>>
>>>>>
>>>>> The options I considered were:
>>>>> 1) keep the "bug", like I did for now;
>>>>> 2) keep the "bug", but only if the compress= algo is the same
>>>>>       as the btrfs.compression one, if they aren't, use the default for the
>>>>>       btrfs.compression algo (e.g. compress=zstd:15 and btrfs.compression=zlib
>>>>>       would compress the extent at zlib:3 instead of clamp(zlib, 15) = 9)
>>>>>       (suggested by Zygo);
>>>>> 3) fix the "bug" entirely, which is what I actually accidentally did at
>>>>>       first, by just setting compress_level = inode->prop_compress_level
>>>>>       without any check prior to that (which means that by default it would
>>>>>       use algo:0).
>>>>
>>>> IHMO both option 2 and 3 are acceptable.
>>>>
>>>>
>>>> The only extra concern is, if we have a new level field in XATTR, can older
>>>> kernels handle it?
>>>>
>>>> And thankfully the existing prop apply handler is checking only the first
>>>> several bytes for different algos, thus the existing code should handle the
>>>> extra appended ":<level>" correctly by just ignoring the level.
>>>>
>>>> So either option 2 or 3 would be fine to me. Although I personally prefer
>>>> option 3 a little more, just because it's much cleaner code wise.
>>>
>>> Option 2 preserves legacy behavior that is 12 years old now, and it
>>> costs a single comparison in two 'if' statements.
>>>
>>> Option 3 makes an already confusing situation worse--it makes the
>>> underspecified behavior change depending on kernel version.
>>
>> One should never rely on something not documented in the first place.
> 
> Option 3 prevents existing mount-option compression level specifications
> from working when the attribute agress with the mount option; otherwise,
> they would be blocked by a btrfs.compression string that doesn't specify
> a level.  That's a _regression_.

Let me be this clear, the current one nor option 2 is not working either.

If the current algo is different from the XATTR algo, it will be 
whatever random number clamped to the XATTR algo for the current code.

This applies to the option 2 solution. When mount option changed, the 
level will suddenly change from whatever previous mount option to the 
default.

It's always broken no matter whatever, I do not want to waste time to 
use another broken behavior to mask a more broken one.

> 
> The current behavior is documented all over the place, used in scripts,
> etc.  The top two from Google:
> 
>      https://wiki.tnonline.net/w/Btrfs/Compression
>      https://fedoraproject.org/wiki/Changes/BtrfsTransparentCompression#Q:_If_I_use_'btrfs_property'_to_set_compression,_what_level_is_used_for_zstd?

None of them is the official btrfs-progs man page.

The first URL doesn't even resolve here.

I don't want to repeat myself, all those confusion is from the bug itself.

Instead of building everything upon an uncertain basis, do it correctly.

And I have repeated it several times, even the behavior change is 
minimal only affecting the level.

I see no point why you treat broken behavior so dogmatically.
