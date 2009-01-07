From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Btrfs for mainline
Date: Wed, 7 Jan 2009 06:24:47 -0700
Message-ID: <20090107132447.GR2002@parisc-linux.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <200901060147.24285.nickpiggin@yahoo.com.au> <1231173015.4290.129.camel@think.oraclecorp.com> <20090107130742.GD3529@elte.hu>
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
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090107130742.GD3529@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 07, 2009 at 02:07:42PM +0100, Ingo Molnar wrote:
> * Chris Mason <chris.mason@oracle.com> wrote:
> > All of this is a long way of saying the btrfs locking scheme is far from 
> > perfect.  I'll look harder at the loop and ways to get rid of it.
> 
> <ob'plug>
> 
> adaptive spinning mutexes perhaps? Such as:

Um, I don't know how your mail client does threading, but mine shows
Peter's message introducing the adaptive spinning mutexes as a reply to
one of Chris' messages in the btrfs thread.

Chris is just saying he'll look at other ways to not need the spinning
mutexes.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
