From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Fri, 9 Jan 2009 19:55:09 +0100
Message-ID: <20090109185509.GJ26290@one.firstfloor.org>
References: <49675920.4050205@hp.com> <20090109153508.GA4671@elte.hu> <49677CB1.3030701@zytor.com> <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org> <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Dirk Hohndel <hohndel@infradead.org>,
	Matthew Wilcox <matthew@wil.cx>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	jim owens <jowens@hp.com>,
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

> But _users_ just get their oopses sent automatically. So it's not about 

If they send it from distro kernels the automated oops sender could
just fetch the debuginfo rpm and decode it down to a line.
My old automatic user segfault uploader I did originally
for the core pipe code did that too.

> "debugging kernels", it's about _normal_ kernels. They are the ones that 
> need to be debuggable, and the ones that care most about things like the 
> symbolic EIP being as helpful as possible.

Ok you're saying we should pay the 4.1% by default for this?
If you want that you can apply the appended patch.
Not sure if it's really a good idea though. 4.1% is a lot.

-Andi

---

Disable inlining of functions called once by default

This makes oopses easier to read because it's clearer in which
function the problem is.

Disadvantage: costs ~4.1% of text size (measured with allyesconfig
on gcc 4.1 on x86-64)

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Makefile |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.28-git12/Makefile
===================================================================
--- linux-2.6.28-git12.orig/Makefile	2009-01-09 07:06:44.000000000 +0100
+++ linux-2.6.28-git12/Makefile	2009-01-09 07:16:21.000000000 +0100
@@ -546,10 +546,8 @@
 KBUILD_CFLAGS	+= -pg
 endif
 
-# We trigger additional mismatches with less inlining
-ifdef CONFIG_DEBUG_SECTION_MISMATCH
+# Disable too aggressive inlining because it makes oopses harder to read
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
-endif
 
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)


-- 
ak@linux.intel.com
