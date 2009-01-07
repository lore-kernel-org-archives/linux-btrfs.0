From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Wed, 07 Jan 2009 22:51:55 +0100
Message-ID: <1231365115.11687.361.camel@twins>
References: <87r63ljzox.fsf@basil.nowhere.org>
	 <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
	 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>
	 <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
	 <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>
	 <49636799.1010109@novell.com>  <20090106214229.GD6741@linux.vnet.ibm.com>
	 <1231278275.11687.111.camel@twins>
	 <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
	 <1231279660.11687.121.camel@twins>
	 <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>
	 <1231281801.11687.125.camel@twins>  <1231283778.11687.136.camel@twins>
	 <1231329783.11687.287.camel@twins>
	 <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steven Rostedt <rostedt@goodmis.org>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-01-07 at 12:55 -0800, Linus Torvalds wrote:

> 	/*
> 	 * Look out! "thread" is an entirely speculative pointer
> 	 * access and not reliable.
> 	 */
> 	void loop_while_oncpu(struct mutex *lock, struct thread_struct *thread)
> 	{
> 		for (;;) {
> 			unsigned cpu;
> 			struct runqueue *rq;
> 
> 			if (lock->owner != thread)
> 				break;
> 
> 			/*
> 			 * Need to access the cpu field knowing that
> 			 * DEBUG_PAGEALLOC could have unmapped it if
> 			 * the mutex owner just released it and exited.
> 			 */
> 			if (__get_user(cpu, &thread->cpu))
> 				break;
> 
> 			/*
> 			 * Even if the access succeeded (likely case),
> 			 * the cpu field may no longer be valid. FIXME:
> 			 * this needs to validate that we can do a
> 			 * get_cpu() and that we have the percpu area.
> 			 */
> 			if (cpu >= NR_CPUS)
> 				break;
> 
> 			if (!cpu_online(cpu))
> 				break;
> 
> 			/*
> 			 * Is that thread really running on that cpu?
> 			 */
> 			rq = cpu_rq(cpu);
> 			if (task_thread_info(rq->curr) != thread)
> 				break;
> 
> 			cpu_relax();
> 		}
> 	}

Do we really have to re-do all that code every loop?

        void loop_while_oncpu(struct mutex *lock, struct thread_struct *thread)
        {
                unsigned cpu;
                struct runqueue *rq;

                /*
                 * Need to access the cpu field knowing that
                 * DEBUG_PAGEALLOC could have unmapped it if
                 * the mutex owner just released it and exited.
                 */
                if (__get_user(cpu, &thread->cpu))
                        break;

                /*
                 * Even if the access succeeded (likely case),
                 * the cpu field may no longer be valid. FIXME:
                 * this needs to validate that we can do a
                 * get_cpu() and that we have the percpu area.
                 */
                if (cpu >= NR_CPUS)
                        break;

                if (!cpu_online(cpu))
                        break;

                rq = cpu_rq(cpu);

                for (;;) {
                        if (lock->owner != thread)
                                break;

                        /*
                         * Is that thread really running on that cpu?
                         */
                        if (task_thread_info(rq->curr) != thread)
                                break;

                        cpu_relax();
                }
        }

Also, it would still need to do the funny:

 l_owner = ACCESS_ONCE(lock->owner)
 if (l_owner && l_owner != thread)
   break;

thing, to handle the premature non-atomic lock->owner tracking.
