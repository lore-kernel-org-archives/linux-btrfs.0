From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 13:20:44 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901061314310.10871@gandalf.stny.rr.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>  <20081231104533.abfb1cf9.akpm@linux-foundation.org>  <1230765549.7538.8.camel@think.oraclecorp.com>  <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>  <1231093310.27690.5.camel@twins>
  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain>
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
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


On Tue, 6 Jan 2009, Linus Torvalds wrote:

> 
> Ok, last comment, I promise.
> 
> On Tue, 6 Jan 2009, Peter Zijlstra wrote:
> > @@ -175,11 +199,19 @@ __mutex_lock_common(struct mutex *lock, 
> >  			debug_mutex_free_waiter(&waiter);
> >  			return -EINTR;
> >  		}
> > -		__set_task_state(task, state);
> >  
> > -		/* didnt get the lock, go to sleep: */
> > +		owner = lock->owner;
> > +		get_task_struct(owner);
> >  		spin_unlock_mutex(&lock->wait_lock, flags);
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
> 
> So I really dislike the whole get_task_struct/put_task_struct thing. It 
> seems very annoying. And as far as I can tell, it's there _only_ to 
> protect "task->rq" and nothing else (ie to make sure that the task 
> doesn't exit and get freed and the pointer now points to la-la-land).

Yeah, that was not one of the things that we liked either. We tried
other ways to get around the get_task_struct but, ended up with
the get_task_struct in the end anyway.

> 
> Wouldn't it be much nicer to just cache the rq pointer (take it while 
> still holding the spinlock), and then pass it in to adaptive_wait()?
> 
> Then, adaptive_wait() can just do
> 
> 	if (lock->owner != owner)
> 		return 0;
> 
> 	if (rq->task != owner)
> 		return 1;
> 
> Sure - the owner may have rescheduled to another CPU, but if it did that, 
> then we really might as well sleep. So we really don't need to dereference 
> that (possibly stale) owner task_struct at all - because we don't care. 
> All we care about is whether the owner is still busy on that other CPU 
> that it was on. 
> 
> Hmm? So it looks to me that we don't really need that annoying "try to 
> protect the task pointer" crud. We can do the sufficient (and limited) 
> sanity checking without the task even existing, as long as we originally 
> load the ->rq pointer at a point where it was stable (ie inside the 
> spinlock, when we know that the task must be still alive since it owns the 
> lock).

Caching the rq is an interesting idea. But since the rq struct is local to 
sched.c, what would be a good API to do this?

in mutex.c:

	void *rq;

	[...]

	rq = get_task_rq(owner);
	spin_unlock(&lock->wait_lock);

	[...]

	if (!task_running_on_rq(rq, owner))


in sched.c:


	void *get_task_rq(struct task_struct *p)
	{
		return task_rq(p);
	}

	int task_running_on_rq(void *r, struct task_sturct *p)
	{
		struct rq *rq = r;

		return rq->curr == p;
	}

??

-- Steve


