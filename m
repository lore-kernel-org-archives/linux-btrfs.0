From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Mon, 15 Nov 2010 14:03:55 -0500
Message-ID: <1289847339-sup-4591@think>
References: <1289236257.3611.3.camel@mars> <1289310046-sup-839@think> <1289326892.4231.2.camel@mars> <1289764507.4303.9.camel@mars> <20101114204206.GV6809@random.random> <20101114220018.GA4512@infradead.org> <20101114221222.GX6809@random.random> <20101115182314.GA2493@infradead.org> <20101115184657.GJ6809@random.random>
Content-Type: text/plain; charset=UTF-8
Cc: Christoph Hellwig <hch@infradead.org>,
        Shane Shrybman <shrybman@teksavvy.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
In-reply-to: <20101115184657.GJ6809@random.random>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrea Arcangeli's message of 2010-11-15 13:46:57 -0500:
> On Mon, Nov 15, 2010 at 01:23:14PM -0500, Christoph Hellwig wrote:
> > On Sun, Nov 14, 2010 at 11:12:22PM +0100, Andrea Arcangeli wrote:
> > > +static int btree_migratepage(struct address_space *mapping,
> > > +                       struct page *newpage, struct page *page)
> > > +{
> > > +       /*
> > > +        * we can't safely write a btree page from here,
> > > +        * we haven't done the locking hook
> > > +        */
> > > +       if (PageDirty(page))
> > > +               return -EAGAIN;
> > >=20
> > > fallback_migrate_page would call writeout() which is apparently not
> > > ok in btrfs for locking issues leading to corruption.
> >=20
> > Hmm, it seems the issue for that particular problem is indeedin btrfs=
.
>=20
> I've been reading the writeout() in mm/migrate.c and I wonder if maybe
> that should have been WB_SYNC_ALL or if we miss a
> wait_on_page_writeback in after ->writepage() returns? Can you have a
> look there? We check the PG_writeback bit when the page is not dirty
> (well before fallback_migrate_page is called), but after calling
> writeout() we don't return to wait on PG_writeback. We make sure to
> hold the page lock after ->writepage returns but that doesn't mean
> PG_writeback isn't still set.

It always returns either -EIO or -EAGAIN, so the caller will try again
and then end up waiting on PageWriteback?

>=20
> > If it needs external locking for writing out data it should not
> > implement ->writepage to start with.  Chris, can you explain what's
> > going on with the btree code? It's pretty funny both in the
> > btree_writepage which goes directly into extent_write_full_page
> > if PF_MEMALLOC is not set, but otherwise does much more complicated
> > work, and also in btree_writepages which skips various WB_SYNC_NONE,
> > including the very weird check for for_kupdate.
> >=20
> > What's the story behing all this and the corruption that Andrea found=
?
> >=20
> > > > Btw, what codepath does THP call migrate_pages from?  If you don'=
t
> > > > use an explicit thread writeout will be a no-op on btrfs and XFS,=
 too.
> > >=20
> > > THP never calls migrate_pages, it's memory compaction that calls it
> > > from inside alloc_pages(order=3D9). It got noticed only with THP be=
cause
> > > it makes more frequent hugepage allocations than nr_hugepages in
> > > hugetlbfs (and maybe there are more THP users already).
> >=20
> > Well, s/THP/compaction/ and the same problem applies.  The modern
> > filesystem all have stopped from writeback happening either at all
> > or at least for the delalloc case from direct reclaim.  Calling
> > into this code from alloc_pages for filesystem backed pages is thus
> > rather pointless.
>=20
> Compaction practically only happens in the context of the task
> allocating memory (in my tree it is also used by kswapd). Not
> immediate to ask a separate daemon to invoke it. Not sure why this
> should screw delalloc. Compaction isn't freeing any memory at all,
> it's not reclaim. It just defragments and moves stuff around and it
> may have to write dirty pages to do so.

The short version is that when the VM jumps in and starts doing single
page IO, we badly fragment files.  The FS wants writepages for
everything, so that we can do smart delayed allocation and so that we
can write out things in units bigger than 4KB.

We most recently hashed this out in threads with Mel Gorman around
balance_dirty_pages, but it has a very big impact on performance.

-chris

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
