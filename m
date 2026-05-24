Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE3A318ED7;
	Sun, 24 May 2026 19:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779652759; cv=none; b=Kbbdb46Q2YONGQMWKzD43z+ja8IKCIX4H8RG1bd63TfWAQoF/b99Yb5puIZ4wOC0rR2A8Qm2LhN0mYCm8h/moBM85aidVG1Ck5SvQLNSli5zgqh3LF5POUlgUV35W74OHY6097ioG0UEOf2qDE54KotkkNDbWWrKfjxuLUk3PF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779652759; c=relaxed/simple;
	bh=vRK8WPnBXnje2OfwocMhmtTvZTVmtqse7kTrbfVDoHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VxD6cfiQ8goqVHBh7mPQkVop4vR6id2v2Y7LntQxX1GyQFhsRvapNrq5/XIEie36iQdZOH7RqEq+ywjSTJt54ZzT1KdUPttZr5+wsgNUmYfhE9CTp/kxl1LCky8FJoP6sjZNPBQOgUZl+5cFrghqkBe7su9ukg/CebJFwLxcItM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ar8psj0a; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ar8psj0a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hHpA1ZzkYv5b4KN+kSM30g2nFp55AVavdrQfo+cc1Sk=; b=Ar8psj0aA9bZQFqkFB4Ib+13Hw
	F+c1DCDGmUEgM9duLy0u5PP3NQBgnveoGxvWrWHxGUGv0/pAyj35OTieGeOnoM1QFhM5kM77gLVnU
	izfepiRzekqLwdZYiN+bgYSc2s82Z9rUcvn5gRJbvXm6pOy1hlniOTaYX51pGSnP914KyOEUi7VuJ
	HFfQWSJP8VNfhk8Q/EpR+XNKlk0ybostK3QtTfmOUpSoLaijv60paSpTqp9OVOXthz8SlRpMTpXtz
	cJQbH6zaoAm9oGe08LRC8YswGDBnhPd+9LONhVhVvO5VF99lrNdqRUwQ6iIxMqaQZWscSLkVS2915
	JLvmMD5w==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wREyb-0000000ChJ8-23fg;
	Sun, 24 May 2026 19:59:09 +0000
Date: Sun, 24 May 2026 20:59:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	linux-mm@kvack.org, david@kernel.org, surenb@google.com,
	hannes@cmpxchg.org, ljs@kernel.org, ziy@nvidia.com,
	usama.arif@linux.dev, fvdl@google.com, Chris Mason <clm@meta.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH 34/40] btrfs: allocate eb-attached btree pages as
 movable
Message-ID: <ahNYjY1aQlgOehlm@casper.infradead.org>
References: <20260520150018.2491267-1-riel@surriel.com>
 <20260520150018.2491267-35-riel@surriel.com>
 <20260520174749.GA1458531@zen.localdomain>
 <20260523155859.GF183694@suse.cz>
 <daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <daa29c92f055d028a5b3ec0e42cfb1ee1496a593.camel@surriel.com>

On Sat, May 23, 2026 at 09:43:23PM -0400, Rik van Riel wrote:
> On Sat, 2026-05-23 at 17:58 +0200, David Sterba wrote:
> > On Wed, May 20, 2026 at 10:47:49AM -0700, Boris Burkov wrote:
> > > My gut says it is nicer to just transparently pass along a gfp flag
> > > rather than a carefully documented movable boolean and let the
> > > callers
> > > do the right thing. Just a nit, I don't care strongly about it.
> > 
> > Agreed, the GFP flags would be better and also a bit more self
> > documenting where the functions are called. The patch is not
> > standalone
> > so I don't mind having the booleans, we can clean it up later to let
> > the
> > 40-patch series proceed.
> 
> 
> I think this patch could go in by itself. It doesn't
> depend on anything else in the series.
> 
> I sent it with this series mostly because it's needed
> to make the series work, and to provide context on why
> it's needed.
> 
> I'm happy to resend it with a GFP mask passed in by
> each caller. That would look better, indeed!

If you're respinning anyway ...

Every use of GFP_NOFS is a bad code smell.  Filesystems should be using
memalloc_nofs_save/restore.  The problem is that it takes deep filesystem
knowledge to understand where the memalloc_nofs_save() should start.
It would be good to lift the GFP_NOFS to the callers of this function as
it gets us slightly closer to being able to replace it with GFP_KERNEL
in the places it's not actually needed.

ie what I'm asking for is, please don't do the 'extra_gfp' thing.
Just pass in gfp from the callers and make them all pass in GFP_NOFS |
__GFP_MOVABLE (or a plain GFP_NOFS) for now.  Someone can come along
later and change them to GFP_KERNEL later where warranted.
