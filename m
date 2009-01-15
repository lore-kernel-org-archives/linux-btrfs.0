From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 19:08:44 +0100
Message-ID: <20090115180844.GL22472@elte.hu>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <matthew@wil.cx>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Has anyone found a non-synthetic benchmark where this makes a 
> > significant difference?  Aside from btrfs, I mean.
> 
> Yea, if you have some particular filesystem (or other subsystem) that 
> uses a global mutex, you'll obviously see way more contention. Btrfs may 
> not be _unique_ in this regard, but it's definitely doing something that 
> isn't good.
> 
> Btw, it's doing something that ext3 also used to do iirc, until we fixed 
> it to use spinlocks instead (the block group lock in particular).
> 
> Yeah - just double-checked. Commit c12b9866ea52 in the historical Linux 
> archive, from 2003. Which made block allocation protected by a per-group 
> spinlock, rather than lock_super().

btw., i think spin-mutexes have a design advantage here: in a lot of code 
areas it's quite difficult to use spinlocks - cannot allocate memory, 
cannot call any code that can sporadically block (but does not _normally_ 
block), etc.

With mutexes those atomicity constraints go away - and the performance 
profile should now be quite close to that of spinlocks as well.

	Ingo
