Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A952C08D0
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Apr 2026 23:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775086200; cv=none; b=uEQRoS9Ttk7+VQ1tGGWn+OPJVG08htLgqWJVY5R4SlNJW0xrrUZMArk7K3zQPVlf+r+VJHtQ3S/4rfN2GOo8GSMy7nI7V26UDB/xj7Ywz8IJqYYNhbld/xO9vXLDd5VdUY7tlcSi1abFSXg1/ImLfXz+gpP6HzQ/GFmXbpgbKw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775086200; c=relaxed/simple;
	bh=D9ZP1vlgYGrZMNGzDF6fD/YbAER7ReqE6FgpMOrrRME=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wz7dY7vRL/xRa2flLYt6aBEfra3505KFNOwL94Q8v3TS6sXZVzKNwkp5WZBwCtuDYwlg1yo+8I5p9vox2EXKwv+P6GNyAnZAi7ps4+wDPAp99+lANpG9oMsSiMZ35BUDU5QeVxr2JarPU2DMuQGy7NuFViA/FjKYk9hDdXANEVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IUsaY/CB; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IUsaY/CB"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-487035181a7so1259625e9.2
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2026 16:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775086197; x=1775690997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ALyi01LunEoCd7urovTTL+eu6k3IR2z87+bISnwUeDI=;
        b=IUsaY/CBLzrDxfInAxjIEKSj20AOL05RTmwljW69zeuKEyPi06gzjAVPa++3qvbYYO
         iic8GV4KllwghXjkVgc06qYkmxWXpHsK3YW/dFUbI1JWknfBJgGuur1bZg90cvkDX9ia
         UAltRvAdSmMPAJclVlK89dJyKU6574mEvk9v9LxkqiYGMhkw2Urh+GJI+DcPtVRSoWNU
         /OsFDWK7Xhvit3qpy9drGbb952W1YdqloU5DOw25afQ2rX3Ab1ayrVTehSmRt078D3Fe
         ZM7d1gjcDXer5thiAOlXu+3nKt8BjWBlu8iayrhr60isaZrb1newmuqNCfaO9hYq8FnH
         Wxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775086197; x=1775690997;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALyi01LunEoCd7urovTTL+eu6k3IR2z87+bISnwUeDI=;
        b=sgwMjvmerklvcmvTVJ+RKsMnb+J78NDOAwIKW2sTjO+ojykFe+yZbRjfKOFEKg0chX
         14Eo/qDRc2pt4m227GkYH2nEvJO4/dfVJUDcH4gtbbco7D7iCYjGsYrK42VcseUfBgdq
         oROHw4coK7VqJcDn3HaQjo8TXPG84XUv1zzdc/G+6l9jCYeOeiiKBxz8JTqALqPE9K5X
         WDORstebdsc9hzXs/f8FyY9IY+9MYT84px/7byyHPCUCwxBafcu7QV78zmxRiU8qwI+l
         q5TILj2ToS5dE/+rSLkv3joe6PuNPWtQLQWWEAIvIw3Otx+xdR9kKgeDjISjBkibGAPy
         K/LA==
X-Gm-Message-State: AOJu0YzP5Huad8X0OK4ofw+I6U2x/wyDZY/zagTxgEeFu7ITfdauJ8B9
	sGQlHoyTDqd+JymIDwnQqSqn4Fx5/9PiKXBTHtjSStwDk5DHolGyquYXxrBs4wg9DzE=
X-Gm-Gg: ATEYQzwAoGU35DgokIzfa33tDcKJlXQ/RS6sDM7M0TCxgSUC+ych9SGYIWupHCnJqQE
	0SeW6tNxfP1LHlNX6BsRCsl71wQYqNRSTravkZJZR7FmqYf7TiM4DHiqQlb1IKTFZR9/Z26++ia
	cPc/WLJeHbIldYxtlBAzR5sSM4vxYxZXBnDrFLrz5UIkBK1zBRRGBB8sgnmIVLMJoe/4DPV/t7Q
	AXsvZE1agoCY+CCK7InGn2FF3LyQBmSHqg7aVY4/kMEhc7gBP/VNHgXB5MSOOXpgpGqQbXi3sD+
	xRsi/IjMhL4MKidp9vuccYmReb9MmK440CNHhlXYIXkxyiNbkYr5GsM4VKuAhDCHl3MHgSdTM4+
	PtAg45d5+ff5r49wMbpt0+zF1RG5fJ5Aluxa3ZF2koEqZkfokVkrDRvB9dokm0NqHhEE1VsW11N
	XqQ8/EkUo3VBUVXOZLTnyuAB6i/feHKH57gNGtKj8arFBbR0Orq4k=
