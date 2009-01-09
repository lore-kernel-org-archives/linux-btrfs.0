From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 09 Jan 2009 11:13:30 -0800
Message-ID: <4967A1DA.70100@zytor.com>
References: <20090109130057.GA31845@elte.hu> <20090109153508.GA4671@elte.hu>	 <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org>	 <20090109172011.GD26290@one.firstfloor.org>	 <20090109172801.GC6936@parisc-linux.org>	 <20090109174719.GG26290@one.firstfloor.org>	 <20090109173914.GD6936@parisc-linux.org>	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>	 <20090109181952.GI26290@one.firstfloor.org> <84fc9c000901091059v65265413wda053d3ce5b0d17a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Dirk Hohndel <hohndel@infradead.org>,
	Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>, jh@suse.cz
To: Richard Guenther <richard.guenther@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <84fc9c000901091059v65265413wda053d3ce5b0d17a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Richard Guenther wrote:
>>
>> But it's also not inconceivable that gcc adds a -fkernel-inlining or
>> similar that changes the parameters if we ask nicely. I suppose
>> actually such a parameter would be useful for far more programs
>> than the kernel.
> 
> I think that the kernel is a perfect target to optimize default -Os behavior for
> (whereas template heavy C++ programs are a target to optimize -O2 for).
> And I think we did a good job in listening to kernel developers if once in
> time they tried to talk to us - GCC 4.3 should be good in compiling the
> kernel with default -Os settings.  We, unfortunately, cannot retroactively
> fix old versions that kernel developers happen to like and still use.
> 

Unfortunately I think there have been a lot of "we can't talk to them" 
on both sides of the kernel-gcc interface, which is incredibly 
unfortunate.  I personally try to at least observe gcc development, 
including monitoring #gcc and knowing enough about gcc internals to 
write a (crappy) port, but I can hardly call myself a gcc expert. 
Still, I am willing to spend some significant time interfacing with 
anyone in the gcc community willing to spend the effort.  I think we can 
do good stuff.

	-hpa
