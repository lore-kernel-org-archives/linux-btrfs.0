Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5B01A76BB;
	Thu, 16 Apr 2026 00:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776300591; cv=none; b=BPX/w9U6deVo7sRv2FsFztOwx0DOGioqastpKzdU2MT8Vp3aCW56ujTYrgYMK228hHBWRDO03Uxq4+Sc6LX6+0ezbqzo5Qnd1uWC9R8jU96CngwZw9SrSvDrQ6F7t6e23VJnGajM21hbBqx7i50LCA2H0eCjfCqaVx8Hjxrt6mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776300591; c=relaxed/simple;
	bh=nZyawi2/LGtC+zwcrr+zobVZrUuRPtZ6WF3mypXUwqM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FnrDkWXB9zxTxOi2cWeXd9ily1bUGMNFRcK0ZwEbivO9qbNeAyzlgKn/ZonyST2mWieVb3sjBn95848aohUzPxQADYyPmwpYfV6hhb7nckdDPMT6hlTN3gGkJwuv+Cku3M89zPDpEix+F8P4aEk8d2ZrdmWQAtHaNJ2J1j2Fyq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=u9pGVu4t; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="u9pGVu4t"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776300579; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=wMDkB3M6DeO+x7rz8eUh1YbTs7caB4nDxuzSIvsHJSU=;
	b=u9pGVu4tz8YOXUv3jDJZ3zVJKNxRdw2KuZbfxjR7TnjS2akLiVuCym9ba4rciE8lD1NsfCkJT8tMwP8PNBWrCif4kbRmkkJJS/ZQtNaS1axQl7NY+L4sAkRWgHF/PV1nhww3rmt4AxNoH1wHc5M7pO7AaT+L+pb2hKlOfLtIOgs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1680nn_1776300576;
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1680nn_1776300576 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Apr 2026 08:49:37 +0800
Message-ID: <9c6e376e-1a91-4aaa-9918-ca161fe57130@linux.alibaba.com>
Date: Thu, 16 Apr 2026 08:49:36 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/16/26 2:01 AM, Zi Yan wrote:
> On 15 Apr 2026, at 5:21, Baolin Wang wrote:
> 
>> On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
>>> On 4/15/26 08:36, Baolin Wang wrote:
>>>>
>>>>
>>>> On 4/15/26 2:25 AM, Zi Yan wrote:
>>>>> On 14 Apr 2026, at 14:14, David Hildenbrand (Arm) wrote:
>>>>>
>>>>>>
>>>>>> Yeah, it would be better if we could avoid it. But the dependency on the
>>>>>> global toggle as it is today is a bit weird.
>>>>>>
>>>>>>
>>>>>> I don't think there is other interaction with FS and the global toggle
>>>>>> besides this and the one you are adjusting, right?
>>>>>>
>>>>
>>>> I'm afraid not. Please also consider the per-size mTHP interfaces. It's
>>>> possible that hugepage_global_enabled() returns false, but
>>>> hugepages-2048kB/enabled is set to "always", which would still allow
>>>> khugepaged to collapse folios.
>>
>> My comments are in reply to Zi’s comment:
>>
>> "I think hugepage_global_enabled() should be enough to decide whether khugepaged should run or not."
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
>  From 92b92f2b2ab41c70b41dd304ce648786ee6a1603 Mon Sep 17 00:00:00 2001
> From: Zi Yan <ziy@nvidia.com>
> Date: Wed, 15 Apr 2026 13:52:50 -0400
> Subject: [PATCH] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
>   hugepage_pmd_enabled()
> 
> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
> hugepages are enabled by the global transparent hugepage control.
> khugepaged can still be enabled by per-size control for anon and shmem when
> the global control is off.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/khugepaged.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b8452dbdb043..586d27ce896e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>   		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>   }
> 
> -static bool hugepage_pmd_enabled(void)
> +static inline bool anon_hpage_pmd_enabled()
>   {
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
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>   		return true;
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> @@ -425,6 +415,20 @@ static bool hugepage_pmd_enabled(void)
>   	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>   	    hugepage_global_enabled())
>   		return true;
> +	return false;
> +}
> +
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
>   	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>   		return true;
>   	return false;

Thanks. Looks reasonable to me. Let’s also see what David thinks.
