From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 12:33:35 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901081227260.24688@gandalf.stny.rr.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>  <1231347442.11687.344.camel@twins>  <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>  <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>  <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
  <1231365115.11687.361.camel@twins>  <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>  <1231366716.11687.377.camel@twins>  <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>  <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
  <1231426014.11687.456.camel@twins>  <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
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
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231434515.14304.27.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, 8 Jan 2009, Chris Mason wrote:

> On Thu, 2009-01-08 at 08:58 -0800, Linus Torvalds wrote:
> > 
> > Ok, I've gone through -v7, and I'm sure you're all shocked to hear it, but 
> > I have no complaints. Except that you dropped all the good commit 
> > commentary you had earlier ;)
> > 
> 
> Seems to get stuck under load.  I've hit it with make -j 50 on ext3 and
> with my btrfs benchmarking.  This was against the latest git from about
> 5 minutes ago.
> 
> -chris
> 
> BUG: soft lockup - CPU#3 stuck for 61s! [python:3970] CPU 3: Modules 
> linked in: netconsole configfs btrfs zlib_deflate loop e1000e 3w_9xxx 

> Pid: 3970, comm: python Not tainted 2.6.28 #1 Call Trace:

>  [<ffffffff8024f4b1>] ? __cmpxchg+0x9/0x3f
>  [<ffffffff805e0068>] ? __mutex_lock_common+0x3d/0x178

Hmm, looking at the code...

mutex.c:

       for (;;) {
                struct thread_info *owner;

                old_val = atomic_cmpxchg(&lock->count, 1, 0);
                if (old_val == 1) {
                        lock_acquired(&lock->dep_map, ip);
                        mutex_set_owner(lock);
                        return 0;
                }

                if (old_val < 0 && !list_empty(&lock->wait_list))
                        break;

                /* See who owns it, and spin on him if anybody */
                owner = ACCESS_ONCE(lock->owner);
                if (owner && !spin_on_owner(lock, owner))
                        break;

                cpu_relax();
        }


and in sched.c:

int spin_on_owner(struct mutex *lock, struct thread_info *owner)
{
        unsigned int cpu;
        struct rq *rq;
        int ret = 1;
[...]
                if (lock->owner != owner)
                        break;


We keep spinning if the owner changes.  I wonder if you have many CPUS 
(Chris, how many cpus did this box have?), you could get one task 
constantly spinning while the mutex keeps changing owners on the other 
CPUS.

Perhaps, we should do something like:

mutex.c:

       for (;;) {
                struct thread_info *owner = NULL;

                old_val = atomic_cmpxchg(&lock->count, 1, 0);
                if (old_val == 1) {
                        lock_acquired(&lock->dep_map, ip);
                        mutex_set_owner(lock);
                        return 0;
                }

                if (old_val < 0 && !list_empty(&lock->wait_list)) 
                        break;

                /* See who owns it, and spin on him if anybody */
		if (!owner)
	                owner = ACCESS_ONCE(lock->owner);
                if (owner && !spin_on_owner(lock, owner)) 
                        break;

                cpu_relax();
        }

Or just pull assigning of the owner out of the loop. This way, we go to 
sleep if the owner changes and is not NULL.

Just a thought,

-- Steve

