Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAC2F25F0;
	Mon, 30 Mar 2026 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774887598; cv=none; b=krQ7IKKpAid7vnwNDODoLZGU22fi/xdLmBHxvhXgrUKCe+XzogV862vedxKDeU8xq8tnv6GmcppD1dR29tcJxIU1p5oii0okrG61wQd5avRqcd8dENRBb3xDNQv1/KUkysO01IIl2KkvGDAo1wnbfvXV/DQHoDdSVOak9nAVxmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774887598; c=relaxed/simple;
	bh=fAEc2VEd4KBBBTYNlosneKYpVkGBGFqE2DSRAogh5Jg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dDngY0OOR9MisdkOq3WD5b9KLXuThU1M8Ml8K6yY+fRGpg7yQXSLJN03DBkQlQV7+qcyjOr7beHUNXVuVYhH2AwkMqG9ZIwVhnOxkMsmu8KqCRpgh7y7jM0O1HumHeNKZIrZEfIjXTgLsACPurmb4eRPRgMGkr+9Z9pZq3QixjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZdozrY14; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZdozrY14"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=z7YLDVYxqF/+f1DCCJKbVAIzX4V8YvHeDqe3ffDzeSI=; b=ZdozrY14XCATmDIlNwlFmzEBwf
	z/K5h87go5Bk2q/blH/hdo9V+pBArg3wPGmyDuHmF8uq/waJkppzeNH8Y45JHHAXDq0IWkHhCCggz
	B8ACncOFhZP6rHi13nM5D3Y/NzwKbDJfwHj/oGAeLxXUv4FoslIrDe+ALSS28fL9hYULE9MgJeJRk
	nd8T/a3GN0RzipUyfwxLfhvmzhSVaKkgq7Gvj8OnQRLkzr9k7V4tKomyIhhKCCiuglHJ5TvrctwId
	CBfpXfmewANcXuQPzuQCftfN+xcZs4YrrvuPelV03TocJrCjQNLc5fnVbP+KbgNcADUZCWra+hNVe
	wm7GzVZw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7FL4-00000006wOx-3GNU;
	Mon, 30 Mar 2026 16:19:42 +0000
Date: Mon, 30 Mar 2026 17:19:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: WANG Rui <r@hev.cc>
Cc: ziy@nvidia.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	akpm@linux-foundation.org, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, brauner@kernel.org, clm@fb.com,
	david@kernel.org, dev.jain@arm.com, dsterba@suse.com, jack@suse.cz,
	lance.yang@linux.dev, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org,
	ryan.roberts@arm.com, shuah@kernel.org, songliubraving@fb.com,
	surenb@google.com, vbabka@kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH v1 05/10] mm/huge_memory: remove READ_ONLY_THP_FOR_FS
 from file_thp_enabled()
Message-ID: <acqinu8H5jo3Zw7b@casper.infradead.org>
References: <DDFEC0C1-3ECF-41CC-9630-A4A742F2B842@nvidia.com>
 <20260330160942.173324-1-r@hev.cc>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330160942.173324-1-r@hev.cc>

On Tue, Mar 31, 2026 at 12:09:42AM +0800, WANG Rui wrote:
> Given the diversity of filesystems in use, each one requires dedicated
> engineering effort to implement and validate large folio support, and
> that assumes both sufficient resources and prioritization on the
> filesystem side. Even after support lands, coverage across different
> base page sizes and configurations may take additional time to mature.
> 
> What I am really concerned about is the transition period: if filesystem
> support is not yet broadly ready, while we have already removed the
> fallback path, we may end up in a situation where PMD-sized mappings
> become effectively unavailable on many systems for some time.
> 
> This is not about the long-term direction, but about the timing and
> practical readiness.

If we leave this fallback in place, we'll never get filesystems to move
forward.  It's time to rip off this bandaid; they've got eight months
before the next stable kernel.  I've talked to them about it for years

LSFMM 2022: https://lwn.net/Articles/893512/
LSFMM 2023: https://lwn.net/Articles/931794/
LSFMM 2024: https://lwn.net/Articles/973565/
LSFMM 2025: https://lwn.net/Articles/1015320/

(and earlier, but I think I've made my point)
