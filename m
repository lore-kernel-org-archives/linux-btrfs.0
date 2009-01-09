From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 09 Jan 2009 11:17:38 -0800
Message-ID: <4967A2D2.3070105@zytor.com>
References: <20090109153508.GA4671@elte.hu>	 <20090109084620.3c711aad@infradead.org>	 <20090109172011.GD26290@one.firstfloor.org>	 <20090109172801.GC6936@parisc-linux.org>	 <20090109174719.GG26290@one.firstfloor.org>	 <20090109173914.GD6936@parisc-linux.org>	 <alpine.LFD.2.00.0901090947080.6528@localhost.localdomain>	 <20090109181952.GI26290@one.firstfloor.org>	 <84fc9c000901091059v65265413wda053d3ce5b0d17a@mail.gmail.com>	 <20090109192158.GK26290@one.firstfloor.org> <84fc9c000901091110n2f5565b7mecf9acec35cf5a0@mail.gmail.com>
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
In-Reply-To: <84fc9c000901091110n2f5565b7mecf9acec35cf5a0@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Richard Guenther wrote:
> On Fri, Jan 9, 2009 at 8:21 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> GCC 4.3 should be good in compiling the
>>> kernel with default -Os settings.
>> It's unfortunately not. It doesn't inline a lot of simple asm() inlines
>> for example.
> 
> Reading Ingos posting with the actual numbers states the opposite.
> 

Well, Andi's patch forcing inlining of the bitops chops quite a bit of 
size off the kernel, so there is clearly room for improvement.  From my 
post yesterday:

: voreg 64 ; size o.*/vmlinux
    text    data     bss     dec     hex     filename
57590217 24940519 15560504 98091240 5d8c0e8 o.andi/vmlinux
59421552 24912223 15560504 99894279 5f44407 o.noopt/vmlinux
57700527 24950719 15560504 98211750 5da97a6 o.opty/vmlinux

110 KB of code size reduction by force-inlining the small bitops.

	-hpa
