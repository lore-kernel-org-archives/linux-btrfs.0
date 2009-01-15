From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 12:13:17 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901151208310.6528@localhost.localdomain>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>  <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>  <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>  <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>
  <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org>  <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain>  <20090115180844.GL22472@elte.hu>  <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
 <1232047618.8269.93.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232047618.8269.93.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 15 Jan 2009, Chris Mason wrote:

> On Thu, 2009-01-15 at 10:16 -0800, Linus Torvalds wrote:
> > 
> > Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
> > hold the lock over all those unnecessary and complex operations.
> 
> While this is true, there are examples of places we should expect
> speedups for this today.

Sure. There are cases where we do have to use sleeping things, because the 
code is generic and really can't control what lower levels do, and those 
lower levels have to be able to sleep.

So:

> Concurrent file creation/deletion in a single dir will often find things
> hot in cache and not have to block anywhere (mail spools).

The inode->i_mutex thing really does need to use a mutex, and spinning 
will help. Of course, it should only help when you really have lots of 
concurrent create/delete/readdir in the same directory, and that hopefully 
is a very rare load in real life, but hey, it's a valid one.

> Concurrent O_DIRECT aio writes to the same file, where i_mutex is
> dropped early on.

Won't the actual IO costs generally dominate in everything but trivial 
benchmarks?

> pipes should see a huge improvement.

Hmm. Pipes may be interesting, but on the other hand, the cases that would 
see huge improvements would tend to be the cases where the biggest 
performance gain is from running both sides on the same CPU. The only case 
where a pipe gets really contended is when both producer and consumer 
basically do nothing with the data, so the biggest costs is the copy in 
kernel space (read: pure benchmarking, no real load), and then you often 
get better performance by scheduling on a single CPU due to cache effects 
and no lock bouncing. 

			Linus
