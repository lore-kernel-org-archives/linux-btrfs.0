From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 10:55:33 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>  <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>  <1231329783.11687.287.camel@twins>  <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
 <1231347442.11687.344.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231347442.11687.344.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>



Ok a few more issues. This never stops.

Here's the basic spinloop:

On Wed, 7 Jan 2009, Peter Zijlstra wrote:
>
> +	for (;;) {
> +		struct task_struct *l_owner;
> +
> +		/* Stop spinning when there's a pending signal. */
> +		if (signal_pending_state(task->state, task))
> +			break;

This just can't be right. If we have signal latency issues, we have way 
way _way_ bigger issues.

So the correct test is to just break out if we have any work at all, 
whether it's signals or rescheduling. Yes, you probably never saw that in 
RT, but that was because you have preemption on etc. And obviously usually 
there isn't enough constant contention to trigger anything like this 
anyway, so usually the wait is short either because the owner ends up 
sleeping, or because the owner releases the semaphore.

But you could have starvation issues where everybody is all on CPU, and 
other processes constantly get the semaphore, and latency is absolutely 
HORRIBLE because of this guy just busy-looping all the time.

So at a minimum, add a couple of "if (need_resched())" calls.

However, the other thing that really strikes me is that we've done all 
that insane work to add ourselves to the waiter lists etc, and _then_ we 
start spinning. Again, that can't be right: if there are other people on 
the waiter list, we should not spin - because it's going to be really 
really unfair to take the lock from them!

So we should do all this spinning ONLY IF there are no other waiters, ie 
everybody else is spinning too!

Anything else sounds just horribly broken due to the extreme unfairness of 
it all. Those things are supposed to be fair.

What does that mean? It means that the spinning loop should also check 
that the wait-queue was empty. But it can't do that, because the way this 
whole adaptive spinning was done is _inside_ the slow path that already 
added itself to the waiting list - so you cannot tell if there are other 
spinners.

So I think that the spinning is actually done in the wrong place. It 
_should_ be done at the very top of __mutex_lock_common, _before_ we've 
done that lock->wait_list thing etc. That also makes us only spin at the 
beginning, and if we start sleeping, we don't suddenly go back to spinning 
again.

That in turn would mean that we should try to do this spinning without any 
locks. I think it's doable. I think it's also doable to spin _without_ 
dirtying the cacheline further and bouncing it due to the spinlock. We can 
really do the spinning by just reading that lock, and the only time we 
want to write is when we see the lock releasing.

Something like this..

NOTE NOTE NOTE! This does _not_ implement "spin_on_owner(lock, owner);". 
That's the thing that the scheduler needs to do, with the extra 
interesting part of needing to be able to access the thread_info struct 
without knowing whether it might possibly have exited already.

But we can do that with __get_user(thread_info->cpu) (very unlikely page 
fault protection due to the possibility of CONFIG_DEBUG_PAGEALLOC) and 
then validating the cpu. It it's in range, we can use it and verify 
whether cpu_rq(cpu)->curr has that thread_info.

So we can do all that locklessly and optimistically, just going back and 
verifying the results later. This is why "thread_info" is actually a 
better thing to use than "task_struct" - we can look up the cpu in it with 
a simple dereference. We knew the pointer _used_ to be valid, so in any 
normal situation, it will never page fault (and if you have 
CONFIG_DEBUG_PAGEALLOC and hit a very unlucky race, then performance isn't 
your concern anyway: we just need to make the page fault be non-lethal ;)

			Linus

---
 kernel/mutex.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 4f45d4b..65525d0 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -120,6 +120,8 @@ void __sched mutex_unlock(struct mutex *lock)
 
 EXPORT_SYMBOL(mutex_unlock);
 
+#define MUTEX_SLEEPERS (-1000)
+
 /*
  * Lock a mutex (possibly interruptible), slowpath:
  */
@@ -132,6 +134,30 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	unsigned int old_val;
 	unsigned long flags;
 
+#ifdef CONFIG_SMP
+	/* Optimistic spinning.. */
+	for (;;) {
+		struct thread_struct *owner;
+		int oldval = atomic_read(&lock->count);
+
+		if (oldval <= MUTEX_SLEEPERS)
+			break;
+		if (oldval == 1) {
+			oldval = atomic_cmpxchg(&lock->count, oldval, 0);
+			if (oldval == 1) {
+				lock->owner = task_thread_info(task);
+				return 0;
+			}
+		} else {
+			/* See who owns it, and spin on him if anybody */
+			owner = lock->owner;
+			if (owner)
+				spin_on_owner(lock, owner);
+		}
+		cpu_relax();
+	}
+#endif
+
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
@@ -142,7 +168,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	list_add_tail(&waiter.list, &lock->wait_list);
 	waiter.task = task;
 
-	old_val = atomic_xchg(&lock->count, -1);
+	old_val = atomic_xchg(&lock->count, MUTEX_SLEEPERS);
 	if (old_val == 1)
 		goto done;
 
@@ -158,7 +184,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 * that when we release the lock, we properly wake up the
 		 * other waiters:
 		 */
-		old_val = atomic_xchg(&lock->count, -1);
+		old_val = atomic_xchg(&lock->count, MUTEX_SLEEPERS);
 		if (old_val == 1)
 			break;
 
