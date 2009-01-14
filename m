From: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Wed, 14 Jan 2009 19:23:12 +0200
Message-ID: <496E1F80.20009@redhat.com>
References: <1231774622.4371.96.camel@laptop> <496B6C23.8000808@redhat.com> <1231780388.4371.185.camel@laptop> <496B7EBC.6020208@redhat.com> <1231951599.14825.18.camel@laptop> <20090114170445.GA18964@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090114170445.GA18964@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

Nick Piggin wrote:
>> (no they're not, Nick's ticket locks still spin on a shared cacheline
>> IIRC -- the MCS locks mentioned could fix this)
>>     
>
> It reminds me. I wrote a basic variation of MCS spinlocks a while back. And
> converted dcache lock to use it, which showed large dbench improvements on
> a big machine (of course for different reasons than the dbench improvements
> in this threaed).
>
> http://lkml.org/lkml/2008/8/28/24
>
> Each "lock" object is sane in size because given set of spin-local queues may
> only be used once per lock stack. But any spinlocks within a mutex acquisition
> will always be at the bottom of such a stack anyway, by definition.
>
> If you can use any code or concept for your code, that would be great.
>   

Does it make sense to replace 'nest' with a per-cpu counter that's 
incremented on each lock?  I guest you'd have to search for the value of 
nest on unlock, but it would a very short search (typically length 1, 2 
if lock sorting is used to avoid deadlocks).

I think you'd need to make the lock store the actual node pointer, not 
the cpu number, since the values of nest would be different on each cpu.

That would allow you to replace spinlocks with mcs_locks wholesale.

-- 
error compiling committee.c: too many arguments to function

