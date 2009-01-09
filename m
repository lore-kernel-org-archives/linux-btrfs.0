From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Thu, 08 Jan 2009 20:59:33 -0800 (PST)
Message-ID: <20090108.205933.96892305.davem@davemloft.net>
References: <20090108183306.GA22916@elte.hu>
	<496648C7.5050700@zytor.com>
	<alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: hpa@zytor.com, mingo@elte.hu, chris.mason@oracle.com,
	peterz@infradead.org, rostedt@goodmis.org,
	paulmck@linux.vnet.ibm.com, ghaskins@novell.com, matthew@wil.cx,
	andi@firstfloor.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, tglx@linutronix.de, npiggin@suse.de,
	pmorreale@novell.com, SDietrich@novell.com
To: torvalds@linux-foundation.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 8 Jan 2009 19:46:30 -0800 (PST)

> First off, gcc _does_ have a perfectly fine notion of how heavy-weight an 
> "asm" statement is: just count it as a single instruction (and count the 
> argument setup cost that gcc _can_ estimate).

Actually, at least at one point, it counted the number of newline
characters in the assembly string to estimate how many instructions
are contained inside.

It actually needs to know exaclty how many instructions are in there,
to emit proper far branches and stuff like that, for some cpus.

Since they never added an (optional) way to actually tell the compiler
this critical piece of information, so I guess the newline hack is the
best they could come up with.
