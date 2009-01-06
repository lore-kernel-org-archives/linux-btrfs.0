From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 12:37:10 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901061230460.10871@gandalf.stny.rr.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106090833.78482f5d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090106090833.78482f5d.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>


On Tue, 6 Jan 2009, Andrew Morton wrote:

> On Tue, 06 Jan 2009 12:40:31 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Subject: mutex: adaptive spin
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Tue Jan 06 12:32:12 CET 2009
> > 
> > Based on the code in -rt, provide adaptive spins on generic mutexes.
> > 
> 
> How dumb is it to send a lump of uncommented, changelogged code as an
> rfc, only to have Ingo reply, providing the changelog for you?

Sounds smart to me. He was able to get someone else to do the work. ;-)

> 
> Sigh.
> 
> > --- linux-2.6.orig/kernel/mutex.c
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
> 
> Each of the tests in this function should be carefully commented.  It's
> really the core piece of the design.

Yep, I agree here too.

> 
> > +#else
> > +static int adaptive_wait(struct mutex_waiter *waiter,
> > +			 struct task_struct *owner, long state)
> > +{
> > +	return 1;
> > +}
> > +#endif
> > +
> >  /*
> >   * Lock a mutex (possibly interruptible), slowpath:
> >   */
> > @@ -127,7 +150,7 @@ static inline int __sched
> >  __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> >  	       	unsigned long ip)
> >  {
> > -	struct task_struct *task = current;
> > +	struct task_struct *owner, *task = current;
> >  	struct mutex_waiter waiter;
> >  	unsigned int old_val;
> >  	unsigned long flags;
> > @@ -141,6 +164,7 @@ __mutex_lock_common(struct mutex *lock, 
> >  	/* add waiting tasks to the end of the waitqueue (FIFO): */
> >  	list_add_tail(&waiter.list, &lock->wait_list);
> >  	waiter.task = task;
> > +	waiter.lock = lock;
> >  
> >  	old_val = atomic_xchg(&lock->count, -1);
> >  	if (old_val == 1)
> > @@ -175,11 +199,19 @@ __mutex_lock_common(struct mutex *lock, 
> >  			debug_mutex_free_waiter(&waiter);
> >  			return -EINTR;
> >  		}
> > -		__set_task_state(task, state);
> >  
> > -		/* didnt get the lock, go to sleep: */
> > +		owner = lock->owner;
> 
> What prevents *owner from exitting right here?

Yeah, this should be commented. Why this is not a race is because
the owner has the mutex here, and we have the lock->wait_lock. When
the owner releases the mutex it must go into the slow unlock path and
grab the lock->wait_lock spinlock. Thus it will block and not go away.

Of course if there's a bug elsewhere in the kernel that lets the task exit 
without releasing the mutex, this will fail. But in that case, there's 
bigger problems that need to be fixed.


> 
> > +		get_task_struct(owner);
> >  		spin_unlock_mutex(&lock->wait_lock, flags);

Here, we get the owner before releasing the wait_lock.

> > -		schedule();
> > +
> > +		if (adaptive_wait(&waiter, owner, state)) {
> > +			put_task_struct(owner);
> > +			__set_task_state(task, state);
> > +			/* didnt get the lock, go to sleep: */
> > +			schedule();
> > +		} else
> > +			put_task_struct(owner);
> > +
> >  		spin_lock_mutex(&lock->wait_lock, flags);
> >  	}
> >  
> > @@ -187,7 +219,7 @@ done:
> >  	lock_acquired(&lock->dep_map, ip);
> >  	/* got the lock - rejoice! */
> >  	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
> > -	debug_mutex_set_owner(lock, task_thread_info(task));
> > +	lock->owner = task;
> >  
> >  	/* set it to 0 if there are no waiters left: */
> >  	if (likely(list_empty(&lock->wait_list)))
> > @@ -260,7 +292,7 @@ __mutex_unlock_common_slowpath(atomic_t 
> >  		wake_up_process(waiter->task);
> >  	}
> >  
> > -	debug_mutex_clear_owner(lock);
> > +	lock->owner = NULL;
> >  
> >  	spin_unlock_mutex(&lock->wait_lock, flags);
> >  }
> > @@ -352,7 +384,7 @@ static inline int __mutex_trylock_slowpa
> >  
> >  	prev = atomic_xchg(&lock->count, -1);
> >  	if (likely(prev == 1)) {
> > -		debug_mutex_set_owner(lock, current_thread_info());
> > +		lock->owner = current;
> >  		mutex_acquire(&lock->dep_map, 0, 1, _RET_IP_);
> >  	}
> >  	/* Set it back to 0 if there are no waiters: */
> > Index: linux-2.6/kernel/sched.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched.c
> > +++ linux-2.6/kernel/sched.c
> > @@ -697,6 +697,11 @@ int runqueue_is_locked(void)
> >  	return ret;
> >  }
> >  
> > +int task_is_current(struct task_struct *p)
> > +{
> > +	return task_rq(p)->curr == p;
> > +}
> 
> Please don't add kernel-wide infrastructure and leave it completely
> undocumented.  Particularly functions which are as vague and dangerous
> as this one.
> 
> What locking must the caller provide?  What are the semantics of the
> return value?
> 
> What must the caller do to avoid oopses if *p is concurrently exiting?
> 
> etc.
> 
> 
> The overall design intent seems very smart to me, as long as the races
> can be plugged, if they're indeed present.

Thanks for the complement on the design. It came about lots of work by 
many people in the -rt tree. What we need here is to comment the code for 
those that did not see the evolution of the changes that were made.

-- Steve

