Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5CE32E9757
	for <linux-btrfs@vger.kernel.org>; Wed,  6 May 2026 21:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778102869; cv=none; b=HjeWo0Yji4bTA8MarthmAyhgkOhCTSfjdityOvhNl0J+FqBgCWIi99FisfAeeZuHuKhcB4VybMT2DTZuO82IlftNFcBUHZuJFF5uzd9rIe6UjJJUsD/mEo2wnB5xh3bkBQ+D/R95MBGCgm91f2ncZZXH/jT/kYIlA1sNHbQ5+XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778102869; c=relaxed/simple;
	bh=1yejcoR0XHXGNKINKGcgAOspzkcLCTvUWMBXJBOp2gM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e55Pjm3idrLVM8WSUElVzoFYht0zrnLkfsVekZgxWPRwtAre+IYEV8REeBN0+GWKrYDg5NjFc9+C/yw2nh2Up4AJ0IHY5FqbelvxCt/O2A5vLRbnDnZC1B3XQRTa6Kn97N4UlgUSpJ/5nHSJJ8n5ykcdWA2Cvq4jlbBmoE+9cL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ko/Gbh0k; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ko/Gbh0k"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bc23bebd345so27933666b.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2026 14:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778102866; x=1778707666; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=D+S9xtZSF6xb0s470muiM7wdca18OyrjjQRZ5TogvYI=;
        b=Ko/Gbh0k3LPCyytavNmq/9d9s4BsPHIwxPr3hoyOeYqYNGczetflMcYoEfhwMr5TbC
         gP68DhKZU117Z5BNFcC+YPkXsl+gyV2M0kynYqUn9dz5OFDEivxxcaq26qQ5xwX+LO2g
         /eqn0Oxhs8nabjqc3Nn3m+Bo7ZqjT84mIz1ZYlV+GRrV1C0ArJX7SemFiIbGLe8ht7Qt
         DD+U3uNd7uPHTgzR2fPerlkjrc/qJicyYpWq5Fio2gRyuaqrEnF+F6YDpOfvVhb7LgLO
         6UCubJn5W6dhs0X3p57hCt0KPCZkURDLSabD7+dSUQXo4Ea02eUD8gMmfzJDpd1T8vv6
         NB6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778102866; x=1778707666;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+S9xtZSF6xb0s470muiM7wdca18OyrjjQRZ5TogvYI=;
        b=WjrDgRFVKdBC+Ivx9JdKq5vYmaK31XcEkW+qZC+f2QCY9xO8z58SqT0y0ZH2qj0pTH
         SxrbFwZaZicjT1O4u0WfQR7vwqo8DQJ7QkNg8lwnGaiMmqj3OcY8FE5478b3Jyb7JICp
         MisjdKJj09EPcIsGmufDI76lR8ONYNCtQDHtbhKUQAeR6El009jDc7NpKuVEG3Q7k8dd
         EiXRReBgEicU0Cc4zmG1QKQMMDNHEMTnqQceKTOj8qsPrhgdDr7Td6vpdxbq9F+SOAAN
         Hnb9ED+GVQFkb4CkNC7jidEM0edeSXy/x6R5h5hGMbRt/LXORyuZJ1oScBpphSnf+I3O
         LTBA==
X-Gm-Message-State: AOJu0Yzgf+zcdqZHz638BhjG1cz3jgM17fV6EG9Kx837wfuP5tY7Dru0
	1nujlHTB3c/4Y734StKayKaucq3RnqOuzMxRRN49NOTGPASt3hHcACjSZhnNL7Xmqmji5gPNq35
	gdLNRzQU=
X-Gm-Gg: AeBDiev4Ef2QpmaxHUiaSNunwzbd8qIkSiOPQii1K6uFpmk+Y85l7pkxCXivgEP6XHM
	Accpg+sVUEgVjYHDOaQHyGMUP5zpUzaG0fMaP41YVJ8AUlVic+U9yLqmP6TfT/BGss8tm/Gl56W
	JdQRy9EQ5iAlSUWkqclChYJEtYZbeOZKyXK/Q18c++M7MAvL2htkKZ3HUYOt2T9ZWcHZEwEhwll
	KTm7huNvI2eG0yXTNaglkd0oSFTWHUHQeZqWKiOhAh9P7kYphQmhMQ2r3qsHZnNkZVSHBfJMQCY
	aCfzX4pZMDetUGQtuEkgozwGp0Z7EdwX5UCx0+uxEfxMTH+NQPD7ZaJ3iIVEeIsUPLBusLc2Xvq
	Fx1tQgTuNFjh3K9AL+bOhk7jVt/wx4WgJNmF/y957b92Jgg7MuOPkqyEt9+hMnNF14XwtN5OOxf
	gVR9/hKKrXKa7RGW7aqBbf94+r1P/jil/Y9f6SjEJSEtcTqTO2pQ/HgzDsI3/4J2yL/Ol2m4jtZ
	RnYKghnjf/3VuOCfBpZAfZM8WZrMhXN2v2h6MPeC/MJyh/1GbpcmeFcaJNtE/TuVonf
