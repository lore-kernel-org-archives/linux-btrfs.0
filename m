From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 08:40:40 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 6 Jan 2009, Linus Torvalds wrote:
> 
> So it should be renamed. Something like "task_is_oncpu()" or whatever.

Another complaint, which is tangentially related in that it actually 
concerns "current".

Right now, if some process deadlocks on a mutex, we get hung process, but 
with a nice backtrace and hopefully other things (that don't need that 
lock) still continue to work.

But if I read it correctly, the adaptive spin code will instead just hang. 
Exactly because "task_is_current()" will also trigger for that case, and 
now you get an infinite loop, with the process spinning until it looses 
its own CPU, which obviously will never happen.

Yes, this is the behavior we get with spinlocks too, and yes, lock 
debugging will talk about it, but it's a regression. We've historically 
had a _lot_ more bad deadlocks on mutexes than we have had on spinlocks, 
exactly because mutexes can be held over much more complex code. So 
regressing on it and making it less debuggable is bad.

IOW, if we do this, then I think we need a

	BUG_ON(task == owner);

in the waiting slow-path. I realize the test already exists for the DEBUG 
case, but I think we just want it even for production kernels. Especially 
since we'd only ever need it in the slow-path.

			Linus
