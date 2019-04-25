Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D65C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:01:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9903F206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:01:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729669AbfDYKAe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:00:34 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:58006 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfDYKAd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:00:33 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJbAG-0001xi-T6; Thu, 25 Apr 2019 11:59:37 +0200
Message-Id: <20190425094803.248604594@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:45:16 +0200
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
Subject: [patch V3 23/29] tracing: Simplify stack trace retrieval
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace the indirection through struct stack_trace by using the storage
array based interfaces.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   40 +++++++++++++---------------------------
 1 file changed, 13 insertions(+), 27 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2774,22 +2774,18 @@ static void __ftrace_trace_stack(struct
 {
 	struct trace_event_call *call = &event_kernel_stack;
 	struct ring_buffer_event *event;
+	unsigned int size, nr_entries;
 	struct ftrace_stack *fstack;
 	struct stack_entry *entry;
-	struct stack_trace trace;
-	int size = FTRACE_KSTACK_ENTRIES;
 	int stackidx;
 
-	trace.nr_entries	= 0;
-	trace.skip		= skip;
-
 	/*
 	 * Add one, for this function and the call to save_stack_trace()
 	 * If regs is set, then these functions will not be in the way.
 	 */
 #ifndef CONFIG_UNWINDER_ORC
 	if (!regs)
-		trace.skip++;
+		skip++;
 #endif
 
 	/*
@@ -2816,28 +2812,24 @@ static void __ftrace_trace_stack(struct
 	barrier();
 
 	fstack = this_cpu_ptr(ftrace_stacks.stacks) + (stackidx - 1);
-	trace.entries		= fstack->calls;
-	trace.max_entries	= FTRACE_KSTACK_ENTRIES;
-
-	if (regs)
-		save_stack_trace_regs(regs, &trace);
-	else
-		save_stack_trace(&trace);
-
-	if (trace.nr_entries > size)
-		size = trace.nr_entries;
+	size = ARRAY_SIZE(fstack->calls);
 
-	size *= sizeof(unsigned long);
+	if (regs) {
+		nr_entries = stack_trace_save_regs(regs, fstack->calls,
+						   size, skip);
+	} else {
+		nr_entries = stack_trace_save(fstack->calls, size, skip);
+	}
 
+	size = nr_entries * sizeof(unsigned long);
 	event = __trace_buffer_lock_reserve(buffer, TRACE_STACK,
 					    sizeof(*entry) + size, flags, pc);
 	if (!event)
 		goto out;
 	entry = ring_buffer_event_data(event);
 
-	memcpy(&entry->caller, trace.entries, size);
-
-	entry->size = trace.nr_entries;
+	memcpy(&entry->caller, fstack->calls, size);
+	entry->size = nr_entries;
 
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
@@ -2916,7 +2908,6 @@ ftrace_trace_userstack(struct ring_buffe
 	struct trace_event_call *call = &event_user_stack;
 	struct ring_buffer_event *event;
 	struct userstack_entry *entry;
-	struct stack_trace trace;
 
 	if (!(global_trace.trace_flags & TRACE_ITER_USERSTACKTRACE))
 		return;
@@ -2947,12 +2938,7 @@ ftrace_trace_userstack(struct ring_buffe
 	entry->tgid		= current->tgid;
 	memset(&entry->caller, 0, sizeof(entry->caller));
 
-	trace.nr_entries	= 0;
-	trace.max_entries	= FTRACE_STACK_ENTRIES;
-	trace.skip		= 0;
-	trace.entries		= entry->caller;
-
-	save_stack_trace_user(&trace);
+	stack_trace_save_user(entry->caller, FTRACE_STACK_ENTRIES);
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		__buffer_unlock_commit(buffer, event);
 


