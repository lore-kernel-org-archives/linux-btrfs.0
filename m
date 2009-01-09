From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
	impact
Date: Fri, 9 Jan 2009 16:35:08 +0100
Message-ID: <20090109153508.GA4671@elte.hu>
References: <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com> <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain> <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49675920.4050205@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>


* jim owens <jowens@hp.com> wrote:

> Ingo Molnar wrote:
>>
>> One interpretation of the numbers would be that core kernel hackers are 
>> more inline-happy, maybe because they think that their functions are 
>> more important to inline.
>>
>> Which is generally a fair initial assumption, but according to the 
>> numbers it does not appear to pay off in practice as it does not result 
>> in a smaller kernel image.
>
> I think people over-use inline for the opposite reason.

Note that i talked about the core kernel (kernel/*.c) specifically.

> They are taught:
>    - use inline functions instead of macros
>    - inlining functions makes your code run faster
>
> They also know inlining may increase program object size. That inlining 
> will reduce object size on many architectures if the function is small 
> is just a happy side effect to them.

Core kernel developers tend to be quite inline-conscious and generally do 
not believe that making something inline will make it go faster.

That's why i picked kernel/built-in.o as a good "best of breed" entity to 
measure - if then that is an area where we have at least the chance to do 
a "kernel coders know best when to inline" manual inlining job.

But despite a decade of tuning and systematic effort in that area, the 
numbers suggest that we dont. (if someone has different numbers or 
different interpretation, please share it with us.)

My goal is to make the kernel smaller and faster, and as far as the 
placement of 'inline' keywords goes, i dont have too strong feelings about 
how it's achieved: they have a certain level of documentation value 
[signalling that a function is _intended_ to be lightweight] but otherwise 
they are pretty neutral attributes to me.

So we want all the mechanisms in place to constantly press towards a 
smaller and faster kernel, with the most efficient use of development 
resources. Some techniques work in practice despite looking problematic, 
some dont, despite looking good on paper.

This might be one of those cases. Or not :-)

	Ingo
