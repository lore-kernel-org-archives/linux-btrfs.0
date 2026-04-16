Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F4D277C9E;
	Thu, 16 Apr 2026 08:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776329238; cv=none; b=lpdYerP9MKPzF8Sy8ApuISup0GdV78OMKjNXr1MPrNg74ySbo5EIbWfNn6I3bGu3BJSqbPTcbvxU87zwIwr6+64STWVKKBKzfNNSqrm6UnChv1te5sbTDq/KLaCzpjIkkUgiFS7H71Z8cnIfXfjJXBl/d3FR2e2Cp2Cp3z9LCw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776329238; c=relaxed/simple;
	bh=ljHxmoprfBQIb7mZOQd9Nqr851XmhOqAdzFFK3AVVB8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sqpZMslEXaaMIgtWhHZpdr1rsd/5lLulY7sPci+sxpwh3dlcRYGqgcPdOFvkFDsquHlZJ1sLioiIWu4fHSD3GzRObRz1TnBb30WmnaBGM6QxkuKhXn/b+DzGMPxwtt+cNJqVJIHuWX7KxOs+yAVOP8V4hjv9fmKGi6JoZghvW6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OoR+cLLp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OoR+cLLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236FFC2BCAF;
	Thu, 16 Apr 2026 08:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776329238;
	bh=ljHxmoprfBQIb7mZOQd9Nqr851XmhOqAdzFFK3AVVB8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OoR+cLLpx1ccGF8jHeCIEO2WG0KmtE7gfcMfcszVO2ap0qzWDPGRaOzUF7ry7egHn
	 Nu9ZzjXLV5ep+/DQ7VRURFa0r6t8qXmr40PjYDKsdFcleR6S/Ws4j8UptbKPH5c/LW
	 0l8bRYlXgZwLbncZ6FZfDX68tvs5tolPPvGxWyDo/5ZXO4HwtpyxV6IJnaVQAzyp7t
	 oSlic8y4ay5jx+bjaoa1wnGln8rP/e65WEuRERPVXkvOmYR1CPz1S/A+aDNjjQSjSK
	 8SqmC7DUl0w+XbDv78koqFD+ifY5f3Jy01Lz75H0f4/BYDTPM6tdVmlnL7t90HCPbS
	 A1NUFh4DOZF/w==
Message-ID: <8d95a9ad-4c85-4b8e-8724-af843e1b7859@kernel.org>
Date: Thu, 16 Apr 2026 10:47:05 +0200
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
 <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
 <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
 <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/15/26 20:01, Zi Yan wrote:
> On 15 Apr 2026, at 5:21, Baolin Wang wrote:
> 
>> On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
>>
>> My comments are in reply to Zi’s comment:
>>
>> "I think hugepage_global_enabled() should be enough to decide whether khugepaged should run or not. "
>>
>> I’m concerned that only relying on hugepage_global_enabled() to decide whether khugepaged should run would cause a regression for anonymous and shmem memory collapse, as it ignores per-size mTHP configuration.
>>
>>> The question is really which semantics we want.
>>>
>>> Right now, there is no way to disable khugepaged for anon pages, to just
>>> get them during page faults.
>>
>> Right.
>>
>>> And we are now talking about the same problem for FS: to only get them
>>> during page faults (like we did so far without CONFIG_READ_ONLY_THP_FOR_FS).
>>
>> OK. I’m fine with using hugepage_global_enabled() to determine whether khugepaged scans file folios.
>>
>> My concern is that for anonymous memory and shmem, the per-size mTHP settings should be considered.
> 
> OK, I misunderstood the meaning of hugepage_global_enabled(), since per-size
> mTHP settings could also enable khugepaged if PMD_SIZE is set.
> 
> I will take willy’s original suggestion and make khugepaged on if the global
> setting is enabled. The below is the new version of this patch. I moved anon
> pmd huge page code to a separate anon_hpage_pmd_enabled() like
> shmem_hpage_pmd_enabled() and cleaned up the comment. Let me know your thoughts.
> 
> Thanks.
> 
> From 92b92f2b2ab41c70b41dd304ce648786ee6a1603 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 15 Apr 2026 13:52:50 -0400
> Subject: [PATCH] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
>  hugepage_pmd_enabled()
> 
> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
> hugepages are enabled by the global transparent hugepage control.
> khugepaged can still be enabled by per-size control for anon and shmem when
> the global control is off.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/khugepaged.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..586d27ce896e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
> 
> -static bool hugepage_pmd_enabled(void)
> +static inline bool anon_hpage_pmd_enabled()
>  {
> -	/*
> -	 * We cover the anon, shmem and the file-backed case here; file-backed
> -	 * hugepages, when configured in, are determined by the global control.
> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> -	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> -	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> -	 */
> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
> -	    hugepage_global_enabled())
> -		return true;
>  	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>  		return true;
>  	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> @@ -425,6 +415,20 @@ static bool hugepage_pmd_enabled(void)
>  	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>  	    hugepage_global_enabled())
>  		return true;
> +	return false;
> +}
> +

Works for me.

> +static bool hugepage_pmd_enabled(void)
> +{
> +	/*
> +	 * Anon, shmem and file-backed pmd-sized hugepages are all determined by
> +	 * the global control. If the global control is off, anon and shmem
> +	 * pmd-sized hugepages are also determined by its per-size control.
> +	 */
> +	if (hugepage_global_enabled())
> +		return true;
> +	if (anon_hpage_pmd_enabled())
> +		return true;
>  	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())

BTW, can we please provide a stub for shmem_hpage_pmd_enabled() in
shmem_fs.h such that we can remove the IS_ENABLED here?

-- 
Cheers,

David
