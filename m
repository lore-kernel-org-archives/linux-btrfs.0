Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1580A416859
	for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 08:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785228542; cv=none; b=YqYLRKiPeZg9MOEvNxpH0EjUpUjSXxSlbdBrDi0nazhIWtMhHdI6FhHkNST7ne2WI7ROjgAFbwVWVkOmMWUYBFypLv+7+6R45bGpRGOJlMgtn96+A844sjkRvl1Sx7z5DcYztoHkJy5PznsVEruLXyyJvQ9x2GNB4qamWldPWLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785228542; c=relaxed/simple;
	bh=qf2S4CkI+1xe+j4GXiY4cxpjlo+kAvoUVBw9ufTdtDE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oAAapjiLWVy5X9UV9xQqD0vaAxW6TsSc2H2Scl9XyhsaMi3ucqgoaYHEzX5fDhrsY8SStzGgbRwOG4Rv4Vd/NomwVwoRqkUkv3nrq4lMT7AxhGRnfSLXL4oToE22hj6LiEjv5RgXIUnww1r5aZDa5Wo6/rPuszVokVgFkilRgHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EyAdpSyF; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EyAdpSyF"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69ff40d9cbcso2884637a12.0
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Jul 2026 01:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1785228539; x=1785833339; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fHZ4VJEu+OnnVxjx5ycJ+LMBqOlzgTqRIDO1MRUtxmU=;
        b=EyAdpSyFbr93Y16GNVZdz6UhhiZ5lhkyNchxfoo6HNQlsnMFWypTOOelI6qP+PeWlE
         JlP0BpCeTKkhlRTDotY1NHf4uYRf2jWWKKf3qAKN3eVxTj847cDHGRMMEEZp5pzJgr3c
         f6Q05+A3nYWu1JvOLl/p0hCobi04qhyaEk4UlR/pY/lCUpmJWH30i0zbQS90ucaNPfeL
         3yLdJ4xdT5Vvrz8uDzfyjxlZ7qizjvPYHEGLnodUHYqxpMIi1qHGMfsRO7ldkIXw02+R
         EBVEt94NTyA7L0UVNVgMbw9I/QAc2FNioiIAESizr5LLU8CTLMimZzETeK2hgkVFzTQQ
         Iu4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785228539; x=1785833339;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fHZ4VJEu+OnnVxjx5ycJ+LMBqOlzgTqRIDO1MRUtxmU=;
        b=pbtZb+7YH8s6R5KP7gj5iMT63t5XxtOfhpkKJO1hFngkOL3+UNhdQ+1CtAnY47FQ/R
         Fw2AL0Ry/Rcdwp4dVBMTa/imEuz06ASE8QPJNlWfoNPrs59y1YBUKBJeYkKgQ+H+4iOP
         sRLB5gbgTz8HP/D9lQ3e9P7dp/hWluPwluVA8j4kN3yC63B9pmRcW6L0R7qoEo0ZdwSE
         1ld6JG9OhAU+P7FojRQvKnQaQn4q6Q9DuxojKvp2DOs8dyDk1DuKbXl4HkPzvbObLecX
         mKI8qYLOqD6Rm8AU6tY5KrOEQEYsgNgUY6KgSHxhAms19uOvg2Us2EJZzStsoPvb87SR
         gyNA==
X-Gm-Message-State: AOJu0YybeIj5vLacJkQ9Ujw2GVBpMaDRT9i83inyZHLtfL0KExgmCCAs
	0oktbNgZR+HsvWzs461JB03ckFci9lfW2a5L3ihJYozI4EV3ma52Wfic+/dPkExqA4ylwG04GCY
	5ecTyGrhqBQ==
X-Gm-Gg: AR+sD119qiWzNoWlmqDSbDvAZTxnzsi73vcrASc6290sz8/hKnCgyGsxiO4CTpxrSjD
	NcZ9qfg8FZe9Ecjw+PLJxgZkFxMSBzenwVnm607yUpSNp4UTeRHIJ2AB90ZeVUHYFJ2S1yTVI5O
	8wWaIHXJJVq2T9JtWBpvme+LKAeQV6PbWAwq05OSszrBG2sxTPTtBJ7jHIgAj6TL+7BNL9nP78K
	zB6goYKv+abMkT6eIMi9CPDcx+UcrrgL//PjmT5HrtF9BTdG8pQh1mMwqI2IXBvQXZUgfXGVWaL
	DtGL7zi+HqXgI5PR0rt37eml+YHcW04w75j9cVDI0ZKwsu6INlB1/43MlYC3bpRD7KGp7Gf2CFe
	Z9YmaDUmfjr4hBTISWRfyyA9wfp7UNNgATAVmHTnHUMyU7HR6XZTBQJ90qsujO8Xy6gUtBrI=
