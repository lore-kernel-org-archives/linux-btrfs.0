From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
Date: Thu, 8 Jan 2009 15:45:41 +0100
Message-ID: <20090108144541.GA496@one.firstfloor.org>
References: <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <1231365115.11687.361.camel@twins> <alpine.LFD.2.00.0901071355350.3057@localhost.localdomain> <1231368870.6686.16.camel@norville.austin.ibm.com> <alpine.LFD.2.00.0901071518570.3057@localhost.localdomain> <alpine.DEB.1.10.0901071848431.23456@gandalf.stny.rr.com> <20090108065235.GX496@one.firstfloor.org> <alpine.DEB.1.10.0901080919540.22642@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Steven Rostedt <rostedt@goodmis.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0901080919540.22642@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Sure, it probably is a non issue, but I'm afraid that non issues of today 
> might become issues of tomorrow. Where does it say that we can never put a 
> task struct in a movable zone.

Task structs are not movable, so they by definition do not belong
in movable zones.

> memory local to it, and pinned tasks to that CPU in that memory. Then 
> there can be cases where we remove the CPU and memory together.

If you did that you would need to redesign so much of the kernel,
changing the mutex code too would be the smallest of your worries.

-Andi
-- 
ak@linux.intel.com
