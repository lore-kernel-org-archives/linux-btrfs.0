From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Btrfs for mainline
Date: Mon, 05 Jan 2009 11:30:15 -0500
Message-ID: <1231173015.4290.129.camel@think.oraclecorp.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
	 <200901060147.24285.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <peterz@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200901060147.24285.nickpiggin@yahoo.com.au>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 01:47 +1100, Nick Piggin wrote:

[ adaptive locking in btrfs ]

> adaptive locks have traditionally (read: Linus says) indicated the locking
> is suboptimal from a performance perspective and should be reworked. This
> is definitely the case for the -rt patchset, because they deliberately
> trade performance by change even very short held spinlocks to sleeping locks. 
> 
> So I don't really know if -rt justifies adaptive locks in mainline/btrfs.
> Is there no way for the short critical sections to be decoupled from the
> long/sleeping ones?

Yes and no.  The locks are used here to control access to the btree
leaves and nodes.  Some of these are very hot and tend to stay in cache
all the time, while others have to be read from the disk.

As the btree search walks down the tree, access to the hot nodes is best
controlled by a spinlock.  Some operations (like a balance) will need to
read other blocks from the disk and keep the node/leaf locked.  So it
also needs to be able to sleep.

I try to drop the locks where it makes sense before sleeping operatinos,
but in some corner cases it isn't practical.

For leaves, once the code has found the item in the btree it was looking
for, it wants to go off and do something useful (insert an inode etc
etc). Those operations also tend to block, and the lock needs to be held
to keep the tree block from changing.

All of this is a long way of saying the btrfs locking scheme is far from
perfect.  I'll look harder at the loop and ways to get rid of it.

-chris


