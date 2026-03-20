Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B22B3783D6
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 22:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774045626; cv=none; b=t2jvpld69ZMtd2Cz8RSV+oH4RWV2gm+POZTral1hbY3gSKZ1x1XJK+TgZNW99/L37mfzDUJqqowSU8k/E0c+q6xE100tzfYHRxotGCV9qy8I6Cr99nRJx677jE7uD+uByyKw2OL8N6s+704ejOwNo303yVyymzmu6VAGYV/93QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774045626; c=relaxed/simple;
	bh=RrHWtNjmagPjo+xiCvixUOMsXB6SF6mT110kYLVQQCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FOQcuhYZYNNJbea4MhJQoqaRGZieit2hM1l8anXBczGWlCBBArnU2JExu09QdULCXWwijuFDdhZfQkirZndaJWZH+SREbimoOTEh8rnH9BxOmx/S2A9a1WGkwZWwNXxrV10EuraS7cCndh/nWrSMmVcME0ZipYrzJDPacSzgxL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=a9s+Kxrv; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="a9s+Kxrv"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-486fb14227cso23571945e9.3
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2026 15:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774045620; x=1774650420; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=oZMf+n+2UaLqD15BKFxgwMFWBdH7VTMfFKDNbfbyD1E=;
        b=a9s+Kxrvs8gbzkMF8sDvevyDPjRblE9GA1/hM8VCp3Axt3KVX0dhqV9wdr6VgoSVuw
         JtKihII0Y2IUZatUU19rh2bmiwrvpQjgonoH8v56NRisoZOEGLgvVtSSxr3PfpX9NI9/
         v0LsG6xTN3/AyL0CL983xRTIhIvWGql5ouwcclUbKrcz9B5PmwSj6a8wdZJJpWaoEmzD
         hpWFYS7jwBu98vqaZmOZ4sG9fmYihcZteYbw9hpYIyf3UqKN8FVt/1tm59x44imGtENr
         TFSVNpxM8o6Exn0irAMKZrDoABN20rFjYisZy+VBK2vNghbgkVkiUs87179Pk9Kqr21u
         C4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774045620; x=1774650420;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZMf+n+2UaLqD15BKFxgwMFWBdH7VTMfFKDNbfbyD1E=;
        b=Hu3W1zXmCySATZu7/KDNQQKXhL8TVrG57166kUyO8JwuSftq3CJAVjQ9CoQAglIn73
         P6+nkhAuyS2leZBMMYhKtiES12NamCJM7cBfZUxPKa+Wb3+nOYXCg5M6J4fLa7iLilGr
         YHW9L57s1PoM8EBrijt14M1M7J+GXZrVMRbpUdmVigqE5WmsALc+Ho1wjzYX71xVeTfa
         JcjFEWWvCw2rjGCdBC0sBTTZEVy6zBI1069mMG3gRGOQVubyeF8mWjToY7AOS5WRAy9t
         /DAe40flMb9gFDaXNwYn3mJjJLhF0+/MwxNbk5tncLNW2pSCl1SFJArugoEWLlzqHj6h
         6NEw==
X-Forwarded-Encrypted: i=1; AJvYcCU0V+aKDAY4AY+6Cr0CD9JSpfYLYdMuwBG86KNMdGkybg7QTtHfCg5vq2b9vHvjgT1WHrpGDYMcq15EmQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzmRqksbzDp7mfuxNY9ED2+BVHpJSb2a7MgkYZKqLmQySh85Ypa
	9JHuPV/VPR+M8tduXZaokt5Soh4UKI4pevulpd2casV8CJyzjaWdJp9DsRVcQ91a4E8=
