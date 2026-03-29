Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50432EA173
	for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 22:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774822979; cv=none; b=o5ToaqEbWcHcX6cCcNdqZFAeXizxFYLYLYYKz6rqvTmDqtyngg5VEYDL1EwTGIwPgCVZdlA5QSxoPnxbrgoqGM8XE5LcAAh2iuijPdhCvS2XjHYBdy5Zb/IXaxSNL0VbUDbD9zUZbRfXYAqla5way+ipcHU098qP53PIYqTV1eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774822979; c=relaxed/simple;
	bh=Rmb03HcOQ+eS2CtS+tA3qXG3S++t7FpjR7Epn54e6tk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=A833C21KSk2Dpxf9W21VkarC/LHdbxq93vvXBl289HZ2hpJHm9bSl1JsaWUvWWqN8HfqOnUgWNefXe3WF6CcZ8DyCm17j2dnUGzxn1+Y+87lyVQdGadH69+ceh1maDBYhnmFjv9Z1SLsO9Vx3ZEtzwUTISAw7NfBXtbJZuslo2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ccdxj2+M; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ccdxj2+M"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48704db565eso51369355e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Mar 2026 15:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774822976; x=1775427776; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=yI8bCc6ccqoRAVSde2XBXMFF+rLvzbpUknKXnWcZlHE=;
        b=Ccdxj2+MROLpOr0obyfGRhZ7oFmaRwyQXm8ptgPdgdgsfMF8VBuz+BUKKTxUAShGu/
         pBizZKSre3dRGCdHlT9MypA7+X4FX7jewwds5MtkIeGY7CsGfg03plgk8nTTIn5Bzvcu
         uIrz0HdtJVOf86Wv3/dkZt+x7M1X89aQUqH//cF8DXB0Vlk+pKiGV6Sy7UtIa7lUTUCh
         yhT70pD+OWIvS34yRDLrUR0tl+tLSherZ5nC8Gi7gyqDEuGctTUhhmLFKbDIeI4D/BBd
         dIeYkHZABNL+ORdBYQ88TuwynDnKCmRqfYZZYo64xnGpE1IPfCYNcrDJ0W1IMIga+koY
         HD7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774822976; x=1775427776;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yI8bCc6ccqoRAVSde2XBXMFF+rLvzbpUknKXnWcZlHE=;
        b=lNTEZGJjDAfV4tVXVs2Q0Aasf+IJTH6rTWmpUeBdqnc+eAMUzmDX0ApQonh8LVFaQv
         O31TqHnPKgHXlpi1t3E8zlqTUjJBfK86sNcTsSag5+gJR8JNVKIFerO8oCtmrGUf45g9
         EWcszCmSqCphGBUtLosgybpOmjrk5iorE8lm0ioMjevZDOXdIlIb3F+G9kBItC1fVW4w
         N+11Fs1N2NCkLkA67n1acciZnHavG+bB+2SmC8YFgLJNRUG6/D/takYZsNFNrvnygNz0
         p82QkowHnsA7jJRWzvkcQ5+j/uGp4cZbHFobzCJwPlWo7S0priM2jCZzi0t5RqBQDn8s
         gZYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYjDOI+zSU6LffMGOOwuy+/Wly3IzF7NyiQvtjy77zQHpqc+/bDjcOu2Y4sGICTFVH7jLZQOPJrSQyxw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa1My+JdRwjjVypcXWPycSsb+ynf+3BaId4LaJQEy/VYhgUh1v
	J6zwH730LpNTZcmWs0ap6MBdlVWHw4ZHj9rEkpujRHuH4ALKpAL8Tx0BfZb+gLDfzrU=
X-Gm-Gg: ATEYQzyZUCS5kd4d8oOHs9m84Ii7fWbLhmvv6zA+92Vo0PsBeHzOvhbWVKR4pbCe0Mw
	3adruudGmFwIHj4M58uBlyinXEcVA9E1GcdHRAvacAyycJQx+i+x7IboNS3xd8J7lDHWcFvxN+v
	wIqGbAemGkGL6sOHblhTawwFseHoLhUUPoXo4UhYgCRRff/fnbZQow5KXQDT7DfQrfV9uEIeH98
	xRcyBiSsK86SlJDrNevnDRSZ56rSZUWK/D9Bc8bzOKWV+7d977cLN5b7/zamy3nWNhyA4l1oH17
	rNY4j54DsSgUS5zLANGAjQU8sfHqcNOzSIvvMpJ4C9TBIz950sfHAPrRmi+wtfXTRFdD8lY9RGI
	oBNWPe3pObT3Wdeqc2QpZTRCoQgmthpbGWppnYDSznvg535tVdtH0eIJB9I0AOKR0CGxfS9jdv2
	/97O4fhY2442jdR0UFwEtNgGDmbIkzfUtAOrWcAwo5p5Sl47eejX8=
X-Received: by 2002:a05:600c:c109:b0:486:fe23:1707 with SMTP id 5b1f17b1804b1-48727eb7fc2mr128664615e9.20.1774822975838;
        Sun, 29 Mar 2026 15:22:55 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35d9507dc3bsm5089735a91.9.2026.03.29.15.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2026 15:22:54 -0700 (PDT)
Message-ID: <840361b6-9b27-4419-b8ab-891ab254fac9@suse.com>
Date: Mon, 30 Mar 2026 08:51:14 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: wait for in-flight readahead BIOs on open_ctree()
 error
