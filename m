From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 19:33:11 +0200
Message-ID: <496B7ED7.3010601@panasas.com>
References: <1231774622.4371.96.camel@laptop>	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain> <1231780581.4371.193.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231780581.4371.193.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

Peter Zijlstra wrote:
> On Mon, 2009-01-12 at 08:20 -0800, Linus Torvalds wrote:
>> On Mon, 12 Jan 2009, Linus Torvalds wrote:
>>> You made it back into the locked version.
>> Btw, even if you probably had some reason for this, one thing to note is 
>> that I think Chris' performance testing showed that the version using a 
>> lock was inferior to his local btrfs hack, while the unlocked version 
>> actually beat his hack.
>>
>> Maybe I misunderstood his numbers, though. But if I followed that sub-part 
>> of the test right, it really means that the locked version is pointless - 
>> it will never be able to replace peoples local hacks for this same thing, 
>> because it just doesn't give the performance people are looking for.
>>
>> Since the whole (and _only_) point of this thing is to perform well, 
>> that's a big deal.
> 
> Like said in reply to Chris' email, I just wanted to see if fairness was
> worth the effort, because the pure unlocked spin showed significant
> unfairness (and I know some people really care about some level of
> fairness).
> 

Which brings me back to my initial reaction to this work. Do we need
two flavors of Mutex? some program sections need Fairness, some need
performance. Some need low-latency, some need absolute raw CPU power.

Because at the end of the day spinning in a saturated CPU work-load
that does not care about latency, eats away cycles that could be spent
on computation. Think multi-threaded video processing for example. 
Thing I would like to measure is 
1 - how many times we spin and at the end get a lock
2 - how many times we spin and at the end sleep.
3 - how many times we sleep like before.
vs. In old case CPU spent on scheduling. Just to see if we are actually loosing
cycles at the end.

> Initial testing with the simple test-mutex thing didn't show too bad
> numbers.
> 

Boaz
