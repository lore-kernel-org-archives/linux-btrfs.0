Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C363438236A;
	Mon, 20 Apr 2026 06:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776666539; cv=none; b=A1Qq81X53MFKIDa8qaH/uJP34Q0XjicE6mt1tET20evgFs0lXfAIV4naS13xywgbw434sXdbo2719kGJx1sBQi0Mz0RUdjouOEleIk5IQUtCPOAXu8I4rE/LFsehBFW7MnYVT6u8tTgyt8Ni/kKoLQl7Nv/z2xag8/2i+PJkKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776666539; c=relaxed/simple;
	bh=OdWyKFIb5pu7/v7CzaMNErLs/PS+/JzianHuO70VLCE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bf1OKE16lJMU7sidnKI5JRvhfv5ox5Ks3Z8lDaxIjJFv7hBYFfEL8rWihr+DkchgYkNhXv3NaaLqqbWSgHlIbbSwhSlbqbr39wIdMH7geMLESMY7MdGOK2d7fHwukBQeNvqDZIiZAvcve72vxow4f7RRVIlPtmHClHe+FA4jeSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=p38bcaUh; arc=none smtp.client-ip=115.124.30.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="p38bcaUh"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776666528; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=TnJNP5Zf8rEkIUqerK5GYr5N8IvbRMuI+6hpj6QnM5w=;
	b=p38bcaUhgMWqkddM9RWWJyS8C+mR0DeDj4yF5EVgaTUxWFxOrAXfZgjsBxlyMO9EWXRZBYUwopcZw7kR+jGl7VC1OGTHJ+m+uEdbvlhTT42ttySwKz2/LieLhhED6xsAi0efWuOn6dUmeXNdqmngvuO5bdtwNfm3qy1ZyF+HwHk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1I6o8n_1776666524;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1I6o8n_1776666524 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 14:28:46 +0800
Message-ID: <78a05609-05f3-4b2f-861c-30dab49083c1@linux.alibaba.com>
Date: Mon, 20 Apr 2026 14:28:44 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 02/12] mm/khugepaged: add folio dirty check after
 try_to_unmap()
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
References: <20260418024429.4055056-1-ziy@nvidia.com>
 <20260418024429.4055056-3-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/18/26 10:44 AM, Zi Yan wrote:
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

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
