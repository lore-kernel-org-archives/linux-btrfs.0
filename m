From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v4][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 10:29:46 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901071028270.32756@gandalf.stny.rr.com>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>  <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins>
 <alpine.DEB.1.10.0901071014120.32756@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901071014120.32756@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, 7 Jan 2009, Steven Rostedt wrote:
> On Wed, 7 Jan 2009, Peter Zijlstra wrote:
> > --- a/kernel/mutex.c
> > +++ b/kernel/mutex.c
> > @@ -10,6 +10,10 @@
> >   * Many thanks to Arjan van de Ven, Thomas Gleixner, Steven Rostedt and
> >   * David Howells for suggestions and improvements.
> >   *
> > + *  - Adaptive spinning for mutexes by Peter Zijlstra. (Ported to mainline
> > + *    from the -rt tree, where it was originally implemented for rtmutexes
> > + *    by Steven Rostedt, based on work by Gregory Haskins.)
> 
> I feel guilty with my name being the only one there for the rtmutexes.
> Thomas Gleixner, Ingo Molnar and Esben Nielsen also played large roles in
> that code.
> 
> And Peter Morreale and Sven Dietrich might also be mentioned next to
> Gregory's name.
> 

If you are not talking about rtmutexes in general, and are just 
referencing the spinning part, then just group us all together:

  Gregory Haskins, Steven Rostedt, Peter Morreale and Sven Dietrich.

Thanks,

-- Steve

