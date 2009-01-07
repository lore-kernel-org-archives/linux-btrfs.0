From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 12:55:49 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>  <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>  <1231329783.11687.287.camel@twins>  <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
 <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
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
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 7 Jan 2009, Steven Rostedt wrote:
> 
> Next comes the issue to know if the owner is still running. Wouldn't we 
> need to do something like
> 
> 	if (task_thread_info(cpu_rq(cpu)->curr) == owner)

Yes. After verifying that "cpu" is in a valid range.

> I understand that this should not be a problem, but I'm afraid it will 
> give me nightmares at night. ;-)
> 
> God that code had better be commented well.

Well, the good news is that it really would be just a few - admittedly 
very subtle - lines, each basically generating just a couple of machine 
instructions. So we'd be looking at code where the actual assembly output 
should hopefully be in the ten-to-twenty instruction range, and the C code 
itself would be about five times as many comments as actual real lines.

So the code really shouldn't be much worse than

	/*
	 * Look out! "thread" is an entirely speculative pointer
	 * access and not reliable.
	 */
	void loop_while_oncpu(struct mutex *lock, struct thread_struct *thread)
	{
		for (;;) {
			unsigned cpu;
			struct runqueue *rq;

			if (lock->owner != thread)
				break;

			/*
			 * Need to access the cpu field knowing that
			 * DEBUG_PAGEALLOC could have unmapped it if
			 * the mutex owner just released it and exited.
			 */
			if (__get_user(cpu, &thread->cpu))
				break;

			/*
			 * Even if the access succeeded (likely case),
			 * the cpu field may no longer be valid. FIXME:
			 * this needs to validate that we can do a
			 * get_cpu() and that we have the percpu area.
			 */
			if (cpu >= NR_CPUS)
				break;

			if (!cpu_online(cpu))
				break;

			/*
			 * Is that thread really running on that cpu?
			 */
			rq = cpu_rq(cpu);
			if (task_thread_info(rq->curr) != thread)
				break;

			cpu_relax();
		}
	}

and it all looks like it shouldn't be all that bad. Yeah, it's like 50 
lines of C code, but it's mostly comments about subtle one-liners that 
really expand to almost no real code at all.

			Linus
