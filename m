Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBEB3644C8
	for <linux-btrfs@vger.kernel.org>; Fri, 27 Mar 2026 16:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774628583; cv=none; b=lFSSnzIll6r8wA7zAHkvubsC1mGy97kXsZUeFPM47ZtxCBZb1mnRJGhRzojDok6bW0oD7lnwBueNDgRK4TZIHF1YAnF08ltOhCwoAZCOYnQ+l6YOq/5yzNMUc/O5njnSfpC/cedE50JcpMRt5o5QMBuu2uzGJpTFAoAQ2fJNYSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774628583; c=relaxed/simple;
	bh=4bpcSqbcM3w+4aWSCfRx0NiNfCkr/R0BvW+nnOpdVgc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPGGu+8E0+tYWcrNFbnF3X7O6ZQN0+z2EskcUESsd/JJDb0FptqfygNniJkMH+iFa0rW9sbYl30R5awQ3XYX7oRRpWcIV/wMGzJBoO893UdCXiYMewKzozABhzK+/dLfZezkDQhv8E3TSMU5frWJRuArp/5A0kBp7xjhRM44GFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WDtTgSOv; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WDtTgSOv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774628579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4B7YUokdw8xne1NnZQBERMZXI1tXPocYgm0kwuMFEtk=;
	b=WDtTgSOvNTtyt1O/PB+qA0i21KrkkzR7bfWwWVL2HuyD5A2xKeM+vgM9ULjnATJq50kNI2
	aNTNaWN3R3jtcMRKZUPhDdng9FCVouhCjt9QVQjmhsmgFeA3xJe6L1ZVrjBEleulqda4Ve
	MpEV3MZFkUCnqzadTMVjZHbYawJ6kLo=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: baolin.wang@linux.alibaba.com,
	ljs@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Sat, 28 Mar 2026 00:22:52 +0800
Message-Id: <20260327162252.57553-1-lance.yang@linux.dev>
In-Reply-To: <6FCC0430-C98D-4D7C-8C53-F7722F1BDC4A@nvidia.com>
References: <6FCC0430-C98D-4D7C-8C53-F7722F1BDC4A@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Fri, Mar 27, 2026 at 11:00:26AM -0400, Zi Yan wrote:
>On 27 Mar 2026, at 10:31, Lorenzo Stoakes (Oracle) wrote:
>
>> On Fri, Mar 27, 2026 at 10:26:53PM +0800, Baolin Wang wrote:
>>>
>>>
>>> On 3/27/26 10:12 PM, Lorenzo Stoakes (Oracle) wrote:
>>>> On Fri, Mar 27, 2026 at 09:45:03PM +0800, Baolin Wang wrote:
>>>>>
>>>>>
>>>>> On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
>>>>>> On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>>>>>>>
>>>>>>>
>>>>>>> On 3/27/26 9:42 AM, Zi Yan wrote:
>>>>>>>> collapse_file() requires FSes supporting large folio with at least
>>>>>>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>>>>>>>> huge option turned on also sets large folio order on mapping, so the check
>>>>>>>> also applies to shmem.
>>>>>>>>
>>>>>>>> While at it, replace VM_BUG_ON with returning failure values.
>>>>>>>>
>>>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>>> ---
>>>>>>>>     mm/khugepaged.c | 7 +++++--
>>>>>>>>     1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>>>>> index d06d84219e1b..45b12ffb1550 100644
>>>>>>>> --- a/mm/khugepaged.c
>>>>>>>> +++ b/mm/khugepaged.c
>>>>>>>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>>>>>     	int nr_none = 0;
>>>>>>>>     	bool is_shmem = shmem_file(file);
>>>>>>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>>>>>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>>>>>>> +	/* "huge" shmem sets mapping folio order and passes the check below */
>>>>>>>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>> +		return SCAN_FAIL;
>>>>>>>
>>>>>>> This is not true for anonymous shmem, since its large order allocation logic
>>>>>>> is similar to anonymous memory. That means it will not call
>>>>>>> mapping_set_large_folios() for anonymous shmem.
>>>>>>>
>>>>>>> So I think the check should be:
>>>>>>>
>>>>>>> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>>>>        return SCAN_FAIL;
>>>>>>
>>>>>> Hmm but in shmem_init() we have:
>>>>>>
>>>>>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>>> 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>>>>> 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>>>>>> 	else
>>>>>> 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
>>>>>>
>>>>>> 	/*
>>>>>> 	 * Default to setting PMD-sized THP to inherit the global setting and
>>>>>> 	 * disable all other multi-size THPs.
>>>>>> 	 */
>>>>>> 	if (!shmem_orders_configured)
>>>>>> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>>>>>> #endif
>>>>>>
>>>>>> And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
>>>>>> shmem_enabled_store() updates that if necessary.
>>>>>>
>>>>>> So we're still fine right?
>>>>>>
>>>>>> __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
>>>>>> __shmem_get_inode() which has:
>>>>>>
>>>>>> 	if (sbinfo->huge)
>>>>>> 		mapping_set_large_folios(inode->i_mapping);
>>>>>>
>>>>>> Shared for both anon shmem and tmpfs-style shmem.
>>>>>>
>>>>>> So I think it's fine as-is.
>>>>>
>>>>> I'm afraid not. Sorry, I should have been clearer.
>>>>>
>>>>> First, anonymous shmem large order allocation is dynamically controlled via
>>>>> the global interface (/sys/kernel/mm/transparent_hugepage/shmem_enabled) and
>>>>> the mTHP interfaces
>>>>> (/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).
>>>>>
>>>>> This means that during anonymous shmem initialization, these interfaces
>>>>> might be set to 'never'. so it will not call mapping_set_large_folios()
>>>>> because sbinfo->huge is 'SHMEM_HUGE_NEVER'.
>>>>>
>>>>> Even if shmem large order allocation is subsequently enabled via the
>>>>> interfaces, __shmem_file_setup -> mapping_set_large_folios() is not called
>>>>> again.
>>>>
>>>> I see your point, oh this is all a bit of a mess...
>>>>
>>>> It feels like entirely the wrong abstraction anyway, since at best you're
>>>> getting a global 'is enabled'.
>>>>
>>>> I guess what happened before was we'd never call into this with ! r/o thp for fs
>>>> && ! is_shmem.
>>>
>>> Right.
>>>
>>>> But now we are allowing it, but should STILL be gating on !is_shmem so yeah your
>>>> suggestion is correct I think actualyl.
>>>>
>>>> I do hate:
>>>>
>>>> 	if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>>>
>>>> As a bit of code though. It's horrible.
>>>
>>> Indeed.
>>>
>>>> Let's abstract that...
>>>>
>>>> It'd be nice if we could find a way to clean things up in the lead up to changes
>>>> in series like this instead of sticking with the mess, but I guess since it
>>>> mostly removes stuff that's ok for now.
>>>
>>> I think this check can be removed from this patch.
>>>
>>> During the khugepaged's scan, it will call thp_vma_allowable_order() to
>>> check if the VMA is allowed to collapse into a PMD.
>>>
>>> Specifically, within the call chain thp_vma_allowable_order() ->
>>> __thp_vma_allowable_orders(), shmem is checked via
>>> shmem_allowable_huge_orders(), while other FSes are checked via
>>> file_thp_enabled().
>
>But for madvise(MADV_COLLAPSE) case, IIRC, it ignores shmem huge config
>and can perform collapse anyway. This means without !is_shmem the check
>will break madvise(MADV_COLLAPSE). Let me know if I get it wrong, since

