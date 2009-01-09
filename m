From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 09 Jan 2009 10:28:25 +0100
Message-ID: <1231493305.11687.528.camel@twins>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Chris Mason <chris.mason@oracle.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 11:13 -0800, Linus Torvalds wrote:
> 
> On Thu, 8 Jan 2009, Chris Mason wrote:
> > 
> > It is less fair though, the 50 proc parallel creates had a much bigger
> > span between the first and last proc's exit time.  This isn't a huge
> > shock, I think it shows the hot path is closer to a real spin lock.
> 
> Actually, the real spin locks are now fair. We use ticket locks on x86.

> We _could_ certainly aim for using ticket locks for mutexes too, that 
> might be quite nice.

Not really, ticket locks cannot handle a spinner going away - and we
need that here.

I've googled around a bit and MCS locks
(http://www.cs.rice.edu/~johnmc/papers/asplos91.pdf) look like a viable
way to gain fairness in our situation.

