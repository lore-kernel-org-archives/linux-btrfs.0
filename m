Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B28C155C97
	for <linux-btrfs@vger.kernel.org>; Sun,  9 Aug 2026 04:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786248457; cv=none; b=mbB4vEvbnxhejsC/SHDAVgSbndzKSaULVTht19a/MpSECn9jnRD08qeJ0pDJHygzvX27CUrOCxjeQwdHrLJGoweyQC6wKAJ/Ht4OYNcrd9F4I3dZjgmrfnlxJnFFZ/jdRnZzg8qRW5sLj7tPoyrmyPFVcxDm3veE2Nn0Z9DOwg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786248457; c=relaxed/simple;
	bh=oG0KIZSrQA3G1waiW1d7rxNQ4H8HGjlvA31+h94E6j8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jfe1jgBBaRhw7YxOrLXp3sEXz4x6Rj780Eb74JDjk0Ojcr+pszWH+Lb0NHD5GGLlVQUzLx1DoB/GK6+govYWfhCHYcXoNAf6RaXfHgVq1d9nIjHS1s66xaHAPw1wLr8Q5iTh6A5EzYKR6TfJlMlMS2LS6eA2lVOKNTTzXnFvUYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WYpNHt91; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WYpNHt91"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso23115125e9.0
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2026 21:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786248454; x=1786853254; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DKhNsN224gzwaWy0DDO/vAbUr9T9JLlaDaHjUkpoRis=;
        b=WYpNHt917f3gnLo+mT/NdwNJ+tDOe9ZYplyd9w+apt+I2qUU1zP6BDVSBkZgAfMsYx
         JFqFXy5TsgAsCI/OMLv9cBmxKBR9A7bOjorm0MHZ1lRRbfxYwCREpqoOKyycTdKT/wi3
         6Cs9T7UbEzx15vGXe6aToNa2cWYc6r0JHmYbRgSdd6VwH4e+9BME17mRj5vPJyiOAB8R
         bsQzeFSih+9RbqpwElvcU+GKuECAvjy2O9XVuq6SHZzTF5F6l+v6EbAxYuJ29GdInwN8
         eRzX/VVEM4g0ysQaSj485KaFggl+w4nzcvYOjOk5frtNUZJj06jBY/YTfjA6SoB5OvcI
         azPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786248454; x=1786853254;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DKhNsN224gzwaWy0DDO/vAbUr9T9JLlaDaHjUkpoRis=;
        b=N1B7ld40JN1IG24CMMMfnOE7rioQ0qkjh3RXm0VUqILsyuMsQ92LjIGIDsSZlait/X
         bkDLcEpUTAzh6cGU1fnrpNUz6/lD8wF2+LFdVUZZYUkfTeEsndU9bJ59CHEjyJjuTBDo
         RShjBqczy0gAjL/IIhkJA6n3C33feFYZh507/WO3B4gmpi3G0cn33r8oWu0+FAPl3z9z
         /zAEm3eY+sXXxm6mu5RF9dOa162dePyOxH1z9+jtVE3ekCFDbjVOsfiVIYsO5wIyJpQ0
         A0eqYk69i27jXuX/HQZ9bgP74p/YIx0uLpLQt8ePcRgBgqxpPQbNx2NHt/nKolkk6Zmn
         fmWQ==
X-Forwarded-Encrypted: i=1; AHgh+RogoDFSicdf96jwPMky4oPeurqAgAF7NFOP+m+5dtsY5kaAUYYepsUSPnAhu4w4lrnrRiTCYm8pp1kAnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEuN9k0kAhnQuA9B9X9QFNcHRPxhF170OD3v96jWZngo8Edo99
	N6uFQ8EwDzrZy9Vc8V3++n4LFhGS+evecRxBybtdnz3rrhR7DKX9sPkN2jYdeO1kpb4=
