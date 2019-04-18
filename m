Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334E5C282DD
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0D019206B6
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbfDRJHE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:07:04 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:33832 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388257AbfDRJHD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 05:07:03 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH2zZ-0001lv-2D; Thu, 18 Apr 2019 11:06:01 +0200
Message-Id: <20190418084253.142712304@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 18 Apr 2019 10:41:20 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexander Potapenko <glider@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
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
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        linux-arch@vger.kernel.org
Subject: [patch V2 01/29] tracing: Cleanup stack trace code
References: <20190418084119.056416939@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

- Remove the extra array member of stack_dump_trace[]. It's not required as
  the stack tracer stores at max array size - 1 entries so there is still
  an empty slot.

- Make variables which are only used in trace_stack.c static.

- Simplify the enable/disable logic.

- Rename stack_trace_print() as it's using the stack_trace_ namespace. Free
  the name up for stack trace related functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
V2: Add more cleanups and use print_max_stack() as requested by Steven.
---
 include/linux/ftrace.h     |   18 ++++--------------
 kernel/trace/trace_stack.c |   36 ++++++++++++------------------------
 2 files changed, 16 insertions(+), 38 deletions(-)

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
@@ -18,8 +18,10 @@
 
 #include "trace.h"
 
-static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES + 1];
-unsigned stack_trace_index[STACK_TRACE_ENTRIES];
+#define STACK_TRACE_ENTRIES 500
+
+static unsigned long stack_dump_trace[STACK_TRACE_ENTRIES];
+static unsigned stack_trace_index[STACK_TRACE_ENTRIES];
 
 /*
  * Reserve one entry for the passed in ip. This will allow
@@ -31,17 +33,16 @@ struct stack_trace stack_trace_max = {
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
@@ -61,16 +62,7 @@ void stack_trace_print(void)
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
@@ -179,7 +171,7 @@ check_stack(unsigned long ip, unsigned l
 	stack_trace_max.nr_entries = x;
 
 	if (task_stack_end_corrupted(current)) {
-		stack_trace_print();
+		print_max_stack();
 		BUG();
 	}
 
@@ -412,23 +404,20 @@ stack_trace_sysctl(struct ctl_table *tab
 		   void __user *buffer, size_t *lenp,
 		   loff_t *ppos)
 {
-	int ret;
+	int ret, was_enabled;
 
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
@@ -444,7 +433,6 @@ static __init int enable_stacktrace(char
 		strncpy(stack_trace_filter_buf, str + len, COMMAND_LINE_SIZE);
 
 	stack_tracer_enabled = 1;
-	last_stack_tracer_enabled = 1;
 	return 1;
 }
 __setup("stacktrace", enable_stacktrace);


