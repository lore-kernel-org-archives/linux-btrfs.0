From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 22:34:42 +0100
Message-ID: <20090109213442.GA20051@elte.hu>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
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
In-Reply-To: <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 9 Jan 2009, Ingo Molnar wrote:
> > 
> > So, should we not remove CONFIG_OPTIMIZE_INLINING, then the correct 
> > one would be to mark it __always_inline [__asm_inline is senseless 
> > there], or the second patch below that changes the bit parameter to 
> > unsigned int.
> 
> Well, I certainly don't want to _remove_ the "inline" like your patch 
> did. Other gcc versions will care. But I committed the pure "change to 
> unsigned" part.
> 
> But we should fix the cmpxchg (and perhaps plain xchg too), shouldn't 
> we?
> 
> That your gcc version gets it right doesn't change the fact that Chris' 
> gcc version didn't, and out-of-lined it all. So we'll need some 
> __always_inlines there too..

Yeah. I'll dig out an older version of gcc (latest distros are all 4.3.x 
based) and run the checks to see which inlines make a difference.

> And no, I don't think it makes any sense to call them "__asm_inline". 
> Even when there are asms hidden in between the C statements, what's the 
> difference between "always" and "asm"? None, really.

Well, the difference is small, nitpicky and insignificant: the thing is 
there are two logically separate categories of __always_inline:

 1) the places where __always_inline means that in this universe no sane 
    compiler ever can end up thinking to move that function out of line.

 2) inlining for_correctness_ reasons: things like vreads or certain 
    paravirt items. Stuff where the kernel actually crashes if we dont 
    inline. Here if we do not inline we've got a materially crashy kernel.

The original intention of __always_inline was to only cover the second 
category above - and thus self-document all the 'correctness inlines'. 

This notion has become bitrotten somewhat: we do use __always_inline in a 
few other places like the ticket spinlock inlines for non-correctness 
reasons. That bitrot happened because we simply have no separate symbol 
for the first category.

So hpa suggested __asm_inline (yesterday, well before all the analysis was 
conducted) under the assumption that there would be many such annotations 
needed and that they would be all about cases where GCC's inliner gets 
confused by inline assembly.

This theory turned out to be a red herring today - asm()s do not seem to 
confuse latest GCC. (although they certain confuse earlier versions, so 
it's still a practical issue, so i agree that we do need to annotate a few 
more places.)

In any case, the __asm_inline name - even if it made some marginal sense 
originally - is totally moot now, no argument about that.

The naming problem remains though:

- Perhaps we could introduce a name for the first category: __must_inline? 
  __should_inline? Not because it wouldnt mean 'always', but because it is 
  'always inline' for another reason than the correctless __always_inline.

- Another possible approach wuld be to rename the second category to 
  __force_inline. That would signal it rather forcefully that the inlining 
  there is an absolute correctness issue.

- Or we could go with the status quo and just conflate those two 
  categories (as it is happening currently) and document the correctness 
  inlines via in-source comments?

But these are really nuances that pale in comparison to the fundamental 
questions that were asked in this thread, about the pure existence of this 
feature.

If the optimize-inlining feature looks worthwile and maintainable to 
remain upstream then i'd simply like to see the information of these two 
categories preserved in a structured way (in 5 years i'm not sure i'd 
remember all the paravirt inlining details), and i dont feel too strongly 
about the style how we preserve that information.

	Ingo
