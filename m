From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y
 impact
Date: Fri, 09 Jan 2009 12:17:56 -0800
Message-ID: <1231532276.2081.12.camel@entropy>
References: <20090108141808.GC11629@elte.hu>
	 <1231426014.11687.456.camel@twins>
	 <alpine.LFD.2.00.0901080849550.3283@localhost.localdomain>
	 <1231434515.14304.27.camel@think.oraclecorp.com>
	 <alpine.LFD.2.00.0901080955400.3283@localhost.localdomain>
	 <20090108183306.GA22916@elte.hu> <496648C7.5050700@zytor.com>
	 <alpine.LFD.2.00.0901081943150.6528@localhost.localdomain>
	 <20090109130057.GA31845@elte.hu> <49675920.4050205@hp.com>
	 <20090109153508.GA4671@elte.hu>
	 <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Ingo Molnar <mingo@elte.hu>, jim owens <jowens@hp.com>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901090817470.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 2009-01-09 at 08:28 -0800, Linus Torvalds wrote:
> 
> We get oopses that have a nice symbolic back-trace, and it reports an 
> error IN TOTALLY THE WRONG FUNCTION, because gcc "helpfully" inlined 
> things to the point that only an expert can realize "oh, the bug was 
> actually five hundred lines up, in that other function that was just 
> called once, so gcc inlined it even though it is huge".
> 
> See? THIS is the problem with gcc heuristics. It's not about quality of 
> code, it's about RELIABILITY of code. 

[bt]$ cat backtrace.c 
#include <stdlib.h>

static void called_once()
{
	abort();
}

int main(int argc, char* argv[])
{
	called_once();
	return 0;
}
[bt]$ gcc -Wall -O2 -g backtrace.c -o backtrace
[bt]$ gdb --quiet backtrace
(gdb) disassemble main 
Dump of assembler code for function main:
0x00000000004004d0 <main+0>:	sub    $0x8,%rsp
0x00000000004004d4 <called_once+0>:	callq  0x4003b8 <abort@plt>
End of assembler dump.
(gdb) run
Starting program: /home/nicholas/src/bitbucket/bt/backtrace 

Program received signal SIGABRT, Aborted.
0x0000003d9dc32f05 in raise (sig=<value optimized out>) at ../nptl/sysdeps/unix/sysv/linux/raise.c:64
64	  return INLINE_SYSCALL (tgkill, 3, pid, selftid, sig);
(gdb) bt
#0  0x0000003d9dc32f05 in raise (sig=<value optimized out>) at ../nptl/sysdeps/unix/sysv/linux/raise.c:64
#1  0x0000003d9dc34a73 in abort () at abort.c:88
#2  0x00000000004004d9 in called_once () at backtrace.c:5
#3  main (argc=3989, argv=0xf95) at backtrace.c:10
(gdb)


Maybe the kernel's backtrace code should be fixed instead of blaming
gcc.

-- 
Nicholas Miell <nmiell@comcast.net>

