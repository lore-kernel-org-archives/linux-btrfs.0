From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: gcc inlining heuristics was Re: [PATCH -v7][RFC]: mutex: implement
 adaptive spinning
Date: Mon, 12 Jan 2009 11:22:56 -0800
Message-ID: <496B9890.1090002@zytor.com>
References: <20090111201427.GP26290@one.firstfloor.org> <1231704939.25018.548.camel@macbook.infradead.org> <20090111203441.GQ26290@one.firstfloor.org> <alpine.LFD.2.00.0901111248060.6528@localhost.localdomain> <alpine.LFD.2.00.0901111458290.6528@localhost.localdomain> <20090112001255.GR26290@one.firstfloor.org> <alpine.LFD.2.00.0901111619400.6528@localhost.localdomain> <20090112005228.GS26290@one.firstfloor.org> <496B86B5.3090707@t-online.de> <alpine.LFD.2.00.0901121034170.6528@localhost.localdomain> <20090112193201.GA23848@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Harvey Harrison <harvey.harrison@gmail.com>,
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
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756824AbZALT1M@vger.kernel.org>
In-Reply-To: <20090112193201.GA23848@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Andi Kleen wrote:
> On Mon, Jan 12, 2009 at 11:02:17AM -0800, Linus Torvalds wrote:
>>> Something at the back of my mind said "aliasing".
>>>
>>> $ gcc linus.c -O2 -S ; grep subl linus.s
>>>         subl    $1624, %esp
>>> $ gcc linus.c -O2 -S -fno-strict-aliasing; grep subl linus.s
>>>         subl    $824, %esp
>>>
>>> That's with 4.3.2.
>> Interesting. 
>>
>> Nonsensical, but interesting.
> 
> What I find nonsensical is that -fno-strict-aliasing generates
> better code here. Normally one would expect the compiler seeing
> more aliases with that option and then be more conservative
> regarding any sharing. But it seems to be the other way round
> here.

For this to be convolved with aliasing *AT ALL* indicates this is done 
incorrectly.

This is about storage allocation, not aliases.  Storage allocation only 
depends on lifetime.

	-hpa
