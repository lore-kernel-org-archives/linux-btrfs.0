From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 22:58:22 +0100
Message-ID: <20090109215822.GA21613@elte.hu>
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
> > So, should we not remove CONFIG_OPTIMIZE_INLINING, then the correct one 
> > would be to mark it __always_inline [__asm_inline is senseless there], or 
> > the second patch below that changes the bit parameter to unsigned int.
> 
> Well, I certainly don't want to _remove_ the "inline" like your patch did. 

hm, that was a bug that i noticed and fixed in the second, fuller version 
of the patch i sent - which converts all the 'int nr' instances in 
bitops.h to 'unsigned int nr'.

This is the only instance where the integer type of 'nr' matters in 
practice though, due to the modulo arithmetics. But for cleanliness 
reasons we want to do the full patch, to have a standard type signature 
for these bitop methods.

> Other gcc versions will care. But I committed the pure "change to 
> unsigned" part.

thanks! I'll clean up the rest - the second patch will now conflict 
(trivially). I also wanted to check the whole file more fully, there might 
be other details. [ So many files, so few nights ;-) ]

We also might need more __always_inline's here and in other places, to 
solve the nonsensical inlining problems that Chris's case showed for 
example, with earlier GCCs.

Another option would be to not trust earlier GCCs at all with this feature 
- to only define inline to not-__always_inline only on latest 4.3.x GCC - 
the only one that seems to at least not mess up royally.

Thus CONFIG_OPTIMIZE_INLINING=y would have no effect on older GCCs. That 
would quarantine the problem (and the impact) sufficiently i think. And if 
future GCCs start messing up in this area we could zap the whole feature 
in a heartbeat.

( Although now that we have this feature this gives an incentive to
  compiler folks to tune their inliner on to the Linux kernel - for a 
  decade we never allowed them to do that. The kernel clearly has one of
  the trickiest (and ugliest) inlining smarts in headers - and we never 
  really exposed compilers to those things, so i'm not surprised at all 
  that they mess up in cases.

  Unfortunately the version lifecycle of most compiler projects is
  measured in years, not in months like that of the kernel. There's many
  reasons for that - and not all of those reasons are strictly their
  fault. )

	Ingo
