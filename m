From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: Re: Data-deduplication?
Date: Fri, 17 Oct 2008 14:24:04 -0400
Message-ID: <20081017182404.GF16946@shell>
References: <20081012020629.GA14615@bludgeon.org> <1223895734.7032.1.camel@think.oraclecorp.com> <20081016192501.GE16946@shell> <1224185449.6938.81.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ray Van Dolson <rayvd@bludgeon.org>, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224185449.6938.81.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 16, 2008 at 03:30:49PM -0400, Chris Mason wrote:
> On Thu, 2008-10-16 at 15:25 -0400, Valerie Aurora Henson wrote:
> > 
> > Both deduplication and compression have an interesting side effect in
> > which a write to a previously "allocated" block can return ENOSPC.
> > This is even more exciting when you factor in mmap.  Any thoughts on
> > how to handle this?
> 
> Unfortunately we'll have a number of places where ENOSPC will jump in
> where people don't expect it, and this includes any COW overwrite of an
> existing extent.  The old extent isn't freed until snapshot deletion
> time, which won't happen until after the current transaction commits.
> 
> Another example is fallocate.  The extent will have a little flag that
> says I'm a preallocated extent, which is how we'll know we're allowed to
> overwrite it directly instead of doing COW.
> 
> But, to write to the fallocated extent, we'll have to clear the flag.
> So, we'll have to cow the block that holds the file extent pointer,
> which means we can enospc.

I'm sure you know this, but for the peanut gallery: You can avoid some
of these sort of purely copy-on-write ENOSPC cases.  Any operation
where the space used afterwards is less than or equal to the space
used before - like in your fallocate case - can avoid ENOSPC as long
as you reserve a certain amount of space on the fs and break down the
changes into small enough groups.  Most file systems don't let you
fill up beyond 90-95% anyway because performance goes to hell.  You
also need to do this so you can delete when your file system is full.

In general, it'd be nice to say that if your app can't handle suprise
ENOSPC, then if you run without snapshots, compression, or data dedup,
we guarantee you'll only get ENOSPC in the "normal" cases.  What do
you think?

-VAL
