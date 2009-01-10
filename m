From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sat, 10 Jan 2009 02:13:56 +0100
Message-ID: <20090110011356.GV26290@one.firstfloor.org>
References: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <1231538387.5825.2.camel@brick> <alpine.LFD.2.00.0901091404150.6528@localhost.localdomain> <1231539918.5825.7.camel@brick> <20090110005342.GC1972@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Andi Kleen <andi@firstfloor.org>,
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
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090110005342.GC1972@shareable.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 10, 2009 at 12:53:42AM +0000, Jamie Lokier wrote:
> Harvey Harrison wrote:
> > Oh yeah, and figure out what actually breaks on alpha such that they added
> > the following (arch/alpha/include/asm/compiler.h)
> > 
> > #ifdef __KERNEL__
> > /* Some idiots over in <linux/compiler.h> thought inline should imply
> >    always_inline.  This breaks stuff.  We'll include this file whenever
> >    we run into such problems.  */
> 
> Does "always_inline" complain if the function isn't inlinable, while

Yes it does.

> "inline" allows it? 

(unless you set -Winline which the kernel doesn't) 

-Andi

-- 
ak@linux.intel.com
