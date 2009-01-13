From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Tue, 13 Jan 2009 08:49:27 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop>  <1231859742.442.128.camel@twins>  <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>  <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ingo Molnar <mingo@elte.hu>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231864854.7141.8.camel@twins>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 13 Jan 2009, Peter Zijlstra wrote:
> 
> Ok, tested only 1, but that was the one I remember lockups from -- and
> that seems to be good with the cmpxchg.
> 
> Do you fancy me sending v10 or will you make that change locally?

I'd like to get this in, but I'm not going to apply it in any case without 
way more testing.

It missed the merge window, but I'm potentially willing to let it slip in 
- but only if there are a fair number of people willing to do numbers and 
some harsh testing. Preferably people who did see problems earlier, ie at 
a minimum Chris and Ingo under the loads they used before and saw issues 
with.

So do a v10, and ask people to test.

			Linus