X-Received: by 2002:a05:600c:a088:b0:486:fdca:ea8d with SMTP id 5b1f17b1804b1-488835cd366mr91214035e9.25.1775086196862;
        Wed, 01 Apr 2026 16:29:56 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35dbba1415csm2177131a91.13.2026.04.01.16.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2026 16:29:55 -0700 (PDT)
Message-ID: <987d1e01-50d7-4877-b55c-62191b12754d@suse.com>
Date: Thu, 2 Apr 2026 09:59:46 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] btrfs: delay compression to bbio submission time
To: Boris Burkov <boris@bur.io>
Cc: linux-btrfs@vger.kernel.org
References: <cover.1773953307.git.wqu@suse.com>
 <20260401225257.GA826348@zen.localdomain>
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
In-Reply-To: <20260401225257.GA826348@zen.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/4/2 09:22, Boris Burkov 写道:
> On Fri, Mar 20, 2026 at 07:34:44AM +1030, Qu Wenruo wrote:
[...]
>> - Write back folio 8K
>>    * Delalloc
>>      writepage_delalloc() find the delalloc range [8K, 128K) and go
>>      compression, but this time we allocated delayed EM and OE for the
>>      range [8K, 128K).
> 
> Just for the sake of the description:
> 
> I think it's helpful to be more clear that we unlock the delalloc
> range here.

Sure.

> 
>>
>>    * Submission
>>      That folio 8K will be added into a bbio, with its dirty flag removed
>>      and writeback flag set.
>>
>> - Writeback folio 12K ~ 124K
>>    * Delalloc
>>      No new delalloc range.
>>   
>>    * Submission
>>      Those folios will be added to the same bbio above.
>>      And after the last folio 124K is queued, we reached the OE end, and
>>      will submit the delayed bbio.
> 
> Can you explain the importance of the delayed bbio more? Why not just a
> work queue item directly?

Which aspect of the importance?

If it's the folio dirty/writeback flags change, workqueue itself won't 
solve it, as it will still be the old async submission, causing the 
writeback flag to be set seemingly randomly.

If it's something else, the new behavior is almost the same as COW path, 
except the complex layered OE part after submission.

> 
>>
>> - Delayed bbio submission
>>    As the bbio has a special @is_delayed flag set, it will not be
>>    submitted directly, but queued into a workqueue for compression.
>>
>>    * Compression in the workqueue
>>    * Real delalloc
>>      Now an on-disk extent is reserved. The real EM will replace the
>>      delayed one.
>>      And the real OE will be added as a child of the original delayed
>>      one.
>>    * Compressed data submission
>>    * Delayed bbio finish
>>      When all child compressed/uncompressed writes finished, the delayed
>>      bbio will finish.
>>
>>      The full delayed OE is also finished, which will insert all of its
>>      child OEs into the subvolume tree.
>>
>> This solves both the problems mentioned above, but is definitely way
>> more complex than the current async submission:
> 
> I mentioned a few key questions in line, but I think they how and why of
> "this solves both the problems mentioned above" is lacking at a high level.
> 
> As *I* understand it, the basic explanation is:
> =====OLD=====
> WRITEBACK
> lock folio F
> lock_extent_delalloc_range([F,F+N])
> submit async chunk work
> folio F+1
> block on folio_lock()
> 
> ASYNC SUBMIT
> do compression
> do allocation
> create OE
> unlock folios (except locked_folio)
> submit bio for OE
> 
> WRITEBACK
> unblock on F+1
> no-op
> etc... till F+N
> 
> =====NEW=====
> WRITEBACK
> lock folio F
> lock_extent_delalloc_range([F,F+N])
> create delayed OE
> unlock folios except locked_folio
> lock folio F+1
> add F+1 delayed bbio
> etc... till F+N
> "submit" delayed bio
> 
> ASYNC SUBMIT
> do compression
> do allocation
> create child OE
> submit real bio
> 
> Is this correct?

Yes.

> 
> If so, the "magic" is in the delayed OE providing enough synchronization
> to allow us to unlock the folios right away in the writeback context.

Please remember that, for non-compressed writes, we do exactly the same 
behavior, unlocking folios right away.

