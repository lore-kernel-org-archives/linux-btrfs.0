From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Data-deduplication?
Date: Thu, 16 Oct 2008 15:30:49 -0400
Message-ID: <1224185449.6938.81.camel@think.oraclecorp.com>
References: <20081012020629.GA14615@bludgeon.org>
	 <1223895734.7032.1.camel@think.oraclecorp.com>
	 <20081016192501.GE16946@shell>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ray Van Dolson <rayvd@bludgeon.org>, linux-btrfs@vger.kernel.org
To: Valerie Aurora Henson <vaurora@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081016192501.GE16946@shell>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2008-10-16 at 15:25 -0400, Valerie Aurora Henson wrote:
> On Mon, Oct 13, 2008 at 07:02:14AM -0400, Chris Mason wrote:
> > On Sat, 2008-10-11 at 19:06 -0700, Ray Van Dolson wrote:
> > > I recall their being a thread here a number of months back regarding
> > > data-deduplication support for bttfs.
> > > 
> > > Did anyone end up picking that up and giving a go at it?  Block level
> > > data dedup would be *awesome* in a Linux filesystem.  It does wonders
> > > for storing virtual machines w/ NetApp and WAFL, and even ZFS doesn't
> > > have this feature yet (although I've read discussions on them looking
> > > to add it).
> > > 
> > 
> > So far nobody has grabbed this one, but I've had more requests (no
> > shocker there, the kvm people are interested in it too).  It probably
> > won't make 1.0 but the disk format will be able to support it.
> 
> Both deduplication and compression have an interesting side effect in
> which a write to a previously "allocated" block can return ENOSPC.
> This is even more exciting when you factor in mmap.  Any thoughts on
> how to handle this?

Unfortunately we'll have a number of places where ENOSPC will jump in
where people don't expect it, and this includes any COW overwrite of an
existing extent.  The old extent isn't freed until snapshot deletion
time, which won't happen until after the current transaction commits.

Another example is fallocate.  The extent will have a little flag that
says I'm a preallocated extent, which is how we'll know we're allowed to
overwrite it directly instead of doing COW.

But, to write to the fallocated extent, we'll have to clear the flag.
So, we'll have to cow the block that holds the file extent pointer,
which means we can enospc.

-chris


