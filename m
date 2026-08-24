Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B980234404E;
	Mon, 24 Aug 2026 05:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787550606; cv=none; b=CvyHj5cbl4dsR3sRSe1gWqulyvGvWFN04SGY8j2JLLRupH8uFqI04/mRXN/FCIQvxZTxX3NJvEjwrcpYmk05cIsCJqW+F55RqQnl1Xja+v8YCETyzE068XRKIRa47CkH5wL7bchzqE9TeRbH/lMjLN8IEt5huYRdb3TsKvLmJRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787550606; c=relaxed/simple;
	bh=3tcl0qNW+p7DYm8Cx+kDi1WCPGllcVeiDy6+NXxIejk=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tCwEOJLrBe9xxvuhqdynywItIGznnXmZFuj2iMv/T2Pxl574q4YoLJ605pmJ4Krzd+JpSPdBeRnFAgVNlMClDpdYrPKirdxRKdKLw957n6R8Ub/YOAnCk+3QipPO7/5nxUg8p+6EZzZeD2wqSerQzDSDs1t7bvxS/Jt63p0Kgnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=D7Z7yKAj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D7Z7yKAj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+yH9MEUgstGWkliTTEIPhXKbSa7E4o58nwQfPfwuLRw=; b=D7Z7yKAj9Cq5X83/uB+gvnrQMW
	OqgZyi0G9tGk+KSFiA6+S79RTIu9M7IWlveKelww7yUPqXzNdtRqoMydyruYicaYriXc/REbRys1+
	NbaR1jDEia9DRO2pSYv/JvcVvDcrxWKeVKhdUxyxK+BeiTZMUnaIuuX9UkI7Em/uDFG59SoSe43wp
	+zDBVb6i5jH3fPc2uJ1jrNHCLdvwDxXCRri/BBEwkvtyaoZBDbY8dPoULBJayJbW8eK64lObDIWXX
	DoQf0YJK8shmc1KKjxkQucoxZw6Mto+0ixLnoDfjlgGzAziOQ42PT8W+0EMcrFmU9M28/ynZCxI4v
	adoebYVg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyNZJ-0000000Fx13-1GtJ;
	Mon, 24 Aug 2026 05:50:01 +0000
Date: Sun, 23 Aug 2026 22:50:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Zorro Lang <zlang@redhat.com>, fstests@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 3/5] generic/746: skip on zoned btrfs
Message-ID: <aovbiVms7w-_VJn4@infradead.org>
References: <20260819131606.1478488-1-johannes.thumshirn@wdc.com>
 <20260819131606.1478488-4-johannes.thumshirn@wdc.com>
 <aofkT7rrfQYCr6yK@infradead.org>
 <aovWTFh_7Xo1s_i7@zlang-mailbox>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aovWTFh_7Xo1s_i7@zlang-mailbox>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Aug 24, 2026 at 01:41:41PM +0800, Zorro Lang wrote:
> > Shouldn't _require_fstrim return false for zoned btrfs given that
> > trimming makes zero sense?  Otherwise once zoned btrfs at some point
> > supports fpunch (which it really should), this starts breaking again.
> 
> Currently _require_fstrim only checks whether the FSTRIM_PROG binary is
> installed, can _require_batched_discard help that? Or should we explicitly
> skip zoned btrfs inside this helper?

Given that this test already explicitly checks for supported file
systems, that's probably the best.

