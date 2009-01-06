From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 14:03:02 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901061401270.10871@gandalf.stny.rr.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>  <20081231104533.abfb1cf9.akpm@linux-foundation.org>  <1230765549.7538.8.camel@think.oraclecorp.com>  <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>  <1231093310.27690.5.camel@twins>
  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <alpine.LFD.2.00.0901060948220.3057@localhost.localdomain> <alpine.LFD.2.00.0901061013250.3057@localhost.localdomain>
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
In-Reply-To: <alpine.LFD.2.00.0901061013250.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


> 
> Btw, this also fixes a bug: your patch did
> 
> 	+                     __set_task_state(task, state);
> 	+                     /* didnt get the lock, go to sleep: */
> 	+                     schedule();
> 
> for the schedule case without holding the mutex spinlock.
> 
> And that seems very buggy and racy indeed: since it doesn't hold the mutex 
> lock, if the old owner releases the mutex at just the right point (yeah, 
> yeah, it requires a scheduling event on another CPU in order to also miss 
> the whole "task_is_current()" logic), the wakeup can get lost, because you 
> set the state to sleeping perhaps _after_ the task just got woken up. So 
> we stay sleeping even though the mutex is clear.


That is indeed a bug.

Peter, why did you need to move __set_task_state down here?  The -rt patch 
does not do this.

-- Steve
