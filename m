From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 10:02:56 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com>  <20081231104533.abfb1cf9.akpm@linux-foundation.org>  <1230765549.7538.8.camel@think.oraclecorp.com>  <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>  <1231093310.27690.5.camel@twins>
  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753488AbZAFSE1@vger.kernel.org>
In-Reply-To: <1231242031.11687.97.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>


Ok, last comment, I promise.

On Tue, 6 Jan 2009, Peter Zijlstra wrote:
> @@ -175,11 +199,19 @@ __mutex_lock_common(struct mutex *lock, 
>  			debug_mutex_free_waiter(&waiter);
>  			return -EINTR;
>  		}
> -		__set_task_state(task, state);
>  
> -		/* didnt get the lock, go to sleep: */
> +		owner = lock->owner;
> +		get_task_struct(owner);
>  		spin_unlock_mutex(&lock->wait_lock, flags);
> -		schedule();
> +
> +		if (adaptive_wait(&waiter, owner, state)) {
> +			put_task_struct(owner);
> +			__set_task_state(task, state);
> +			/* didnt get the lock, go to sleep: */
> +			schedule();
> +		} else
> +			put_task_struct(owner);
> +
>  		spin_lock_mutex(&lock->wait_lock, flags);

So I really dislike the whole get_task_struct/put_task_struct thing. It 
seems very annoying. And as far as I can tell, it's there _only_ to 
protect "task->rq" and nothing else (ie to make sure that the task 
doesn't exit and get freed and the pointer now points to la-la-land).

Wouldn't it be much nicer to just cache the rq pointer (take it while 
still holding the spinlock), and then pass it in to adaptive_wait()?

Then, adaptive_wait() can just do

	if (lock->owner != owner)
		return 0;

	if (rq->task != owner)
		return 1;

Sure - the owner may have rescheduled to another CPU, but if it did that, 
then we really might as well sleep. So we really don't need to dereference 
that (possibly stale) owner task_struct at all - because we don't care. 
All we care about is whether the owner is still busy on that other CPU 
that it was on. 

Hmm? So it looks to me that we don't really need that annoying "try to 
protect the task pointer" crud. We can do the sufficient (and limited) 
sanity checking without the task even existing, as long as we originally 
load the ->rq pointer at a point where it was stable (ie inside the 
spinlock, when we know that the task must be still alive since it owns the 
lock).

		Linus
