From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 18:24:39 +0100
Message-ID: <1231781079.4371.198.camel@laptop>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
	 <1231778757.22806.24.camel@think.oraclecorp.com>
	 <1231779015.4371.138.camel@laptop>
	 <1231780491.22806.28.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
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
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231780491.22806.28.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-12 at 12:14 -0500, Chris Mason wrote:
> On Mon, 2009-01-12 at 17:50 +0100, Peter Zijlstra wrote:
> > > 
> > > (the file stat run is total run time, so lower is better.  The other
> > > numbers are files or MB per second, so higher is better)
> > > 
> > > For the file create run, v8 had much lower system time than v7,
> > > averaging 1s of sys time per proc instead of 1.6s.
> > 
> > Right, how about the spread in completion time, because that is the only
> > reason I tried this fairness stuff, because you reported massive
> > differences there.
> > 
> 
> I reran the numbers with a slightly different kernel config and they
> have changed somewhat.  These are just for the 4k file create run, all
> numbers in files created per second (and the numbers are stable across
> runs)
> 
> v8 avg 176.90 median 171.85 std 12.49 high 215.97 low 165.54
> v7 avg 169.02 median 163.77 std 16.82 high 267.95 low 157.95

Any opinions on the fairness matter, will -v9 be unlocked and unfair
again?

