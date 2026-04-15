Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1774390CB4;
	Wed, 15 Apr 2026 06:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776236005; cv=none; b=q5q+NDJ7AsN0MPVi7aHN/qKlTJ0dcH9s2tnO2aHvsxoneXuRTkx5Ug2sKAL6UI0d2CUYQYfUVhe46kL2qN55LGJCVi/a1O+YVQsGTDrhTzGlN9J6hJeAGT/H2hyHgk9xi8kfwQG+N0/r9ptqhGgQ/TXlCTqDVMB6m7bBabnY/Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776236005; c=relaxed/simple;
	bh=UXPzQmdpVK6aOkz7145owxsJT2pDfIEcbb28cuJU+OE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FPy5L2oCdY/9SbnaSbwnb5XIW2+8AFkdrdhBIgknTNGxbNT3OBkgwpRePk/n43MZzu2dUffWWf7m3PncwJKNfGU4RdLpPFLM8fPfJdY0eaCxJpQcHZw8fsGYGQbxPd0PpmYW6Gc1shuY5E94t+ZGpd+xIWj/vUk6vlHIwW9HPQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Da8xb072; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Da8xb072"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1776235999; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UCQ7usOU14shNLTSWEUmhQvpbKphWMoPUYFh990S0rg=;
	b=Da8xb072aIw5QspxyFG9F+ZvXBQ55cHtcZz6Ac/GR3juam44oOkntukskpkiQv/7GmPX4HpOpTD+vlL/51I830McxSmzCYVBmRTXMF7NlpcPR5Wi0TIWbXgyGa1Nnnk5V9e5sQDf+yeXMedzFk6iJj4diA8fRk0+Qi73DfkL5dY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X13f5NE_1776235996;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X13f5NE_1776235996 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 15 Apr 2026 14:53:17 +0800
Message-ID: <85f163b8-9a86-4223-b835-b271a4502b47@linux.alibaba.com>
Date: Wed, 15 Apr 2026 14:53:15 +0800
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 06/12] mm: fs: remove filemap_nr_thps*() functions
 and their users
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
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-7-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260413192030.3275825-7-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/14/26 3:20 AM, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.
> 
> READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
> smp_mb() to prevent writes to a read-only THP and collapsing writable
> folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
> smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
> do_dentry_open() first increases inode->i_writecount, then a full memory
> fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.
> 
> Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
> since a dirty folio check has been added after try_to_unmap() and
> try_to_unmap_flush() in collapse_file() to make sure no writable folio can
> be collapsed.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Thanks. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
