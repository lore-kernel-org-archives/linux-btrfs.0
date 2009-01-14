From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v9][RFC] mutex: implement adaptive spinning
Date: Wed, 14 Jan 2009 07:43:02 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901140739110.6528@localhost.localdomain>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
 <1231867314.7141.16.camel@twins> <1231901899.1709.18.camel@think.oraclecorp.com> <20090114112158.GA8625@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
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
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114112158.GA8625@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 14 Jan 2009, Ingo Molnar wrote:

> 
> * Chris Mason <chris.mason@oracle.com> wrote:
> 
> > v10 is better that not spinning, but its in the 5-10% range.  So, I've 
> > been trying to find ways to close the gap, just to understand exactly 
> > where it is different.
> > 
> > If I take out:
> > 	/*
> > 	 * If there are pending waiters, join them.
> > 	 */
> > 	if (!list_empty(&lock->wait_list))
> > 		break;
> > 
> > 
> > v10 pops dbench 50 up to 1800MB/s.  The other tests soundly beat my 
> > spinning and aren't less fair.  But clearly this isn't a good solution.
> 
> i think since we already decided that it's ok to be somewhat unfair (_all_ 
> batching constructs introduce unfairness, so the question is never 'should 
> we?' but 'by how much?'), we should just take this out and enjoy the speed 

Yeah, let's just do it. It's going to be unfair, but let's see if the 
unfairness is going to actually be noticeable in real life. I suspect it 
isn't, and if it is, we can look at it again and see if there are other 
approaches.

If it makes _that_ much of a difference on dbench, it's worth being unfair 
even if it's just for some dubious benchmark.

			Linus
