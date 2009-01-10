From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 17:04:22 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091701010.6528@localhost.localdomain>
References: <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>
 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <1231538387.5825.2.camel@brick> <alpine.LFD.2.00.0901091404150.6528@localhost.localdomain> <1231539918.5825.7.camel@brick> <20090110005342.GC1972@shareable.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090110005342.GC1972@shareable.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Sat, 10 Jan 2009, Jamie Lokier wrote:
> 
> Does "always_inline" complain if the function isn't inlinable, while
> "inline" allows it?  That would explain the alpha comment.

I suspect it dates back to gcc-3.1 days. It's from 2004. And the author of 
that comment is a part-time gcc hacker who was probably offended by the 
fact that we thought (correctly) that a lot of gcc inlining was totally 
broken.

Since he was the main alpha maintainer, he got to do things his way 
there..

			Linus
