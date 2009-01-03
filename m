From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Btrfs for mainline
Date: Sat, 3 Jan 2009 12:17:06 -0700
Message-ID: <20090103191706.GA2002@parisc-linux.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <87r63ljzox.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 02, 2009 at 08:05:50PM +0100, Andi Kleen wrote:
> Some items I remember from my last look at the code that should
> be cleaned up before mainline merge (that wasn't a full in depth review):
> 
> - locking.c needs a lot of cleanup.
> If combination spinlocks/mutexes are really a win they should be 
> in the generic mutex framework. And I'm still dubious on the hardcoded 
> numbers.

I don't think this needs to be cleaned up before merge.  I've spent
an hour or two looking at it, and while we can do a somewhat better
job as part of the generic mutex framework, it's quite tricky (due to
the different <asm/mutex.h> implementations).  It has the potential to
introduce some hard-to-hit bugs in the generic mutexes, and there's some
API discussions to have.

It's no worse than XFS (which still has its own implementation of
'synchronisation variables', a (very thin) wrapper around mutexes, a
(thin) wrapper around rwsems, and wrappers around kmalloc and kmem_cache.

> - compat.h needs to go

Later.  It's still there for XFS.

> - there's various copy'n'pasted code from the VFS (like may_create) 
> that needs to be cleaned up.

No urgency here.

> - there should be manpages for all the ioctls and other interfaces.

I wonder if Michael Kerrisk has time to help with that.  Cc'd.

> - ioctl.c was not explicitely root protected. security issues?

This does need auditing.

> - some code was severly undercommented.
> e.g. each file should at least have a one liner
> describing what it does (ideally at least a paragraph). Bad examples
> are export.c or free-space-cache.c, but also others.

Nice to have, but generally not required.

> - ENOMEM checks are still missing all over (e.g. with most of the 
> btrfs_alloc_path callers). If you keep it that way you would need
> at least XFS style "loop for ever" alloc wrappers, but better just
> fix all the callers. Also there used to be a lot of BUG_ON()s on
> memory allocation failure even.
> - In general BUG_ONs need review I think. Lots of externally triggerable
> ones.

Agreed on these two.

> - various checkpath.pl level problems I think (e.g. printk levels) 

Can be fixed up later.

> - the printks should all include which file system they refer to

Ditto.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
