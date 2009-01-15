From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 10:53:21 +0100
Message-ID: <20090115095321.GC5833@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <1231958447.8269.30.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
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
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1231958447.8269.30.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


* Chris Mason <chris.mason@oracle.com> wrote:

> On Wed, 2009-01-14 at 19:33 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Full series, including changelogs available at:
> > > 
> > >  http://programming.kicks-ass.net/kernel-patches/mutex-adaptive-spin/
> > > 
> > > and should shortly appear in a git tree near Ingo :-)
> > 
> > Linus,
> > 
> > Please pull the adaptive-mutexes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git adaptive-mutexes-for-linus
> > 
> 
> I was going to put this into the btrfs tree, but since you have a branch
> just for adaptive mutexes, is it easier to put there?
> 
> From: Chris Mason <chris.mason@oracle.com>
> 
> Btrfs: stop spinning on mutex_trylock and let the adaptive code spin for us
> 
> Mutexes now spin internally and the btrfs spin is no longer required for
> performance.
> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>

applied it to tip/core/locking, thanks Chris!

	Ingo
