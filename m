From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Tue, 6 Jan 2009 17:56:15 +0100
Message-ID: <20090106165615.GA5168@elte.hu>
References: <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <alpine.LFD.2.00.0901060750410.3057@localhost.localdomain> <alpine.LFD.2.00.0901060808260.3057@localhost.localdomain> <alpine.LFD.2.00.0901060833060.3057@localhost.localdomain> <20090106165409.GA32608@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090106165409.GA32608@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>


* Ingo Molnar <mingo@elte.hu> wrote:

> One thought:
> 
> BUG_ON()'s do_exit() shows a slightly misleading failure pattern to 
> users: instead of a 'hanging' task, we'd get a misbehaving app due to 
> one of its tasks exiting spuriously. It can even go completely unnoticed 
> [users dont look at kernel logs normally] - while a hanging task 
> generally does get noticed. (because there's no progress in processing)
> 
> So instead of the BUG_ON() we could emit a WARN_ONCE() perhaps, plus not 
> do any spinning and just block - resulting in an uninterruptible task 
> (that the user will probably notice) and a scary message in the syslog? 
> [all in the slowpath]

And we'd strictly do an uninterruptible sleep here, unconditionally: even 
if this is within mutex_lock_interruptible() - we dont want a Ctrl-C or a 
SIGKILL to allow to 'break out' the app from the deadlock.

	Ingo