From: Qu Wenruo <wqu@suse.com>
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.com, clm@fb.com, linux-kernel@vger.kernel.org
References: <20260329063417.642647-1-27rabbitlt@gmail.com>
 <11c944aa-7745-4720-9f40-af99bf7bb727@suse.com> <aclYf4R2XxlUkxAQ@rabbitArch>
 <4a129696-0352-427f-9e0e-7962e789df57@suse.com>
Content-Language: en-US
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
In-Reply-To: <4a129696-0352-427f-9e0e-7962e789df57@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/30 08:36, Qu Wenruo 写道:
> 
> 
> 在 2026/3/30 03:53, Teng Liu 写道:
>> Thanks for your review!
>> On 2026-03-29 17:33, Qu Wenruo wrote:
>>>
>>>
>>> This doesn't make any sense to me.
>> It confuses me as well when I try to reproduce the bug. The reported
>> claimed that btrfs_bio_counter_sub triggered a use-after-free but this
>> function lives under `dev-reaplce.c` which should have nothing to do
>> with the setting from the name.
>>
>> However when I checked the function call chain:
>>
>> open_ctree()
>>    → btrfs_read_sys_array()          # OK — sys_chunk_array in 
>> superblock is intact
>>    → load_super_root(chunk_root)     # OK — reads root node, passes 
>> validation
>>    → btrfs_read_chunk_tree()
>>        → btrfs_for_each_slot()
>>            → readahead_tree_node_children(node)
>>                → for each child pointer in the internal node:
>>                    btrfs_readahead_node_child()
>>                      → btrfs_readahead_tree_block()
>>                        → read_extent_buffer_pages_nowait()
>>                          → btrfs_submit_bbio()
>>                            → btrfs_submit_chunk()
>>                              → btrfs_bio_counter_inc_blocked()  ← 
>> bio_counter++
>>                              → btrfs_map_block()
>>                              → submit_bio()                     ← sent 
>> to USB drive
> 
> Even you wait for all bios, it can still cause problems.
> 
> As the bio counter is only for btrfs bio layer, we still have 
> btrfs_bio::end_io called after btrfs_bio_counter_dec().
> 
> And if the full fs_info has been freed, then at end_bbio_meta_read(), we 
> can still have problems as btrfs_validate_extent_buffer() will access eb 
> (bbio->private) and fs_info (eb->fs_info), which triggers use after free.
> 
> So using that bio counter is not going to solve all problems, but only 
> reducing the race window thus masking the problem.
> 
>>
>> After submit_bio() sends BIO to USB drive, we continue on
>> read_one_dev():
>>
>> open_ctree()
>>    → btrfs_read_sys_array()          # OK — sys_chunk_array in 
>> superblock is intact
>>    → load_super_root(chunk_root)     # OK — reads root node, passes 
>> validation
>>    → btrfs_read_chunk_tree()
>>        → btrfs_for_each_slot()
>>            → readahead_tree_node_children(node)
>>              → bio_coutner++ and submit_bio() send BIO to USB drive
>>            → read_one_dev()
>>
>> This read_one_dev will return an error since the leaf block is actually
>> corrupted. Then open_ctree will get into error path and try to free
>> fs_info.
>>
>> After USB device finished BIO, it will try to decreament the counter but
>> the fs_info is already freed.
>>
>> Any suggestions on this?
> 
> The following ideas come up to me, but neither seems as simple as your 
> current one:
> 
> 1) Introduce a dedicated counter for metadata readahead/reads
>     This seems to be the simplest one among all.
>     But the only usage is only the error handling, thus may not be
>     worthy.
> 
> 2) Disable metadata readahead during open_ctree()
>     Which will delay the mount, especially for large extent tree without
>     bgt feature.
> 
> 3) Use buffer_tree xarray to iterate through all ebs
>     Since this is only for error handling of open_ctree(), we're fine to
>     do the full xarray iteration, and wait for any eb that has
>     EXTENT_BUFFER_READING flag.
> 
>     The problem is, we do not have a dedicated tag like
>     PAGECACHE_TAG_(TOWRITE|DIRTY) to easily catch all dirty/writeback
>     ebs.
>     So the only option is to go through each eb and check their flags.
> 
>     I think this is the one with minimal impact, but may cause much
>     longer runtime during this error handling path.
> 
> My personal preference is option 3).

Or the 4th one, which is only an idea and I haven't yet verified:

4) Handle error from invalidate_inode_pages2()
    Currently we just call invalidate_inode_pages2() on btree inode and
    expect it to return 0.

    But if there is still an eb reading pending, it will make that
    function to return -EBUSY, as try_release_extent_buffer() will
    find a eb whose refs is not 0, and refuse the release that eb which
    belongs to a folio.

    That should be a good indicator of any pending metadata reads.

    So if that invalidate_inode_pages2() returned -EBUSY, we should wait
    retry until it returns 0.

> 
>>
>>
>>>
>>> The wait and counter are all for dev-reaplce, not matching your 
>>> description
>>> of the generic metadata readahead.
>>>
>>> If you want to wait for all existing metadata reads, I didn't find a 
>>> good
>>> helper, thus you will need to go through all extent buffers and wait for
>>> EXTENT_BUFFER_READING flags.
>>>
>>>
>>
>>
> 
> 

