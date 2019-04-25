Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E3CC282E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 901C8206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfDYKCI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:02:08 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:57987 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbfDYKA0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:00:26 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJb9l-0001qa-F3; Thu, 25 Apr 2019 11:59:05 +0200
Message-Id: <20190425094801.324810708@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:44:55 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        David Rientjes <rientjes@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        iommu@lists.linux-foundation.org,
        Robin Murphy <robin.murphy@arm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
        Mike Snitzer <snitzer@redhat.com>,
        Alasdair Kergon <agk@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-arch@vger.kernel.org
Subject: [patch V3 02/29] stacktrace: Provide helpers for common stack trace
 operations
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

All operations with stack traces are based on struct stack_trace. That's a
horrible construct as the struct is a kitchen sink for input and
output. Quite some usage sites embed it into their own data structures
which creates weird indirections.

There is absolutely no point in doing so. For all use cases a storage array
and the number of valid stack trace entries in the array is sufficient.

Provide helper functions which avoid the struct stack_trace indirection so
the usage sites can be cleaned up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
V3: Fix kernel doc.
---
 include/linux/stacktrace.h |   27 +++++++
 kernel/stacktrace.c        |  170 +++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 182 insertions(+), 15 deletions(-)

--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -3,11 +3,26 @@
 #define __LINUX_STACKTRACE_H
 
 #include <linux/types.h>
+#include <asm/errno.h>
 
 struct task_struct;
 struct pt_regs;
 
 #ifdef CONFIG_STACKTRACE
