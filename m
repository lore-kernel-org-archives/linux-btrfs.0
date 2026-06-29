Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B050403156;
	Mon, 29 Jun 2026 12:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736825; cv=none; b=d95Lnpgku5jeL/FeBBB1UpcwqKvQw7DEfNIgFab6Z22V/caeCXLIo4uPeTr0XhiM0DYPagARAB0onPJb87bP+Y3fTEkkl50Z3bM4v/m/nC07jKL4Br9Ui+nz60r5lj+4wAvOFqGzqpsBPhli1Ac4FFwE/e6bYXPsFn+EM7lmzZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736825; c=relaxed/simple;
	bh=8Gq20f70P3xrMq7HHdU5Cazx7f4MMrqI2luPiCWeh4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tsIQpdO7CTcbfvB1D1ng/l8JaaTRy5JIZxbq+rz3UZDe07p2QCNjgBDqCF+mDiLn+/dKDH2Y27BeEnIkmLpYErsR09FUHuOVK4z2KKESL4xEm988bsQSDjbh3Zox+zg5H1gYt0VoXRhufIw/dKKSxJ4g+u+Tt/z59ItOx4Ha4F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EYBAw2t9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EYBAw2t9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+s6aEnd5GUZssw9D40njjBiTG5/a7zBPVFIRoM0stE4=; b=EYBAw2t9PPyB7NeXcvPKKABBgQ
	2L5tCUQ6OcEv1nWMMC6QRYfZ65zzhTm0GkkNqYlMMxZ3wXHdmhJ54Ze0BPPypBekCdBzS2OQ/oO7Q
	/VJZy0GWB7W7KGsvdqM+GZUqX5rfgMIjNAl2sUm4ozdG9XY6qki7A6xySbnFn/GurNvIzEA6NPch5
	zH2ms3i5WZ20AQnsFc3KcxZBMm2Adjmij7bhabX9Il0MTiGLxt2xYeTT+QFdjFLgP1/P+dyIEjb7t
	yPIXCp/c1pjg2WguK+1Ur+lJYfnfavp7cEJnF5hq2h+yW3m8XAXJsRUYb2YF8reB1lKxJbb0ZjnB2
	u6l2GBcg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weBHi-0000000EaU4-3kwv;
	Mon, 29 Jun 2026 12:40:22 +0000
Date: Mon, 29 Jun 2026 05:40:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: Rosen Penev <rosenp@gmail.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: raid56: use async_tx API for parity operations
Message-ID: <akJnttvuvEv55nOh@infradead.org>
References: <20260629023912.2102700-1-rosenp@gmail.com>
 <d96ddcc0-a62f-40e4-9f80-34929dc3bcfd@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d96ddcc0-a62f-40e4-9f80-34929dc3bcfd@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 29, 2026 at 02:41:44PM +0930, Qu Wenruo wrote:
> Do you have any benchmark?

Yeah.  The async_tx stuff is a mess, and will cause real slow downs
for CPU native operation, while in general offloads have proven to
not be very useful.  There might be a tinty use case if your data is
all P2P and never touches the CPU at all, but I don't think btrfs even
supports that right now.

