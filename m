From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 9 Jan 2009 09:54:14 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>
References: <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org>
 <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz,
	richard.guenther@gmail.com
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090109173914.GD6936@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Matthew Wilcox wrote:
> 
> That seems like valuable feedback to give to the GCC developers.

Well, one thing we should remember is that the kernel really _is_ special.

The kernel not only does things no other program tends to do (inline asms 
are unusual in the first place - many of them are literally due to system 
issues like atomic accesses and interrupts that simply aren't an issue in 
user space, or that need so much abstraction that they aren't inlinable 
anyway).

But the kernel also has totally different requirements in other ways. When 
was the last time you did user space programming and needed to get a 
backtrace from a user with register info because you simply don't have the 
hardware that he has? 

IOW, debugging in user space tends to be much more about trying to 
reproduce the bug - in a way that we often cannot in the kernel. User 
space in general is much more reproducible, since it's seldom as hardware- 
or timing-dependent (threading does change the latter, but usually user 
space threading is not _nearly_ as aggressive as the kernel has to be).

So the thing is, even if gcc was "perfect", it would likely be perfect for 
a different audience than the kernel. 

Do you think _any_ user space programmer worries about the stack space 
being a few hundred bytes larger because the compiler inlined two 
functions, and caused stack usage to be sum of them instead of just the 
maximum of the two?

So we do have special issues. And exactly _because_ we have special issues 
we should also expect that some compiler defaults simply won't ever really 
be appropriate for us.

			Linus
