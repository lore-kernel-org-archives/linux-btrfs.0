From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 08:11:41 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peter Zijlstra <peterz@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Gregory Haskins <ghaskins@novell.com>,
	Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 6 Jan 2009, Linus Torvalds wrote:
> 
> The other way around, you mean: we spin until the owner is no longer 
> holding a cpu.

Btw, I hate the name of the helper function for that. "task_is_current()"? 
"current" means something totally different in the linux kernel: it means 
that the task is _this_ task.

So the only sensible implementation of "task_is_current(task)" is to just 
make it return "task == current", but that's obviously not what the 
function wants to do.

So it should be renamed. Something like "task_is_oncpu()" or whatever.

I realize that the scheduler internally has that whole "rq->curr" thing, 
but that's an internal scheduler thing, and should not be confused with 
the overall kernel model of "current".

		Linus
