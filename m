From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 18:02:04 +0100
Message-ID: <20090106170204.GB32608@elte.hu>
References: <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain> <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain> <alpine.LFD.2.00.0901060841000.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901060841000.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 6 Jan 2009, Linus Torvalds wrote:
> > 
> > Right now, if some process deadlocks on a mutex, we get hung process, 
> > but with a nice backtrace and hopefully other things (that don't need 
> > that lock) still continue to work.
> 
> Clarification: the "nice backtrace" we only get with something like 
> sysrq-W, of course. We don't get a backtrace _automatically_, but with 
> an otherwise live machine, there's a better chance that people do get 
> wchan or other info. IOW, it's at least a fairly debuggable situation.

btw., the softlockup watchdog detects non-progressing uninterruptible 
tasks (regardless of whether they locked up due to mutexes or any other 
reason).

This does occasionally help in debugging deadlocks:

  http://marc.info/?l=linux-mm&m=122889587725061&w=2

but it would indeed be also good to have the most common self-deadlock 
case checked unconditionally in the mutex slowpath.

	Ingo
