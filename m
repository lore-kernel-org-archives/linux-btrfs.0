From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Sun, 11 Jan 2009 19:13:07 +0100
Message-ID: <20090111181307.GM26290@one.firstfloor.org>
References: <alpine.LFD.2.00.0901091251380.6528@localhost.localdomain> <20090109213442.GA20051@elte.hu> <1231537320.5726.2.camel@brick> <alpine.LFD.2.00.0901091347170.6528@localhost.localdomain> <20090109231227.GA25070@elte.hu> <alpine.LFD.2.00.0901091522250.6528@localhost.localdomain> <20090110010125.GA31031@elte.hu> <20090109174158.096dee70.akpm@linux-foundation.org> <20090110030216.GW26290@one.firstfloor.org> <1231676801.25018.150.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231676801.25018.150.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 11, 2009 at 12:26:41PM +0000, David Woodhouse wrote:
>   - Unconditionally have 'inline' meaning 'always_inline'. If we say it,
>     we should mean it.
> 
>   - Resist the temptation to use -fno-inline-functions. Allow GCC to
>     inline other things if it wants to.

The proposal was to use -fno-inline-functions-called-once (but 
the resulting numbers were not promising)

We've never allowed gcc to inline any other functions not marked
inline explicitely because that's not included in -O2. 

>   - Reduce the number of unnecessary 'inline' markers, and have a policy
>     that the use of 'inline' should be accompanied by either a GCC PR#
>     or an explanation of why we couldn't reasonably have expected GCC to
>     get this particular case right.
> 
>   - Have a similar policy of PR# or explanation for 'uninline' too.
> 
> I don't think we should just give up on GCC ever getting it right. That
> way lies madness. As we've often found in the past. 

It sounds like you're advocating to set -O3/-finline-functions
by default.   Not sure that's a good idea.

-Andi

-- 
ak@linux.intel.com