X-Gm-Gg: ATEYQzx/ckOGPt+iCX7KOwF780b8Ixi42UnpwgRQrRK0UlLlZR2TrdfWIp3tRfz6xmS
	bpquo+l8ySlPtgphfNkmGMz2l390/jpNbKHQ77L3dRbyoE8w0/jSQf44Bxc0XR34fP2WvTJcJvu
	CQNDzv+AgBfxZezGdj8SkGsYXAI6kVP76StkeBkiMWHUlVXBObmRVY9l5NHpaaG4CSahzaDgidS
	Br2Pc7fQ5NukXCNLVRRhZQd/uRzJMzwR841hxqSu5iF0VRscTf2Ygn13hynSajBhpFPGeD3Xhww
	SYuHJtiOpXLRNkWJCtHiVa4r48R8kbBGVxQh00EjE1+XSLzFVnO+sUihS6+OPeYr3mjvF2iX3jc
	e5UqtZBoFHgl5tCOovxLZANPVHy4mGq3QD7XDK6uN/82I3m0f8sxcBX7nLO/j346sZVYw7g6rlm
	swgryuySEJ9aKLU+VBcj3A38rn4rCauP9JBC05/Z42/ap+Rkt+h1A=
X-Received: by 2002:a05:600c:548e:b0:485:40c6:f51a with SMTP id 5b1f17b1804b1-486ff028ff2mr67823685e9.31.1774045619752;
        Fri, 20 Mar 2026 15:26:59 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b08352a17asm32327585ad.24.2026.03.20.15.26.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2026 15:26:58 -0700 (PDT)
