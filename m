Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CA73128CC
	for <linux-btrfs@vger.kernel.org>; Sun,  3 May 2026 22:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777847815; cv=none; b=MCoRt7N+xgDV5/2081puHFDH8sHnry11UrKGyDKq26WE5D4OGfDVl4KqVoMgrGPUvQqZGEZdWmWnet0LwZz/4HU63SfHHErmtxc/TLLk1HXwjyJz/9WjLzcNPU8PGXXB6ytFfKI4I/mRNKpOt6DxioRjhibOcD7C+q6qIEkIuxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777847815; c=relaxed/simple;
	bh=+9eNfLNUvSWpW4nzE8oDJN5VP28Fzw9MAp/WrjczjUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oVmU4Q1CVOjq5owAgxxCiuH4A7LkcYwsZGKeDFSUqEnueAL3tHz3tUi5MLym2RQoSoISVSAoSOxBQ8vaTsF6zCneg3T3oMco0WYdUmmyDRE1M6J6RmfAc6OUyr4IWGWK+/yMVchsfIkgV66lCwV4Pr+D4gGKeFzGjbcTwvH7V60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=drg+ClBh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="drg+ClBh"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-48896199cbaso30970405e9.1
        for <linux-btrfs@vger.kernel.org>; Sun, 03 May 2026 15:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777847812; x=1778452612; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=sltDay8l9ZiZBoT2XcBVZ/nZTs4xKINTiPbeFR2fFFM=;
        b=drg+ClBh35nZg1pYGis18RefPRusrgcY+wiB+FxLZdfkvY7ageiNqrl3wTFYjn5HnA
         9JhxOSwnTJ9yM8aCfvH9tuUzamCQvtoEb0AVkiE5LS9sixICnC1LzeEuZw7mgeEBGm4W
         HJ4bvk1dp9uI1p+hEpKbVwodpbiDKDqI1XSm1c83L9V8Z4ZMkkaOlTErTRiWQEeLZF9b
         1JF+USZTMsczXtpzUvsHlz1OUHwXng07f7ZMO4O/isMO27q1DzXTBI2/WszR1I53kpmb
         BvZHaqIoSDl0AO33zPsspj5GdjmpbIghKqYrHvon9x/hkSCXn/a170xi3lCJ8RsSXpZm
         gVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777847812; x=1778452612;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sltDay8l9ZiZBoT2XcBVZ/nZTs4xKINTiPbeFR2fFFM=;
        b=B7Sg9SqXrjgp/pNG+B2JKOlR7zhcN9xXMbsRBMbUgifXksfPWb1/55T/gFQQNtmhKj
         YV/Lz/4phmQy/PfJVZpKCOMMKKeAcIegNzq0/1WWSn4T9n9J4u1oW71zx24yCiEZwBaf
         TvRCc3XOzCBcOG5yiHgETdOs/VeO0wLqB3lmsMYpVyp7wLqo8fyEjS5JVQ1tNz0wuINj
         jfyVflBvV9tVwxml5NhCfSL8Sp2YA84aU2Pjt/W1VoBQz/P4msb6z3CncBdRZt06CC1f
         G9iNUQGFfe+/Vwt7v3z0SVsDzHmWJYyfRQUOysIds57XN1/0SoE+Rfh5NYoLddNE3OQy
         RLhg==
X-Forwarded-Encrypted: i=1; AFNElJ9OxwaWJraJnwYF4W+VYR0Qs0eJXx9KIuwshA5LnnT/TaE5ajjjrMmpP5uXXxZ5bnuGLtIP9UjoYB8/6w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4vlgkS6Kbvf9zCCFCAD9qKBjfPjbPvQ+L88Mcst9dhebte4wu
	t9/XQOhzx3G9mFS+hiEQk4pvEb1UJB/dsYxy6lWneDfs9d251m7LWlWLlmAjENDp1Bk=
