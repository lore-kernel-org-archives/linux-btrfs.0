Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066141D7E5C;
	Mon, 13 Apr 2026 20:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112538; cv=none; b=GYLPtldiTQixNwXJAu7aNQc1QKoibq0ZMtNOEb0xKQSFfVffSgSTHdiHc5U7i6oWVHTiRmZrY8B2Sf5Cm+9deCuSJ/PFZyhpOViVrejLsF2WMoJwQk03MbIyC/b22aN/54aCo0IB/Q0C8C3JjQ7T+KE2QcbHRgGVZsbvl1B8KPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112538; c=relaxed/simple;
	bh=ZgIHMj/rTFa9DI+CIcb1jMpBmBvtFd4WIBqa2HVurUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kgte+NR2kSNaCY+Uv/d4pt8y0xtXGu3XT5Duit/cedNiqYbI8JR4rDxCVeeGhiv4R9CdFVUQyLHn8te1s7+6l7x56awM3CR2MfDgwSu/etfvw3iefGRXZXJtFlukxFgf5Q9XPCLpDD8ESb3/tPJ5RKhVkFabKx80weLRPtb2+IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jf7uu1hT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jf7uu1hT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HtYokny6y9/Dl1p1xfnv9fH4Sv6CkK/mGZxE/olmdzE=; b=jf7uu1hTkK2Zwo8KKL/jpCnllm
	SGc4Da5qY8GmfJl5cU3V0+CgwLIZbm9GlRAVavYLD9l2XG7QmnAQ6BblK7KRgDhDVhh5TP3hWkN0P
	ThoJDJaT8ngjJZJ5U4jJxKCcX8XvhzGnRDe9hq1OzGE6buVl5zwgfk47IKk3bfIaaSplcJctRSkDP
	XDc7z14zpX01OvUOxGOQxXNhCDbQuDlJeWDE1iR1eociaVwO6flHBQErkKXTPwghs5XeoQt4gbxK7
	Nq+2fhrFzwMOvKha4JhePdOLj5m6F/RyKNjANmNDJ0BqBn8/KpUdcRFaS0bFTDwAumZyyarpLs5PE
	wvJ4xH+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCO0G-0000000EUTe-3j3B;
	Mon, 13 Apr 2026 20:35:29 +0000
Date: Mon, 13 Apr 2026 21:35:28 +0100
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
Subject: Re: [PATCH 7.2 v2 06/12] mm: fs: remove filemap_nr_thps*() functions
 and their users
Message-ID: <ad1TkEKQ9cyzBDWp@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-7-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-7-ziy@nvidia.com>

On Mon, Apr 13, 2026 at 03:20:24PM -0400, Zi Yan wrote:
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
>  fs/open.c               | 27 ---------------------------
>  include/linux/pagemap.h | 29 -----------------------------
>  mm/filemap.c            |  1 -
>  mm/huge_memory.c        |  1 -
>  mm/khugepaged.c         | 28 ----------------------------
>  5 files changed, 86 deletions(-)

This is great.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
