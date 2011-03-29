From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Tue, 29 Mar 2011 19:37:33 +0200
Message-ID: <1301420253.2250.430.camel@laptop>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325101238.GC1409@htj.dyndns.org>
	 <20110329163702.GE29865@htj.dyndns.org>
	 <20110329170949.GF29865@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110329170949.GF29865@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2011-03-29 at 19:09 +0200, Tejun Heo wrote:
> Here's the combined patch I was planning on testing but didn't get to
> (yet).  It implements two things - hard limit on spin duration and
> early break if the owner also is spinning on a mutex.

This is going to give massive conflicts with

 https://lkml.org/lkml/2011/3/2/286
 https://lkml.org/lkml/2011/3/2/282

which I was planning to stuff into .40


> @@ -4021,16 +4025,44 @@ EXPORT_SYMBOL(schedule);
>  
>  #ifdef CONFIG_MUTEX_SPIN_ON_OWNER
>  /*
> + * Maximum mutex owner spin duration in nsecs.  Don't spin more then
> + * DEF_TIMESLICE.
> + */
> +#define MAX_MUTEX_SPIN_NS	(DEF_TIMESLICE * 1000000000LLU / HZ)

DEF_TIMESLICE is SCHED_RR only, so its use here is dubious at best, also
I bet we have something like NSEC_PER_SEC to avoid counting '0's.

> +
> +/**
> + * mutex_spin_on_owner - optimistic adaptive spinning on locked mutex
> + * @lock: the mutex to spin on
> + * @owner: the current owner (speculative pointer)
> + *
> + * The caller is trying to acquire @lock held by @owner.  If @owner is
> + * currently running, it might get unlocked soon and spinning on it can
> + * save the overhead of sleeping and waking up.
> + *
> + * Note that @owner is completely speculative and may be completely
> + * invalid.  It should be accessed very carefully.
> + *
> + * Forward progress is guaranteed regardless of locking ordering by never
> + * spinning longer than MAX_MUTEX_SPIN_NS.  This is necessary because
> + * mutex_trylock(), which doesn't have to follow the usual locking
> + * ordering, also uses this function.

While that puts a limit on things it'll still waste time. I'd much
rather pass an trylock argument to mutex_spin_on_owner() and then bail
on owner also spinning.

> + * CONTEXT:
> + * Preemption disabled.
> + *
> + * RETURNS:
> + * %true if the lock was released and the caller should retry locking.
> + * %false if the caller better go sleeping.
>   */
> -int mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
> +bool mutex_spin_on_owner(struct mutex *lock, struct thread_info *owner)
>  {

> @@ -4070,21 +4104,30 @@ int mutex_spin_on_owner(struct mutex *lo
>  			 * we likely have heavy contention. Return 0 to quit
>  			 * optimistic spinning and not contend further:
>  			 */
> +			ret = !lock->owner;
>  			break;
>  		}
>  
>  		/*
> -		 * Is that owner really running on that cpu?
> +		 * Quit spinning if any of the followings is true.
> +		 *
> +		 * - The owner isn't running on that cpu.
> +		 * - The owner also is spinning on a mutex.
> +		 * - Someone else wants to use this cpu.
> +		 * - We've been spinning for too long.
>  		 */
> +		if (task_thread_info(rq->curr) != owner ||
> +		    rq->spinning_on_mutex || need_resched() ||
> +		    local_clock() > start + MAX_MUTEX_SPIN_NS) {

While we did our best with making local_clock() cheap, I'm still fairly
uncomfortable with putting it in such a tight loop.

> +			ret = false;
> +			break;
> +		}
>  
>  		arch_mutex_cpu_relax();
>  	}
>  
> +	this_rq()->spinning_on_mutex = false;
> +	return ret;
>  }
>  #endif
>  