X-Gm-Gg: AR+sD11ukOwbc8qHVGa4aKyOuYflQCCC5iglGGryfLH1/cbDaSdu9lWyeZHekXNbGGP
	cs8xsB/X1Isls7f0AnBNeSO34uYj61O9Zc6F6yiga5XYIJpxdn2vcEGsl5VUlwnT4SsHOwl9Prs
	aWf0WLK3rBFK8PAjLLAYzlldVZ0ggRiwtIDDpbQAUNF7yex0w3H4ec8LucKQ/rcfj2vjRRIK96l
	y76q+I8Vp91FA794yqChZlfv9UTnenH1WUttd2Jm6OT3pyGznjL0lJ/iJUtWHkCxF+ViSfSakga
	nf5NWptd1AYNW7ICbpMm4AA3ZFaEy6j1hIb9ClXbVxbZ9cLO+5MGXetmmohAZicdyhl8tBVn8Zl
	atpvRowrD5biRrpeOYhmNuxgKuZBDpEowazFC7UvB3bEEO9hfbZnXAdsnkEhSGfqwjgd7GVl/Y/
	fZdfEEDj4gpRSQyFHLL3u6noJdGdi9dcqc1DYsxCigmjcaqErdcF8UFQBgq+x2LW8M
X-Received: by 2002:a05:600c:6052:b0:495:4f89:8117 with SMTP id 5b1f17b1804b1-49962455754mr86185875e9.1.1786248454397;
        Sat, 08 Aug 2026 21:07:34 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315bec128a0sm29667786eec.25.2026.08.08.21.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 21:07:33 -0700 (PDT)
Message-ID: <dd2168bd-359d-4d3a-9efc-41344e071e26@suse.com>
Date: Sun, 9 Aug 2026 13:37:28 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/4] btrfs: also validate compression levels in
 btrfs_compress_is_valid_type()
To: koraynilay <koray.fra@gmail.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>
Cc: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>, linux-btrfs@vger.kernel.org
References: <20260809015054.779137-1-koray.fra@gmail.com>
 <20260809015054.779137-3-koray.fra@gmail.com>
 <f190abba-cbe0-4ffa-a815-00286b5f0c88@suse.com>
 <DKK3JZ4VEBDZ.3TZKOIV87R4ZG@gmail.com>
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
In-Reply-To: <DKK3JZ4VEBDZ.3TZKOIV87R4ZG@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/8/9 13:05, koraynilay 写道:
> On Sun Aug 9, 2026 at 4:53 AM CEST, Qu Wenruo wrote:
>> Please make sure every commit compiles, this will easily break bisection.
>>
>> You're changing a function prototype and implementation without
>> modifying any callers, this fails compiling.
> 
> Right, I'm sorry, I didn't notice I changed the caller in 3/4 as that
> call point also had other changes.
> 
>> Furthermore, I do not think it's a good idea to just rely on the strlen().
>>
>> E.g. if a crafted image removing the last terminating NUL, relying
>> strlen() can easily go beyond the expected string.
>>
>> I think the change to remove @len is going to reduce the robustness of
>> the original code.
> 
> That was what I feared too, the problem is that
> btrfs_compress_str2level() uses kstrtoint(), which requires the string
> to be null-terminated[1], so the len paramenter would only be used by
> if (len < comp_len) and that reduces the robustness even more IMO, since
> a developer could think it's safe because of len, while it actually
> isn't because of kstrtoint().
> The only fix I can think of would be to use
> _parse_integer_limit(..., len) directly or write a wrapper.
> Or just document that it needs a null-terminated string.

OK, you're right, in that case we're not losing anything.

So feel free to go ahead just fixing the compiling error.

Thanks,
Qu

> 
> Thanks.
> 
> Best,
> koraynilay
> 
> [1]:
> from lib/kstrtox.c:251:
>   * kstrtoint - convert a string to an int
>   * @s: The start of the string. The string must be null-terminated [...]

