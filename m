Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEE81D7E41;
	Tue, 21 Apr 2026 02:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.111
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776737591; cv=none; b=C3W4jNm8WDB1XM9qiRvn0yEldoquLBypOh/a8a4Hl+vJbNbayVKJ3h5y4hu94beuKftwPtmwD37V5CdP3fvOSP2zvi56lp3UEm2M5PzfWP6d6G27qdM8snjV3eCCItIOmyfQCNThzd6qIjUouQ2BRToXpFRK5545vtnfaani4Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776737591; c=relaxed/simple;
	bh=g6PNdNEfS2mYEysdHv5nrnFZGx9/WN9a3gjeMLIlvYw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T3zkBiHXeWct4JHGizyvzdpAFthHbJ/mhZVxfmO932moYmluZEs0xgyHt4DC1MFLCfURukBZPnzfx2i6fVp2/xJyBcTMEfivtkD0lKj5dYYeEex7I7mqqgUcWTv90/vwxWz9CAC7vbjLrPPMu+9tKYXZaq2bOegqdvH3b/vZJDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=KCsRuJmV; arc=none smtp.client-ip=115.124.30.111
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="KCsRuJmV"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776737579; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hA0i3udkMiNuPIN+N6Va5cEC1S96vQmqUF4aWxz/iKc=;
	b=KCsRuJmVJUe55QV3bR5cJze3j3GvAJjqaw1n+kTop9PzbxDMDP2iI/NaE9sWxsmz7S+ZYG1dCbIoJ8gSBsyAErGu+el3Ah3IJmJ8iJBjBSlPhVzm0OkngbfV9rIdII75C76mHjFSFjUkm8XrGODTfKyb/l0d1yf7Sk1sICjtfL8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1RNv9w_1776737575;
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1RNv9w_1776737575 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 21 Apr 2026 10:12:56 +0800
Message-ID: <2c88f810-5c5c-4c26-af34-49e90ca2ba93@linux.alibaba.com>
Date: Tue, 21 Apr 2026 10:12:55 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 04/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
To: Zi Yan <ziy@nvidia.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-5-ziy@nvidia.com>
 <b228baf2-0dcd-4135-bab9-04d979b6e617@linux.alibaba.com>
 <E7EBC528-C511-4166-89F3-654171383646@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <E7EBC528-C511-4166-89F3-654171383646@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/20/26 10:57 PM, Zi Yan wrote:
> On 20 Apr 2026, at 2:55, Baolin Wang wrote:
> 
>> On 4/18/26 10:44 AM, Zi Yan wrote:
>>> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
>>> hugepages are enabled by the global transparent hugepage control.
>>> khugepaged can still be enabled by per-size control for anon and shmem when
>>> the global control is off.
>>>
>>> Add shmem_hpage_pmd_enabled() stub for !CONFIG_SHMEM to remove
>>> IS_ENABLED(SHMEM) in hugepage_pmd_enabled().
>>>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    include/linux/shmem_fs.h |  2 +-
>>>    mm/khugepaged.c          | 28 ++++++++++++++++------------
>>>    2 files changed, 17 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
>>> index 1a345142af7d..dff8fb6ddac0 100644
>>> --- a/include/linux/shmem_fs.h
>>> +++ b/include/linux/shmem_fs.h
>>> @@ -127,7 +127,7 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>    void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end);
>>>    int shmem_unuse(unsigned int type);
>>>   -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> +#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && defined(CONFIG_SHMEM)
>>>    unsigned long shmem_allowable_huge_orders(struct inode *inode,
>>>    				struct vm_area_struct *vma, pgoff_t index,
>>>    				loff_t write_end, bool shmem_huge_force);
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 1c0fdc81d276..718a2d06d1e6 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>>>    		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>>    }
>>>   -static bool hugepage_pmd_enabled(void)
>>> +static inline bool anon_hpage_pmd_enabled(void)
>>>    {
>>> -	/*
>>> -	 * We cover the anon, shmem and the file-backed case here; file-backed
>>> -	 * hugepages, when configured in, are determined by the global control.
>>> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>>> -	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
>>> -	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>>> -	 */
>>> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>>> -	    hugepage_global_enabled())
>>> -		return true;
>>>    	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>>>    		return true;
>>>    	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>>> @@ -425,7 +415,21 @@ static bool hugepage_pmd_enabled(void)
>>>    	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>>>    	    hugepage_global_enabled())
>>>    		return true;
>>> -	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>>> +	return false;
>>> +}
>>> +
>>> +static bool hugepage_pmd_enabled(void)
>>> +{
>>> +	/*
>>> +	 * Anon, shmem and file-backed pmd-size hugepages are all determined by
>>> +	 * the global control. If the global control is off, anon and shmem
>>> +	 * pmd-sized hugepages are also determined by its per-size control.
>>> +	 */
>>
>> Personally, I found the previous comments clearer to me. The statement "Anon, shmem pmd-size hugepages are all determined by the global control" seems somewhat confusing. For example, if hugepage_global_enabled() returns true but the pmd-sized sub-control is set to 'never', that means anon pmd-size hugepages are not allowed.
> 
> You are right.
> 
> I will revert back to the old comment without “when configured in” like below.
> 
> 	/*
> 	 * We cover the anon, shmem and the file-backed case here; file-backed
> 	 * hugepages are determined by the global control.
> 	 * Anon pmd-sized hugepages are determined by the pmd-size control.
> 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
> 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
> 	 */

Thanks. With that, feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
