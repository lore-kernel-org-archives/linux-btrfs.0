Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFB3476071;
	Tue,  1 Sep 2026 09:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253786; cv=none; b=iSe8K/9GSrCOd8TM/Ib4Zwic4oNrvL1Kz4cTO98uhX3Gu7sfJC54SviXoOakH3NeoxKQC6e9E/cOpGumYiSWiLla2Fwt66Y3ytxY5XaUKKce5IXf1KiZJTJMFRdK2Mbu4TruDLHvOG3egz3XjtHrp7/2Op9zW+7VtgRG+OmQZAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253786; c=relaxed/simple;
	bh=zliyLqyybuFHP0j0ditrK9MFKPRDMBtVUi4l3b1GvUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R4eoNudxXPM5z8WiDr89xmzs5JA/fUgwOYNTsdw8o3EgHnbb+EuxkpanLaLIt/5SYOGT25vmMF45WwebBI2Vv0vpV1mWI7wwLL/n+qWJuYpkK7xQ5c/1OdcEWPRFuRLX2IT1kOuXZNiURKr6u444OE2xoYrWiPOPiRAGVvtczrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XWf+uYxi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XWf+uYxi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xFwBYDkuC9hK34JYFG7X/WNGs30Z9GA+vCr8Ld/xm10=; b=XWf+uYxipl0qIN/SnY/kctIOvn
	5Y0rUp1GkWftqqNYYEJ/pwWoEoA39sI24P1EMp0EaZPlvyaIiOxDpf0RQjHLyHx1v6LEOaa7idXc7
	GhmgfaKquUd89sKi+VfZcRdUAM+34ss5B1T6VLGF09T2QCkiNmD4X5xhKO5W0E1ArIVK9eV0QEcqF
	d50KU7KnfW3dbwsDXgr5AgUsFZUS17A+vkwgwjivl/eSHAVCr+nWbG/+UVP8an+K5D9doCF2bXnZI
	aKf/lsQerIy4KKAMXrNgNjmFbE96Offu0aBnq2ZwwJ4NOHoNpsh3pcuNg++ypQKBBrP6UsSa0TR6B
	wZk2gV5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1KUl-0000000BNV6-3PYE;
	Tue, 01 Sep 2026 09:09:31 +0000
Date: Tue, 1 Sep 2026 02:09:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neil@brown.name>
Cc: Christoph Hellwig <hch@infradead.org>, fstests@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Chuck Lever <cel@kernel.org>,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] fstests: generic: Add test of seek in directories
Message-ID: <apaWSyUwfKr8SnR0@infradead.org>
References: <20260827234743.2389778-1-neilb@ownmail.net>
 <20260827234743.2389778-2-neilb@ownmail.net>
 <apV6seOac1Ynq19a@infradead.org>
 <178821647879.3510150.13369288580807708176@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178821647879.3510150.13369288580807708176@noble.neil.brown.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Sep 01, 2026 at 08:47:58AM +1000, NeilBrown wrote:
> > Posix requires telldir/seekdir to provide a stable cookie, but how
> > that cookie behaves when the directory is modified is completely
> > undefined.  The same is true for NFS which requires basically the
> > same, but more stateless than local telldir/seekdir.
> 
> I don't think the behaviour is "completely" undefined in the face of
> change.
> 
> https://pubs.opengroup.org/onlinepubs/007908799/xsh/readdir.html
> 
> says the directory stream represents "all the directory entries in a
> particular directory" and makes exceptions:
> 
>   If a file is removed from or added to the directory after the most
>   recent call to opendir() or rewinddir(), whether a subsequent call to
>   readdir() returns an entry for that file is unspecified. 
> 
> so "all" doesn't need to includes things that were added or removed.
> Does a rename over an existing file "add" or "remove"?
> It depends on how you understand "file".
> 
> We are told "Directory entries represent files" so we need to understand
> "files" in that context.
> If we considered "file" to mean "filesystem object", then the above
> would allow readdir to ignore multiple hard-links to a file reporting
> only one of them.  Hopefully we all agree that would be wrong.
> 
> So I think "file" in this context must mean "name" (that is the main
> part of a "directory entry").

It does not.  Posix very precisely uses "directory entry" when referring
to directory entries, and files refer to what is an inode in Linux.
This is very clear in the rename documentation:

    The rename() function shall change the name of a file. The old
    argument points to the pathname of the file to be renamed. The new
    argument points to the new pathname of the file.
    If the new argument does not resolve to an existing directory
    entry...

https://pubs.opengroup.org/onlinepubs/9799919799/functions/rename.html

> So, when we rename over an existing name, is that name added or removed?
> I think not. It is critical to rename(2) that the replacement is atomic.

The directory entry for the old file is removed, and the directory entry
for the file is added in one atomic transaction.

> With btrfs at present, if a name is the target of a rename while a
> readdir is happening, that name might not be reported.  This is because
> btrfs iterate_shared deliberately skips any names that are "new" since
> the start of the readdir, and it considers a name replaced in a rename
> as "new".  I think this is incorrect behaviour and could be harmful.
> 
> Prior to 
> Commit: 9b378f6ad48c ("btrfs: fix infinite directory reads")
> 
> btrfs could report the target of a rename twice in a readdir listing
> (but always at least once).
> While I think the duplication is unnecessary it is harder to criticise.

I'm in agreement here.

