From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Thu, 15 Jan 2009 23:03:57 +0100
Message-ID: <20090115220357.GB4314@elte.hu>
References: <20090114183319.GA18630@elte.hu> <20090114184746.GA21334@elte.hu> <20090114192811.GA19691@elte.hu> <20090115174440.GF29283@parisc-linux.org> <alpine.LFD.2.00.0901150958300.6528@localhost.localdomain> <20090115180844.GL22472@elte.hu> <alpine.LFD.2.00.0901151015270.6528@localhost.localdomain> <1232047618.8269.93.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901151208310.6528@localhost.localdomain> <1232053458.8269.139.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
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
In-Reply-To: <1232053458.8269.139.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>


* Chris Mason <chris.mason@oracle.com> wrote:

> [ re: pipes, ok I don't know of realistic pipe benchmarks but I'll run 
> them if people can suggest one ]

Threaded servers making heavy use of sys_splice() ought to hit the pipe 
mutex all the time.

	Ingo
