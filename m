From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 10:16:53 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain>
References: <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu>
 <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain> <20090115180844.GL22472@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090115180844.GL22472@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Thu, 15 Jan 2009, Ingo Molnar wrote:
> 
> btw., i think spin-mutexes have a design advantage here: in a lot of code 
> areas it's quite difficult to use spinlocks - cannot allocate memory, 
> cannot call any code that can sporadically block (but does not _normally_ 
> block), etc.
> 
> With mutexes those atomicity constraints go away - and the performance 
> profile should now be quite close to that of spinlocks as well.

Umm. Except if you wrote the code nicely and used spinlocks, you wouldn't 
hold the lock over all those unnecessary and complex operations.

IOW, if you do pre-allocation instead of holding a lock over the 
allocation, you win. So yes, spin-mutexes makes it easier to write the 
code, but it also makes it easier to just plain be lazy.

			Linus
