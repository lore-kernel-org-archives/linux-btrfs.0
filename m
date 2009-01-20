From: Ingo Molnar <mingo@elte.hu>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
	implement adaptive spinning
Date: Tue, 20 Jan 2009 22:05:15 +0100
Message-ID: <20090120210515.GC19710@elte.hu>
References: <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de> <20090120123824.GD7790@elte.hu> <1232480940.22233.1435.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Andi Kleen <andi@firstfloor.org>,
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
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232480940.22233.1435.camel@macbook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2009-01-20 at 13:38 +0100, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > > > it seems like a nice opt-in thing that can be used where the aliases 
> > > > > are verified and the code is particularly performance critical...
> > > > 
> > > > Yes. I think we could use it in the kernel, although I'm not sure how 
> > > > many cases we would ever find where we really care.
> > > 
> > > Yeah, we don't tend to do a lot of intensive data processing, so it is 
> > > normally the cache misses that hurt most as you noted earlier.
> > > 
> > > Some places it might be appropriate, though. It might be nice if it can 
> > > bring code size down too...
> > 
> > I checked, its size effects were miniscule [0.17%] on the x86 defconfig 
> > kernel and it seems to be a clear loss in total cost as there would be an 
> > ongoing maintenance cost
> 
> They were talking about 'restrict', not strict-aliasing. Where it can be 
> used, it's going to give you optimisations that strict-aliasing can't.

the two are obviously related (just that the 'restrict' keyword can be 
used for same-type pointers so it gives even broader leeway) so i used the 
0.17% figure i already had to give a ballpark figure about what such type 
of optimizations can bring us in general.

(Different-type pointer uses are a common pattern: we have a lot of places 
where we have pointers to structures with different types so 
strict-aliasing optimization opportunities apply quite broadly already.)

	Ingo
