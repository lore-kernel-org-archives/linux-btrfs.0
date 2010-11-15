From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Mon, 15 Nov 2010 14:18:22 -0500
Message-ID: <1289848574-sup-2632@think>
References: <1289236257.3611.3.camel@mars> <1289310046-sup-839@think> <1289326892.4231.2.camel@mars> <1289764507.4303.9.camel@mars> <20101114204206.GV6809@random.random> <20101114220018.GA4512@infradead.org> <20101114221222.GX6809@random.random> <20101115182314.GA2493@infradead.org> <20101115184657.GJ6809@random.random> <20101115191204.GB11374@infradead.org>
Content-Type: text/plain; charset=UTF-8
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Shane Shrybman <shrybman@teksavvy.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
In-reply-to: <20101115191204.GB11374@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Christoph Hellwig's message of 2010-11-15 14:12:04 -0500:
> On Mon, Nov 15, 2010 at 07:46:57PM +0100, Andrea Arcangeli wrote:
> > I've been reading the writeout() in mm/migrate.c and I wonder if mayb=
e
> > that should have been WB_SYNC_ALL or if we miss a
> > wait_on_page_writeback in after ->writepage() returns? Can you have a
> > look there? We check the PG_writeback bit when the page is not dirty
> > (well before fallback_migrate_page is called), but after calling
> > writeout() we don't return to wait on PG_writeback. We make sure to
> > hold the page lock after ->writepage returns but that doesn't mean
> > PG_writeback isn't still set.
>=20
> I didn't even notice that, but the WB_SYNC_NONE does indeed seem
> buggy to me.  If we set the sync_mode to WB_SYNC_NONE filesystem
> can and frequently do trylock operations and might just skip to
> write it out completely.
>=20
> So we defintively do need to change writeout to do a WB_SYNC_ALL
> writeback.  In addition to that we'll also need the
> wait_on_page_writeback call to make sure we actually wait for I/O
> to finish.
>=20
> Also what protects us from updating the page while we write it out?
> PG_writeback on many filesystems doesn't protect writes from modifying
> the in-flight buffer, and just locking the page after ->writepage
> is racy without a check that nothing changed.
>=20

Oh, I should have thought of that.  Btrfs (and most of the time xfs?)
will wait on PageWriteback internally, but for the ext crowd we're in
trouble.

-chris

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom policy in Canada: sign http://dissolvethecrtc.ca/
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
