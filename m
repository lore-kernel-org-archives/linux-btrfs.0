From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Wed, 30 Mar 2011 13:52:04 +0200
Message-ID: <1301485924.4859.181.camel@twins>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325101238.GC1409@htj.dyndns.org>
	 <20110329163702.GE29865@htj.dyndns.org>  <1301485262-sup-5247@think>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1301485262-sup-5247@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2011-03-30 at 07:46 -0400, Chris Mason wrote:
> 
> In this case, the only thing we're really missing is a way to mutex_lock
> without the cond_resched() 

So you're trying to explicitly avoid a voluntary preemption point? Seems
like a bad idea, normally people add those :-)
