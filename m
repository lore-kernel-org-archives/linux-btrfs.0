Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D95392822;
	Mon, 13 Apr 2026 20:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776112903; cv=none; b=nYQ9hetWkbo7yvJr5ZL12cBmoZSB9lrbtppCAmEGvzm9zwXjAYtXocN/1V99oBGhdPVCNSXbReXNu+ocseMl/4v1X9rSuEGfjge6zPlJcwjsaZ/tpyccLgyDZo4zEOQ67E9k8vLWKqXDNw6ESs1X1KoC4swAOifNE4wo6ssqniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776112903; c=relaxed/simple;
	bh=rUA7A3jZzvigCCuLEgfU6nW2+5s0NXr7H9u+d/oilcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IpvfyhcH6li471MFECbuQwbBIrCj04A4Yj0i0bw2h3UOI/ZPbfATcjwCfED4BDjLUr0jxdIDjZFMp279qpfzf8t7N0z0z5AcEjMeAsE5S9IWCZjpniZEJa3HT4eTaVcl0ntOV5ieBTbAxoOH5FUIiSYxpjzRdp8Owm9LGF6lgbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nz6I/UeB; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nz6I/UeB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5WByCkjiLUoqcmY9Xk0+CO+njRcv+yHwZgHE3y0xPWo=; b=nz6I/UeB31UCPopxIB3F0rbi86
	SqZnsUv69hzGeNzZ4PVCquLOIt1OlfD0/uVGqu3TlVUPaeXkWFJJUFJ6+mOLPQYezOkwng160E5bM
	3MBc8hfcIhvtd1sllANYdWigpW2WL+w6EsmqF6mw/+wW8lt6LpChOtI4JL96XzY6YmHylpgFsR+wK
	bY3PSA9jTLDaeu3OFopBo/uXEFQEKohH4bTbKMzJNvZp7YufeNQNu+m0fOj5WlHYyW+Ucy54AjiVA
	1n6dA/HSOBYDxHn0T5GfZteKVFKSYlK6d0YYNDCkz11UWxGdahEt967YMy3e9sqSkNzt/f/1qhWyF
	yLqFV3/w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCO6A-0000000EUrG-0RoH;
	Mon, 13 Apr 2026 20:41:34 +0000
Date: Mon, 13 Apr 2026 21:41:33 +0100
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
Subject: Re: [PATCH 7.2 v2 08/12] mm/huge_memory: remove folio split check
 for READ_ONLY_THP_FOR_FS
Message-ID: <ad1U_Z1b7hKlgnun@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-9-ziy@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-9-ziy@nvidia.com>

On Mon, Apr 13, 2026 at 03:20:26PM -0400, Zi Yan wrote:
> +	/* order-1 is not supported for anonymous THP. */

It's also not supported for file folios, right?  Or do we just skip
adding order-1 file folios to the deferred split list?  Either way,
we need to correct _something_, whether it's the code or the comment.

> +	if (folio_test_anon(folio) && new_order == 1)
> +		return -EINVAL;
