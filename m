From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 10:24:16 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091021070.6528@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901081140550.3283@localhost.localdomain>  <1231498062.11687.608.camel@twins> <1231513614.442.11.camel@twins>  <alpine.DEB.1.10.0901091051591.17378@gandalf.stny.rr.com>
 <alpine.LFD.2.00.0901090828510.6528@localhost.localdomain>  <alpine.DEB.1.10.0901091142060.17378@gandalf.stny.rr.com> <1231524964.442.103.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231524964.442.103.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Peter Zijlstra wrote:
> 
> On that note:
> 
> Index: linux-2.6/kernel/mutex.c
> ===================================================================
> --- linux-2.6.orig/kernel/mutex.c
> +++ linux-2.6/kernel/mutex.c
> @@ -220,7 +220,9 @@ __mutex_lock_common(struct mutex *lock, 
>  		__set_task_state(task, state);
>  
>  		/* didnt get the lock, go to sleep: */
> +		preempt_disable();
>  		spin_unlock_mutex(&lock->wait_lock, flags);
> +		preempt_enable_no_resched();
>  		schedule();

Yes. I think this is a generic issue independently of the whole adaptive 
thing.

In fact, I think wee could make the mutex code use explicit preemption and 
then the __raw spinlocks to make this more obvious. Because now there's a 
hidden "preempt_enable()" in that spin_unlock_mutex, and anybody looking 
at the code and not realizing it is going to just say "Whaa? Who is this 
crazy Peter Zijlstra guy, and what drugs is he on? I want me some!".

Because your patch really doesn't make much sense unless you know how 
spinlocks work, and if you _do_ know how spinlocks work, you go "eww, 
that's doing extra preemption crud in order to just disable the 
_automatic_ preemption crud".

			Linus
