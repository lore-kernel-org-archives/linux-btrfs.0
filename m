From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
Date: Fri, 25 Mar 2011 10:05:18 -0400
Message-ID: <1301061918.14261.188.camel@gandalf.stny.rr.com>
References: <20110323153727.GB12003@htj.dyndns.org>
	 <20110324094119.GD12038@htj.dyndns.org>
	 <20110324094151.GE12038@htj.dyndns.org>
	 <20110325033956.GB9313@home.goodmis.org>
	 <AANLkTimO3b3D+SofYFLyh8Txk+e4Ke4ToKrBiatdFghr@mail.gmail.com>
	 <1301058727.14261.174.camel@gandalf.stny.rr.com>
	 <AANLkTi=BaRFeAL1mS1Rjq_QGgcMb1rOKkvf=ig+23jvP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=BaRFeAL1mS1Rjq_QGgcMb1rOKkvf=ig+23jvP@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2011-03-25 at 16:50 +0300, Andrey Kuzmin wrote:
> On Fri, Mar 25, 2011 at 4:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > On Fri, 2011-03-25 at 14:13 +0300, Andrey Kuzmin wrote:
> >> Turning try_lock into indefinitely spinning one breaks its semantics,
> >> so deadlock is to be expected. But what's wrong in this scenario if
> >> try_lock spins a bit before giving up?
> >
> > Because that will cause this scenario to spin that "little longer"
> > always, and introduce latencies that did not exist before. Either the
> > solution does not break this scenario, or it should not go in.
> 
> Broken semantics and extra latency are two separate issues. If the
> former is fixed, the latter is easily handled by introducing new
> mutex_trylock_spin call that lets one either stick to existing
> behavior (try/fail) or choose a new one where latency penalty is
> justified by locking patterns.
> 

For those wanting a more RT deterministic OS, I will argue against
latency penalties.

-- Steve
