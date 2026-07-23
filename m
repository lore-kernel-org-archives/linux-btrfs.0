Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF8443B3D1;
	Thu, 23 Jul 2026 12:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808011; cv=none; b=s6E31JpJIX+eSzul7NEd4P1lDbEGjCnLesEYf+V3L4OU8qZfeXU6n5byKr4l0s6Qmr2S082PzM+gACLwT6Q1f/1hLBWQk5dFTCubaSXVm62ffcAAR/TyMAvn/gpA+RQkJoIyLUO3XA+Zc+oDQw0gOHoxFHj0wZUm2tfR4fxsK7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808011; c=relaxed/simple;
	bh=vl0TeuTcWnosTAVKcGI0I4lkggB1UVzt9mBoGeLJF0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLEgURe8nFt6rFUZAh92c+Srpc9AbeIYAJw8Ue4NI/5fYpnqfZkExBAUNijo1a6FuHZGLKPKlmMyBxePUEoJiXiCl5zLIZ4ovJsC2Pr11Qio1pd+R43AAtw5LWx2Q046clU7rc+eRZJalSnxk5zmjSI+UBbAKzJzojdg4G0y5mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=pass smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MHyabGz3; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MHyabGz3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=c4hElVqmYpqUsdMIDfblHdUXoaZAp8PegjmWKWhCfi0=; b=MHyabGz3a+YQkwKLmY93en+C9q
	V3KyBg0TsuClrun8CjqP00/AdTEnKuRdi0xjGvsJ0thjHbQPuiMXgPmZu/3ticfErRaRG+XTDJg31
	WqoM4h3w8B/SknpDK78zm6lk+beGWfs1oGFFRDgoUSS2yVqDFVGNDBiTGCGiIPNmGY5YJ9WqQIh3R
	b3Bmqvmn7Ejq0BXm+oMUDJuRBiYdLpERczqWZwKrLGutLbmpZRQtmt6saykl6+AOnzslJi43hJjit
	VBeX/GbxaWFqD8g6BNzaebWGbKWvRQwBtIoi3TS90ETdg6JGTLyAboSWSBi7IslW/LgW785QvN8Nw
	uB6TxpWw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wms5p-00000000S92-3D48;
	Thu, 23 Jul 2026 12:00:01 +0000
Date: Thu, 23 Jul 2026 13:00:01 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
	linux-btrfs@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
Message-ID: <amICQYTK9Xu4KLtH@casper.infradead.org>
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
 <amC-J7yzwk4Z5tHW@casper.infradead.org>
 <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ad6eebbd-07f8-41ce-b04c-edd50d91a6e3@gmx.com>

On Thu, Jul 23, 2026 at 10:12:27AM +0930, Qu Wenruo wrote:
> 
> 
> 在 2026/7/22 22:27, Matthew Wilcox 写道:
> > On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
> > >   *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
> > >   *      Whenever a full clean cycle (clear_page_dirty_for_io(),
> > >   *      writeback, bits cleared) completes inside thread A's
> > >   *      submission->completion window, the completion-time
> > >   *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
> > >   *      sets only the folio flag and the xarray tag - no btrfs subpage
> > >   *      dirty bit, no delalloc reservation.  See the 20-year-old comment
> > >   *      above bio_set_pages_dirty() in block/bio.c describing exactly
> > >   *      this ("other code (eg, flusher threads) could clean the pages").
> > 
> > There's your problem.  filemap_dirty_folio() documents that btrfs is
> > doing it wrongly:
> > 
> >   * Filesystems which do not use buffer heads should call this function
> >   * from their dirty_folio address space operation.  It ignores the
> >   * contents of folio_get_private(), so if the filesystem marks individual
> >   * blocks as dirty, the filesystem should handle that itself.
> > 
> > fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,
> > 
> > so btrfs should have its own btrfs_dirty_folio() which does whatever
> > metadata updates it needs to and then call filemap_dirty_folio() to
> > take care of the page cache business.  See iomap_dirty_folio() as
> > an example, but many other filesystems also do this.
> 
> Thanks a lot for the advice.
> 
> However it looks like the sub-folio dirty block tracking is a little
> different between iomap and btrfs.

My point is not that "you should do it the exact same way as iomap".
Rather "the dirty_folio op is the entry point to tell the filesystem
that a folio is being dirtied".  And you aren't taking advantage of
that, you're just calling the VFS so the VFS can do its own tracking.

> E.g. iomap will mark the full folio range dirty even if the EOF is inside
> the folio, but btrfs will only mark the range inside EOF as dirty.
> 
> 
> Another thing is, even if we follow iomap to mark the full folio dirty, it's
> still not the end of the story.
> 
> We have other supporting mechanisms required to tracking the dirty range.
> E.g. EXTENT_DELALLOC flags inside extent-io-tree, indicating we have already
> reserved space for the dirty range.
> 
> Only with EXTENT_DELALLOC flag set, we will do the real delayed allocation,
> allocating the on-disk extents etc.
> 
> So even if we always mark the full folio dirty, the writeback path will not
> handle them correctly either.
> 
> 
> Finally, even without large folios, the reproducer can already cause
> problems on btrfs. E.g. on x86_64, with mapping_set_folio_order_range()
> disabled.
> 
> The symptom there is that, ordered extent accounting underflows, which may
> also contribute to the stall observed.
> 
> I'll keep digging for this bug.
> 
> Thanks,
> Qu
> 
> 
