Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39A2146D53
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2026 20:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779653141; cv=none; b=lW+HFHgKRdbJ/lV2WB9lvpupUozFn2yVaSDTqEoMkcsS4TNMpzv4NqhzoqU7AssdVdsC2O7hSImnkNVpC76Cl0PB9xPeHYg5TZW41d8D906MV1bsRTPV1m8gtpSVZGHsVi4ayZA3sov6tfEa+DEt/61QjLccBEYuToZEepZT9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779653141; c=relaxed/simple;
	bh=xwmoJCilXiQlai74aNklDKySmvWVX2ILn7dYJkwLjh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u6t9XA4yd/YWrzqkt8hoVrTHx84xW5yJqQtmu+Ii+BID788jP28PjHAPs/e6/xKNeJot/62bkLhcTHIFF1erIdqA8wsBI3RcRZtZnqtTSMZbJuAaC4K3KPicAkg2ONSIpbt9UkL4yT5wIogfzI1Gltpc9uW5mxeUEC3Svfogms8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=tvYdNhxH; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="tvYdNhxH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7azdLpgudsF1v8TzDwM0i3DTFsg1eqxIcgtpL4Ormvo=; b=tvYdNhxHdDSCrb1393jBSvkC2x
	c1ScH8MbUkMsX1yayDqpeq1WHQ1voUByz5UUeCmuMhA9vc5cR9VYeivnTuUPpgLn1TNKnLuTzzB7g
	jjlgrrq3S+SEjBdL8kD2A/fSdP2305x6dtRTNp8mBtD7RvXRKgYu3ld6WizcsTp1IGAJcbtHrdoyG
	b9K+T0dvxzyv6JdMdQFVEeCkmfAsOoRa2aFn8Gep1ofvu7If9NCf0JlOzzZgipLTUN2+DKKT8QopC
	uUjViWC0bfP/hYQFzbg1wha7dXuy828beoaDYnKl9IBr7SC7WQ07uFxZmWnmH4FFZDj0ZE5c1XM1l
	PCAQwpVg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRF4r-0000000Chd8-19mB;
	Sun, 24 May 2026 20:05:37 +0000
Date: Sun, 24 May 2026 21:05:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Boris Burkov <boris@bur.io>, Filipe Manana <fdmanana@suse.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: Re: [PATCH 0/3] Three folio-related btrfs fixes
Message-ID: <ahNaEb4XOBPJIZDk@casper.infradead.org>
References: <20260522181411.2487732-1-willy@infradead.org>
 <20260522223855.GA29010@twin.jikos.cz>
 <ahDtLYinnFX5CBcE@casper.infradead.org>
 <20260523140601.GA183694@suse.cz>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523140601.GA183694@suse.cz>

On Sat, May 23, 2026 at 04:06:01PM +0200, David Sterba wrote:
> On Sat, May 23, 2026 at 12:56:29AM +0100, Matthew Wilcox wrote:
> > On Sat, May 23, 2026 at 12:38:55AM +0200, David Sterba wrote:
> > > On Fri, May 22, 2026 at 07:14:06PM +0100, Matthew Wilcox (Oracle) wrote:
> > > > All of these were discovered through auditing the (mis)uses of the folio
> > > > API throughout the kernel; I haven't been specifically reviewing btrfs,
> > > > nor testing.
> > > > 
> > > > Matthew Wilcox (Oracle) (3):
> > > >   Revert "btrfs: fix the file offset calculation inside
> > > >     btrfs_decompress_buf2page()"
> > > 
> > > Why do you do the revert? It does not seem suitable for this case, we
> > > use reverts if we want to get back to the original behaviour, or when
> > > removing a patch from a long series to avoid a rebase. Merging the first
> > > and second patch makes more sense to me.
> > 
> > The revert is for a patch which was merged into v6.16.  Since the fix
> > for page_offset() was merged into v6.15, af566bdaff54 should never have
> > been merged, and it can safely be reverted.
> 
> That it can be safely/cleanly reverted does not matter, you could say
> that about many other patches. If the code was wrong then fix it in a
> "forward" manner, no need for revert, namely for code from a year ago.

The patch should never have been merged.  It didn't make sense at
the time.  Reverting it is the right approach.  There is no "forward"
to move it to, other than converting the code to use folios instead of
pages, which I'm not signing up for right now as that's more involved.

The fact that it's been in for a year with nobody reporting the bug just
shows the lack of 32-bit testing (and users).
