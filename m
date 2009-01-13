From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Tue, 13 Jan 2009 19:24:49 +0100
Message-ID: <20090113182449.GA1718@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <20090113181222.GA24910@elte.hu> <alpine.LFD.2.00.0901131013580.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901131013580.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 13 Jan 2009, Ingo Molnar wrote:
> >
> > And v8 is rock solid in all my testing - and i'll give v10 a similar 
> > workout as well.
> 
> The differences between v8 and v10 are very fundamental, since v8 does 
> the spinning inside the spinlock'ed loop (the spinning itself is not 
> inside the spinlock, but all the "real action" is).  So v8 not showing 
> problems doesn't really say much about v10 - totally different 
> algorithms that share only some of the support code.
> 
> So even if many lines look the same, those code-lines aren't the really 
> interesting ones. The only really interesting once is really the 
> atomic_cmpxchg (outside spinlock) vs atomic_xchg (inside spinlock), and 
> those are almost diametrically opposite.

yeah. What i thought they would be useful for are testing and experiments 
like this:

" what if you switch the spinning to more fair by typing this in your 
  current tree:

     git revert c10b491
"

... but that's a pretty narrow purpose.

> > Would you prefer a single commit or is this kind of delta development 
> > history useful, with all the variants (at least the later, more 
> > promising ones) included?
> 
> I'm not sure it makes sense to show the history here, especially as 
> there really were two different approaches, and while they share many 
> issues, they sure aren't equivalent nor are we really talking about any 
> evolution of the patch except in the sense of one being the kick-starter 
> for the alternative approach.
> 
> What _can_ make sense is to commit some of the infrastructure helper 
> code separately, ie the lock ownership and preemption changes, since 
> those really are independent of the spinning code, and at least the 
> preemption thing is interesting and relevant even without it.

ok, we'll improve the splitup.

	Ingo
