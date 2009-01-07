From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 14:06:40 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901071401380.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
 <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>  <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
  <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>  <1231329783.11687.287.camel@twins>  <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 7 Jan 2009, Linus Torvalds wrote:
> 
> We don't actually care that it only happens once: this all has _known_ 
> races, and the "cpu_relax()" is a barrier.

I phrased that badly. It's not that it has "known races", it's really that 
the whole code sequence is very much written and intended to be 
optimistic.

So whatever code motion or whatever CPU memory ordering motion that 
happens, we don't really care, because none of the tests are final. We do 
need to make sure that the compiler doesn't optimize the loads out of the 
loops _entirely_, but the "cpu_relax()" things that we need for other 
reasons guarantee that part.

One related issue: since we avoid the spinlock, we now suddenly end up 
relying on the "atomic_cmpxchg()" having lock acquire memory ordering 
semantics. Because _that_ is the one non-speculative thing we do end up 
doing in the whole loop. 

But atomic_cmpxchg() is currently defined to be a full memory barrier, so 
we should be ok. The only issue might be that it's _too_ much of a memory 
barrier for some architectures, but this is not the pure fastpath, so I 
think we're all good.

			Linus
