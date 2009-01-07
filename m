From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Btrfs for mainline
Date: Wed, 7 Jan 2009 15:56:21 +0100
Message-ID: <20090107145621.GB23455@elte.hu>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <200901060147.24285.nickpiggin@yahoo.com.au> <1231173015.4290.129.camel@think.oraclecorp.com> <20090107130742.GD3529@elte.hu> <20090107132447.GR2002@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Peter Zijlstra <peterz@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>
To: Matthew Wilcox <matthew@wil.cx>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090107132447.GR2002@parisc-linux.org>
List-ID: <linux-btrfs.vger.kernel.org>


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jan 07, 2009 at 02:07:42PM +0100, Ingo Molnar wrote:
> > * Chris Mason <chris.mason@oracle.com> wrote:
> > > All of this is a long way of saying the btrfs locking scheme is far from 
> > > perfect.  I'll look harder at the loop and ways to get rid of it.
> > 
> > <ob'plug>
> > 
> > adaptive spinning mutexes perhaps? Such as:
> 
> Um, I don't know how your mail client does threading, but mine shows 
> Peter's message introducing the adaptive spinning mutexes as a reply to 
> one of Chris' messages in the btrfs thread.
>
> Chris is just saying he'll look at other ways to not need the spinning 
> mutexes.

But those are not the same spinning mutexes. Chris wrote his mail on Jan 
05, Peter his first mail about spin-mutexes on Jan 06, as a reaction to 
Chris's mail.

My reply links back the discussion to the original analysis from Chris 
pointing out that it would be nice to try BTRFS with plain mutexes plus 
Peter's patch - instead of throwing away BTRFS's locking design or 
anything intrusive like that.

Where's the problem? :)

	Ingo
