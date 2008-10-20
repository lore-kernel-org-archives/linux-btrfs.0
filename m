From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data-deduplication?
Date: Sun, 19 Oct 2008 20:16:31 -0400
Message-ID: <1224461791.27474.17.camel@think.oraclecorp.com>
References: <20081012020629.GA14615@bludgeon.org>
	 <1223895734.7032.1.camel@think.oraclecorp.com>
	 <20081016192501.GE16946@shell>
	 <1224185449.6938.81.camel@think.oraclecorp.com>
	 <20081017182404.GF16946@shell>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ray Van Dolson <rayvd@bludgeon.org>, linux-btrfs@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081017182404.GF16946@shell>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2008-10-17 at 14:24 -0400, Valerie Aurora Henson wrote:
> On Thu, Oct 16, 2008 at 03:30:49PM -0400, Chris Mason wrote:
> > On Thu, 2008-10-16 at 15:25 -0400, Valerie Aurora Henson wrote:
> > > 
> > > Both deduplication and compression have an interesting side effect in
> > > which a write to a previously "allocated" block can return ENOSPC.
> > > This is even more exciting when you factor in mmap.  Any thoughts on
> > > how to handle this?
> > 
> > Unfortunately we'll have a number of places where ENOSPC will jump in
> > where people don't expect it, and this includes any COW overwrite of an
> > existing extent.  The old extent isn't freed until snapshot deletion
> > time, which won't happen until after the current transaction commits.
> > 
> > Another example is fallocate.  The extent will have a little flag that
> > says I'm a preallocated extent, which is how we'll know we're allowed to
> > overwrite it directly instead of doing COW.
> > 
> > But, to write to the fallocated extent, we'll have to clear the flag.
> > So, we'll have to cow the block that holds the file extent pointer,
> > which means we can enospc.
> 
> I'm sure you know this, but for the peanut gallery: You can avoid some
> of these sort of purely copy-on-write ENOSPC cases.  Any operation
> where the space used afterwards is less than or equal to the space
> used before - like in your fallocate case - can avoid ENOSPC as long
> as you reserve a certain amount of space on the fs and break down the
> changes into small enough groups.  Most file systems don't let you
> fill up beyond 90-95% anyway because performance goes to hell.  You
> also need to do this so you can delete when your file system is full.
> 
> In general, it'd be nice to say that if your app can't handle suprise
> ENOSPC, then if you run without snapshots, compression, or data dedup,
> we guarantee you'll only get ENOSPC in the "normal" cases.  What do
> you think?

I think I'll have to come back to this after getting ENOSPC to work at
all ;)  You're right that reserved space can do wonders to dig us out of
holes, it has to be reserved at a multiple of the number of procs that I
allow into the transaction.

I should be able to go into an emergency one writer at a time theme as
space gets really tight, but there are lots of missing pieces that
haven't been coded yet in that area.

-chris


