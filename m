From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Oops while rebalancing, now unmountable.
Date: Sun, 14 Nov 2010 17:00:18 -0500
Message-ID: <20101114220018.GA4512@infradead.org>
References: <1289236257.3611.3.camel@mars>
 <1289310046-sup-839@think>
 <1289326892.4231.2.camel@mars>
 <1289764507.4303.9.camel@mars>
 <20101114204206.GV6809@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shane Shrybman <shrybman@teksavvy.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
To: Andrea Arcangeli <aarcange@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101114204206.GV6809@random.random>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 14, 2010 at 09:42:06PM +0100, Andrea Arcangeli wrote:
> btrfs misses this:
> 
> +       .migratepage    = btree_migratepage,
> 
> It's a bug that can trigger upstream too (not only with THP) if there
> are hugepage allocations (like while incrasing nr_hugepages). Chris
> already fixed it with an experimental patch.

If the lack of an obscure method causes data corruption something
is seriously wrong with THP.  At least from the 10.000 foot view
I can't quite figure what the exact issue is, though.
fallback_migrate_page seems to do the right thing to me for that
case.

Btw, there's also another issue with the page migration code when used
for filesystem pages.  If directly calls into ->writepage instead
of using the flusher threads.  On most filesystems this will
"only" cause nasty I/O patterns, but on ext4 for example it will
be more nasty as ext3 doesn't do conversions from delayed allocations to
real ones.  So unless you're doing a lot of overwrites it will be
hard to make any progress in writeout().

Btw, what codepath does THP call migrate_pages from?  If you don't
use an explicit thread writeout will be a no-op on btrfs and XFS, too.
