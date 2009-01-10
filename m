From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 09 Jan 2009 17:08:17 -0800
Message-ID: <1231549697.5700.7.camel@brick>
References: <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu>
	 <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
	 <20090109204103.GA17212@elte.hu>
	 <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain>
	 <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick>
	 <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain>
	 <20090109231227.GA25070@elte.hu>
	 <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain>
	 <20090110010125.GA31031@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090110010125.GA31031@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2009-01-10 at 02:01 +0100, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:

>  - Headers could probably go back to 'extern inline' again. At not small 
>    expense - we just finished moving to 'static inline'. We'd need to 
>    guarantee a library instantiation for every header include file - this 
>    is an additional mechanism with additional introduction complexities 
>    and an ongoing maintenance cost.

Puzzled?  What benefit is there to going back to extern inline in headers?

Harvey

