From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 16:23:40 +0100
Message-ID: <1231428220.11687.464.camel@twins>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins>  <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.DEB.1.10.0901081003050.22642@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901081003050.22642@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 10:09 -0500, Steven Rostedt wrote:
> On Thu, 8 Jan 2009, Peter Zijlstra wrote:
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -4672,6 +4672,72 @@ need_resched_nonpreemptible:
> >  }
> >  EXPORT_SYMBOL(schedule);
> >  
> > +#ifdef CONFIG_SMP
> > +/*
> > + * Look out! "owner" is an entirely speculative pointer
> > + * access and not reliable.
> > + */
> > +int spin_on_owner(struct mutex *lock, struct thread_info *owner)
> > +{
> > +	unsigned int cpu;
> > +	struct rq *rq;
> > +	int ret = 1;
> > +
> > +	if (unlikely(!sched_feat(OWNER_SPIN)))
> 
> I would remove the "unlikely", if someone turns OWNER_SPIN off, then you 
> have the wrong decision being made. Choices by users should never be in a 
> "likely" or "unlikely" annotation. It's discrimination ;-)

in the unlikely case we schedule(), that seems expensive enough to want
to make the spin case ever so slightly faster.

> > +		return 0;
> > +
> > +	preempt_disable();
> > +#ifdef CONFIG_DEBUG_PAGEALLOC
> > +	/*
> > +	 * Need to access the cpu field knowing that
> > +	 * DEBUG_PAGEALLOC could have unmapped it if
> > +	 * the mutex owner just released it and exited.
> > +	 */
> > +	if (probe_kernel_address(&owner->cpu, cpu))
> > +		goto out;
> > +#else
> > +	cpu = owner->cpu;
> > +#endif
> > +
> > +	/*
> > +	 * Even if the access succeeded (likely case),
> > +	 * the cpu field may no longer be valid.
> > +	 */
> > +	if (cpu >= nr_cpumask_bits)
> > +		goto out;
> > +
> > +	/*
> > +	 * We need to validate that we can do a
> > +	 * get_cpu() and that we have the percpu area.
> > +	 */
> > +	if (!cpu_online(cpu))
> > +		goto out;
> 
> Should we need to do a "get_cpu" or something? Couldn't the CPU disappear 
> between these two calls. Or does it do a stop-machine and the preempt 
> disable will protect us?

Did you miss the preempt_disable() a bit up?

> > +
> > +	rq = cpu_rq(cpu);
> > +
> > +	for (;;) {
> > +		if (lock->owner != owner)
> > +			break;
> > +
> > +		/*
> > +		 * Is that owner really running on that cpu?
> > +		 */
> > +		if (task_thread_info(rq->curr) != owner)
> > +			break;
> > +
> > +		if (need_resched()) {
> > +			ret = 0;
> > +			break;
> > +		}
> > +
> > +		cpu_relax();
> > +	}
> > +out:
> > +	preempt_enable_no_resched();
> > +	return ret;
> > +}
> > +#endif

