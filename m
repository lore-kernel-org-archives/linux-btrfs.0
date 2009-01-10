From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 21:28:01 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901092119100.6528@localhost.localdomain>
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>  <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>  <20090109204103.GA17212@elte.hu>  <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>  <20090109213442.GA20051@elte.hu>
 <1231537320.5726.2.camel@brick>  <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>  <20090109231227.GA25070@elte.hu>  <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>  <20090110010125.GA31031@elte.hu> <1231549697.5700.7.camel@brick>
 <alpine.LFD.2.00.0901091713150.6528@localhost.localdomain> <49682C05.7030407@zytor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
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
	Sven Dietrich <SDietrich@novell.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49682C05.7030407@zytor.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, H. Peter Anvin wrote:
> 
> I was thinking about experimenting with this, to see what level of
> upside it might add.  Ingo showed me numbers which indicate that a
> fairly significant fraction of the cases where removing inline helps is
> in .h files, which would require code movement to fix.  Hence to see if
> it can be automated.

We _definitely_ have too many inline functions in headers. They usually 
start out small, and then they grow. And even after they've grown big, 
it's usually not at all clear exactly where else they should go, so even 
when you realize that "that shouldn't be inlined", moving them and making 
them uninlined is not obvious.

And quite often, some of them go away - or at least shrink a lot - when 
some config option or other isn't set. So sometimes it's an inline because 
a certain class of people really want it inlined, simply because for 
_them_ it makes sense, but when you enable debugging or something, it 
absolutely explodes.

		Linus
