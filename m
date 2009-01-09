From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 9 Jan 2009 07:58:41 +0100
Message-ID: <20090109065841.GB26290@one.firstfloor.org>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <1231444786.5715.8.camel@brick> <4966ABF9.9080409@zytor.com> <20090109033531.GR496@one.firstfloor.org> <20090108220028.3b73a509.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Harvey Harrison <harvey.harrison@gmail.com>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090108220028.3b73a509.akpm@linux-foundation.org>
List-ID: <linux-btrfs.vger.kernel.org>

> foo()
> {
> 	char a[1000];
> }
> 
> bar()
> {
> 	char a[1000];
> }
> 
> zot()
> {
> 	foo();
> 	bar();
> }
> 
> uses 2000 bytes of stack.
> And with the right compiler version.

I believe that's fixed in newer gcc versions.

For old gccs we might indeed need to add noinlines though.

-Andi

-- 
ak@linux.intel.com
