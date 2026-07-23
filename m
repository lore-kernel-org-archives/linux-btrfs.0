Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F79443E9DF
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2026 11:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806309; cv=none; b=JhnJgQwymZnniBIighY3pfBRZAF73cUI9aaYn4cHvcuLvClqvSQ5JomOxMmOdtkE4fG4+5HA88jFGX3JI2DAkKeKATY/cpoB9JsZe6yIpmV7SpUN3i6KxXta4/IWkI6F0yoYQkbcLly1leU6slW3EiQCGexPG23fmo4gSdnmXME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806309; c=relaxed/simple;
	bh=ch67q3QeCmeVRsKVM+rRJQIYbUII92ztwmRMgcSfB1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ohoot3LxIi8FQjateO0J8BuRwzoKRds1BVQVKYvy2BbHlShSWdwdjKt3jhWAuKtoBAorSlqJIangzyckD8uoJ2cPSsCrkh23b8KLqDhWSajY6I/c095IDH+GkpxTtBsdbFtCo0mQMLoY7+nm8A+vSRXnIhVuvgM2n2sl5dFNg5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=K3jMCs1X; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K3jMCs1X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=heGMiZDvR5wzx1sW8NlfZNnbumoPexIyQpTuyOrqqsI=; b=K3jMCs1XVxt8K3p/MR9EX/LxmN
	Nzl+kn1dDTwzz1FS++sC4/4tWw1ix4RQwB6B2zW+eDj0NjXhGmx17RFnZ5nQ0K+p7aanD5DPt0RbK
	8wjJNdA2e93jbGZYb1FMve/NXuhU0A1A0WIGTda2Mu/1ZrGSOaVzJDMyWjWfnFiYSarcnwx4sLkTF
	N5dwb9d680JQQBz/dN4h/6NouPzYXykW6UhyeDRKKhN7ODFba6iK+VbWAkQbkggiYCti0dZaBvNb2
	MW++oIFXbK/nQz64WSfu2I6p6nuQbJsaWy7aPXh9Tx3YP0IDdR9FiaTmoA299aqpwJMyKIhdAWzzT
	F9ZR20Eg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmreL-0000000E9v7-3ncZ;
	Thu, 23 Jul 2026 11:31:37 +0000
Date: Thu, 23 Jul 2026 04:31:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RFC v2] btrfs: disable direct reads to avoid dirty folios
 without fs knowing
Message-ID: <amH7mUsPFIAJXZUg@infradead.org>
References: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6dfdac9fc51c94183e51a861eec269185239660.1784787211.git.wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Jul 23, 2026 at 03:43:40PM +0930, Qu Wenruo wrote:
> There is a bug report that a reproducer which doing the following
> workloads in two threads:
> 
> - Direct read into memory mapped from page cache
> - Sync the above range
> 
> This can lead to dirty folios without fs knowing, this can be a huge
> problem for btrfs, as even on the very basic bs == ps cases without
> large folios, such reproducer can screw up the ordered extent accounting
> already:

Disabling direct I/O on btrfs is not going to help you with that,
as you could still call the direct I/O read operation on another
file system (or a block device, or various other direct I/O like
things) on the btrfs file mapping.

