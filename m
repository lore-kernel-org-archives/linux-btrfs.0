Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD602C10F0E
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:09:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B06E206B6
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388667AbfDRJIC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:08:02 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:34147 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388631AbfDRJIC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 05:08:02 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH30X-00020X-3n; Thu, 18 Apr 2019 11:07:01 +0200
Message-Id: <20190418084255.652003111@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 18 Apr 2019 10:41:47 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        linux-arch@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [patch V2 28/29] stacktrace: Provide common infrastructure
References: <20190418084119.056416939@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All architectures which support stacktrace carry duplicated code and
do the stack storage and filtering at the architecture side.

Provide a consolidated interface with a callback function for consuming the
stack entries provided by the architecture specific stack walker. This
removes lots of duplicated code and allows to implement better filtering
than 'skip number of entries' in the future without touching any
architecture specific code.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-arch@vger.kernel.org
---
 include/linux/stacktrace.h |   38 +++++++++
 kernel/stacktrace.c        |  173 +++++++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig                |    4 +
 3 files changed, 215 insertions(+)

--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -23,6 +23,43 @@ unsigned int stack_trace_save_regs(struc
 unsigned int stack_trace_save_user(unsigned long *store, unsigned int size);
 
 /* Internal interfaces. Do not use in generic code */
+#ifdef CONFIG_ARCH_STACKWALK
+
+/**
+ * stack_trace_consume_fn - Callback for arch_stack_walk()
+ * @cookie:	Caller supplied pointer handed back by arch_stack_walk()
+ * @addr:	The stack entry address to consume
+ * @reliable:	True when the stack entry is reliable. Required by
+ *		some printk based consumers.
+ *
+ * Returns:	True, if the entry was consumed or skipped
+ *		False, if there is no space left to store
+ */
+typedef bool (*stack_trace_consume_fn)(void *cookie, unsigned long addr,
+				       bool reliable);
+/**
+ * arch_stack_walk - Architecture specific function to walk the stack
+
+ * @consume_entry:	Callback which is invoked by the architecture code for
+ *			each entry.
+ * @cookie:		Caller supplied pointer which is handed back to
+ *			@consume_entry
+ * @task:		Pointer to a task struct, can be NULL
+ * @regs:		Pointer to registers, can be NULL
+ *
+ * @task	@regs:
+ * NULL		NULL	Stack trace from current
+ * task		NULL	Stack trace from task (can be current)
+ * NULL		regs	Stack trace starting on regs->stackpointer
+ */
+void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
+		     struct task_struct *task, struct pt_regs *regs);
+int arch_stack_walk_reliable(stack_trace_consume_fn consume_entry, void *cookie,
+			     struct task_struct *task);
+void arch_stack_walk_user(stack_trace_consume_fn consume_entry, void *cookie,
+			  const struct pt_regs *regs);
+
+#else /* CONFIG_ARCH_STACKWALK */
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
@@ -37,6 +74,7 @@ extern void save_stack_trace_tsk(struct
 extern int save_stack_trace_tsk_reliable(struct task_struct *tsk,
 					 struct stack_trace *trace);
 extern void save_stack_trace_user(struct stack_trace *trace);
+#endif /* !CONFIG_ARCH_STACKWALK */
 #endif /* CONFIG_STACKTRACE */
 
 #if defined(CONFIG_STACKTRACE) && defined(CONFIG_HAVE_RELIABLE_STACKTRACE)
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -5,6 +5,8 @@
  *
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
+#include <linux/sched/task_stack.h>
+#include <linux/sched/debug.h>
 #include <linux/sched.h>
 #include <linux/kernel.h>
 #include <linux/export.h>
@@ -64,6 +66,175 @@ int stack_trace_snprint(char *buf, size_
 }
 EXPORT_SYMBOL_GPL(stack_trace_snprint);
 
+#ifdef CONFIG_ARCH_STACKWALK
+
+struct stacktrace_cookie {
+	unsigned long	*store;
+	unsigned int	size;
+	unsigned int	skip;
+	unsigned int	len;
+};
+
+static bool stack_trace_consume_entry(void *cookie, unsigned long addr,
+				      bool reliable)
+{
+	struct stacktrace_cookie *c = cookie;
+
+	if (c->len >= c->size)
+		return false;
+
+	if (c->skip > 0) {
+		c->skip--;
+		return true;
+	}
+	c->store[c->len++] = addr;
+	return c->len < c->size;
+}
+
+static bool stack_trace_consume_entry_nosched(void *cookie, unsigned long addr,
+					      bool reliable)
+{
+	if (in_sched_functions(addr))
+		return true;
+	return stack_trace_consume_entry(cookie, addr, reliable);
+}
+
+/**
+ * stack_trace_save - Save a stack trace into a storage array
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ *
+ * Returns number of entries stored.
+ */
+unsigned int stack_trace_save(unsigned long *store, unsigned int size,
+			      unsigned int skipnr)
+{
+	stack_trace_consume_fn consume_entry = stack_trace_consume_entry;
+	struct stacktrace_cookie c = {
+		.store	= store,
+		.size	= size,
+		.skip	= skipnr + 1,
+	};
+
+	arch_stack_walk(consume_entry, &c, current, NULL);
+	return c.len;
+}
+EXPORT_SYMBOL_GPL(stack_trace_save);
+
+/**
+ * stack_trace_save_tsk - Save a task stack trace into a storage array
+ * @task:	The task to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ *
+ * Returns number of entries stored.
+ */
+unsigned int stack_trace_save_tsk(struct task_struct *tsk, unsigned long *store,
+				  unsigned int size, unsigned int skipnr)
+{
+	stack_trace_consume_fn consume_entry = stack_trace_consume_entry_nosched;
+	struct stacktrace_cookie c = {
+		.store	= store,
+		.size	= size,
+		.skip	= skipnr + 1,
+	};
+
+	if (!try_get_task_stack(tsk))
+		return 0;
+
+	arch_stack_walk(consume_entry, &c, tsk, NULL);
+	put_task_stack(tsk);
+	return c.len;
+}
+
+/**
+ * stack_trace_save_regs - Save a stack trace based on pt_regs into a storage array
+ * @regs:	Pointer to pt_regs to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ *
+ * Returns number of entries stored.
+ */
+unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
+				   unsigned int size, unsigned int skipnr)
+{
+	stack_trace_consume_fn consume_entry = stack_trace_consume_entry;
+	struct stacktrace_cookie c = {
+		.store	= store,
+		.size	= size,
+		.skip	= skipnr,
+	};
+
+	arch_stack_walk(consume_entry, &c, current, regs);
+	return c.len;
+}
+
+#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
+/**
+ * stack_trace_save_tsk_reliable - Save task stack with verification
+ * @tsk:	Pointer to the task to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ *
+ * Returns:	An error if it detects any unreliable features of the
+ *		stack. Otherwise it guarantees that the stack trace is
+ *		reliable and returns the number of entries stored.
+ *
+ * If the task is not 'current', the caller *must* ensure the task is inactive.
+ */
+int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
+				  unsigned int size)
+{
+	stack_trace_consume_fn consume_entry = stack_trace_consume_entry;
+	struct stacktrace_cookie c = {
+		.store	= store,
+		.size	= size,
+	};
+	int ret;
+
+	/*
+	 * If the task doesn't have a stack (e.g., a zombie), the stack is
+	 * "reliably" empty.
+	 */
+	if (!try_get_task_stack(tsk))
+		return 0;
+
+	ret = arch_stack_walk_reliable(consume_entry, &c, tsk);
+	put_task_stack(tsk);
+	return ret;
+}
+#endif
+
+#ifdef CONFIG_USER_STACKTRACE_SUPPORT
+/**
+ * stack_trace_save_user - Save a user space stack trace into a storage array
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ *
+ * Returns number of entries stored.
+ */
+unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
+{
+	stack_trace_consume_fn consume_entry = stack_trace_consume_entry;
+	struct stacktrace_cookie c = {
+		.store	= store,
+		.size	= size,
+	};
+
+	/* Trace user stack if not a kernel thread */
+	if (!current->mm)
+		return 0;
+
+	arch_stack_walk_user(consume_entry, &c, task_pt_regs(current));
+	return c.len;
+}
+#endif
+
+#else /* CONFIG_ARCH_STACKWALK */
+
 /*
  * Architectures that do not implement save_stack_trace_*()
  * get these weak aliases and once-per-bootup warnings
@@ -193,3 +364,5 @@ unsigned int stack_trace_save_user(unsig
 	return trace.nr_entries;
 }
 #endif /* CONFIG_USER_STACKTRACE_SUPPORT */
+
+#endif /* !CONFIG_ARCH_STACKWALK */
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -597,6 +597,10 @@ config ARCH_HAS_UACCESS_FLUSHCACHE
 config ARCH_HAS_UACCESS_MCSAFE
 	bool
 
+# Temporary. Goes away when all archs are cleaned up
+config ARCH_STACKWALK
+       bool
+
 config STACKDEPOT
 	bool
 	select STACKTRACE


