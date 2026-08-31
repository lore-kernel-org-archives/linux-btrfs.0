Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC543D301E;
	Mon, 31 Aug 2026 12:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788181175; cv=none; b=VzSmljzlMwq5TUzbCJZw32PexruNG44rxLOE8LnVkL1muEaYl16grPYXSU05DSrtfHHvVWZquLjpiWOtX3YzxvsR4itnaJ5PuHPomiletk1EfdLqUYKYGcoPb0IbRbncozKX9gjFQdW0qqyU6cwy3GvGzhbulai7Y7MJipwIoZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788181175; c=relaxed/simple;
	bh=qsw7MUzPOsf3Q+OT21pO0Cc1K0yCmK4TGwy/aNcHwuU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n08e6kSKdyqebPFs66sYy8LtLPVQxQ5XKrAFngJqOJgzamghyki79acfQbnUaX/lEJX1fd92zFL1iryFq/CsnmO4MimQoC04t0vFzU3QmRAVMvZvcKDmX42Htccqvc0pQ/iP+oAMWcg9i20PCTUvtgNvyNtPvsDOZQbFzQgz5cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ChSVorVh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ChSVorVh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rZJ6FLU1fGH5VbVtK/x0QiK9EOyoC1+KIXc7Owfw3VI=; b=ChSVorVhSbXeutemVgq5yB37j9
	Lv671GauA/58U/T9xCI6YKuM6PTv8YbTEg6SgCm2ldbAbbIeLW85QJT7PvOwyzExNC/2rBf+D2HzV
	P+F5skslMVEVSCDQNwKUMlzZsOl+netSf+uFy+U3RIrLUGwJhoY33i1JozLbU+bz2MjjABhieGR2g
	PqDwyVP6bCdA6M4MsjOWgjdBs9ng/YSRaY040fwY20fNuTlFKAdR3O+/QUiQMgolrWMKFb4PBtosz
	HZMk6WH3pHeziNxAzA/LbNKupOuuR27R0ZO9Fr463afLd97089qEQ4qnmp4xfBj/BvBeW2sBxRSm0
	BjGQfhJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x11bl-00000009Lsa-0pAp;
	Mon, 31 Aug 2026 12:59:29 +0000
Date: Mon, 31 Aug 2026 05:59:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Chuck Lever <cel@kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Add test of seek in directories
Message-ID: <apV6seOac1Ynq19a@infradead.org>
References: <20260827234743.2389778-1-neilb@ownmail.net>
 <20260827234743.2389778-2-neilb@ownmail.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827234743.2389778-2-neilb@ownmail.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Please include the mainling list for the file system you think is
buggy or at least odd.  Done now.

On Fri, Aug 28, 2026 at 09:36:10AM +1000, NeilBrown wrote:
> The test then reads the directory to find the order of the stable name,
> which should never change. It also find the "d_off" of all names.
> These d_off should be usable as a "seek" offset to find at least all
> the stable names that came after that point in the original listing.
> 
> After creating the names and finding the order, a loop which repeatly:
>   - makes random changes to unstable names
>   - checks the complete order of stable names in a new readdir
>   - checks what appears after a seek() to a randomly chosen offet
> 
> In Linux 7.2 this test always passes for xfs and ext4 but fails
> for btrfs unless we suppress renames with a "stable" name as target.
> It also fails for tmpfs.

There is no requirement where the entry for a renamed entry is placed.
Posix requires telldir/seekdir to provide a stable cookie, but how
that cookie behaves when the directory is modified is completely
undefined.  The same is true for NFS which requires basically the
same, but more stateless than local telldir/seekdir.