X-Received: by 2002:a17:907:1c97:b0:c1c:4ab9:2c1c with SMTP id a640c23a62f3a-c1f7212f752mr74174566b.37.1785228539230;
        Tue, 28 Jul 2026 01:48:59 -0700 (PDT)
Received: from [172.16.0.229] ([159.196.52.54])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f6414705bsm939912a91.15.2026.07.28.01.48.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 01:48:58 -0700 (PDT)
Message-ID: <1186dfeb-0d0c-40d0-bd47-74687f2b332e@suse.com>
Date: Tue, 28 Jul 2026 18:18:53 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] btrfs: use proper inclusive end in extent_fiemap()
To: Filipe Manana <fdmanana@kernel.org>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1785220613.git.wqu@suse.com>
 <44822c23fc6764aa93a855648a1533a5faf4925c.1785220613.git.wqu@suse.com>
 <CAL3q7H53Vy4aGRui9L_GTkzuKJfHJXRSP0dtybGRJhJRdFLSqw@mail.gmail.com>
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
In-Reply-To: <CAL3q7H53Vy4aGRui9L_GTkzuKJfHJXRSP0dtybGRJhJRdFLSqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/7/28 17:05, Filipe Manana 写道:
> On Tue, Jul 28, 2026 at 7:47 AM Qu Wenruo <wqu@suse.com> wrote:
>>
>> The @end parameter for all extent io tree helpers is inclusive, but
>> the call site in extent_fiemap() is passing exclusive end.
>>
>> Fix it to follow the common pattern.
>>
>> Fixes: ac3c0d36a2a2 ("btrfs: make fiemap more efficient and accurate reporting extent sharedness")
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>   fs/btrfs/fiemap.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/btrfs/fiemap.c b/fs/btrfs/fiemap.c
>> index ba6a360074c0..2f2ae0b76799 100644
>> --- a/fs/btrfs/fiemap.c
>> +++ b/fs/btrfs/fiemap.c
>> @@ -657,7 +657,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>
>>   restart:
>>          range_start = round_down(start, sectorsize);
>> -       range_end = round_up(start + len, sectorsize);
>> +       range_end = round_up(start + len, sectorsize) - 1;
> 
> Here it was an exclusive end.
> 
>>          prev_extent_end = range_start;
>>
>>          btrfs_lock_extent(&inode->io_tree, range_start, range_end, &cached_state);
>> @@ -710,7 +710,7 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>
>>                  /* We have in implicit hole (NO_HOLES feature enabled). */
>>                  if (prev_extent_end < key.offset) {
>> -                       const u64 hole_end = min(key.offset, range_end) - 1;
>> +                       const u64 hole_end = min(key.offset - 1, range_end);
> 
> Here we guaranteed hole_end is not exclusive, by subtracting 1 from
> the result of min(), and both arguments passed to min() are exclusive.
> 
>>
>>                          ret = fiemap_process_hole(inode, fieinfo, &cache,
>>                                                    &delalloc_cached_state,
>> @@ -812,10 +812,10 @@ static int extent_fiemap(struct btrfs_inode *inode,
>>          if (!stopped && prev_extent_end < range_end) {
>>                  ret = fiemap_process_hole(inode, fieinfo, &cache,
>>                                            &delalloc_cached_state, backref_ctx,
>> -                                         0, 0, 0, prev_extent_end, range_end - 1);
>> +                                         0, 0, 0, prev_extent_end, range_end);
> 
> And here range_end was exclusive, we subtracted 1 to make it inclusive.
> 
>>                  if (ret < 0)
>>                          goto out_unlock;
>> -               prev_extent_end = range_end;
>> +               prev_extent_end = range_end + 1;
> 
> Here range_end was exclusive so there was no need to sum 1.
> 
> In other words, this change doesn't fix anything; it's just rewriting
> the calculations in a different way to reach the same results.
> 
> Where exactly do you think you saw a wrong end offset being used?

btrfs_lock_extent(), which is inserting extent_state that is not aligned 
and will be caught by the last patch.

Thanks,
Qu

> 
> Thanks.
> 
>>          }
>>
>>          if (cache.cached && cache.offset + cache.len >= last_extent_end) {
>> --
>> 2.54.0
>>
>>

