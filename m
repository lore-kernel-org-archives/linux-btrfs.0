From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Wed, 14 Jan 2009 18:32:58 +0100
Message-ID: <b647ffbd0901140932v5fba34f9oe2098635c937a678@mail.gmail.com>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins>
	 <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	 <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
	 <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	 <1231867314.7141.16.camel@twins>
	 <1231901899.1709.18.camel@think.oraclecorp.com>
	 <b647ffbd0901140318g7e4ccab6m9bf03e9ac6acf797@mail.gmail.com>
	 <1231951662.8269.22.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
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
	Sven Dietrich <SDietrich@novell.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231951662.8269.22.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/1/14 Chris Mason <chris.mason@oracle.com>:
> On Wed, 2009-01-14 at 12:18 +0100, Dmitry Adamushko wrote:
>> 2009/1/14 Chris Mason <chris.mason@oracle.com>:
>> > On Tue, 2009-01-13 at 18:21 +0100, Peter Zijlstra wrote:
>> >> On Tue, 2009-01-13 at 08:49 -0800, Linus Torvalds wrote:
>> >> >
>> >> > So do a v10, and ask people to test.
>> >>
>> >> ---
>> >> Subject: mutex: implement adaptive spinning
>> >> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> >> Date: Mon Jan 12 14:01:47 CET 2009
>> >>
>> >> Change mutex contention behaviour such that it will sometimes busy wait on
>> >> acquisition - moving its behaviour closer to that of spinlocks.
>> >>
>> >
>> > I've spent a bunch of time on this one, and noticed earlier today that I
>> > still had bits of CONFIG_FTRACE compiling.  I wasn't actually tracing
>> > anything, but it seems to have had a big performance hit.
>> >
>> > The bad news is the simple spin got much much faster, dbench 50 coming
>> > in at 1282MB/s instead of 580MB/s.  (other benchmarks give similar
>> > results)
>> >
>> > v10 is better that not spinning, but its in the 5-10% range.  So, I've
>> > been trying to find ways to close the gap, just to understand exactly
>> > where it is different.
>> >
>> > If I take out:
>> >        /*
>> >         * If there are pending waiters, join them.
>> >         */
>> >        if (!list_empty(&lock->wait_list))
>> >                break;
>> >
>> >
>> > v10 pops dbench 50 up to 1800MB/s.  The other tests soundly beat my
>> > spinning and aren't less fair.  But clearly this isn't a good solution.
>> >
>> > I tried a few variations, like only checking the wait list once before
>> > looping, which helps some.  Are there other suggestions on better tuning
>> > options?
>>
>> (some thoughts/speculations)
>>
>> Perhaps for highly-contanded mutexes the spinning implementation may
>> quickly degrade [*] to the non-spinning one (i.e. the current
>> sleep-wait mutex) and then just stay in this state until a moment of
>> time when there are no waiters  [**]  -- i.e.
>> list_empty(&lock->wait_list) == 1 and waiters can start spinning
>> again.
>
> It is actually ok if the highly contention mutexes don't degrade as long
> as they are highly contended and the holder isn't likely to schedule.

Yes, my point was that they likely do fall back (degrade) to the
wait-on-the-list (non-spinning) behavior with dbench, and that's why
the performance numbers are similar (5-10% IIRC) to those of the
'normal' mutex.

And the thing is that for the highly contention mutexes, it's not easy
to switch back to the (fast) spinning-wait -- just because most of the
time there is someone waiting for the lock (and if this 'someone' is
not a spinner, none of the new mutex_lock() requests can do
busy-waiting/spinning).

But whatever, without the list_empty() check it's not relevant any more.

>>
>> what may trigger [*]:
>>
>> (1) obviously, an owner scheduling out.
>>
>> Even if it happens rarely (otherwise, it's not a target scenario for
>> our optimization), due to the [**] it may take quite some time until
>> waiters are able to spin again.
>>
>> let's say, waiters (almost) never block (and possibly, such cases
>> would be better off just using a spinlock after some refactoring, if
>> possible)
>>
>> (2) need_resched() is triggered for one of the waiters.
>>
>> (3) !owner && rt_task(p)
>>
>> quite unlikely, but possible (there are 2 race windows).
>>
>> Of course, the question is whether it really takes a noticeable amount
>> of time to get out of the [**] state.
>> I'd imagine it can be a case for highly-contended locks.
>>
>> If this is the case indeed, then which of 1,2,3 gets triggered the most.
>
> Sorry, I don't have stats on that.
>
>>
>> Have you tried removing need_resched() checks? So we kind of emulate
>> real spinlocks here.
>
> Unfortunately, the need_resched() checks deal with a few of the ugly
> corners.  They are more important without the waiter list check.
> Basically if we spun without the need_resched() checks, the process who
> wants to unlock might not be able to schedule back in.

Yeah, for the "owner == NULL" case. If the owner was preempted in the
fast path right after taking the lock and before calling
mutex_set_owner().

btw., I wonder... would an additional preempt_disable/enable() in the
fast path harm that much?
We could avoid the preemption scenario above.

>
> -chris
>


-- 
Best regards,
Dmitry Adamushko
