Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B574C40DFBD;
	Mon, 20 Apr 2026 07:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776671805; cv=none; b=lJCr37IRyfG0dVV24IjAyZe9lgZrDYbCUI03RCGzIMLIbfwwI1IQ9psAvMUo3lqTEhzxI7YFvZ5wE0FlD72lvQCoyGmDQDwGYRrW8PfutAe2gJOZ/GqAS/MOtP9k9LSM5OjNb4Gn6bd6orpRhwreBF8aH61dqOTo1zYwvODWYiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776671805; c=relaxed/simple;
	bh=5queap52K73mDcWZRnpsercrASVJe7bERpuTxjUVZ/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OZ3iH0znn5jK+D9oKdE0Ptxqy1ym+6ltZ/+rF9HFC1BnNbqfy7XdbcbN1Fvkaa4F8PzfRXDJniyPAZG2xpJi8ExfMl9fAmXpX7XZM0nP03m1lP/W+LqbFEhdxoLjI6yncXRvrYIMZuAuSbNqswbPqSWQmoCpzSol6bQ7mjNgb6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=utjinGhd; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="utjinGhd"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776671793; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xXWSFBSCtt1/CFq45jJqfZ4qaQqmuiM4XbV6wvtaWvg=;
	b=utjinGhdOWzKtqAp+x094qkfcQAJgKCArp6t+zBP2qZewpLJdG4NzVpOGhEw/kXZxRSBDVzwHmU+YLbgaDYd859GjQFh5sQKRqFDSldRHjQX9vcv3lHsbmEEscRsPSZnc8y/9PlnWHnkSGiVZs/5yra2mPfl73PGvgA8dgikRf8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R281e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X1J08mT_1776671790;
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X1J08mT_1776671790 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 20 Apr 2026 15:56:31 +0800
Message-ID: <e1baac32-dcb9-4458-bc57-0ac3cea65fa7@linux.alibaba.com>
Date: Mon, 20 Apr 2026 15:56:29 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v3 11/12] selftests/mm: remove READ_ONLY_THP_FOR_FS in
 khugepaged
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
 <20260418024429.4055056-12-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260418024429.4055056-12-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/18/26 10:44 AM, Zi Yan wrote:
> Change the requirement to a file system with large folio support and the
> supported order needs to include PMD_ORDER.
> 
> Also add tests of opening a file with read write permission and populating
> folios with writes. Reuse the XFS image from split_huge_page_test.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
