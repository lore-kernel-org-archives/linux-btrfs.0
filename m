From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 11:13:29 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901081109300.3283@localhost.localdomain>
References: <1231441350.14304.48.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762150AbZAHTPB@vger.kernel.org>
In-Reply-To: <1231441350.14304.48.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 8 Jan 2009, Chris Mason wrote:
> 
> It is less fair though, the 50 proc parallel creates had a much bigger
> span between the first and last proc's exit time.  This isn't a huge
> shock, I think it shows the hot path is closer to a real spin lock.

Actually, the real spin locks are now fair. We use ticket locks on x86.

Well, at least we do unless you enable that broken paravirt support. I'm 
not at all clear on why CONFIG_PARAVIRT wants to use inferior locks, but I 
don't much care.

We _could_ certainly aim for using ticket locks for mutexes too, that 
might be quite nice.

But yes, from a throughput standpoint fairness is almost always a bad 
thing, so your numbers could easily go down if we did.

			Linus
