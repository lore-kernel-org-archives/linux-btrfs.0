From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 20:23:06 +0100
Message-ID: <1231960986.14825.45.camel@laptop>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop>
	 <20090114183319.GA18630@elte.hu>
	 <20090114105300.66bd014d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114105300.66bd014d.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-14 at 10:53 -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2009 19:33:19 +0100 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Please pull the adaptive-mutexes-for-linus git tree
> 
> <fear>
> 
> - It seems a major shortcoming that the feature is disabled if
>   CONFIG_DEBUG_MUTEXES=y.  It means that lots of people won't test it.

Yes, that's a bit unfortunate, a simple patch to enable that is:

I must admit I'm a bit stumped on why that debug check triggers, I
couldn't reproduce today, but Ingo ran into it quite quickly :/

Index: linux-2.6/kernel/mutex-debug.c
===================================================================
--- linux-2.6.orig/kernel/mutex-debug.c
+++ linux-2.6/kernel/mutex-debug.c
@@ -74,7 +74,7 @@ void debug_mutex_unlock(struct mutex *lo
 		return;
 
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
+	/* DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info()); */
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	mutex_clear_owner(lock);
 }
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -148,7 +148,7 @@ __mutex_lock_common(struct mutex *lock, 
 
 	preempt_disable();
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-#if defined(CONFIG_SMP) && !defined(CONFIG_DEBUG_MUTEXES)
+#ifdef CONFIG_SMP
 	/*
 	 * Optimistic spinning.
 	 *
@@ -162,9 +162,6 @@ __mutex_lock_common(struct mutex *lock, 
 	 * Since this needs the lock owner, and this mutex implementation
 	 * doesn't track the owner atomically in the lock field, we need to
 	 * track it non-atomically.
-	 *
-	 * We can't do this for DEBUG_MUTEXES because that relies on wait_lock
-	 * to serialize everything.
 	 */
 
 	for (;;) {


> - When people hit performance/latency oddities, it would be nice if
>   they had a /proc knob with which they could disable this feature at
>   runtime.
> 
>   This would also be useful for comparative performance testing.

CONFIG_SCHED_DEBUG=y

echo NO_MUTEX_SPIN > /debug/sched_features


