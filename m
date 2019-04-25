Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104F3C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D197E217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729489AbfDYKA0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:00:26 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:57986 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbfDYKAZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:00:25 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJbAD-0001wo-Fc; Thu, 25 Apr 2019 11:59:33 +0200
Message-Id: <20190425094803.066064076@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:45:14 +0200
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
Subject: [patch V3 21/29] tracing: Use percpu stack trace buffer more
 intelligently
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The per cpu stack trace buffer usage pattern is odd at best. The buffer has
place for 512 stack trace entries on 64-bit and 1024 on 32-bit. When
interrupts or exceptions nest after the per cpu buffer was acquired the
stacktrace length is hardcoded to 8 entries. 512/1024 stack trace entries
in kernel stacks are unrealistic so the buffer is a complete waste.

Split the buffer into 4 nest levels, which are 128/256 entries per
level. This allows nesting contexts (interrupts, exceptions) to utilize the
cpu buffer for stack retrieval and avoids the fixed length allocation along
with the conditional execution pathes.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
V3: Limit to 4 nest levels and increase size per level.
---
 kernel/trace/trace.c |   77 +++++++++++++++++++++++++--------------------------
 1 file changed, 39 insertions(+), 38 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2749,12 +2749,21 @@ trace_function(struct trace_array *tr,
 
 #ifdef CONFIG_STACKTRACE
 
-#define FTRACE_STACK_MAX_ENTRIES (PAGE_SIZE / sizeof(unsigned long))
+/* Allow 4 levels of nesting: normal, softirq, irq, NMI */
+#define FTRACE_KSTACK_NESTING	4
+
+#define FTRACE_KSTACK_ENTRIES	(PAGE_SIZE / FTRACE_KSTACK_NESTING)
+
 struct ftrace_stack {
-	unsigned long		calls[FTRACE_STACK_MAX_ENTRIES];
+	unsigned long		calls[FTRACE_KSTACK_ENTRIES];
+};
+
+
+struct ftrace_stacks {
+	struct ftrace_stack	stacks[FTRACE_KSTACK_NESTING];
 };
 
-static DEFINE_PER_CPU(struct ftrace_stack, ftrace_stack);
+static DEFINE_PER_CPU(struct ftrace_stacks, ftrace_stacks);
 static DEFINE_PER_CPU(int, ftrace_stack_reserve);
 
 static void __ftrace_trace_stack(struct ring_buffer *buffer,
@@ -2763,10 +2772,11 @@ static void __ftrace_trace_stack(struct
 {
 	struct trace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
+	struct ftrace_stack *fstack;
 	struct stack_entry *entry;
 	struct stack_trace trace;
-	int use_stack;
-	int size = FTRACE_STACK_ENTRIES;
+	int size = FTRACE_KSTACK_ENTRIES;
+	int stackidx;
 
 	trace.nr_entries	= 0;
 	trace.skip		= skip;
@@ -2788,29 +2798,32 @@ static void __ftrace_trace_stack(struct
 	 */
 	preempt_disable_notrace();
 
-	use_stack = __this_cpu_inc_return(ftrace_stack_reserve);
+	stackidx = __this_cpu_inc_return(ftrace_stack_reserve);
+
+	/* This should never happen. If it does, yell once and skip */
+	if (WARN_ON_ONCE(stackidx >= FTRACE_KSTACK_NESTING))
+		goto out;
+
 	/*
-	 * We don't need any atomic variables, just a barrier.
-	 * If an interrupt comes in, we don't care, because it would
-	 * have exited and put the counter back to what we want.
-	 * We just need a barrier to keep gcc from moving things
-	 * around.
+	 * The above __this_cpu_inc_return() is 'atomic' cpu local. An
+	 * interrupt will either see the value pre increment or post
+	 * increment. If the interrupt happens pre increment it will have
+	 * restored the counter when it returns.  We just need a barrier to
+	 * keep gcc from moving things around.
 	 */
 	barrier();
-	if (use_stack == 1) {
-		trace.entries		= this_cpu_ptr(ftrace_stack.calls);
-		trace.max_entries	= FTRACE_STACK_MAX_ENTRIES;
-
-		if (regs)
-			save_stack_trace_regs(regs, &trace);
-		else
-			save_stack_trace(&trace);
-
-		if (trace.nr_entries > size)
-			size = trace.nr_entries;
-	} else
-		/* From now on, use_stack is a boolean */
-		use_stack = 0;
+
+	fstack = this_cpu_ptr(ftrace_stacks.stacks) + (stackidx - 1);
+	trace.entries		= fstack->calls;
+	trace.max_entries	= FTRACE_KSTACK_ENTRIES;
+
+	if (regs)
+		save_stack_trace_regs(regs, &trace);
+	else
+		save_stack_trace(&trace);
+
+	if (trace.nr_entries > size)
+		size = trace.nr_entries;
 
 	size *= sizeof(unsigned long);
 
@@ -2820,19 +2833,7 @@ static void __ftrace_trace_stack(struct
 		goto out;
 	entry = ring_buffer_event_data(event);
 
-	memset(&entry->caller, 0, size);
-
-	if (use_stack)
-		memcpy(&entry->caller, trace.entries,
-		       trace.nr_entries * sizeof(unsigned long));
-	else {
-		trace.max_entries	= FTRACE_STACK_ENTRIES;
-		trace.entries		= entry->caller;
-		if (regs)
-			save_stack_trace_regs(regs, &trace);
-		else
-			save_stack_trace(&trace);
-	}
+	memcpy(&entry->caller, trace.entries, size);
 
 	entry->size = trace.nr_entries;
 


