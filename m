Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA5D352C4E;
	Fri, 27 Mar 2026 09:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774604699; cv=none; b=i/LMgcApK8VEDGCcmb4ooA/LKWvNi1wSTK+HFbOFFNssk7WUyasrghh2oyCLA1/+FMmiDZEdO8U7KpZ8PeR/h7HDXHYn4pXAlnhTlM7rMSmiGGfyFznoS88Te9CQHGG8py/+YHhbS/fUa+6V9N2C6ULh22NeH72PZmsQLXynwe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774604699; c=relaxed/simple;
	bh=uwv/A6VDU71smC9cjCzHcWme2MW+RxTF5DCl65hyCZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aktLQLG+Ru6H4mqA33FqLNd0CORzme+NIW6t5Ykm17cpCp9w1hvCm/3R8SZS+e2RBX2JIMp4HKxCA8pFUFhDNtsegWwoD3I/BV1W15RzAIuhC5g24MvqftzPUXt/EA0WUphaBUFQZHROrvd5ZRuMKHWhIqPQq/uFxBZwv/iA3Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=u5n847fF; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="u5n847fF"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774604692; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=d0T3QbIX0f+LhSvEfVUQnp7VQm8nnkhkwzqmdsHsY0I=;
	b=u5n847fFzODrKxFbvRndlqqg1iNbNPHkC53Mp3YUz8d4IdVmm8pGXmbjtVXY7vS7n0Hki6ovK37ln+vcl5nogfeMgtKuqm2XQY0oRn8DdqixEEb7m8GN4aFs1jg8zJjW6EhABlkLcSjDOjD5JZpjTuu4FOFUbdEiy0pEdEHRi1A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X.o0Fj8_1774604690;
Received: from 30.74.146.57(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.o0Fj8_1774604690 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 17:44:50 +0800
Message-ID: <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
Date: Fri, 27 Mar 2026 17:44:49 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
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
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260327014255.2058916-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/27/26 9:42 AM, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> huge option turned on also sets large folio order on mapping, so the check
> also applies to shmem.
> 
> While at it, replace VM_BUG_ON with returning failure values.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/khugepaged.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d06d84219e1b..45b12ffb1550 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   	int nr_none = 0;
>   	bool is_shmem = shmem_file(file);
>   
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/* "huge" shmem sets mapping folio order and passes the check below */
> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> +		return SCAN_FAIL;

This is not true for anonymous shmem, since its large order allocation 
logic is similar to anonymous memory. That means it will not call 
mapping_set_large_folios() for anonymous shmem.

So I think the check should be:

if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
      return SCAN_FAIL;
