From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 13:27:14 -0500
Message-ID: <1231439234.14304.33.camel@think.oraclecorp.com>
References: <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
	 <1231347442.11687.344.camel@twins>
	 <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain>
	 <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain>
	 <1231365115.11687.361.camel@twins>
	 <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain>
	 <1231366716.11687.377.camel@twins>
	 <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain>
	 <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.DEB.1.10.0901081227260.24688@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901080943270.3283@localhost.localdomain>
	 <alpine.DEB.1.10.0901081300370.24688@gandalf.stny.rr.com>
	 <alpine.LFD.2.00.0901081005560.3283@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901081005560.3283@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2009-01-08 at 10:16 -0800, Linus Torvalds wrote:
> 
> On Thu, 8 Jan 2009, Steven Rostedt wrote:
> > 
> > Ouch! I think you are on to something:
> 
> Yeah, there's somethign there, but looking at Chris' backtrace, there's 
> nothing there to disable preemption. So if it was this simple case, it 
> should still have preempted him to let the other process run and finish 
> up.
> 

My .config has no lockdep or schedule debugging and voluntary preempt.
I do have CONFIG_INLINE_OPTIMIZE on, its a good name for trusting gcc I
guess.

> So I don't think Chris' softlockup is at least _exactly_ that case. 
> There's something else going on too.
> 
> That said, I do think it's a mistake for us to care about the value of 
> "spin_on_owner()". I suspect v8 should
> 
>  - always have
> 
> 	if (need_resched())
> 		break
> 
>    in the outer loop.
> 
>  - drop the return value from "spin_on_owner()", and just break out if 
>    anything changes (including the need_resched() flag).
> 
>  - I'd also drop the "old_value < 0 &&" test, and just test the 
>    list_empty() unconditionally. 
> 

I'll give the above a shot, and we can address the preempt + !owner in
another rev

-chris

