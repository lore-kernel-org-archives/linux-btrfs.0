Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B945390CAC;
	Mon, 13 Apr 2026 22:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776119357; cv=none; b=l3Kk/gvbKOYseUl6STqPDx+oZ8niNPA3nxRksyI5DRb2yTv6Try2/s+xSYK6CNT27f9PAjygKopwdnDO0Dlojq6dhQ0pezMCjrZP8XCtwqjRPQMDzDlX58LIltVmfO+UMPIwBBlM6+t0WNeejAVWH9k76BB7ndahTKxy3k0Lqho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776119357; c=relaxed/simple;
	bh=EpPryzj2H6swIOptKBgz2vNXyU4jbKi7icnmCJDVN44=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VWBR9nWGvxHUQA+qPPBraW/sOexRxir8G4CdwvsjWmCShb0EKQ3oPEzulc9T2Am+prVshMznn4wjabYBlJCuJBLDgO1O2f9782+Zw1YalqvF7v/i2SwdEaPNk2seyA+Ou9fp29NLZaQf4cbGm1GNqGfzGXynN1APLZI8Bv6CV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZmWg/RE7; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZmWg/RE7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NTwBXrFpNi4Fseaq8Sky7pLzRp0mlA1ksSlPEqI0JKk=; b=ZmWg/RE7pdRpXKI55S8cbSa8gw
	Wjv5sTE0WbQzhn8CDWWUinuH2sjpRwR/arldGQVvp9Ra7GtijGUvaSE3/iP/y4vXKYlxAfLog97NV
	LbRjs5e/P3yEPbFYnAC+qP4JFhZves3bYyPL+lSIlhsI6Z/fEIUPloZDi6gsheeUIfbr/snXATm9m
	2D1Ykc9DMdIJE9vnCflifaF7szT4YN+e2+8cwyWUsWvGylUHJTs3Gvn7SUY7kQuMOBsISsJ+KID92
	sxg648RqlrvaJKmdhjNXNXUaNVNc4TyMjhrvxYBO2uKgWDH6LjtI8A9dkQXWsdLJ7N+NdYnV0ltXA
	7nIexsqA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCPm8-0000000Ecwc-0D5J;
	Mon, 13 Apr 2026 22:29:00 +0000
Date: Mon, 13 Apr 2026 23:28:59 +0100
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
Subject: Re: [PATCH 7.2 v2 12/12] selftests/mm: remove READ_ONLY_THP_FOR_FS
 from comments in guard-regions
Message-ID: <ad1uK11f_J8sFN0e@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-13-ziy@nvidia.com>
 <ad1WTCR5Kld-tiL8@casper.infradead.org>
 <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E3268570-18E4-40AF-92E5-931A8ED1C9B5@nvidia.com>

On Mon, Apr 13, 2026 at 04:51:28PM -0400, Zi Yan wrote:
> On 13 Apr 2026, at 16:47, Matthew Wilcox wrote:
> 
> > On Mon, Apr 13, 2026 at 03:20:30PM -0400, Zi Yan wrote:
> >> +++ b/tools/testing/selftests/mm/guard-regions.c
> >> @@ -2205,7 +2205,7 @@ TEST_F(guard_regions, collapse)
> >>
> >>  	/*
> >>  	 * We must close and re-open local-file backed as read-only for
> >> -	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
> >> +	 * MADV_COLLAPSE to work.
> >
> > Is this true?  Does MADV_COLLAPSE refuse to work on writable files?
> > Should we delete some code here as well as fix the comment?  ;-)
> 
> file_thp_enabled() used by __thp_vma_allowable_orders() refuses
> writable files with inode_is_open_for_write(). That should prevent
> MADV_COLLAPSE from working on writable files.

That sounds like more code that was added for RO_THP and should be
deleted?  See commit e6be37b2e7bd
