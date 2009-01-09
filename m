From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 13:50:13 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
References: <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>  <1231434515.14304.27.camel@think.oraclecorp.com>  <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>  <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org>
  <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>  <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>  <20090109204103.GA17212@elte.hu>  <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>  <20090109213442.GA20051@elte.hu>
 <1231537320.5726.2.camel@brick>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
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
In-Reply-To: <1231537320.5726.2.camel@brick>
List-ID: <linux-btrfs.vger.kernel.org>



On Fri, 9 Jan 2009, Harvey Harrison wrote:
> 
> __needs_inline?  That would imply that it's for correctness reasons.

.. but the point is, we have _thousands_ of inlines, and do you know which 
is which? We've historically forced them to be inlined, and every time 
somebody does that "OPTIMIZE_INLINE=y", something simply _breaks_.

So instead of just continually hitting our head against this wall because 
some people seem to be convinced that gcc can do a good job, just do it 
the other way around. Make the new one be "inline_hint" (no underscores 
needed, btw), and there is ansolutely ZERO confusion about what it means. 

At that point, everybody knows why it's there, and it's clearly not a 
correctness issue or anything else.

Of course, at that point you might as well argue that the thing should not 
exist at all, and that such a flag should just be removed entirely. Which 
I certainly agree with - I think the only flag we need is "inline", and I 
think it should mean what it damn well says.

		Linus
