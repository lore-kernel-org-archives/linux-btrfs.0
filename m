From: Nick Piggin <npiggin@suse.de>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Tue, 20 Jan 2009 01:51:24 +0100
Message-ID: <20090120005124.GD16304@wotan.suse.de>
References: <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	Andi Kleen <andi@firstfloor.org>,
	David Woodhouse <dwmw2@infradead.org>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 20, 2009 at 08:01:52AM +1100, Linus Torvalds wrote:
> 
> 
> On Mon, 19 Jan 2009, Nick Piggin wrote:
> > 
> > I want to know what is the problem with the restrict keyword?
> > I'm sure I've read Linus ranting about how bad it is in the
> > past...
> 
> No, I don't think I've ranted about 'restrict'. I think it's a reasonable 
> solution for performance-critical code, and unlike the whole type-aliasing 
> model, it actually works for the _sane_ cases (ie doing some operation 
> over two arrays of the same type, and letting the compiler know that it 
> can access the arrays without fearing that writing to one would affect 
> reading from the other).
> 
> The problem with 'restrict' is that almost nobody uses it, and it does 
> obviously require programmer input rather than the compiler doing it 
> automatically. But it should work well as a way to get Fortran-like 
> performance from HPC workloads written in C - which is where most of the 
> people are who really want the alias analysis.

OK, that makes sense. I just had a vague feeling that you disliked
it.

 
> > it seems like a nice opt-in thing that can be used where the aliases are 
> > verified and the code is particularly performance critical...
> 
> Yes. I think we could use it in the kernel, although I'm not sure how many 
> cases we would ever find where we really care. 

Yeah, we don't tend to do a lot of intensive data processing, so it is
normally the cache misses that hurt most as you noted earlier.

Some places it might be appropriate, though. It might be nice if it can
bring code size down too...

