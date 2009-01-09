From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 10:39:14 -0700
Message-ID: <20090109173914.GD6936@parisc-linux.org>
References: <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dirk Hohndel <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz,
	richard.guenther@gmail.com
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090109174719.GG26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2009 at 06:47:19PM +0100, Andi Kleen wrote:
> On Fri, Jan 09, 2009 at 10:28:01AM -0700, Matthew Wilcox wrote:
> > On Fri, Jan 09, 2009 at 06:20:11PM +0100, Andi Kleen wrote:
> > > Also cc Honza in case he has comments (you might want
> > > to review more of the thread in the archives) 
> > 
> > I think this particular bug is already known and discussed:
> 
> I thought so initially too, but:
> 
> > 
> > http://gcc.gnu.org/ml/gcc/2008-12/msg00365.html
> > 
> > and it hints at being fixed with gcc 4.4.  Does anyone want to test
> > that?
> 
> Hugh already tested with 4.4 and it didn't work well. At least
> a lot of the low level asm inlines were not inlined.
> So it looks like it's still mistuned for the kernel.

That seems like valuable feedback to give to the GCC developers.

Richi, you can find the whole thread at

http://marc.info/?l=linux-fsdevel&m=123150610901773&w=2

and http://marc.info/?l=linux-fsdevel&m=123150834405285&w=2 is also
relevant.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
