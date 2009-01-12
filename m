From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH -v8][RFC] mutex: implement adaptive spinning
Date: Mon, 12 Jan 2009 11:45:57 -0500
Message-ID: <1231778757.22806.24.camel@think.oraclecorp.com>
References: <1231774622.4371.96.camel@laptop>
	 <alpine.LFD.2.00.0901120802430.6528@localhost.localdomain>
	 <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901120818070.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2009-01-12 at 08:20 -0800, Linus Torvalds wrote:
> 
> On Mon, 12 Jan 2009, Linus Torvalds wrote:
> > 
> > You made it back into the locked version.
> 
> Btw, even if you probably had some reason for this, one thing to note is 
> that I think Chris' performance testing showed that the version using a 
> lock was inferior to his local btrfs hack, while the unlocked version 
> actually beat his hack.
> 

The spinning hack was faster than everything before v7 (we'll call it
the Linus-fix), and the v7 code was much faster than my spin.

This is somewhere in between, with slightly better fairness than v7.

             spin         v7         v8
dbench 50    580MB/s      789MB/s    421MB/s
file creates 152 file/s   162 file/s 195 file/s
file stat    3.8s total   2.3s total 5.3s total

(the file stat run is total run time, so lower is better.  The other
numbers are files or MB per second, so higher is better)

For the file create run, v8 had much lower system time than v7,
averaging 1s of sys time per proc instead of 1.6s.

-chris


