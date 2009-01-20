From: Ingo Molnar <mingo@elte.hu>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex:
	implement adaptive spinning
Date: Tue, 20 Jan 2009 13:38:24 +0100
Message-ID: <20090120123824.GD7790@elte.hu>
References: <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org> <alpine.LFD.2.00.0901121128080.6528@localhost.localdomain> <496BBE27.2020206@t-online.de> <20090119001345.GA9880@elte.hu> <20090119062212.GC22584@wotan.suse.de> <alpine.LFD.2.00.0901200754100.2974@localhost.localdomain> <20090120005124.GD16304@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090120005124.GD16304@wotan.suse.de>
List-ID: <linux-btrfs.vger.kernel.org>


* Nick Piggin <npiggin@suse.de> wrote:

> > > it seems like a nice opt-in thing that can be used where the aliases 
> > > are verified and the code is particularly performance critical...
> > 
> > Yes. I think we could use it in the kernel, although I'm not sure how 
> > many cases we would ever find where we really care.
> 
> Yeah, we don't tend to do a lot of intensive data processing, so it is 
> normally the cache misses that hurt most as you noted earlier.
> 
> Some places it might be appropriate, though. It might be nice if it can 
> bring code size down too...

I checked, its size effects were miniscule [0.17%] on the x86 defconfig 
kernel and it seems to be a clear loss in total cost as there would be an 
ongoing maintenance cost of this weird new variant of C that language 
lawyers legislated out of thin air and which departs so significantly from 
time-tested C coding concepts and practices.

We'd have to work around aliasing warnings of the compiler again and again 
with no upside and in fact i'd argue that the resulting code is _less_ 
clean.

The lack of data processing complexity in the kernel is not a surprise: 
the kernel is really just a conduit/abstractor between hw and apps, and 
rarely generates genuinely new information. (In fact it can be generally 
considered a broken system call concept if such data processing _has_ to 
be conducted somewhere in the kernel.)

( Notable exceptions would be the crypto code and the RAID5 [XOR checksum]
  and RAID6 [polinomial checksums] code - but those tend to be seriously
  hand-optimized already, with the most critical bits written in assembly. )

	Ingo