X-Gm-Gg: AeBDieui33j05tEXz4UMTcMQ4VmAGnV6sY0+ARApM1bWxVX/4YjvZOltvTBSoswpLZK
	vzNy/GigGML0mgTpJQAC/4/YT8xnXOcC5gCluUDepjBSGhJQZuAnE1ve9JgiAlqUd/Qab2ZZRlr
	jm3ElNKcJvRaV3lqn7k7nWyjiS+9tYX6GkaFue1/cwrT9ekw+Etphl7X+pK2gfx2bLyViFG8bP9
	RzIqzWVQkKjFHko2XwSMgCZuWXsIdg7sM/a9jv9/Iz71ty2SYsgJktco20VtfNz48xkIhncmmOt
	ObCfM9jLPQt+a5elnTATZWiICvirHrSjKRvQopakg8c+6vaTcioreM/QwkLuazKTVJr46I8CDWi
	lrgzpSWIaaHG/xPyvxDkdbT7IiBtnjc5TIihe+/YOvtv6neAnrt8PqNCRhFCznX8mYAVRI36twP
	rAMqM+xc405azdEmjB1y2Mgk/eNYnCmWQ1mCbThoaVuNvPkldk3hm7dIGhl1VY8fZmpUxzSDgp6
	8Ioon4EAobl7hKn/hfYGlDDThsDdaA9KNS+T+s8QYBjhqCGPvFTMYD2Qw==
