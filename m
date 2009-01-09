From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 12:56:36 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
 <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109204103.GA17212@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Ingo Molnar wrote:
> 
> So, should we not remove CONFIG_OPTIMIZE_INLINING, then the correct one 
> would be to mark it __always_inline [__asm_inline is senseless there], or 
> the second patch below that changes the bit parameter to unsigned int.

Well, I certainly don't want to _remove_ the "inline" like your patch did. 
Other gcc versions will care. But I committed the pure "change to 
unsigned" part.

But we should fix the cmpxchg (and perhaps plain xchg too), shouldn't we?

That your gcc version gets it right doesn't change the fact that Chris' 
gcc version didn't, and out-of-lined it all. So we'll need some 
__always_inlines there too..

And no, I don't think it makes any sense to call them "__asm_inline". Even 
when there are asms hidden in between the C statements, what's the 
difference between "always" and "asm"? None, really.

		Linus
