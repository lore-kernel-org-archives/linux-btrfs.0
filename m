From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 19:07:16 +0100
Message-ID: <1231783636.4371.201.camel@laptop>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
	 <1231780581.4371.193.camel@laptop>  <496B7ED7.3010601@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <496B7ED7.3010601@panasas.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-12 at 19:33 +0200, Boaz Harrosh wrote:

> Which brings me back to my initial reaction to this work. Do we need
> two flavors of Mutex? some program sections need Fairness, some need
> performance. Some need low-latency, some need absolute raw CPU power.

Thing is, its the kernel, we cannot have such knobs per task. So we have
to pick one and stick with it -- the 'best' we can do is what PREEMPT_RT
does and replace the thing whole sale at build time.

> Because at the end of the day spinning in a saturated CPU work-load
> that does not care about latency, eats away cycles that could be spent
> on computation. Think multi-threaded video processing for example. 
> Thing I would like to measure is 
> 1 - how many times we spin and at the end get a lock
> 2 - how many times we spin and at the end sleep.
> 3 - how many times we sleep like before.
> vs. In old case CPU spent on scheduling. Just to see if we are actually loosing
> cycles at the end.

Feel free to do so ;-)

