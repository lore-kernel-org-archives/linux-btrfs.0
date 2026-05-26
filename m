Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82D737BE97
	for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2026 06:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779777524; cv=none; b=P2TIIO2AYY0Jt2G3S3O0FBeovvhvqjSvKEHb7FOv1Wz8ldrYMCwqXjUacYY5ZRBdNLp2FLXecYOgwmKtNAMWDik2hdU3eBoWLEzkfDzpWcJp8KTYankQp6aAbwIBJdU4NTygCc42z03LpkuY09oKqjyaWMWfe1419UHoS4KqnCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779777524; c=relaxed/simple;
	bh=ZCBMMHFWAU9prEhcAetqdkujqvWfFFzIWRG11/B2O/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QpSZ5QPuAtCuw54hKant/StuOAgaNtOdqiqztIFiqH5IBq+K+pDJ8ZyF4t/oQnExs8UNSxoMjkJOO7d/XGSVwez+ySBvr5r0eR25pjoi2OE+M26hgDzTl4ND6XyNaXlTKIf88RSD9abSQfeDJiFu30kYfb+uqyRRcRRaWlntWzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A+9aKfNa; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A+9aKfNa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MJHZIk5Per+ft2mJCcE8cmAsZYN2hf0sI2TMXCN8YE8=; b=A+9aKfNaWHX4x7v6pc1ac9Dms7
	EwPzeo+r/F8OWP6oEBZXg215euz1uFKeBGu9oRcK9ucxT6NOIU92BvFI8iTs0FEiQBhSeNzBLG98r
	0vAhZc8UcuO6ox8IVDo4HWq1z+8gqNaIAMBR4i3cGciqgobjVppt1bmzWfbSOwQqgaK+BGo8ivmct
	tbyeQWCZkDGdFKPuNZJmiuSxiJrhLqnCVATPf1Q1kLGKMZb/Ck8HlN3qMOfZruSA1t1n+6+vy9bWr
	s1nQZh+AhaJ8uhZvdx9E9hwYRGbJBFkCCcvMy2T6/lAbw8ZMO4kO/XOBp/tWvuELG2pxv00Eeeyec
	+nCGiMxg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRlR5-00000001BRB-0Tdf;
	Tue, 26 May 2026 06:38:43 +0000
Date: Mon, 25 May 2026 23:38:43 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
	Filipe Manana <fdmanana@kernel.org>
Subject: Re: [PATCH v2] btrfs: use IOMAP_DIO_BOUNCE flag instead of falling
 back to buffered IO
Message-ID: <ahU_86ZpD-U3TUf9@infradead.org>
References: <e578ff1a2dd9a4f720ea77bc601534734ce87e18.1779685479.git.wqu@suse.com>
 <150d5b1f-d1b0-48c1-ae33-56b4c049576f@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150d5b1f-d1b0-48c1-ae33-56b4c049576f@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, May 25, 2026 at 06:44:48PM +0930, Qu Wenruo wrote:
> Currently btrfs avoids the deadlock by disabling page fault for the @from
> iov_iter.
> 
> But that iov_iter->nofault is not respected during
> bio_iov_iter_bounce_write() -> copy_from_iter(), thus we will hit a deadlock
> at exactly the situation described in the comment just before
> btrfs_dio_write() call.

Yeah.  We could try to propagate it, but ...

> I tried to check how XFS handles this, and XFS seems to go a completely
> different way using different flags for xfs_ilock().

Note that the flag is just messaging.  The important part is that XFS
uses a different lock for protecting the internal state in the inode
like the extent mapping (xfs_inode.i_lock) vs the highlevel VFS lock
protecting I/O (inode.i_rwsem), which is really important to avoid
all kinds of locking pitfalls.  I thought btrfs was doing the same,
but maybe this is some other lock you are seeing the recursion on?

Sorting out the locking is good way to avoid these problems and also
integrate better with common VFS helpers and/or iomap.

> Or we should add some extra checks inside btrfs? E.g. if we found out that
> the folio we're reading belongs to a direct write, instead of waiting for
> the OE to finish, returning -EFAULT?

Oh, this isn't actually a lock, but the ordered_extent wait?  My memory
is a little fuzzy, but I think this is the same problem with the
ordered_extent semantics that is also causing so many other problems:

btrfs completes the pagecache level writeback (that is clearing the
folio writeback bit) before the ordered_extent has completed and thus
the metadata has been recorded.  Which breaks the assumptions of all
the common VFS code, and requires reads into the pagecache to lock
the extent.  If you'd manage to fix the writeback code to only clear
the folio writeback bit once all metadata is recorded in the right place
all this would go away.  I.e. call btrfs_folio_clear_writeback only
from the finish ordered extent context and not directly from
end_bbio_data_write.  I tried this a long time ago and was running
into problems, but you cleaned up a lot of the mess in this area
since, so it might be easier now.

