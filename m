From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 14:26:58 -0500
Message-ID: <1232047618.8269.93.camel@think.oraclecorp.com>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>
	 <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org>
	 <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>
	 <20090115180844.GL22472@elte.hu>
	 <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Andi Kleen <andi@firstfloor.org>,
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
In-Reply-To: <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-15 at 10:16 -0800, Linus Torvalds wrote:
> 
> On Thu, 15 Jan 2009, Ingo Molnar wrote:
> > 
> > btw., i think spin-mutexes have a design advantage here: in a lot of code 
> > areas it's quite difficult to use spinlocks - cannot allocate memory, 
> > cannot call any code that can sporadically block (but does not _normally_ 
> > block), etc.
> > 
> > With mutexes those atomicity constraints go away - and the performance 
> > profile should now be quite close to that of spinlocks as well.
> 
> Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
> hold the lock over all those unnecessary and complex operations.
> 

While this is true, there are examples of places we should expect
speedups for this today.

Concurrent file creation/deletion in a single dir will often find things
hot in cache and not have to block anywhere (mail spools).

Concurrent O_DIRECT aio writes to the same file, where i_mutex is
dropped early on.

pipes should see a huge improvement.

I'll kick off some runs of my three benchmarks on ext3 for comparison.
If there are things less synthetic people would like to see, please let
me know.

-chris


