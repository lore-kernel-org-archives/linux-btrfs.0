Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690772556E;
	Sun, 26 Apr 2026 06:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777183299; cv=none; b=Sqblrtt/BmiS9t3LQLxbwtRVfz5hioj6DBtBw88fCZHtwE/2q7v6EEzkMPwKWQMrsREQ6Q9q19+sQAgRU4aPj9ChyCwm6EYGseT9qkHFRmg4f1xLhQ3jGnuusXXyVzBB7HKAS0UJgW+y2nYWUXDOQ4Q+PI3AeN0l5lrOln2S5tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777183299; c=relaxed/simple;
	bh=SY6bpUtbGeACGvwsANX2qd3x5liJRX9jCEOqSHdBstM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SyRPYu3KVhwAFiqypPQ0lPd3OxLddTPMhlDggbhKxvWPTvMoF2EnJaK5YYxwhOLC42aiIlN5dOK35uNvKjJ9q4Q2URAxKhHgbQn18pR2rdYww1mT+NpUxombq/nbcBMmGBjlbD7KESezQb04G5kNLE0dBt6+QG9OkQ3ZS5TbPTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mD/H9xBA; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mD/H9xBA"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1777183295; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=b+wabLzY7PQDl0SUnNEn2ncKgvz1hAOANX6yNTSodsQ=;
	b=mD/H9xBAz6Jq09uKI5Ckro26gwVve6ObUrB2+4bVUWfIKZj8AHXTiVjj/ZtstBOzOtzjssmV69JMDZONJiejMv4v+NA9gGsWGxgWxZgjQdTt4A55TLfOzOT/cH2XLbsiDLHmFOTj+aMo0JU5gyCXzKqVeD1RuX6C8ikv0JPV7TI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1gM9NY_1777183293;
Received: from 192.168.0.100(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1gM9NY_1777183293 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 26 Apr 2026 14:01:34 +0800
Message-ID: <6a6f15ff-233a-4912-8be4-b2a43d442692@linux.alibaba.com>
Date: Sun, 26 Apr 2026 14:01:32 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v4 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260424024915.28758-1-ziy@nvidia.com>
 <20260424024915.28758-3-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260424024915.28758-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/26 10:49 AM, Zi Yan wrote:
> This check ensures the correctness of collapse read-only THPs for FSes
> after READ_ONLY_THP_FOR_FS is enabled by default for all FSes supporting
> PMD THP pagecache.
> 
> READ_ONLY_THP_FOR_FS only supports read-only fd and uses mapping->nr_thps
> and inode->i_writecount to prevent any write to read-only to-be-collapsed
> folios. In upcoming commits, READ_ONLY_THP_FOR_FS will be removed and the
> aforementioned mechanism will go away too. To ensure khugepaged functions
> as expected after the changes, skip if any folio is dirty after
> try_to_unmap(), since a dirty folio means this read-only folio
> got some writes via mmap can happen between try_to_unmap() and
> try_to_unmap_flush() via cached TLB entries and khugepaged does not support
> writable pagecache folio collapse yet.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM (Thanks to Lance for pointing out the xas lock issue in the 
previous version). Feel free to add:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
