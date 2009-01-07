From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v4][RFC]: mutex: implement adaptive spinning
Date: Wed, 7 Jan 2009 09:50:57 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901070945450.3057@localhost.localdomain>
References: <87r63ljzox.fsf@basil.nowhere.org>  <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>  <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins>  <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com>
  <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins>  <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com>  <1231278275.11687.111.camel@twins>  <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain>
 <1231279660.11687.121.camel@twins>  <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain>  <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins>  <1231329783.11687.287.camel@twins>  <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain>
 <1231348801.27813.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
	Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231348801.27813.31.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, 7 Jan 2009, Chris Mason wrote:
> 
> So far I haven't found any btrfs benchmarks where this is slower than
> mutexes without any spinning.  But, it isn't quite as fast as the btrfs
> spin.

Quite frankly, from our history with ext3 and other filesystems, using a 
mutex in the filesystem is generally the wrong thing to do anyway. 

Are you sure you can't just use a spinlock, and just release it over IO? 
The "have to do IO or extend the btree" case is usually pretty damn clear.

Because it really sounds like you're lock-limited, and you should just try 
to clean it up. A pure "just spinlock" in the hotpath is always going to 
be better.

		Linus
