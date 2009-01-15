From: Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH -v11][RFC] mutex: implement adaptive spinning
Date: Thu, 15 Jan 2009 08:52:33 +0100
Message-ID: <20090115075233.GD17810@wotan.suse.de>
References: <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114171800.GA18621@wotan.suse.de> <1231953757.14825.33.camel@laptop> <20090115004645.GB32044@wotan.suse.de> <1232005443.14825.82.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232005443.14825.82.camel@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 15, 2009 at 08:44:03AM +0100, Peter Zijlstra wrote:
> On Thu, 2009-01-15 at 01:46 +0100, Nick Piggin wrote:
> 
> > Hmm, well this is rather a slow path, I would say. I'd prefer not to
> > modify schedule in this way (if we just get scheduled back on after
> > being switched away, the subsequent call to schedule is going to be
> > cache hot and not do too much work).
> > 
> > preempt_enable_noresched maybe if you really care, would close up the
> > window even more. But is it really worthwhile? We'd want to see numbers
> > (when in doubt, keep it  simpler).
> 
> I initially did the preempt_enable_no_resched() thing and that showed
> some improvement for PREEMPT=y kernels (lost the numbers though).
> 
> When I redid all the patches I tried closing that last hole by doing
> that __schedule() thing, never realizing that schedule() would then get
> extra overhead,.. d'0h.
> 
> I agree that that isn't worth it. I shall revert to
> preempt_enable_no_resched() and try to get some new numbers.

Thanks!