+void stack_trace_print(unsigned long *trace, unsigned int nr_entries,
+		       int spaces);
+int stack_trace_snprint(char *buf, size_t size, unsigned long *entries,
+			unsigned int nr_entries, int spaces);
+unsigned int stack_trace_save(unsigned long *store, unsigned int size,
+			      unsigned int skipnr);
+unsigned int stack_trace_save_tsk(struct task_struct *task,
+				  unsigned long *store, unsigned int size,
+				  unsigned int skipnr);
+unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
+				   unsigned int size, unsigned int skipnr);
+unsigned int stack_trace_save_user(unsigned long *store, unsigned int size);
+
+/* Internal interfaces. Do not use in generic code */
 struct stack_trace {
 	unsigned int nr_entries, max_entries;
 	unsigned long *entries;
@@ -41,4 +56,16 @@ extern void save_stack_trace_user(struct
 # define save_stack_trace_tsk_reliable(tsk, trace)	({ -ENOSYS; })
 #endif /* CONFIG_STACKTRACE */
 
+#if defined(CONFIG_STACKTRACE) && defined(CONFIG_HAVE_RELIABLE_STACKTRACE)
+int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
+				  unsigned int size);
+#else
+static inline int stack_trace_save_tsk_reliable(struct task_struct *tsk,
+						unsigned long *store,
+						unsigned int size)
+{
+	return -ENOSYS;
+}
+#endif
+
 #endif /* __LINUX_STACKTRACE_H */
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -11,35 +11,54 @@
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
 
-void print_stack_trace(struct stack_trace *trace, int spaces)
+/**
+ * stack_trace_print - Print the entries in the stack trace
+ * @entries:	Pointer to storage array
+ * @nr_entries:	Number of entries in the storage array
+ * @spaces:	Number of leading spaces to print
+ */
+void stack_trace_print(unsigned long *entries, unsigned int nr_entries,
+		       int spaces)
 {
-	int i;
+	unsigned int i;
 
-	if (WARN_ON(!trace->entries))
+	if (WARN_ON(!entries))
 		return;
 
-	for (i = 0; i < trace->nr_entries; i++)
-		printk("%*c%pS\n", 1 + spaces, ' ', (void *)trace->entries[i]);
+	for (i = 0; i < nr_entries; i++)
+		printk("%*c%pS\n", 1 + spaces, ' ', (void *)entries[i]);
+}
+EXPORT_SYMBOL_GPL(stack_trace_print);
+
+void print_stack_trace(struct stack_trace *trace, int spaces)
+{
+	stack_trace_print(trace->entries, trace->nr_entries, spaces);
 }
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
-int snprint_stack_trace(char *buf, size_t size,
-			struct stack_trace *trace, int spaces)
+/**
+ * stack_trace_snprint - Print the entries in the stack trace into a buffer
+ * @buf:	Pointer to the print buffer
+ * @size:	Size of the print buffer
+ * @entries:	Pointer to storage array
+ * @nr_entries:	Number of entries in the storage array
+ * @spaces:	Number of leading spaces to print
+ *
+ * Return: Number of bytes printed.
+ */
+int stack_trace_snprint(char *buf, size_t size, unsigned long *entries,
+			unsigned int nr_entries, int spaces)
 {
-	int i;
-	int generated;
-	int total = 0;
+	unsigned int generated, i, total = 0;
 
-	if (WARN_ON(!trace->entries))
+	if (WARN_ON(!entries))
 		return 0;
 
-	for (i = 0; i < trace->nr_entries; i++) {
+	for (i = 0; i < nr_entries && size; i++) {
 		generated = snprintf(buf, size, "%*c%pS\n", 1 + spaces, ' ',
-				     (void *)trace->entries[i]);
+				     (void *)entries[i]);
 
 		total += generated;
-
-		/* Assume that generated isn't a negative number */
 		if (generated >= size) {
 			buf += size;
 			size = 0;
@@ -51,6 +70,14 @@ int snprint_stack_trace(char *buf, size_
 
 	return total;
 }
+EXPORT_SYMBOL_GPL(stack_trace_snprint);
+
+int snprint_stack_trace(char *buf, size_t size,
+			struct stack_trace *trace, int spaces)
+{
+	return stack_trace_snprint(buf, size, trace->entries,
+				   trace->nr_entries, spaces);
+}
 EXPORT_SYMBOL_GPL(snprint_stack_trace);
 
 /*
@@ -77,3 +104,116 @@ save_stack_trace_tsk_reliable(struct tas
 	WARN_ONCE(1, KERN_INFO "save_stack_tsk_reliable() not implemented yet.\n");
 	return -ENOSYS;
 }
+
+/**
+ * stack_trace_save - Save a stack trace into a storage array
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ *
+ * Return: Number of trace entries stored
+ */
+unsigned int stack_trace_save(unsigned long *store, unsigned int size,
+			      unsigned int skipnr)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+		.skip		= skipnr + 1,
+	};
+
+	save_stack_trace(&trace);
+	return trace.nr_entries;
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
+ * Return: Number of trace entries stored
+ */
+unsigned int stack_trace_save_tsk(struct task_struct *task,
+				  unsigned long *store, unsigned int size,
+				  unsigned int skipnr)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+		.skip		= skipnr + 1,
+	};
+
+	save_stack_trace_tsk(task, &trace);
+	return trace.nr_entries;
+}
+
+/**
+ * stack_trace_save_regs - Save a stack trace based on pt_regs into a storage array
+ * @regs:	Pointer to pt_regs to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ * @skipnr:	Number of entries to skip at the start of the stack trace
+ *
+ * Return: Number of trace entries stored
+ */
+unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
+				   unsigned int size, unsigned int skipnr)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+		.skip		= skipnr,
+	};
+
+	save_stack_trace_regs(regs, &trace);
+	return trace.nr_entries;
+}
+
+#ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
+/**
+ * stack_trace_save_tsk_reliable - Save task stack with verification
+ * @tsk:	Pointer to the task to examine
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ *
+ * Return:	An error if it detects any unreliable features of the
+ *		stack. Otherwise it guarantees that the stack trace is
+ *		reliable and returns the number of entries stored.
+ *
+ * If the task is not 'current', the caller *must* ensure the task is inactive.
+ */
+int stack_trace_save_tsk_reliable(struct task_struct *tsk, unsigned long *store,
+				  unsigned int size)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+	};
+	int ret = save_stack_trace_tsk_reliable(tsk, &trace);
+
+	return ret ? ret : trace.nr_entries;
+}
+#endif
+
+#ifdef CONFIG_USER_STACKTRACE_SUPPORT
+/**
+ * stack_trace_save_user - Save a user space stack trace into a storage array
+ * @store:	Pointer to storage array
+ * @size:	Size of the storage array
+ *
+ * Return: Number of trace entries stored
+ */
+unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
+{
+	struct stack_trace trace = {
+		.entries	= store,
+		.max_entries	= size,
+	};
+
+	save_stack_trace_user(&trace);
+	return trace.nr_entries;
+}
+#endif /* CONFIG_USER_STACKTRACE_SUPPORT */


