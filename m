From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 20:18:41 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0901092012450.17378@gandalf.stny.rr.com>
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu>
 <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
In-Reply-To: <20090110010125.GA31031@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>


>  - Headers could probably go back to 'extern inline' again. At not small 
>    expense - we just finished moving to 'static inline'. We'd need to 
>    guarantee a library instantiation for every header include file - this 
>    is an additional mechanism with additional introduction complexities 
>    and an ongoing maintenance cost.

I thought the "static inline" in headers should be more of a "always 
inline". As Andrew Morton keeps yelling at me to use static inline instead 
of macros ;-)

I do not see the point in the functions in the headers needing to have 
their "inlines" removed.

> 
>  - 'static inline' functions in .c files that are not used cause no build 
>    warnings - while if we change them to 'static', we get a 'defined but
>    not used' warning. Hundreds of new warnings in the allyesconfig builds.

Perhaps that's a good thing to see what functions are unused in the 
source.

> 
> I know that because i just have removed all variants of 'inline' from all 
> .c files of the kernel, it's a 3.5MB patch:
> 
>    3263 files changed, 12409 insertions(+), 12409 deletions(-)
> 
> x86 defconfig comparisons:
> 
>       text    filename
>    6875817    vmlinux.always-inline                       (  0.000% )
>    6838290    vmlinux.always-inline+remove-c-inlines      ( -0.548% )
>    6794474    vmlinux.optimize-inlining                   ( -1.197% )
> 
> So the kernel's size improved by half a percent. Should i submit it?

Are there cases that are "must inline" in that patch? Also, what is the 
difference if you do vmlinux.optimize-remove-c-inlines? Is there a 
difference there?

-- Steve

