From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Btrfs for mainline
Date: Sat, 3 Jan 2009 14:50:34 -0500
Message-ID: <20090103195034.GA27541@infradead.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090103191706.GA2002@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 03, 2009 at 12:17:06PM -0700, Matthew Wilcox wrote:
> It's no worse than XFS (which still has its own implementation of
> 'synchronisation variables',

Which are a trivial wrapper around wait queues.  I have patches to kill
them, but I'm not entirely sure it's worth it

> a (very thin) wrapper around mutexes,

nope.

> a
> (thin) wrapper around rwsems,

Which are needed so we can have asserts about the lock state, which
generic rwsems still don't have.  At some pointer Peter looked into
it, and once we have that we can kill the wrapper.

and wrappers around kmalloc and kmem_cache.
> 
> > - compat.h needs to go
> 
> Later.  It's still there for XFS.

?

> > - there should be manpages for all the ioctls and other interfaces.
> 
> I wonder if Michael Kerrisk has time to help with that.  Cc'd.

Actually a lot of the ioctl API don't just need documentation but
a complete redo.  That's true at least for the physical device
management and subvolume / snaphot ones.

> > - various checkpath.pl level problems I think (e.g. printk levels) 
> 
> Can be fixed up later.
> 
> > - the printks should all include which file system they refer to
> 
> Ditto.

>From painfull experience with a lot of things, including a filesystem
you keep on mentioning it's clear that once stuff is upstream there
is very little to no incentive to fix these things up.

