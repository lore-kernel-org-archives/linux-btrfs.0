Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D5621638D
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 04:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776919682; cv=none; b=c7b2YK5VxvTzxZXnGjo86JLovSBGLOT/KKCzl32AOx7hIvrOgmY/MwOrZjt/nsogLsl3I6g4rqMW9rXUa8bHsorSMwD6zxOSqorZ/JzP/5nhoe/vAG4sE1k3NpLmgPTokOPh4dcCr+TiRpYgSggpmqRJopJj8tMq9fLyZ56uLxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776919682; c=relaxed/simple;
	bh=rv++CDO3/N6wprt/C2IZzwTSdIEqADbSlhN+/tasXIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BfoJbyiQMWfZsBQtlmlm4nZb/798sywippY4ecWscruyJ1pB8HoelB7OqSpQm3HKy3+wBuxRPIl78Q1jhumxYFF++Wo0iw2lCEvp70lMWLC7SW1amj9I1+WuvFIM7p7vsBsMkCbH6aWvnWYsbyWhQ1h5n0t+9Yj219F5mViMm7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pSwKFVPk; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pSwKFVPk"
Message-ID: <268e0f1e-8575-4ee1-8a0c-48e1b9ae05f0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776919676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F2ZOLwoMzsrbZBwQV+NdexL8zdWBG0VIOfAx2UN7NiM=;
	b=pSwKFVPk3ujuY4dTQoLRLMcsH014KXuXyCtwbvn5BpAjl2tog1AzPpF6zi5PKQRYU+4s54
	DcR7ZoY7F9/0nR2yK2QwOs9aKQaduL6/xrtsJdILfC6i+J7TBDgLWAKIpxiidWUUC/kA4E
	MB+UB0RZF7aHqNLieJzBgCKgNazv8gg=
Date: Thu, 23 Apr 2026 12:47:39 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 7.2 v3 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: willy@infradead.org, songliubraving@fb.com, clm@fb.com, dsterba@suse.com,
 viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-2-ziy@nvidia.com>
 <20260423024324.51588-1-lance.yang@linux.dev>
 <20BA865A-1B69-48DA-BE12-9BFC6EA5A4CE@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20BA865A-1B69-48DA-BE12-9BFC6EA5A4CE@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT



On 2026/4/23 10:51, Zi Yan wrote:
> On 22 Apr 2026, at 22:43, Lance Yang wrote:
> 
>> On Fri, Apr 17, 2026 at 10:44:18PM -0400, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>>
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>>
>>> Add a helper function mapping_pmd_thp_support() for FSes supporting large
>>> folio with at least PMD_ORDER.
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>> include/linux/pagemap.h | 10 ++++++++++
>>> mm/khugepaged.c         |  5 +++--
>>> 2 files changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
>>> index ec442af3f886..c3cb1ec982cd 100644
>>> --- a/include/linux/pagemap.h
>>> +++ b/include/linux/pagemap.h
>>> @@ -524,6 +524,16 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>>> 	return mapping_max_folio_order(mapping) > 0;
>>> }
>>>
>>> +static inline bool mapping_pmd_thp_support(const struct address_space *mapping)
>>> +{
>>> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
>>> +	VM_WARN_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON,
>>> +			"Anonymous mapping always supports PMD THP");
>>
>> Nit: afraid not, at least when running on architectures without PMD leaf
>> entries ...
>>
>> Maybe better to say this helper is only meaningful for pagecache-backed
>> mappings. Anonymous mappings should not reach here.
> 
> Good suggestion. Will fix it.
> 
>>
>>> +
>>> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;
>>> +}
>>> +
>>> +
>>> /* Return the maximum folio size for this pagecache mapping, in bytes. */
>>> static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>>> {
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index b8452dbdb043..3eb5d982d3d3 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>> 	int nr_none = 0;
>>> 	bool is_shmem = shmem_file(file);
>>>
>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>>> +	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_thp_support(mapping));
>>
>> With [1], can we drop !is_shmem here as well? shmem would then always
>> call mapping_set_large_folios(inode->i_mapping):
>>
>> ---8<---
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 4ecefe02881d..dafbea53b22d 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -3087,10 +3087,7 @@ static struct inode *__shmem_get_inode(struct mnt_idmap *idmap,
>>   	cache_no_acl(inode);
>>   	if (sbinfo->noswap)
>>   		mapping_set_unevictable(inode->i_mapping);
>> -
>> -	/* Don't consider 'deny' for emergencies and 'force' for testing */
>> -	if (sbinfo->huge)
>> -		mapping_set_large_folios(inode->i_mapping);
>> +	mapping_set_large_folios(inode->i_mapping);
>>
>>   	switch (mode & S_IFMT) {
>>   	default:
>> --
>>
>> But we can do that in a follow-up, once the revert lands :)
> 
> Right. That would make this patchset depend on Baolin’s fix. A follow-up
> patch is easier for managing these patches. I will add a TODO in the
> comment, so that we will not forget. Thank you for the suggestion.

OK. With the changes above,

Reviewed-by: Lance Yang <lance.yang@linux.dev>