X-Received: by 2002:a17:907:1c10:b0:bb8:118e:2ff6 with SMTP id a640c23a62f3a-bc838fbe219mr15231466b.0.1778102866139;
        Wed, 06 May 2026 14:27:46 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2babadef254sm1447855ad.61.2026.05.06.14.27.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 14:27:45 -0700 (PDT)
Message-ID: <e8cb0102-a329-4b55-913b-fa52ea11db10@suse.com>
Date: Thu, 7 May 2026 06:57:41 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/4] btrfs: remove folio ordered flag
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
References: <cover.1777937175.git.wqu@suse.com>
 <20260506134341.GD2558453@twin.jikos.cz>
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
In-Reply-To: <20260506134341.GD2558453@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/6 23:13, David Sterba 写道:
> On Tue, May 05, 2026 at 09:19:20AM +0930, Qu Wenruo wrote:
>> Btrfs has a long history using an internal folio flag called ordered,
>> which is to indicate if an fs block is covered by an ordered extent.
>>
>> However this means we need to synchronize between ordered extents, which
>> are managed by a per-inode ordered tree, and folio flag/subpage bitmap.
>>
>> Furthermore with huge folio support, the ordered bitmap can be as large
>> as 64 bytes (512 bits), which is not a small amount.
>>
>> The series is going to remove folio ordered flag completely, along with
>> the ordered subpage bitmap.
>>
>> Most call sites of folio_test_ordered() are just inside ASSERT()s, so
>> it's not too hard to remove them.
>>
>> But there is a special call site inside btrfs_invalidate_folio() where
>> we use ordered flag to check if we can skip an ordered extent.
>> This is worked around by using the fact that we have waited for
>> writeback of the folio, so that endio should have already finished for
>> the writeback range. Then check dirty flags to determine if we can skip
>> the OE range.
>>
>> To get a reliable dirty flag for both sub-folio and full-folio cases, we
>> can not clear the folio dirty flag early, so the first patch is
>> introduced to change the folio dirty flag clearing timing, then the
>> second patch can remove the folio_test_ordered() usage.
>>
>> Then the third patch is to remove the remaining folio_test_ordered()
>> usage, and finally we can remove the whole ordered flag/subpage bitmap
>> completely.
>>
>> [REASON FOR RFC]
>> I'm not sure if we should remove the folio ordered flag completely, or
>> keep it an internal debug feature for a while.
> 
> For debugging and additional verification we can keep it as long as it's
> practical.
> 
>> The main concern is that we're removing quite some ASSERT()s, some are
>> never hit, but at least one is very useful and had triggered several
>> times during development, exposing bugs.
>>
>> In the long run, we will eventually remove the folio ordered
>> flag/subpage bitmap so that we can align btrfs_folio_state with
>> iomap_folio_state, so ordered flags should still be gone eventually.
>>
>> Another point of concern is the new btrfs_ordered_extent_in_range()
>> helper for extent_writepage_io().
>> Previously we're just doing a folio flag check, now we have to do an
>> rbtree search.
>> I hope the overhead is not that huge.
> 
> This seems to be a concern for removing the ordered bit, it will have
> some performance impact. Searching in rb-tree is not cheap, compared to
> a single bit check. This kind of optimization could be there even after
> we switch to iomap.

I have a better idea now, we can move the ordered extent check into 
alloc_new_bio(), where we're already doing an ordered extent search there.

For now if we failed to find an OE, we continue.

This can be changed to output an error, but will need extra error 
handling if no OE is found.

This will not introduce new OE search, and have a better accuracy than 
the per-folio checks.

Thanks,
Qu

> 
> Otherwise, reducing the size of bitmaps makes sense. We could live for a
> release with less effective storage just to make sure things work and
> then remove ordered bitmap or other optimizations.

