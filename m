Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:36046 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751492AbcLFIRJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Dec 2016 03:17:09 -0500
Date: Tue, 6 Dec 2016 09:16:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161206081659.GV3092@twins.programming.kicks-ass.net>
References: <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161123193419.pq7adje2eanky2wx@codemonkey.org.uk>
 <20161123195845.iphzr7ac4mu5ewjt@codemonkey.org.uk>
 <CAOMGZ=HPUoVZ8_yBLsMUHLigvKadKwBio-8gJ5-WM+2Fe4BZ6A@mail.gmail.com>
 <CAOMGZ=EsaGs9B3jc5X+3Sa1vyBfBW6AznYy3JR1=6iJMgCgG0g@mail.gmail.com>
 <CAOMGZ=HfdHLXrRCbzvXcQTgfA-PAErtwZQfPzFr4P8H0MJWZ5g@mail.gmail.com>
 <CA+55aFxeWe2VQaW30qGR0syiZ75jSwFwg3Ac+wS20KDtf5UKNw@mail.gmail.com>
 <CAOMGZ=Eb8mw6CfGaruM-tRir7pWn78vLTaCqp1pGPqkagfzPPA@mail.gmail.com>
 <CA+55aFzEG-6pkJXy4itiXsHPu_VV5q2vd6zJLq6vmi=AzdnaUw@mail.gmail.com>
 <CA+55aFwC3nfmum6oPoBRU325CKjK-g3MuqW+bhq3+9DnE_4fgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFwC3nfmum6oPoBRU325CKjK-g3MuqW+bhq3+9DnE_4fgw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 05, 2016 at 12:35:52PM -0800, Linus Torvalds wrote:
> Adding the scheduler people to the participants list, and re-attaching
> the patch, because while this patch is internal to the VM code, the
> issue itself is not.
> 
> There might well be other cases where somebody goes "wake_up_all()"
> will wake everybody up, so I can put the wait queue head on the stack,
> and then after I've woken people up I can return".
> 
> Ingo/PeterZ: the reason that does *not* work is that "wake_up_all()"
> does make sure that everybody is woken up, but the usual autoremove
> wake function only removes the wakeup entry if the process was woken
> up by that particular wakeup. If something else had woken it up, the
> entry remains on the list, and the waker in this case returned with
> the wait head still containing entries.
> 
> Which is deadly when the wait queue head is on the stack.

Yes, very much so.

> So I'm wondering if we should make that "synchronous_wake_function()"
> available generally, and maybe introduce a DEFINE_WAIT_SYNC() helper
> that uses it.

We could also do some debug code that tracks the ONSTACK ness and warns
on autoremove. Something like the below, equally untested.

> 
> Of course, I'm really hoping that this shmem.c use is the _only_ such
> case.  But I doubt it.

$ git grep DECLARE_WAIT_QUEUE_HEAD_ONSTACK | wc -l
28

---


diff --git a/include/linux/wait.h b/include/linux/wait.h
index 2408e8d5c05c..199faaa89847 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -39,6 +39,9 @@ struct wait_bit_queue {
 struct __wait_queue_head {
 	spinlock_t		lock;
 	struct list_head	task_list;
+#ifdef CONFIG_DEBUG_WAITQUEUE
+	int			onstack;
+#endif
 };
 typedef struct __wait_queue_head wait_queue_head_t;
 
@@ -56,9 +59,18 @@ struct task_struct;
 #define DECLARE_WAITQUEUE(name, tsk)					\
 	wait_queue_t name = __WAITQUEUE_INITIALIZER(name, tsk)
 
-#define __WAIT_QUEUE_HEAD_INITIALIZER(name) {				\
+#ifdef CONFIG_DEBUG_WAITQUEUE
+#define ___WAIT_QUEUE_ONSTACK(onstack)	.onstack = (onstack),
+#else
+#define ___WAIT_QUEUE_ONSTACK(onstack)
+#endif
+
+#define ___WAIT_QUEUE_HEAD_INITIALIZER(name, onstack)	{		\
 	.lock		= __SPIN_LOCK_UNLOCKED(name.lock),		\
-	.task_list	= { &(name).task_list, &(name).task_list } }
+	.task_list	= { &(name).task_list, &(name).task_list },	\
+	___WAIT_QUEUE_ONSTACK(onstack) }
+
+#define __WAIT_QUEUE_HEAD_INITIALIZER(name) ___WAIT_QUEUE_HEAD_INITIALIZER(name, 0)
 
 #define DECLARE_WAIT_QUEUE_HEAD(name) \
 	wait_queue_head_t name = __WAIT_QUEUE_HEAD_INITIALIZER(name)
@@ -80,11 +92,12 @@ extern void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct
 
 #ifdef CONFIG_LOCKDEP
 # define __WAIT_QUEUE_HEAD_INIT_ONSTACK(name) \
-	({ init_waitqueue_head(&name); name; })
+	({ init_waitqueue_head(&name); (name).onstack = 1; name; })
 # define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) \
 	wait_queue_head_t name = __WAIT_QUEUE_HEAD_INIT_ONSTACK(name)
 #else
-# define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) DECLARE_WAIT_QUEUE_HEAD(name)
+# define DECLARE_WAIT_QUEUE_HEAD_ONSTACK(name) \
+	wait_queue_head_t name = ___WAIT_QUEUE_HEAD_INITIALIZER(name, 1)
 #endif
 
 static inline void init_waitqueue_entry(wait_queue_t *q, struct task_struct *p)
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 9453efe9b25a..746d00117d08 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -156,6 +156,13 @@ void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
+static inline void prepare_debug(wait_queue_head_t *q, wait_queue_t *wait)
+{
+#ifdef CONFIG_DEBUG_WAITQUEUE
+	WARN_ON_ONCE(q->onstack && wait->func == autoremove_wake_function)
+#endif
+}
+
 /*
  * Note: we use "set_current_state()" _after_ the wait-queue add,
  * because we need a memory barrier there on SMP, so that any
@@ -178,6 +185,7 @@ prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	if (list_empty(&wait->task_list))
 		__add_wait_queue(q, wait);
 	set_current_state(state);
+	prepare_debug(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait);
@@ -192,6 +200,7 @@ prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state)
 	if (list_empty(&wait->task_list))
 		__add_wait_queue_tail(q, wait);
 	set_current_state(state);
+	prepare_debug(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(prepare_to_wait_exclusive);
@@ -235,6 +244,7 @@ long prepare_to_wait_event(wait_queue_head_t *q, wait_queue_t *wait, int state)
 		}
 		set_current_state(state);
 	}
+	prepare_debug(q, wait);
 	spin_unlock_irqrestore(&q->lock, flags);
 
 	return ret;
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 9bb7d825ba14..af2ef22a5b2b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1235,6 +1235,14 @@ config DEBUG_PI_LIST
 
 	  If unsure, say N.
 
+config DEBUG_WAITQUEUE
+	bool "Debug waitqueue"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to do sanity checking on waitqueue usage
+
+	  If unsure, say N.
+
 config DEBUG_SG
 	bool "Debug SG table operations"
 	depends on DEBUG_KERNEL
