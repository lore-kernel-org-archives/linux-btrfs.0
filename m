From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 10:05:11 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
References: <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins>
 <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090115174440.GF29283@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 15 Jan 2009, Matthew Wilcox wrote:
> 
> I asked a couple of our benchmarking teams to try -v9.  Neither the OLTP
> benchmark, nor the kernel-perf test suite found any significant
> performance change.  I suspect mutex contention isn't a significant
> problem for most workloads.

We've been very good about spreading out mutexes. The normal kernel really 
only does it for write accesses to the same directory, and readdir(). 
Almost everything else is totally in the noise.

I think Ingo's benchmark essentially tests exactly that "write to same 
directory" case, and little else.

Unless:

> Has anyone found a non-synthetic benchmark where this makes a
> significant difference?  Aside from btrfs, I mean.

Yea, if you have some particular filesystem (or other subsystem) that uses 
a global mutex, you'll obviously see way more contention. Btrfs may not be 
_unique_ in this regard, but it's definitely doing something that isn't 
good.

Btw, it's doing something that ext3 also used to do iirc, until we fixed 
it to use spinlocks instead (the block group lock in particular).

Yeah - just double-checked. Commit c12b9866ea52 in the historical Linux 
archive, from 2003. Which made block allocation protected by a per-group 
spinlock, rather than lock_super().

		Linus