X-Received: by 2002:a05:600c:444c:b0:488:e7e4:8425 with SMTP id 5b1f17b1804b1-48a9866a6b4mr122731695e9.23.1777847812366;
        Sun, 03 May 2026 15:36:52 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1:0:2bb5:f164:6e6a:38d8? (2403-580d-fda1-0-2bb5-f164-6e6a-38d8.ip6.aussiebb.net. [2403:580d:fda1:0:2bb5:f164:6e6a:38d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7ffbbbf298sm7715064a12.13.2026.05.03.15.36.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2026 15:36:51 -0700 (PDT)
Message-ID: <8005d598-f4fd-4e92-9df4-a90674756876@suse.com>
Date: Mon, 4 May 2026 08:06:45 +0930
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] btrfs: validate data reloc tree file extent item
 members in tree-checker
To: Teng Liu <27rabbitlt@gmail.com>, linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
References: <20260426201605.36626-1-27rabbitlt@gmail.com>
 <20260427202822.278326-1-27rabbitlt@gmail.com> <afdoNU3rQUr0pREJ@rabbitArch>
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
In-Reply-To: <afdoNU3rQUr0pREJ@rabbitArch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/5/4 01:05, Teng Liu 写道:
> On 2026-04-27 22:24, Teng Liu wrote:
>> get_new_location() uses BUG_ON() to crash the kernel if the file extent
>> item it looks up has any of offset, compression, encryption, or
>> other_encoding set. The data reloc inode is only written by relocation's
>> own paths -- insert_prealloc_file_extent() and
>> insert_ordered_extent_file_extent() -- which always leave those four
>> fields at 0 (the data reloc inode is created with BTRFS_INODE_NOCOMPRESS,
>> and encryption/other_encoding are reserved-and-zero). Observing a
>> non-zero value therefore means the leaf decoded from disk does not match
>> what the kernel wrote, i.e. on-disk corruption. A malformed image can
>> reach this code via balance and panic the kernel.
>>
>> Move the validation into tree-checker's check_extent_data_item(), where
>> the constraint is enforced when the leaf is read off disk rather than
>> after relocation has already started. The data reloc tree has a fixed
>> root id (BTRFS_DATA_RELOC_TREE_OBJECTID) recorded in the extent buffer
>> header, so check_extent_data_item() has all the information it needs to
>> apply this check on its own. Report violations via file_extent_err() and
>> print the four offending values.
>>
>> In get_new_location() replace the BUG_ON() with an ASSERT().
>> The caller in replace_file_extents() already handles non-zero returns from
>> get_new_location() by breaking out of the loop without aborting the
>> transaction, so no caller changes are needed.
>>
> 
> Hi Qu, David, and all,
> 
> I spent some time trying to understand why the tree-checker saw non-zero
> offset while BUG_ON never hit. Share some observation here in case it's
> helpful and also ask for further advice about how to make the patch
> correct.
> 
> Short answer: I noticed that get_new_location() and the tree-checker
> look at different itmes in the data reloc tree. The tree-chcker
> validates every item pre-write; while get_new_location() searches only
> exact cluster boundary key, so the offset is always 0.
> 
> == How I tested ==
> 
> I instrumented both check_extent_data_item() (tree-checker) and
> get_new_location() with pr_info() to log ino+key_offset+offset for every
> item. Then ran btrfs/061 on qemu.
> 
> == Some Evidence ==
> 
> Tree-checker hits (items with non-zero fields in the data reloc tree):
> [   63.531400] tree-checker HIT: ino=258 key_off=13303808 type=1 offset=102400
>                compress=0 encrypt=0 other=0
> 
> Printing out the leaf items (when tree-checker hit an item with non-zero
> offset) and we found:
> [   63.540541]  item 114 key (258 EXTENT_DATA 13201408) itemoff 10188 itemsize 53
> [   63.540549]          generation 22 type 2
> [   63.540554]          extent data disk bytenr 4566134784 nr 110592
> [   63.540558]          extent data offset 0 nr 102400 ram 110592
> [   63.540613]          extent compression 0
> [   63.540619]  item 115 key (258 EXTENT_DATA 13303808) itemoff 10135 itemsize 53
> [   63.540644]          generation 22 type 1
> [   63.540649]          extent data disk bytenr 4566134784 nr 110592
> [   63.540744]          extent data offset 102400 nr 8192 ram 110592
> [   63.540750]          extent compression 0
> 
> Looking for the two 13201408 and 13303808 items in get_new_location:
> 
> get_new_location() search keys:
>    ino=258 key_off=13201408 offset=0 type=1
>    ...
> 
> We didn't see 13303808 item at all during get_new_location.
> get_new_location searched for key_off=13201408 (the cluster boundary) and
> found offset=0.  It never searched for 13303808.
> 
> === Why this happens ===
> 
> During the MOVE_DATA_EXTENTS phase:
> 
> 1. prealloc_file_extent_cluster() inserts one PREALLOC per cluster
>     boundary (via insert_prealloc_file_extent), all with offset=0.
> 
> 2. relocate_one_folio() reads source data and marks pages dirty.  On
>     writeback, ordered extents are created.  When an ordered extent
>     completes, insert_ordered_extent_file_extent() calls
>     insert_reserved_file_extent(), which calls btrfs_drop_extents() to
>     carve out the written range from the PREALLOC, splitting it.  The
>     right-hand piece (REG) gets the ordered extent's offset into the
>     shared disk_bytenr -- which can be non-zero.
> 
> 3. The pre-write tree-checker fires when the modified leaf is written
>     to disk, seeing the REG item with offset!=0.  This is the false
>     positive.
> 
> 4. btrfs_wait_ordered_range() waits for all ordered extents to finish,
>     then the stage switches to UPDATE_DATA_PTRS.  replace_file_extents()
>     calls get_new_location(src_disk_bytenr) for each source extent.
>     The search key is:
> 
>         bytenr -= reloc_block_group_start;
>         btrfs_lookup_file_extent(..., ino, bytenr, 0);
> 
>     This is the cluster boundary -- the start of an extent, where offset
>     is always 0.  get_new_location never searches the mid-range keys
>     where the split pieces live.
> 
> == Advice Needed ==
> 
> If my analysis is correct, what do you think is the best way to fix this
> problem? Or am I missing something somewhere?

Make the tree-checker to reject compress/encoded extents in data reloc tree.

And add proper handling with leaf dump for relocation when an non-zero 
offset is hit.

> 
> Thanks in advance,
> Teng Liu
> 

