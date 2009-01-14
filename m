From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Date: Wed, 14 Jan 2009 10:53:00 -0800
Message-ID: <20090114105300.66bd014d.akpm@linux-foundation.org>
References: <1231774622.4371.96.camel@laptop>
	<1231859742.442.128.camel@twins>
	<alpine.LFD.2.00.0901130812590.6528@localhost.localdomain>
	<1231863710.7141.3.camel@twins>
	<1231864854.7141.8.camel@twins>
	<alpine.LFD.2.00.0901130846320.6528@localhost.localdomain>
	<1231867314.7141.16.camel@twins>
	<1231952436.14825.28.camel@laptop>
	<20090114183319.GA18630@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>,
	Dmitry Adamushko <dmitry.adamushko@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090114183319.GA18630@elte.hu>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 14 Jan 2009 19:33:19 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Please pull the adaptive-mutexes-for-linus git tree

<fear>

- It seems a major shortcoming that the feature is disabled if
  CONFIG_DEBUG_MUTEXES=y.  It means that lots of people won't test it.

- When people hit performance/latency oddities, it would be nice if
  they had a /proc knob with which they could disable this feature at
  runtime.

  This would also be useful for comparative performance testing.
