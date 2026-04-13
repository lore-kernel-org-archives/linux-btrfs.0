Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59888347BA5;
	Mon, 13 Apr 2026 20:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776111629; cv=none; b=RLZFehF1Q5JPTTl7/3pyCQ3Lb4tz0XTrBITvsZ5qeX8ZO6BNqxlRQjnheFc1/RsOcmIJWJl7dI6rcLKu/cUWVgqeqvv12SsfyFSeEroZIndV653oxsXmI7UKvBPod9qSYVISTNh1u101Dakkzal4USim51OphDInacQ5nuHKXIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776111629; c=relaxed/simple;
	bh=7/qmIlG+iVNkJ8dZehaJIEiCnbgMSyEDShXc0WdgPvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PGPGpfZb9AzmcnKZWPYXarU6zKN5TL0GE0OXSfnYtq+Ph8bXEOnIuRZ5UFyc84DM7+GGYUGEfCHAB7UHGoZG9kNNNhxuGzGCjX0bp4CS20Q8UZCE10QAHm9gZ0JYbntws6e+CdqBToQUPKStwGS1/Jp9UFsLJWtN7AnJcuBP5gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dMUgBK9h; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dMUgBK9h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NLcVHcvKWmcbrgR33gHCYc9nnRDShPHrweRag0w3Rss=; b=dMUgBK9hVQVcXUT4U24DGS3kiz
	GhjKY37BWh7Jb4Fks9Pd0D3clCeD40QWA0HpurHvoHRsXZJ/IpWmvPCaV2Vboww0FQBL71Abpbgrr
	2ED5tKDObX9PFme+mVM5dtHPtBv/pKL3xOJ627FzQX/g0qkGh+PUIFb/Fx6/hkNnU42atx9J1Ftdn
	qmXI4eBd+pvfs2sXUBVj/geCsEOHcWCYydHRwRfgOPyiw0NgRAInjizITUXcz9Bt7Fn5ypTEQ6l7o
	YPsqJImx66NhuiVlkCjO16+WE70N5plOdZNpfq9oeLmoOdiJQ6/JKILn4JvRyLefnMDODtAcnbJIm
	qg5fHBaA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCNlS-0000000ETMo-0see;
	Mon, 13 Apr 2026 20:20:10 +0000
Date: Mon, 13 Apr 2026 21:20:09 +0100
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
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-ID: <ad1P-bfr_Vp6VdKf@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-2-ziy@nvidia.com>

On Mon, Apr 13, 2026 at 03:20:19PM -0400, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Why?  These are bugs.  I don't think we gain anything from continuing.

> +	/*
> +	 * skip files without PMD-order folio support
> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
> +	 */
> +	if (!shmem_file(file) && mapping_max_folio_order(mapping) < PMD_ORDER)
> +		return SCAN_FAIL;

I wonder if it should.  If the commit message to 5a90c155defa is
to be believed,

    Since 'deny' is for emergencies and 'force' is for testing, performance
    issues should not be a problem in real production environments, so don't
    call mapping_set_large_folios() in __shmem_get_inode() when large folio is
    disabled with mount huge=never option (default policy).

so maybe MADV_COLLAPSE should honour huge=never?
Documentation/filesystems/tmpfs.rst implies that we do!

huge=never       Do not allocate huge pages.  This is the default.
huge=always      Attempt to allocate huge page every time a new page is needed.
huge=within_size Only allocate huge page if it will be fully within i_size.
                 Also respect madvise(2) hints.
huge=advise      Only allocate huge page if requested with madvise(2).

so what's the difference between huge=never and huge=madvise?
