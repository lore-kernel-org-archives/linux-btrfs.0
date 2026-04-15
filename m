Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257CD2C11DF;
	Wed, 15 Apr 2026 06:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776233367; cv=none; b=Y4v58c+UBXeJcSjJcySIk+K+idpAseiaFpM/PDq5ZT19fUHyB5374sizGOzjRcKaPbCCq2V3UYqbKkq3aR9XwN+FtphFmYjWzntjeraq3KrXzV3ABrXf4C9UPZ+rd1g6s2G+2ux54OavrhEu/y9T1+ttbuDhyptbUTXPjZH7lkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776233367; c=relaxed/simple;
	bh=+9A6xNRJnb25icKZPPc6CntcWptZjxHF25hiKgnXWVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=szaoYfNaghjPjK6/rrqPyyiibIenUsjUAGkwHI6l8u8LmAdm6egg95rtBApf/+Wvsf++mMFWV813g2pZMTTyc2jIjv9pLwrfQ1jotVlSnnAZlyh0rsptS8uOtaPEa2WxkTyAhTg2ZbcVGFq7BIeBDXj7VIQ1n+2dxzL3b+rp6Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=HilZ6w55; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="HilZ6w55"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776233362; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=dyJinyTSq4T8BSAk1UnNAy+5mkfCDxihn06xcyJlkGg=;
	b=HilZ6w55QxL2Biei6bZE0JtqGYeELuVQIlC9WQbpZ0ox0Dg89pWxS7NyDwxN7JIMoZmFYDn0e0hBIAdwzeFHzgza0ZmZQd0ai95lqCqbUZisPE137jn1ZRaI7yGlAzqCmD+qg+hzDVG1Zx3lEg6iaytUXwOl7mhsruB5+hWg6eg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R401e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13bA.g_1776233358;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13bA.g_1776233358 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:09:19 +0800
Message-ID: <1024290c-a00a-45db-990e-50bcf7c817ff@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:09:18 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
To: Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
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
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
 <ad1P-bfr_Vp6VdKf@casper.infradead.org>
 <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CD565023-4FA6-44C4-8E40-8B06CB09B59F@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/14/26 4:34 AM, Zi Yan wrote:
> On 13 Apr 2026, at 16:20, Matthew Wilcox wrote:
> 
>> On Mon, Apr 13, 2026 at 03:20:19PM -0400, Zi Yan wrote:
>>> collapse_file() requires FSes supporting large folio with at least
>>> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
>>> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
>>>
>>> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
>>
>> Why?  These are bugs.  I don't think we gain anything from continuing.
> 
> The goal is to catch these issues during development. VM_BUG_ON crashes
> the system and that is too much for such issues in collapse_file().
> 
>>
>>> +	/*
>>> +	 * skip files without PMD-order folio support
>>> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
>>> +	 */
>>> +	if (!shmem_file(file) && mapping_max_folio_order(mapping) < PMD_ORDER)
>>> +		return SCAN_FAIL;
>>
>> I wonder if it should.  If the commit message to 5a90c155defa is
>> to be believed,
>>
>>      Since 'deny' is for emergencies and 'force' is for testing, performance
>>      issues should not be a problem in real production environments, so don't
>>      call mapping_set_large_folios() in __shmem_get_inode() when large folio is
>>      disabled with mount huge=never option (default policy).
>>
>> so maybe MADV_COLLAPSE should honour huge=never?
>> Documentation/filesystems/tmpfs.rst implies that we do!
>>
>> huge=never       Do not allocate huge pages.  This is the default.
>> huge=always      Attempt to allocate huge page every time a new page is needed.
>> huge=within_size Only allocate huge page if it will be fully within i_size.
>>                   Also respect madvise(2) hints.
>> huge=advise      Only allocate huge page if requested with madvise(2).
>>
>> so what's the difference between huge=never and huge=madvise?
> 
> I think madvise means MADV_HUGEPAGE for the region, not MADV_COLLAPSE.

Right.

> In v1, I did the check for shmem, but that regressed MADV_COLLAPSE, which
> always can collapse THPs on shmem. I know it sounds unreasonable, but
> that ship has sailed.

Previously, I tried to make MADV_COLLAPSE also honour the THP 
configuration of shmem/tmpfs[1], but Hugh strongly objected and 
explained the original intent of MADV_COLLAPSE[2]. I’ll quote Hugh’s 
comments:

"
Seldom has a feature been so thorougly documented as MADV_COLLAPSE,
in its 6.1 commits and in the "man 2 madvise" page: which are
explicit about MADV_COLLAPSE providing a way to get THPs where the
sysfs setting governing automatic behaviour does not insert them.

We would all prefer a less messy world of THP tunables.  I certainly
find plenty to dislike there too; and wish that a less assertive name
than "never" had been chosen originally for the default off position.

But please don't break the accepted and documented behaviour of
MADV_COLLAPSE now.

If you want to exclude all possibility of THPs, then please use the
prctl(PR_SET_THP_DISABLE); or shmem_enabled=deny (I think it was me
who insisted that be respected by MADV_COLLAPSE back then).
"

Afterwards, we reached an agreement to keep the current logic, and 
Lorenzo helped update the docs, see commit a27848a03504 (“docs: update 
THP documentation to clarify sysfs ‘never’ setting”).

[1] 
https://lore.kernel.org/all/cover.1750815384.git.baolin.wang@linux.alibaba.com/
[2] 
https://lore.kernel.org/all/75c02dbf-4189-958d-515e-fa80bb2187fc@google.com/
