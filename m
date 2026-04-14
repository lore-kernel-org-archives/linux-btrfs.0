Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE393E6396
	for <linux-btrfs@vger.kernel.org>; Tue, 14 Apr 2026 15:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776181418; cv=none; b=NL8sXqHx9xdYC7MN2BIddnAh0NNfMQxvWAKZVAbq7H0C/qhg5Rv3bGS2a0ww3JLlAsSqjR85Tqs2AnlGV8A9/fW+41lDGWeOpa5xQH0r+bQASN0peRxrCwLiYQjuA1HmHV4YISp9ULhwt4t8I1uxlpakBpUfqkYhQ45x9iMKGwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776181418; c=relaxed/simple;
	bh=hZDJpf0SiekVMU9h5Mt5tAfgMY1esUFBXHQ1y03LU4s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bjs+8EMMBCL52NY7hkxGFbCF7kK6hXb5MNJSOPD402IZNRizN8iHVVX/NkcRtg4sIb29jRdKAUOqerg9SFgMnkRSpxZ3+ABpl5Zg6aG6o7bSOZ1UsO0rF1vRLnz5HNufeXDl/rdQzYLBDEBijrHcPQMMQqB0Gj+vSaBEd438ZjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a+Zoy3/H; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a+Zoy3/H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776181404;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xofRIGZTZWakFR4r7hnHb6VQphFQ4wt9gOLnTsomTno=;
	b=a+Zoy3/HP0If3I2KC+z/xy+o4Zd3PZ4Kc0jqpMBHxJwT2FNA1df/rmFfyx81rcasSH+5Hv
	3D8TW/roWmTFaZKQaN7FwnaCG0eCBFeUrBT5hmsEqIkTCywMek5EgN3BWqJqRa7+KXE8dh
	ISMIBMFQ06zz7nJpwbC5FH7qif4qJk0=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com,
	david@kernel.org
Cc: willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
Date: Tue, 14 Apr 2026 23:43:16 +0800
Message-Id: <20260414154316.42935-1-lance.yang@linux.dev>
In-Reply-To: <20260414153724.35950-1-lance.yang@linux.dev>
References: <20260414153724.35950-1-lance.yang@linux.dev>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On Tue, Apr 14, 2026 at 11:37:24PM +0800, Lance Yang wrote:
>
>On Tue, Apr 14, 2026 at 12:29:04PM +0200, David Hildenbrand (Arm) wrote:
>>On 4/13/26 21:20, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>> 
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>> 
>>> In collapse_scan_file(), add FS eligibility check to avoid redundant scans.
>>> 
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  mm/khugepaged.c | 12 ++++++++++--
>>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index b8452dbdb043..d2f0acd2dac2 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -1892,8 +1892,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>  	int nr_none = 0;
>>>  	bool is_shmem = shmem_file(file);
>>>  
>>> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
>>> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
>>> +	/* MADV_COLLAPSE ignores shmem huge config, so do not check shmem */
>>> +	VM_WARN_ON_ONCE(!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER);
>>> +	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
>>>  
>>>  	result = alloc_charge_folio(&new_folio, mm, cc);
>>>  	if (result != SCAN_SUCCEED)
>>> @@ -2321,6 +2322,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>>>  	int node = NUMA_NO_NODE;
>>>  	enum scan_result result = SCAN_SUCCEED;
>>>  
>>> +	/*
>>> +	 * skip files without PMD-order folio support
>>> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
>>> +	 */
>>
>>How is the !collapse path handled? Through thp_vma_allowable_order() in
>>collapse_scan_mm_slot()?
>>
>>Wouldn't it be better to have that check exactly there?
>
>Right! Looks like patch #03[1] already does that, as David also pointed
>out there :)
>
>With that in place, regular files should end up in file_thp_enabled(),
>which checks that mapping_max_folio_order() >= PMD_ORDER.

Forgot to add:

thp_vma_allowable_order()
	-> file_thp_enabled()
	-> mapping_max_folio_order() check

>For khugepaged, collapse_scan_mm_slot() calls thp_vma_allowable_order()
>before entering the per-PMD scan loop, so ineligible regular file VMAs
>should already get filtered there.
>
>madvise_collapse() also calls thp_vma_allowable_order() early, so it
>should get the same filtering before reaching collapse_scan_file().
>
>So the extra check here looks redundant :)
>
>[1] https://lore.kernel.org/linux-mm/20260413192030.3275825-4-ziy@nvidia.com/
>
>Cheers,
>Lance
>
