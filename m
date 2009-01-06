From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 06 Jan 2009 13:21:41 +0100
Message-ID: <1231244501.11687.102.camel@twins>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
	 <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753381AbZAFMWc@vger.kernel.org>
In-Reply-To: <20090106121052.GA27232@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 13:10 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > +++ linux-2.6/kernel/mutex.c
> > @@ -46,6 +46,7 @@ __mutex_init(struct mutex *lock, const c
> >  	atomic_set(&lock->count, 1);
> >  	spin_lock_init(&lock->wait_lock);
> >  	INIT_LIST_HEAD(&lock->wait_list);
> > +	lock->owner = NULL;
> >  
> >  	debug_mutex_init(lock, name, key);
> >  }
> > @@ -120,6 +121,28 @@ void __sched mutex_unlock(struct mutex *
> >  
> >  EXPORT_SYMBOL(mutex_unlock);
> >  
> > +#ifdef CONFIG_SMP
> > +static int adaptive_wait(struct mutex_waiter *waiter,
> > +			 struct task_struct *owner, long state)
> > +{
> > +	for (;;) {
> > +		if (signal_pending_state(state, waiter->task))
> > +			return 0;
> > +		if (waiter->lock->owner != owner)
> > +			return 0;
> > +		if (!task_is_current(owner))
> > +			return 1;
> > +		cpu_relax();
> > +	}
> > +}
> > +#else
> 
> Linus, what do you think about this particular approach of spin-mutexes? 
> It's not the typical spin-mutex i think.
> 
> The thing i like most about Peter's patch (compared to most other adaptive 
> spinning approaches i've seen, which all sucked as they included various 
> ugly heuristics complicating the whole thing) is that it solves the "how 
> long should we spin" question elegantly: we spin until the owner runs on a 
> CPU.

s/until/as long as/

> So on shortly held locks we degenerate to spinlock behavior, and only 
> long-held blocking locks [with little CPU time spent while holding the 
> lock - say we wait for IO] we degenerate to classic mutex behavior.
> 
> There's no time or spin-rate based heuristics in this at all (i.e. these 
> mutexes are not 'adaptive' at all!), and it degenerates to our primary and 
> well-known locking behavior in the important boundary situations.

Well, it adapts to the situation, choosing between spinning vs blocking.
But what's in a name ;-)

> A couple of other properties i like about it:
> 
>  - A spinlock user can be changed to a mutex with no runtime impact. (no 
>    increase in scheduling) This might enable us to convert/standardize 
>    some of the uglier locking constructs within ext2/3/4?

I think a lot of stuff there is bit (spin) locks.

> It's hard to tell how it would impact inbetween workloads - i guess it 
> needs to be measured on a couple of workloads.

Matthew volunteered to run something IIRC.
