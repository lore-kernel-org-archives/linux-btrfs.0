From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Btrfs for mainline
Date: Sat, 3 Jan 2009 14:12:59 -0700
Message-ID: <20090103211258.GB2002@parisc-linux.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <20090103195034.GA27541@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090103195034.GA27541@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 03, 2009 at 02:50:34PM -0500, Christoph Hellwig wrote:
> On Sat, Jan 03, 2009 at 12:17:06PM -0700, Matthew Wilcox wrote:
> > It's no worse than XFS (which still has its own implementation of
> > 'synchronisation variables',
> 
> Which are a trivial wrapper around wait queues.  I have patches to kill
> them, but I'm not entirely sure it's worth it

I'm not sure it's worth it either.

> > a (very thin) wrapper around mutexes,
> 
> nope.

It's down to:

typedef struct mutex mutex_t;

but it's still there.

> > a
> > (thin) wrapper around rwsems,
> 
> Which are needed so we can have asserts about the lock state, which
> generic rwsems still don't have.  At some pointer Peter looked into
> it, and once we have that we can kill the wrapper.

Good to know.  Rather like btrfs's wrappers around mutexes then ...

> > > - compat.h needs to go
> > 
> > Later.  It's still there for XFS.
> 
> ?

XFS still has 'fs/xfs/linux-2.6'.  It's a little bigger than compat.h,
for sure, and doesn't contain code for supporting different Linux
versions, sure.  But it's still a compat layer.

> > > - there should be manpages for all the ioctls and other interfaces.
> > 
> > I wonder if Michael Kerrisk has time to help with that.  Cc'd.
> 
> Actually a lot of the ioctl API don't just need documentation but
> a complete redo.  That's true at least for the physical device
> management and subvolume / snaphot ones.

That's a more important critique than Andi's.  Let's take care of that.

> From painfull experience with a lot of things, including a filesystem
> you keep on mentioning it's clear that once stuff is upstream there
> is very little to no incentive to fix these things up.

I don't think that's as true of btrfs as it was of XFS -- for example,
Chris has no incentive to keep compatibility with IRIX, or continue to
support CXFS.  I don't think 'getting included in kernel' is Chris'
goal, so much as it is a step towards making btrfs better.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