Message-ID: <33164dbf-ab81-4611-ba1a-e6e187bfaf51@suse.com>
Date: Sat, 21 Mar 2026 08:56:52 +1030
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] btrfs: Fix BTRFS arm64 tagged KASAN false-positive
To: dsterba@suse.cz
Cc: Daniel J Blueman <daniel@quora.org>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260319053413.14771-1-daniel@quora.org>
 <4d6f78d3-f274-43e1-adc8-c4fff4f85e24@suse.com>
 <20260320220137.GI5735@twin.jikos.cz>
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
In-Reply-To: <20260320220137.GI5735@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2026/3/21 08:31, David Sterba 写道:
> On Thu, Mar 19, 2026 at 07:26:34PM +1030, Qu Wenruo wrote:
>>
>>
>> 在 2026/3/19 16:04, Daniel J Blueman 写道:
>>> When booting Linux 7.0-rc4 on a Qualcomm Snapdragon X1 with KASAN
>>> software tagging with a BTRFS filesystem, we see:
>>>
>>> BUG: KASAN: invalid-access in xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
>>> Read of size 8 at addr 7bff000804fe1000 by task kworker/u49:2/138
>>> Pointer tag: [7b], memory tag: [b2]
>>>
>>> CPU: 0 UID: 0 PID: 138 Comm: kworker/u49:2 Not tainted 7.0.0-rc4+ #34 PREEMPTLAZY
>>> Hardware name: LENOVO 83ED/LNVNB161216, BIOS NHCN60WW 09/11/2025
>>> Workqueue: btrfs-endio-meta simple_end_io_work
>>> Call trace:
>>> show_stack (arch/arm64/kernel/stacktrace.c:501) (C)
>>> dump_stack_lvl (lib/dump_stack.c:122)
>>> print_report (mm/kasan/report.c:379 mm/kasan/report.c:482)
>>> kasan_report (mm/kasan/report.c:597)
>>> kasan_check_range (mm/kasan/sw_tags.c:86 (discriminator 1))
>>> __hwasan_loadN_noabort (mm/kasan/sw_tags.c:158)
>>> xxh64_update (lib/xxhash.c:143 lib/xxhash.c:283)
>>> btrfs_csum_update (fs/btrfs/fs.c:106)
>>> csum_tree_block (fs/btrfs/disk-io.c:103 (discriminator 3))
>>> btrfs_validate_extent_buffer (fs/btrfs/disk-io.c:389)
>>> end_bbio_meta_read (fs/btrfs/extent_io.c:3853 (discriminator 1))
>>> btrfs_bio_end_io (fs/btrfs/bio.c:152)
>>> simple_end_io_work (fs/btrfs/bio.c:388)
>>> process_one_work (./arch/arm64/include/asm/jump_label.h:36 ./include/trace/events/workqueue.h:110 kernel/workqueue.c:3281)
>>> worker_thread (kernel/workqueue.c:3353 (discriminator 2) kernel/workqueue.c:3440 (discriminator 2))
>>> kthread (kernel/kthread.c:436)
>>> ret_from_fork (arch/arm64/kernel/entry.S:861)
>>>
>>> The buggy address belongs to the physical page:
>>> page: refcount:3 mapcount:0 mapping:f1ff00080055dee8 index:0x2467bd pfn:0x884fe1
>>> memcg:51ff000800e68ec0 aops:btree_aops ino:1
>>> flags: 0x9340000000004000(private|zone=2|kasantag=0x4d)
>>> raw: 9340000000004000 0000000000000000 dead000000000122 f1ff00080055dee8
>>> raw: 00000000002467bd 43ff00081d0cc6f0 00000003ffffffff 51ff000800e68ec0
>>> page dumped because: kasan: bad access detected
>>>
>>> Memory state around the buggy address:
>>> ffff000804fe0e00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
>>> ffff000804fe0f00: 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b 7b
>>>> ffff000804fe1000: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
>>> ^
>>> ffff000804fe1100: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
>>> ffff000804fe1200: b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2 b2
>>>
>>> This occurs as contiguous pages may have different KASAN tags in the upper address
>>> bits, leading to a tag mismatch if linear addressing is used.
>>>
>>> Fix this by treating them as discontiguous.
>>>
>>> Signed-off-by: Daniel J Blueman <daniel@quora.org>
>>> Fixes: 397239ed6a6c ("btrfs: allow extent buffer helpers to skip cross-page handling")
>>>
>>> ---
>>>    fs/btrfs/extent_io.c | 12 ++++++++++--
>>>    1 file changed, 10 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
>>> index 5f97a3d2a8d7..e2b241fb6c0e 100644
>>> --- a/fs/btrfs/extent_io.c
>>> +++ b/fs/btrfs/extent_io.c
>>> @@ -3517,8 +3517,16 @@ struct extent_buffer *alloc_extent_buffer(struct btrfs_fs_info *fs_info,
>>>    		 * At this stage, either we allocated a large folio, thus @i
>>>    		 * would only be 0, or we fall back to per-page allocation.
>>>    		 */
>>> -		if (i && folio_page(eb->folios[i - 1], 0) + 1 != folio_page(folio, 0))
>>> -			page_contig = false;
>>> +		if (i > 0) {
>>> +			struct page *prev = folio_page(eb->folios[i - 1], 0);
>>> +			struct page *curr = folio_page(folio, 0);
>>> +
>>> +			/*
>>> +			 * Contiguous pages may have different tags; can't be treated as contiguous
>>> +			 */
>>> +			if (curr != prev + 1 || page_kasan_tag(curr) != page_kasan_tag(prev))
>>> +				page_contig = false;
>>
>> I am not a fan of this solution.
>>
>> Although it doesn't affect end users who don't have KASAN soft tag
>> enabled, I don't get what we can really get from the different tags.
>>
>> I mean all those pages are already contig in physical addresses, why we
>> can not access the range in one go?
>>
>> Maybe it will be better to set all pages with the same random tag if
>> page_contig is true?
> 
> I don't know if there's an interface how to change the tags but adding
> one condition that enables a sanitizer to work on some platform does not
> sound like a terrible thing. The contiguous pages on our side is an
> optimization so it's a special case, I'd rather adapt to the sanitizers
> than to let people ignore a warning or have to read a warning that that
> one is harmless.

There is the interface, page_kasan_tag_set()/page_kasan_tag_reset(), and 
is already utilized inside MM.

And the deeper problem is, if this is a false alert, shouldn't we fix 
the sanitizer?

Especially in this case I didn't see any problem accessing properly 
allocated and physically adjacent pages.

If this is really a problem, I think a lot of bio accesses are also 
going to cause problems, as one bvec can have multiple physically 
adjacent pages, and if they have different tags then drivers copying a 
large bvec should lead to the same tag difference.


So to the reporter/KASAN people, what's the problem of accessing 
different tags in the first place?

Thanks,
Qu
