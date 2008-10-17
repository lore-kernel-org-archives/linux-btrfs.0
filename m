From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Data-deduplication?
Date: Fri, 17 Oct 2008 16:10:46 -0400
Message-ID: <20081017201046.GA20862@infradead.org>
References: <20081012020629.GA14615@bludgeon.org> <1223895734.7032.1.camel@think.oraclecorp.com> <20081016192501.GE16946@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Ray Van Dolson <rayvd@bludgeon.org>,
	linux-btrfs@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081016192501.GE16946@shell>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 16, 2008 at 03:25:01PM -0400, Valerie Aurora Henson wrote:
> Both deduplication and compression have an interesting side effect in
> which a write to a previously "allocated" block can return ENOSPC.
> This is even more exciting when you factor in mmap.  Any thoughts on
> how to handle this?

Note that this can already happen in todays filesystems.  Writing into
some preallocated space can always cause splits of the allocation or
bmap btrees as the pervious big preallocated extent now is split into
one allocated and at least one (or two if writing into the middle)
preallocated extents.

