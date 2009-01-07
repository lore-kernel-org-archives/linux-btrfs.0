From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Date: Wed, 7 Jan 2009 06:35:40 -0700
Message-ID: <20090107133540.GS2002@parisc-linux.org>
References: <49636799.1010109@novell.com> <20090106214229.GD6741@linux.vnet.ibm.com> <1231278275.11687.111.camel@twins> <alpine.LFD.2.00.0901061349520.3057@localhost.localdomain> <1231279660.11687.121.camel@twins> <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <49642829.20006@cn.fujitsu.com> <1231309970.11687.163.camel@twins> <49645B17.7000001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <49645B17.7000001@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 07, 2009 at 03:34:47PM +0800, Lai Jiangshan wrote:
> So I think current task should sleep earlier when it detects that
> mutex owner start schedule().

How do you propose it detects this?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
