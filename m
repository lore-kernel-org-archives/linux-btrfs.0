Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954DE2E5B2A;
	Mon, 13 Apr 2026 20:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112446; cv=none; b=DN8sG3JFBM1WPr7bSIbrginMzAK6MOqXaErKYwFGAk74bCuQnP43aJtd3HnvWXe4+UI1mzicWQzB6LpBXnKkHzQNUj4alLgJ8w5GsDyxNPYdOOapQjvn8We4O62MOeLZXfOiPWp2og9eQOSAI3TPCgL/hzd8U5qsvJRz6dAUbP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112446; c=relaxed/simple;
	bh=Adu/hnhFgLduYjObCgRqOExgPZZ9nwaPujE1FVmmU3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjpPa+uk2stoeOeaZgOCWzD7jckcbc822cszmH/OGB2O69hfyJppsqHv2LJF2wUe7JovcwR2gHSIjXj2hzt2IUtbfMGoFG4Pn9wBN2Ve0CWclwFbMiTQESIDMXvmBXzY3oZVW9Og7RTWWKNbaux48asotjkyXfNpbMPq8hr2w2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nndHwHFa; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nndHwHFa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w905OpVwDJNK2AclWlr7lRjsU2T+d2Nuu2dnfXPIdOc=; b=nndHwHFar4XXsb4K79GwTmv8aW
	WAhaU28xU7z1SQx418EOM3NLDQ/WHDY2UjqSPtX5YClQeBVF/0Moiq+LM8FkzN1ZIsZTt72hbTTKn
	8v6APgVYC/9DUkK/NpmZUbTTKWxMM4lPCfFy8lfKfrB1+MtWNRq4NjMOS0zpu7IkE983w5VwSC7iU
	5FgYRSjt+/zwmhwRcPLFdr/T19HBOSq0IN92qtFwWMc/nLUIhUIpRThsDRPvTkRxhoVdbruPffLwb
	+xNS0tUdM9WDp84+Uu0Dq0AsjWPap0AlzTBebyCm80gN5M7YQzYDzLTPVk6BcZ6hYSg5CApG14Id7
	+9ozj1Aw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCNyk-0000000EUGp-31Lo;
	Mon, 13 Apr 2026 20:33:54 +0000
Date: Mon, 13 Apr 2026 21:33:54 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Message-ID: <ad1TMjF1L3usYIC5@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-6-ziy@nvidia.com>

On Mon, Apr 13, 2026 at 03:20:23PM -0400, Zi Yan wrote:
> After READ_ONLY_THP_FOR_FS Kconfig is removed, this check becomes dead
> code.
> 
> This changes hugepage_pmd_enabled() semantics. Previously, with
> READ_ONLY_THP_FOR_FS enabled, hugepage_pmd_enabled() returned true whenever
> /sys/kernel/mm/transparent_hugepage/enabled was set to "always" or
> "madvise".
> 
> After this change, hugepage_pmd_enabled() is governed only by the anon and
> shmem PMD THP controls. As a result, khugepaged collapse for file-backed
> folios no longer runs unconditionally under the top-level THP setting, and
> now depends on the anon/shmem PMD configuration.

This seems like it'll turn off khugepaged too easily.  I would have
thought we'd want:

-	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-	    hugepage_global_enabled())
+	if (hugepage_global_enabled())
 		return true;

... or maybe this whole thing could be simplified?