Right. That will break MADV_COLLAPSE, IIUC.

For MADV_COLLAPSE on anonymous shmem, eligibility is determined by the
TVA_FORCED_COLLAPSE path via shmem_allowable_huge_orders(), not by
whether the inode mapping got mapping_set_large_folios() at creation
time.

Using mmap(MAP_SHARED | MAP_ANONYMOUS):
- create time: shmem_enabled=never, hugepages-2048kB/shmem_enabled=never
- collapse time: shmem_enabled=never, hugepages-2048kB/shmem_enabled=always

With the !is_shmem guard, collapse succeeds. Without it, the same setup
fails with -EINVAL.

Thanks,
Lance

>I was in that TVA_FORCED_COLLAPSE email thread but does not remember
>everything there.
>
>
>>
>> It sucks not to have an assert. Maybe in that case make it a
>> VM_WARN_ON_ONCE().
>
>Will do that as I replied to David already.
>
>>
>> I hate that you're left tracing things back like that...
>>
>>>
>>> For those other filesystems, Patch 5 has already added the following check,
>>> which I think is sufficient to filter out those FSes that do not support
>>> large folios:
>>>
>>> if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
>>> 	return false;
>>
>> 2 < 5, we won't tolerate bisection hazards.
>>
>>>
>>>
>>>>> Anonymous shmem behaves similarly to anonymous pages: it is controlled by
>>>>> the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() to
>>>>> check for allowed large orders, rather than relying on
>>>>> mapping_max_folio_order().
>>>>>
>>>>> The mapping_max_folio_order() is intended to control large page allocation
>>>>> only for tmpfs mounts. Therefore, I find the current code confusing and
>>>>> think it needs to be fixed:
>>>>>
>>>>> /* Don't consider 'deny' for emergencies and 'force' for testing */
>>>>> if (sb != shm_mnt->mnt_sb && sbinfo->huge)
>>>>>         mapping_set_large_folios(inode->i_mapping);
>>>>
>
>Hi Baolin,
>
>Do you want to send a fix for this?
>
>Also I wonder how I can distinguish between anonymous shmem code and tmpfs code.
>I thought they are the same thing except that they have different user interface,
>but it seems that I was wrong.
>
>
>Best Regards,
>Yan, Zi
>
>
