From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 09 Jan 2009 19:16:04 +0100
Message-ID: <1231524964.442.103.camel@twins>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>
	 <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins>
	 <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901090828510.6528@localhost.localdomain>
	 <alpine.DEB.1.10.0901091142060.17378@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
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
	Sven Dietrich <SDietrich@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754739AbZAISQt@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901091142060.17378@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-01-09 at 11:44 -0500, Steven Rostedt wrote:

> When we get to the schedule() it then needs to be a:
> 
> 	preempt_enable_no_resched();
> 	schedule();

On that note:

Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -220,7 +220,9 @@ __mutex_lock_common(struct mutex *lock, 
 		__set_task_state(task, state);
 
 		/* didnt get the lock, go to sleep: */
+		preempt_disable();
 		spin_unlock_mutex(&lock->wait_lock, flags);
+		preempt_enable_no_resched();
 		schedule();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}


actually improves mutex performance on PREEMPT=y
