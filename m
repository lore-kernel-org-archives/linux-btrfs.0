Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1ADC10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBD19206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387542AbfDYKAH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:00:07 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:57857 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387410AbfDYKAB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:00:01 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJb9k-0001qX-9I; Thu, 25 Apr 2019 11:59:04 +0200
Message-Id: <20190425094801.230654524@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:44:54 +0200
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
Subject: [patch V3 01/29] tracing: Cleanup stack trace code
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

- Remove the extra array member of stack_dump_trace[] along with the
  ARRAY_SIZE - 1 initialization for struct stack_trace :: max_entries.

  Both are historical leftovers of no value. The stack tracer never exceeds
  the array and there is no extra storage requirement either.

- Make variables which are only used in trace_stack.c static.

- Simplify the enable/disable logic.

- Rename stack_trace_print() as it's using the stack_trace_ namespace. Free
  the name up for stack trace related functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
---
V3: Remove the -1 init and split the variable declaration as requested by Steven.
V2: Add more cleanups and use print_max_stack() as requested by Steven.
---
 include/linux/ftrace.h     |   18 ++++--------------
 kernel/trace/trace_stack.c |   42 +++++++++++++-----------------------------
 2 files changed, 17 insertions(+), 43 deletions(-)

--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -241,21 +241,11 @@ static inline void ftrace_free_mem(struc
 
 #ifdef CONFIG_STACK_TRACER
 
-#define STACK_TRACE_ENTRIES 500
-
-struct stack_trace;
-
-extern unsigned stack_trace_index[];
-extern struct stack_trace stack_trace_max;
-extern unsigned long stack_trace_max_size;
-extern arch_spinlock_t stack_trace_max_lock;
-
 extern int stack_tracer_enabled;
-void stack_trace_print(void);
-int
-stack_trace_sysctl(struct ctl_table *table, int write,
-		   void __user *buffer, size_t *lenp,
-		   loff_t *ppos);
+
+int stack_trace_sysctl(struct ctl_table *table, int write,
+		       void __user *buffer, size_t *lenp,
+		       loff_t *ppos);
 
 /* DO NOT MODIFY THIS VARIABLE DIRECTLY! */
 DECLARE_PER_CPU(int, disable_stack_tracer);
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -18,30 +18,26 @@
 
 #include "trace.h"
 
-static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES + 1];
-unsigned stack_trace_index[STACK_TRACE_ENTRIES];
+#define STACK_TRACE_ENTRIES 500
+
+static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES];
+static unsigned stack_trace_index[STACK_TRACE_ENTRIES];
 
-/*
- * Reserve one entry for the passed in ip. This will allow
- * us to remove most or all of the stack size overhead
- * added by the stack tracer itself.
- */
 struct stack_trace stack_trace_max = {
-	.max_entries		= STACK_TRACE_ENTRIES - 1,
+	.max_entries		= STACK_TRACE_ENTRIES,
 	.entries		= &stack_dump_trace[0],
 };
 
-unsigned long stack_trace_max_size;
-arch_spinlock_t stack_trace_max_lock =
+static unsigned long stack_trace_max_size;
+static arch_spinlock_t stack_trace_max_lock =
 	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
 
 DEFINE_PER_CPU(int, disable_stack_tracer);
 static DEFINE_MUTEX(stack_sysctl_mutex);
 
 int stack_tracer_enabled;
-static int last_stack_tracer_enabled;
 
-void stack_trace_print(void)
+static void print_max_stack(void)
 {
 	long i;
 	int size;
@@ -61,16 +57,7 @@ void stack_trace_print(void)
 	}
 }
 
-/*
- * When arch-specific code overrides this function, the following
- * data should be filled up, assuming stack_trace_max_lock is held to
- * prevent concurrent updates.
- *     stack_trace_index[]
- *     stack_trace_max
- *     stack_trace_max_size
- */
-void __weak
-check_stack(unsigned long ip, unsigned long *stack)
+static void check_stack(unsigned long ip, unsigned long *stack)
 {
 	unsigned long this_size, flags; unsigned long *p, *top, *start;
 	static int tracer_frame;
@@ -179,7 +166,7 @@ check_stack(unsigned long ip, unsigned l
 	stack_trace_max.nr_entries = x;
 
 	if (task_stack_end_corrupted(current)) {
-		stack_trace_print();
+		print_max_stack();
 		BUG();
 	}
 
@@ -412,23 +399,21 @@ stack_trace_sysctl(struct ctl_table *tab
 		   void __user *buffer, size_t *lenp,
 		   loff_t *ppos)
 {
+	int was_enabled;
 	int ret;
 
 	mutex_lock(&stack_sysctl_mutex);
+	was_enabled = !!stack_tracer_enabled;
 
 	ret = proc_dointvec(table, write, buffer, lenp, ppos);
 
-	if (ret || !write ||
-	    (last_stack_tracer_enabled == !!stack_tracer_enabled))
+	if (ret || !write || (was_enabled == !!stack_tracer_enabled))
 		goto out;
 
-	last_stack_tracer_enabled = !!stack_tracer_enabled;
-
 	if (stack_tracer_enabled)
 		register_ftrace_function(&trace_ops);
 	else
 		unregister_ftrace_function(&trace_ops);
-
  out:
 	mutex_unlock(&stack_sysctl_mutex);
 	return ret;
@@ -444,7 +429,6 @@ static __init int enable_stacktrace(char
 		strncpy(stack_trace_filter_buf, str + len, COMMAND_LINE_SIZE);
 
 	stack_tracer_enabled = 1;
-	last_stack_tracer_enabled = 1;
 	return 1;
 }
 __setup("stacktrace", enable_stacktrace);


