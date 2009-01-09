From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch] measurements, numbers about CONFIG_OPTIMIZE_INLINING=y impact
Date: Sat, 10 Jan 2009 00:32:26 +0100
Message-ID: <20090109233226.GA25793@uranus.ravnborg.org>
References: <20090109084620.3c711aad@infradead.org> <20090109172011.GD26290@one.firstfloor.org> <20090109172801.GC6936@parisc-linux.org> <20090109174719.GG26290@one.firstfloor.org> <20090109094142.367012b6@infradead.org> <20090109180213.GH26290@one.firstfloor.org> <alpine.LFD.2.00.0901090954410.6528@localhost.localdomain> <20090109185509.GJ26290@one.firstfloor.org> <20090109195232.GE23869@mit.edu> <20090109224410.GQ26290@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>,
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
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759345AbZAIXbI@vger.kernel.org>
In-Reply-To: <20090109224410.GQ26290@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 09, 2009 at 11:44:10PM +0100, Andi Kleen wrote:
> > Fetch a gigabyte's worth of data for the debuginfo RPM? 
> 
> The suse 11.0 kernel debuginfo is ~120M.

How is this debuginfo generated?

Someone have posted the following patch which I did not apply in lack
of any real need. But maybe distroes have something similar already
so it makes sense to apply it.

	Sam

Subject: [PATCH] Kbuild: generate debug info in building

This patch will generate kernel debuginfo in Kbuild when invoking "make
debug_info". The separate debug files are in .debug under building tree.
They can help the cases of requiring debug info for tracing/debug tools,
especially cross-compilation. Moreover, it can simplify or standardize
the packaging process for the distributions those will provide
kernel-debuginfo.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 Makefile                 |   14 ++++++++++++++
 scripts/Makefile.modpost |   14 ++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)


diff --git a/Makefile b/Makefile
index 7f9ff9b..eed7510 100644
--- a/Makefile
+++ b/Makefile
@@ -814,6 +814,20 @@ define rule_vmlinux-modpost
        $(Q)echo 'cmd_$@ := $(cmd_vmlinux-modpost)' > $(dot-target).cmd
 endef

+ifdef CONFIG_DEBUG_INFO
+quiet_cmd_vmlinux_debug = GEN     $<.debug
+      cmd_vmlinux_debug = mkdir -p .debug;                          \
+                          $(OBJCOPY) --only-keep-debug              \
+                                     $< .debug/$<.debug
+targets += vmlinux.debug
+endif
+
+debug_info: vmlinux FORCE
+ifdef CONFIG_DEBUG_INFO
+       $(call if_changed,vmlinux_debug)
+       $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost $@
+endif
+
 # vmlinux image - including updated kernel symbols
 vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o
$(kallsyms.o) FORCE
 ifdef CONFIG_HEADERS_CHECK
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index f4053dc..0df73b2 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -137,6 +137,20 @@ $(modules): %.ko :%.o %.mod.o FORCE

 targets += $(modules)

+modules-debug := $(modules:.ko=.ko.debug)
+ifdef CONFIG_DEBUG_INFO
+quiet_cmd_debug_ko = GEN     $@
+      cmd_debug_ko = mkdir -p .debug/`dirname $@`;                     \
+                    $(OBJCOPY) --only-keep-debug $< .debug/$@
+targets += $(modules-debug)
+endif
+
+debug_info: $(modules-debug) FORCE
+
+$(modules-debug): $(modules) FORCE
+ifdef CONFIG_DEBUG_INFO
+       $(call if_changed,debug_ko)
+endif

 # Add FORCE to the prequisites of a target to force it to be always
rebuilt.
 #
---------------------------------------------------------------------------
