Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31853BADB6
	for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 23:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779319475; cv=none; b=M5aCIY+CqWTApKe1pmq9PfjktRPGxFjOj9Kwi3sGDguiu6nsJrlELReLA+yd7xPtZd77blLcwXyVQgpi+mPrEnzIOcDNINlORWofPuraIJoVeIS/J3wLa/8L9Zkk2u8wsbgxe9yJ2sDvgguq14I283CouV76b0Y9fQlaHk8NXPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779319475; c=relaxed/simple;
	bh=Ci2lYXWa6H6IKO9kev9hjyj0Pl+hnrYzJevsdU9Qjok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gUszoedBL8r29z9Tq+6cWV5rQG0FIFdVUQU8ejmwn/0JJYfop6HHnL4JZsgwlBTvwe20e5yLudS77VIyE/nyA5cW2bhzWv88uB17qy48lRqAC/6phSh2nt5QF93xflaK8hvXfAUxQD6CuhEc3mVhIooaWIOZSX2L4udhz5oYif8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B013WFLi; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B013WFLi"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4893940bb5eso30369475e9.3
        for <linux-btrfs@vger.kernel.org>; Wed, 20 May 2026 16:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1779319472; x=1779924272; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=x93b05LqwC8lXT/3IhlsHXSgF954VUMXWJ0YVutMS2U=;
        b=B013WFLiN6CRY5VbkBPHhYd01k/XeueE9gabHIRhNMfIQAwk+DizEuFJCnDY7EwmTA
         hFZzSf0CWMyYq1X91SRfyiXAXbnAIm66bW5axTmI4GvWs9yBhLke8gUKQQe7VzaQla2Z
         9CFZpn6zY63IOqbozuFPsWalmoXTfApX6IpOlUNiNgFs7WmjGx5vKFLbJFY6fOIGflEj
         WwCMEk4vRFKZWwS6OKhg6nz92zQXC2PSEpJYJLxWLDSRUiV+HqdGpgiW/6f7vClGKN9y
         yGlTOd1XEDaXrBpROiJMcMGf3KKIePE+IGg/QoMERWxWHFvtbA4KC1i+6eunHK4dyBEA
         YmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779319472; x=1779924272;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x93b05LqwC8lXT/3IhlsHXSgF954VUMXWJ0YVutMS2U=;
        b=LiT5lFfhSQ3R4mxB7U54GM/ljqj1Zu63RXcMuZdQu21lrkr54Fxk+pNbt0ojBmIz/E
         ahyiBiPme1X28NovANiGneOkBWIpLNhCyM5S4W//O7OiCk6P++cZ9OTOzx15Y3YaP4Wl
         F4CbCEJkSS7spf7Hhx8e731l+VADL0PBKrE74MAjyjJq6zEo/MwB5NKvR+8zAJrMt9Mh
         /BMFfMNQOhaA4/oUMpX8D84RjcTIAP6uME4vX9uTUlqAZn65gZ9JYH6SGbS9FZWPUQiv
         Mb6t13M/oWsqMiv1cYm2KufO8A3SyMPIQqCa99ToKTI3/SdmrBauiYmGyvfkgRtgpzql
         DaYQ==
X-Gm-Message-State: AOJu0Yzf1Ml/havQ75+PDlqSSCdFPWiMkZbCFFvL1uAawx/jtiDY7JsO
	nShGAHDVoutaV/N3q2yMaXeDSXV4A2PbOdm69Ws9TSgHvpudGTiriaCgYoOTj/R5583fCwQGKC8
	WVa/z
