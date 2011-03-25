From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Fri, 25 Mar 2011 11:31:38 +0100
Message-ID: <20110325103138.GC31903@elte.hu>
References: <20110323153727.GB12003@htj.dyndns.org>
 <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org>
 <20110325101238.GC1409@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110325101238.GC1409@htj.dyndns.org>
List-ID: <linux-btrfs.vger.kernel.org>


* Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Mar 24, 2011 at 10:41:51AM +0100, Tejun Heo wrote:
> >         USER   SYSTEM   SIRQ    CXTSW  THROUGHPUT
> >  SIMPLE 61107  354977    217  8099529  845.100 MB/sec
> >  SPIN   63140  364888    214  6840527  879.077 MB/sec
> > 
> > On various runs, the adaptive spinning trylock consistently posts
> > higher throughput.  The amount of difference varies but it outperforms
> > consistently.
> 
> I've been running more of these tests and am having doubts about the
> consistency.  It seems that, even on a fresh filesystem, some random
> initial condition seems to have persistent effect on the whole run.
> I'll run more tests and report back.

Ok, and there's the deadlock issue as well which Steve noticed.

I'll zap the patches from tip:core/urgent and lets do this via tip:core/locking 
with a .40 timeframe and plenty of time of testing.

Thanks,

	Ingo
