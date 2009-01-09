From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -v7][RFC]: mutex: implement adaptive spinning
Date: Fri, 09 Jan 2009 08:23:42 -0800
Message-ID: <49677A0E.3090709@zytor.com>
References: <alpine.LFD.2.00.0901071509160.3057@localhost.localdomain> <1231408718.11687.400.camel@twins> <20090108141808.GC11629@elte.hu> <1231426014.11687.456.camel@twins> <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain> <1231434515.14304.27.camel@think.oraclecorp.com> <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain> <20090108183306.GA22916@elte.hu> <20090108190038.GH496@one.firstfloor.org> <4966AB74.2090104@zytor.com> <20090109133710.GB31845@elte.hu> <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
	Chris Mason <chris.mason@oracle.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	paulmck@linux.vnet.ibm.com, Gregory Haskins <ghaskins@novell.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nick Piggin <npiggin@suse.de>,
	Peter Morreale <pmorreale@novell.com>,
	Sven Dietrich <SDietrich@novell.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901090759420.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Linus Torvalds wrote:
> 
> On Fri, 9 Jan 2009, Ingo Molnar wrote:
>>  
>> -static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
>> +static __asm_inline int
>> +constant_test_bit(int nr, const volatile unsigned long *addr)
>>  {
>>  	return ((1UL << (nr % BITS_PER_LONG)) &
>>  		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
> 
> Thios makes absolutely no sense.
> 
> It's called "__always_inline", not __asm_inline.
> 
> Why add a new nonsensical annotations like that?
> 

__asm_inline was my suggestion, to distinguish "inline this
unconditionally because gcc screws up in the presence of asm()" versus
"inline this unconditionally because the world ends if it isn't" -- to
tell the human reader, not gcc.  I guess the above is a good indicator
that the __asm_inline might have been a bad name.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

