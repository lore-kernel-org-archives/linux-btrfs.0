From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Fri, 25 Mar 2011 09:29:30 -0400
Message-ID: <1301059770.14261.187.camel@gandalf.stny.rr.com>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325033956.GB9313@home.goodmis.org>
	 <AANLkTikayCJyYVo1MNpg1EN+88bSQNOu=NPW5s_j4shD@mail.gmail.com>
	 <20110325065300.GB1409@htj.dyndns.org>
	 <1301058600.14261.172.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1301058600.14261.172.camel@gandalf.stny.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2011-03-25 at 09:10 -0400, Steven Rostedt wrote:

> One solution is to have this be only done on explicit trylocks. Perhaps
> introduce a mutex_trylock_spin()? Then when the developer knows that
> this scenario does not exist, they can convert mutex_trylocks() into
> this spinning version.
> 

I'm not sure this is even worth it, as I'm looking at the
btfs/extend-tree.c code, this is the main reason to use mutex_trylock().

I guess what you see in your benchmarks is that trylock contention
happens mostly in the non-deadlock scenario. But I bet you have
latencies when it does happen, but the benefit seems to out weigh it in
the results.

I wonder what happens if you run dbench as an RT task.

-- Steve