So the synchronization part is at least no worse than the regular COW path.
But I agree the current delalloc time folio lock/unlock is not 
straightfoward to grasp.

> So
> we are breaking the contract "OE <=> allocated space" to allow this. I
> think making the absolute core of the improvement more apparent in the
> descriptions would be helpful.
> 
> I think one thing I still don't understand is the desire for the layered
> bios/OEs instead of creating the same delayed OE, but then as we do the real
> allocation/compression and discover the actual ranges doing
> btrfs_split_ordered_extent() like short DIO writes, which seems quite
> similar. Splitting/joining feels like a much more natural model for
> ranges like OEs than layering into a tree. As we discover the sub ranges
> we actually use, we split off the real OE.

I can definitely work towards that direction. Although my concern is the 
OE waiting/start part and error handling.

But so far those are only concerns, I need to implement the code to see 
what can go wrong.

And if no major problem is hit, you can see a v2 with the split solution.

> 
> I actually think this sort of makes sense for non-compressed too, where the
> reserved size can be less than the maximum you tried for, just the same.
> Probably too early to try to switch over everything, but it could be a
> uniformity benefit in the future.

The problem is the size of the contig range we can get with page cache, 
compared to the max extent size.

Our max extent size is 128M, but one bio can only hold 256 bvecs.

For the worst case scenario, all of our page cache are not contig, thus 
a bio can only hold 1M data for 4K page size, resulting way more fragments.

Although large folios can help, e.g. 64K IO block size with enough 
memory can easily fill a 128MiB bio, it's indeed a little too early.

> 
> Fundamentally, I think it just feels kind of strange (with the old code
> or the new) to have the one folio at a time iteration in writeback that
> does lock/unlock on each folio and the delalloc locking/iteration that
> we really need to do the right thing with extents. I would love if we
> could reconcile them more completely rather than just hacking OEs into
> submission (no pun intended :D).

IMHO, all the complex delalloc page lock/unlock is just to get a large 
enough contig range to reduce fragments.

Personally I would prefer to submit one or more bios after locking all 
folios at delalloc stage, which can reach the same less fragments.

But I guess there are a lot of extra writeback control related 
accounting is needed, and the current folio/tag based writeback is 
making it harder to do such early bio assembly/submission.

And with the ultimate objective of iomap integration, submission at 
delalloc time can also be very tricky for iomap.

> 
> I actually think your model is quite close to what I want, I think it
> might just be too hacky/incremental. I am ok with moving forward with it
> if we can also envision future next steps for further simplification.
> 
> I read the patches but apologies if I missed the answer to some of my
> questions in the code.

No problem at all, your review really helps to improve the patchset.

Thanks,
Qu

> 
> Thanks,
> Boris
> 
>>
>> - Layered OEs
>>    And we need to manage the child/parent OEs properly
>>    But still it brings the minimal amount of changes to the existing OE
>>    users, and keep the scheme that every block going through
>>    extent_writepage_io() has a corresponding OE.
>>
>> - Possible extra split
>>    Since the delayed OE is allocated first, we can still submit two
>>    different delayed bbio for the same OE.
>>
>>    This means we can have two smaller compressed extents compared to one,
>>    which may reduce the compression ratio.
>>
>> - More complex error handling
>>    We need to handle cases where some part of the delayed OE has no child
>>    one. In that case we need to manually release the reserved data/meta
>>    space.
>>
>> Qu Wenruo (6):
>>    btrfs: add skeleton for delayed btrfs bio
>>    btrfs: add delayed ordered extent support
>>    btrfs: introduce the skeleton of delayed bbio endio function
>>    btrfs: introduce compression for delayed bbio
>>    btrfs: implement uncompressed fallback for delayed bbio
>>    btrfs: enable experimental delayed compression support
>>
>>   fs/btrfs/bio.c          |   1 +
>>   fs/btrfs/bio.h          |   3 +
>>   fs/btrfs/btrfs_inode.h  |   3 +
>>   fs/btrfs/extent_io.c    |  29 ++-
>>   fs/btrfs/extent_map.h   |   9 +-
>>   fs/btrfs/inode.c        | 492 +++++++++++++++++++++++++++++++++++++++-
>>   fs/btrfs/ordered-data.c | 181 +++++++++++----
>>   fs/btrfs/ordered-data.h |  14 ++
>>   8 files changed, 678 insertions(+), 54 deletions(-)
>>
>> -- 
>> 2.53.0
>>

