From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 17:39:18 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901091734260.6528@localhost.localdomain>
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain> <20090109204103.GA17212@elte.hu> <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu>
 <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090110010125.GA31031@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Sat, 10 Jan 2009, Ingo Molnar wrote:
> 
>  - 'static inline' functions in .c files that are not used cause no build 
>    warnings - while if we change them to 'static', we get a 'defined but
>    not used' warning. Hundreds of new warnings in the allyesconfig builds.

Well, duh. Maybe they shouldn't be marked "inline", and maybe they should 
be marked with "__maybe_unused" instead. 

I do not think it makes sense to use "inline" as a way to say "maybe I 
won't use this function".

Yes, it's true that "static inline" won't warn, but hey, as a way to avoid 
a warning it's a pretty bad one.

			Linus
