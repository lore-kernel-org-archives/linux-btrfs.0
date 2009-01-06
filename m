From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 07:55:58 -0800 (PST)
Message-ID: <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <20081231104533.abfb1cf9.akpm@linux-foundation.org> <1230765549.7538.8.camel@think.oraclecorp.com> <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins>
 <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>
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
In-Reply-To: <20090106121052.GA27232@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>



On Tue, 6 Jan 2009, Ingo Molnar wrote:
> 
> The thing i like most about Peter's patch (compared to most other adaptive 
> spinning approaches i've seen, which all sucked as they included various 
> ugly heuristics complicating the whole thing) is that it solves the "how 
> long should we spin" question elegantly: we spin until the owner runs on a 
> CPU.

The other way around, you mean: we spin until the owner is no longer 
holding a cpu.

I agree that it's better than the normal "spin for some random time" 
model, but I can't say I like the "return 0" cases where it just retries 
the whole loop if the semaphore was gotten by somebody else instead. 
Sounds like an easyish live-lock to me. 

I also still strongly suspect that whatever lock actually needs this, 
should be seriously re-thought. 

But apart from the "return 0" craziness I at least dont' _hate_ this 
patch. Do we have numbers? Do we know which locks this matters on?

		Linus
