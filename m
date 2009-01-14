From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Wed, 14 Jan 2009 11:23:45 -0500
Message-ID: <1231950225.8269.16.camel@think.oraclecorp.com>
References: <1231774622.4371.96.camel@laptop>
	 <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins>
	 <1231901899.1709.18.camel@think.oraclecorp.com>
	 <20090114112158.GA8625@elte.hu>
	 <alpine.LFD.2.00.0901140739110.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901140739110.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-14 at 07:43 -0800, Linus Torvalds wrote:
> 
> On Wed, 14 Jan 2009, Ingo Molnar wrote:
> 
> > 
> > * Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > v10 is better that not spinning, but its in the 5-10% range.  So, I've 
> > > been trying to find ways to close the gap, just to understand exactly 
> > > where it is different.
> > > 
> > > If I take out:
> > > 	/*
> > > 	 * If there are pending waiters, join them.
> > > 	 */
> > > 	if (!list_empty(&lock->wait_list))
> > > 		break;
> > > 
> > > 
> > > v10 pops dbench 50 up to 1800MB/s.  The other tests soundly beat my 
> > > spinning and aren't less fair.  But clearly this isn't a good solution.
> > 
> > i think since we already decided that it's ok to be somewhat unfair (_all_ 
> > batching constructs introduce unfairness, so the question is never 'should 
> > we?' but 'by how much?'), we should just take this out and enjoy the speed 

Ok, numbers first, incremental below:

* dbench 50 (higher is better):
spin        1282MB/s
v10         548MB/s
v10 no wait 1868MB/s

* 4k creates (numbers in files/second higher is better):
spin        avg 200.60 median 193.20 std 19.71 high 305.93 low 186.82
v10         avg 180.94 median 175.28 std 13.91 high 229.31 low 168.73
v10 no wait avg 232.18 median 222.38 std 22.91 high 314.66 low 209.12

* File stats (numbers in seconds, lower is better):
spin        2.27s
v10         5.1s
v10 no wait 1.6s

This patch brings v10 up to v10 no wait.  The changes are smaller than
they look, I just moved the need_resched checks in __mutex_lock_common
after the cmpxchg.

-chris

diff --git a/kernel/mutex.c b/kernel/mutex.c
index 0d5336d..c2d47b7 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -171,12 +171,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		struct thread_info *owner;
 
 		/*
-		 * If there are pending waiters, join them.
-		 */
-		if (!list_empty(&lock->wait_list))
-			break;
-
-		/*
 		 * If there's an owner, wait for it to either
 		 * release the lock or go to sleep.
 		 */
@@ -184,6 +178,13 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		if (owner && !mutex_spin_on_owner(lock, owner))
 			break;
 
+		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
+			lock_acquired(&lock->dep_map, ip);
+			mutex_set_owner(lock);
+			preempt_enable();
+			return 0;
+		}
+
 		/*
 		 * When there's no owner, we might have preempted between the
 		 * owner acquiring the lock and setting the owner field. If
@@ -192,14 +193,6 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		 */
 		if (!owner && (need_resched() || rt_task(task)))
 			break;
-
-		if (atomic_cmpxchg(&lock->count, 1, 0) == 1) {
-			lock_acquired(&lock->dep_map, ip);
-			mutex_set_owner(lock);
-			preempt_enable();
-			return 0;
-		}
-
 		/*
 		 * The cpu_relax() call is a compiler barrier which forces
 		 * everything in this loop to be re-loaded. We don't need


