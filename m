From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
	impact
Date: Fri, 9 Jan 2009 16:23:35 -0500
Message-ID: <20090109212335.GH23869@mit.edu>
References: <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109173914.GD6936@parisc-linux.org> <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain> <84fc9c000901091109t2c2aef2fu596f8807b0962688@mail.gmail.com> <alpine.LFD.2.00.0901091128170.6528@localhost.localdomain> <84fc9c000901091214i16fc74b7q349433a5586d5619@mail.gmail.com> <alpine.LFD.2.00.0901091217530.6528@localhost.localdomain> <84fc9c000901091237i68b2e495tab55e61fb3dbd565@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
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
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Richard Guenther <richard.guenther@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <84fc9c000901091237i68b2e495tab55e61fb3dbd565@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I'm beginning to think that for the kernel, we should just simply
remove CONFIG_OPTIMIZE_INLINING (so that inline means
"always_inline"), and -fno-inline-functions
-fno-inline-functions-called-one (so that gcc never inlines functions
behind our back) --- and then we create tools that count how many times functions get used, and how big functions are, so that we can flag if some 
function really should be marked inline when it isn't or vice versa.   

But given that this is a very hard thing for an automated program
todo, let's write some tools so we can easily put a human in the loop,
who can add or remove inline keywords where it makes sense, and let's
give up on gcc being able to "guess" correctly.

For some things, like register allocation, I can accept that the
compiler will usually get these things right.  But whether or not to
inline a function seems to be one of those things that humans (perhaps
with some tools assist) can still do a better job than compilers.

     	  		    	     - Ted
