From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 06 Jan 2009 14:20:41 +0100
Message-ID: <1231248041.11687.107.camel@twins>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	 <20081231104533.abfb1cf9.akpm@linux-foundation.org>
	 <1230765549.7538.8.camel@think.oraclecorp.com>
	 <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org>
	 <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org>
	 <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu>
	 <4963584A.4090805@novell.com>  <20090106131643.GA15228@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090106131643.GA15228@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-01-06 at 14:16 +0100, Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > Ingo Molnar wrote:
> > > There's no time or spin-rate based heuristics in this at all (i.e. these 
> > > mutexes are not 'adaptive' at all!),
> > 
> > FYI: The original "adaptive" name was chosen in the -rt implementation 
> > to reflect that the locks can adaptively spin or sleep, depending on 
> > conditions.  I realize this is in contrast to the typical usage of the 
> > term when it is in reference to the spin-time being based on some 
> > empirical heuristics, etc as you mentioned.  Sorry for the confusion.
> 
> the current version of the -rt spinny-mutexes bits were mostly written by 
> Steve, right? Historically it all started out with a more classic 
> "adaptive mutexes" patchset so the name stuck i guess.

Yeah, Gregory and co. started with the whole thing and showed there was
significant performance to be gained, after that Steve rewrote it from
scratch reducing it to this minimalist heuristic, with help from Greg.

(At least, that is how I remember it, please speak up if I got things
wrong)
