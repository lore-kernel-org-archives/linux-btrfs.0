From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sat, 10 Jan 2009 00:53:42 +0000
Message-ID: <20090110005342.GC1972@shareable.org>
References: <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <1231538387.5825.2.camel@brick> <alpine.LFD.2.00.0901091404150.6528@localhost.localdomain> <1231539918.5825.7.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Harvey Harrison <harvey.harrison@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1231539918.5825.7.camel@brick>
List-ID: <linux-btrfs.vger.kernel.org>

Harvey Harrison wrote:
> Oh yeah, and figure out what actually breaks on alpha such that they added
> the following (arch/alpha/include/asm/compiler.h)
> 
> #ifdef __KERNEL__
> /* Some idiots over in <linux/compiler.h> thought inline should imply
>    always_inline.  This breaks stuff.  We'll include this file whenever
>    we run into such problems.  */

Does "always_inline" complain if the function isn't inlinable, while
"inline" allows it?  That would explain the alpha comment.

-- Jamie
