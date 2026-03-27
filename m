Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD87B221FDE;
	Fri, 27 Mar 2026 13:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774619113; cv=none; b=iut5/SD5Qw8jkvXtz0o09FRLXdHezSHo2Y6HgJQO8ES6+pRSmXf2jMcuK7k//zKjU41c9CgtyfwakO3Y6fgnxOiVHn0yEPzZ5ZB7n7At4W3yNzIiCGqJiadf/y9x19LMjUDfchHWjvF8nF1S2agEz1K3iiParxPJp/xkjrls2+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774619113; c=relaxed/simple;
	bh=dQ5yeCu+XRggWfYvMHL3f4uBspLzLrnyG1E50eBFPfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KLGRuD0NEUfNPEuxAdz9GdlZD5VPtWu6T8nK3uQb1FJ/CZdJ72i9zwI2jc/LCBRGQZtzM0hgP+TixJyFaAjwU1YXrLKe0k+9z9ZoG2DeR0/rmbG4HiONLS/uw2JkAAeLibLy+8QieIo75P7AZce5/RMtndwbYEqsPySewTnv9wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=R1VVK0Og; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="R1VVK0Og"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774619106; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DbLmVGzsI4+uNyjVzgEOD2NfpFFBuqWmyl7ZIzmxZec=;
	b=R1VVK0Og6Aga5K/4z682Re7Zwz8CLs8wR26E0l/v3vjxTH8hCADUEPzEWcCPEc77fty+Ja+2ouCqkOq+ybYlMtx36qU6+RuEjCuyUaZaGWSAJZ+jNamS78qOUr8Zjd3cCm/a0ZHcwy0rvkBD59cKcKHfaC5QyOpgxSaSqfTFjeY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X.oRvWO_1774619103;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.oRvWO_1774619103 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 21:45:04 +0800
Message-ID: <ec927492-4577-4192-8fad-85eb1bb43121@linux.alibaba.com>
Date: Fri, 27 Mar 2026 21:45:03 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
 <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
 <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8f5119a1-9aa9-4a39-ac94-ca1631db26e1@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/27/26 8:02 PM, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 27, 2026 at 05:44:49PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/27/26 9:42 AM, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
>>> huge option turned on also sets large folio order on mapping, so the check
>>> also applies to shmem.
>>>
>>> While at it, replace VM_BUG_ON with returning failure values.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    mm/khugepaged.c | 7 +++++--
>>>    1 file changed, 5 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index d06d84219e1b..45b12ffb1550 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>    	int nr_none = 0;
>>>    	bool is_shmem = shmem_file(file);
>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>> +	/* "huge" shmem sets mapping folio order and passes the check below */
>>> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
>>> +		return SCAN_FAIL;
>>
>> This is not true for anonymous shmem, since its large order allocation logic
>> is similar to anonymous memory. That means it will not call
>> mapping_set_large_folios() for anonymous shmem.
>>
>> So I think the check should be:
>>
>> if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
>>       return SCAN_FAIL;
> 
> Hmm but in shmem_init() we have:
> 
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> 	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
> 	else
> 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
> 
> 	/*
> 	 * Default to setting PMD-sized THP to inherit the global setting and
> 	 * disable all other multi-size THPs.
> 	 */
> 	if (!shmem_orders_configured)
> 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
> #endif
> 
> And shm_mnt->mnt_sb is the superblock used for anon shmem. Also
> shmem_enabled_store() updates that if necessary.
> 
> So we're still fine right?
> 
> __shmem_file_setup() (used for anon shmem) calls shmem_get_inode() ->
> __shmem_get_inode() which has:
> 
> 	if (sbinfo->huge)
> 		mapping_set_large_folios(inode->i_mapping);
> 
> Shared for both anon shmem and tmpfs-style shmem.
> 
> So I think it's fine as-is.

I'm afraid not. Sorry, I should have been clearer.

First, anonymous shmem large order allocation is dynamically controlled 
via the global interface 
(/sys/kernel/mm/transparent_hugepage/shmem_enabled) and the mTHP 
interfaces 
(/sys/kernel/mm/transparent_hugepage/hugepages-*kB/shmem_enabled).

This means that during anonymous shmem initialization, these interfaces 
might be set to 'never'. so it will not call mapping_set_large_folios() 
because sbinfo->huge is 'SHMEM_HUGE_NEVER'.

Even if shmem large order allocation is subsequently enabled via the 
interfaces, __shmem_file_setup -> mapping_set_large_folios() is not 
called again.

Anonymous shmem behaves similarly to anonymous pages: it is controlled 
by the 'shmem_enabled' interfaces and uses shmem_allowable_huge_orders() 
to check for allowed large orders, rather than relying on 
mapping_max_folio_order().

The mapping_max_folio_order() is intended to control large page 
allocation only for tmpfs mounts. Therefore, I find the current code 
confusing and think it needs to be fixed:

/* Don't consider 'deny' for emergencies and 'force' for testing */
if (sb != shm_mnt->mnt_sb && sbinfo->huge)
        mapping_set_large_folios(inode->i_mapping);
