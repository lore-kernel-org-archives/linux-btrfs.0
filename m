Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1AA30568F;
	Mon, 25 May 2026 06:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779692270; cv=none; b=HJoTdANXA0MpE0OpF+v5R/bsn3Jb5/dSrRrASLje912ckxzM5jOGbMXO0bkgkKT+mksa6y4saebgfA6CBXaOvGAV8O2IeWt+cHAE8rFlMXVwwXt/6rA0nIWHxORpNrgeqQcHT3oMNQiTmcvGSfoyp0BotfJRRApRjJHpI23ACvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779692270; c=relaxed/simple;
	bh=PAs/Z93IV9B5x4AAfzT7HBGhUppKtqjIcnFRDDaSaGI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QCnhZ+wRfuTho2NeU3EUQac5nYyLKuqtPtPQzifBYTQWkgMzBL2lXKiPCJ9eJ3jOWjgvUOMozoehjhDCAB68MHu81Pgu7uKynNYZt1F42Kh4gzLJHnny/1ts1H8XEvF05/1esMPmQROEIhmtavTSMFmNU++WZx0g7uD1ItFeDR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QUI4ZzFw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QUI4ZzFw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=W5p3AvS0xdML2EzDjatAHJdIboLFfBJpjK7i1jwoXuM=; b=QUI4ZzFwVqog0cjI4lGEZLbGmo
	uitDcKoLRwLqqTIeFDbo6xgSetgUCp6z0TeJkYv5hq3Q9aJ+MoMj8caLbPuj4BlRlGOnOLgQSzEi7
	e0R4FWCAEMeBlO0OvDn+VpgOLTEAz8E1/bfzC2I0RW0FpKPSLu3trSCps7qFs0whiFgYzGjtuAoht
	+d1Wtew9q80JGg80Kq8mjESGGXbSsy8oVhVzaKrqoVHGh2S7cViZhMiEp+uo7AQJnzC6kgMIPG/7m
	eA7YO0K23m90+GR0pz3Jxm6lE9JorQExRX2ZIfBihgRR75gbbPT9bZuOmGMu1aXqQuyIStIHJgyZx
	RZ/AkIEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRPFu-0000000GThS-18DE;
	Mon, 25 May 2026 06:57:42 +0000
Date: Sun, 24 May 2026 23:57:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>, dsterba@suse.cz,
	Boris Burkov <boris@bur.io>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, linux-mm@kvack.org, david@kernel.org,
	surenb@google.com, hannes@cmpxchg.org, ljs@kernel.org,
	ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com,
	Chris Mason <clm@meta.com>, David Sterba <dsterba@suse.com>,
	linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
Message-ID: <ahPy5sZfkqwkB1FT@infradead.org>
References: <20260520150018.2491267-1-riel@surriel.com>
 <20260520150018.2491267-35-riel@surriel.com>
 <20260520174749.GA1458531@zen.localdomain>
 <20260523155859.GF183694@suse.cz>
 <daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com>
 <ahNYjY1aQlgOehlm@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahNYjY1aQlgOehlm@casper.infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, May 24, 2026 at 08:59:09PM +0100, Matthew Wilcox wrote:
> Every use of GFP_NOFS is a bad code smell.  Filesystems should be using
> memalloc_nofs_save/restore.  The problem is that it takes deep filesystem
> knowledge to understand where the memalloc_nofs_save() should start.
> It would be good to lift the GFP_NOFS to the callers of this function as
> it gets us slightly closer to being able to replace it with GFP_KERNEL
> in the places it's not actually needed.
> 
> ie what I'm asking for is, please don't do the 'extra_gfp' thing.
> Just pass in gfp from the callers and make them all pass in GFP_NOFS |
> __GFP_MOVABLE (or a plain GFP_NOFS) for now.  Someone can come along
> later and change them to GFP_KERNEL later where warranted.

Note that is should be pretty trivial to just bubble it up a layer
for changes like this.  This will naturally gravitate to more useful
places.  To make it fully correct it will need manual intervention,
but generally bubbling up should improve the situation.

Same for GFP_NOIO.
