From: Andi Kleen <andi@firstfloor.org>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Wed, 21 Jan 2009 10:20:49 +0100
Message-ID: <20090121092049.GE15750@one.firstfloor.org>
References: <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de> <20090120123824.GD7790@elte.hu> <1232480940.22233.1435.camel@macbook.infradead.org> <20090120210515.GC19710@elte.hu> <alpine.LFD.2.00.0901210814130.2892@localhost.localdomain> <20090120220516.GA10483@elte.hu> <20090121085402.GD15750@one.firstfloor.org> <20090121085208.GO24891@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090121085208.GO24891@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 21, 2009 at 09:52:08AM +0100, Nick Piggin wrote:
> On Wed, Jan 21, 2009 at 09:54:02AM +0100, Andi Kleen wrote:
> > > GCC 4.3.2. Maybe i missed something obvious?
> > 
> > The typical use case of restrict is to tell it that multiple given
> > arrays are independent and then give the loop optimizer 
> > more freedom to handle expressions in the loop that
> > accesses these arrays.
> > 
> > Since there are no loops in the list functions nothing changed.
> > 
> > Ok presumably there are some other optimizations which 
> > rely on that alias information too, but again the list_*
> > stuff is probably too simple to trigger any of them.
> 
> Any function that does several interleaved loads and stores
> through different pointers could have much more freedom to
> move loads early and stores late. 

For once that would require more live registers. It's not
a clear and obvious win. Especially not if you have
only very little registers, like on 32bit x86.

Then it would typically increase code size.

Then x86s tend to have very very fast L1 caches and
if something is not in L1 on reads then the cost of fetching
something for a read dwarfs the few cycles you can typically
get out of this.

And lastly even on a in order system stores can 
be typically queued without stalling, so it doesn't
hurt to do them early.

Also at least x86 gcc normally doesn't do scheduling 
beyond basic blocks, so any if () shuts it up.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