X-Gm-Gg: Acq92OGChZ4hM+BuDXDFqCl4veEsyMJOvoiK8Wyli0FeMpeDJlBX6vYeqtkXXD9d5zV
	pEqN0BzWAKnUeDNqjgFtdPfN66UIHVMEJDKVTzZuuQXtY/DKuJWshgyp9i+IeshugfyeHBMzrUe
	X9lPOE19YY0i8T2vqs/2kcklV4LpP0M5UDIT+pDbCGZz+ri09KM+h1axhTr3uIMQQEMwbhanDlH
	edHiLjoW3gUrc2rDVmVTQIPvyclbXyYy0GIsQ48usH+uPyP2XPNo0VBNtnBSwfS67u9lPas6ybU
	bxsbZ6VEegCCAC9aKVXvpI3abls6jkQgytuEQkFvNWUPY5ZfUUJOfOdA3bVjnWW87D+FDnSYeIH
	/AjaO3qDXIxT8hfmCK3WvJ+mkNfL4+JWYQQhBUgSUfcQXjzu6baulRd+DMzSizOezFx431OtPwV
	yiMPC0GSPtVSNXFSsASvoVQyQTfkei5UdiGCwdj70eoVGlDeOQNCux8t6EKer3pWb4a1XV9syol
	JIxOgUl6mj1pGM31cySddivBnKNfwYZcXedh1tCO3KEZhk=
X-Received: by 2002:a05:600c:4816:b0:490:17da:27f8 with SMTP id 5b1f17b1804b1-4903607cef2mr2668865e9.18.1779319472285;
        Wed, 20 May 2026 16:24:32 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fe51sm230300325ad.2.2026.05.20.16.24.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 16:24:31 -0700 (PDT)
Message-ID: <23e9b6b4-1824-40b5-b9d3-160fbdefe319@suse.com>
Date: Thu, 21 May 2026 08:54:26 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] btrfs: add skeleton for delayed btrfs bio
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1778902677.git.wqu@suse.com>
 <d8b91a2081c898c548545c8b7c0aff6f463766c4.1778902677.git.wqu@suse.com>
 <20260520213811.GA1479855@zen.localdomain>
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
In-Reply-To: <20260520213811.GA1479855@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/21 07:08, Boris Burkov 写道:
> On Sat, May 16, 2026 at 01:15:14PM +0930, Qu Wenruo wrote:
>> The objective of such new delayed btrfs bio infrastructure is to allow
>> compressed write to go the regular extent_writepage_io() path, without
>> going through the async submission path.
>>
>> This will make it easier to align our write path to iomap.
>>
>> The core ideas of delayed btrfs bio are:
>>
>> - A placeholder ordered extent created at delalloc time
>>    No space is reserved at that time, and is not implemented in this
>>    patch.
>>
>> - A delayed extent map created at delalloc time
>>    It will have a special disk_bytenr (-4) to indicate the range is
>>    delayed.
>>    And a new EXTENT_FLAG_DELAYED flag.
>>
> 
> What is the protection for current callers of btrfs_get_extent() which
> use em->disk_bytenr? Many of them have specific logic for hole/inline
> em, are we sure none of them need to handle em->disk_bytenr == EXTENT_MAP_DELAYED ?

I checked all btrfs_get_extent() callers, they have all different kinds 
of protection:

- Check against EXTENT_MAP_LAST_BYTE

- Have writeback or wait ordered extents for the range
   Including:
   * Direct IO

- Extra handling before calling btrfs_get_extent()
   E.g. btrfs_do_readpage(), which checks uptodate bit before
   calling btrfs_get_extent().
   In our case, since the delayed OE is only for writeback, the
   folio is always uptodate.

- Exactly on the submit path
   E.g. submit_one_sector()

- Callers only care about holes/prealloc
   E.g. find_first_non_hole() and all callsites inside file.c.
   And some other callsites like btrfs_find_new_delalloc_bytes().

> 
>> - Delayed btrfs bios will be limited to BTRFS_MAX_COMPRESSED size
>>    As only compression will go through delayed btrfs bio.
>>
>> - Delayed btrfs bios will have @is_delayed flag set
>>    And such bio will have 0 as bi_sector, but will never be submitted
>>    directly through btrfs_submit_bio().
> 
> What is the purpose of using a false bbio as an async placeholder?
> 
> Is it to allow keeping the "submission" code the same, though it is sort
> of a no-op submission?

Yes, re-use the same submission code is the core.

The idea is to make sure we're going through the same submission, so 
eventually we can get rid of the async-submission.

> 
> Put a different way, is this for convenience because real and delayed
> bio submission share a bunch of delayed-agnostic folio logic,

It's not only for convenience, but it is the objective.

Thanks,
Qu



