Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509A7379C23
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 23:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779494197; cv=none; b=R1f6k3igayzjIK2innWrOkItnIl/vaHNLECyckKpJGTKFgveZuZw3ktJcDblwgAWMtsc3UIdfaz4GQVJ+4inIVn9f9ga57oQyx9kr9AV6TxS2lV9hodzYxv7bE236NkapNVZQQap8AIC0TZVpFEwlOt91HGeUzUfY867hjtVKuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779494197; c=relaxed/simple;
	bh=zq/unLPZk386k8wqzWiAllhAlqL+UAOTKeXdCyqhDFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ge2k3TQCvHR/N179kZEWAxF4Z74MvycXV7YkKYbY1o54ZKROm5fyOTLrfsK02/0LPms/YQEWQPDRnbKobPrARb8vQpwYutmQoENwEQYS0wRYYhAZaOuQ0zk620rjN6SMdF05dCBu01KpTeq3nduKmMJlC8rrm8Z2gQHadHJ8+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RH1SChT2; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RH1SChT2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nsSLN1yvxA3leIOsNWITPTfRwTfgb8EFJCqwCRkf6zg=; b=RH1SChT2u2ElfNBnUUX7+e2kOa
	2gfEvb9ZK0gjLnA6cMrEuARyBukqedqHkNCfEVsxIP1yaxRX9YBdekNd8PWxPO5e2NoZprHKXLSn5
	H8XWlWoGgvtNdO9tM6iKPJMyE12/8lHgXhVdpOr09HAFVdiHv5nyifr4iCfeGM+LuHs98/23fopn5
	98wQ7RK1eNf1oqDEKZ6fI5hre7EaBhE8j6vVsSgAgTE8pFCUbyxbxqFfEu9X0fH8Mmz7hjCuNd3Fe
	VfHuKGdp8Yh7SlRe9bRtOdfPf8evg6eP5BiI0pJT3j77UMc15f7UKKn3X1cgPIekVrxlsR9UCZW+8
	s59FHNYw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQZjB-0000000Ak0d-1OCt;
	Fri, 22 May 2026 23:56:29 +0000
Date: Sat, 23 May 2026 00:56:29 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <ahDtLYinnFX5CBcE@casper.infradead.org>
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522223855.GA29010@twin.jikos.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522223855.GA29010@twin.jikos.cz>

On Sat, May 23, 2026 at 12:38:55AM +0200, David Sterba wrote:
> On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> > All of these were discovered through auditing the (mis)uses of the folio
> > API throughout the kernel; I haven't been specifically reviewing btrfs,
> > nor testing.
> > 
> > Matthew Wilcox (Oracle) (3):
> >   Revert "btrfs: fix the file offset calculation inside
> >     btrfs_decompress_buf2page()"
> 
> Why do you do the revert? It does not seem suitable for this case, we
> use reverts if we want to get back to the original behaviour, or when
> removing a patch from a long series to avoid a rebase. Merging the first
> and second patch makes more sense to me.

The revert is for a patch which was merged into v6.16.  Since the fix
for page_offset() was merged into v6.15, af566bdaff54 should never have
been merged, and it can safely be reverted.
