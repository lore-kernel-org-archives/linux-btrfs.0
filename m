Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCFBC282DD
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE820218A1
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:07:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388636AbfDRJHw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:07:52 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:34124 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388571AbfDRJHv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 05:07:51 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH30B-0001tP-SF; Thu, 18 Apr 2019 11:06:40 +0200
Message-Id: <20190418084254.819500258@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 18 Apr 2019 10:41:38 +0200
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
Subject: [patch V2 19/29] lockdep: Simplify stack trace handling
References: <20190418084119.056416939@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace the indirection through struct stack_trace by using the storage
array based interfaces and storing the information is a small lockdep
specific data structure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/lockdep.h  |    9 +++++++--
 kernel/locking/lockdep.c |   44 +++++++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 21 deletions(-)

--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -66,6 +66,11 @@ struct lock_class_key {
 
 extern struct lock_class_key __lockdep_no_validate__;
 
+struct lock_trace {
+	unsigned int		nr_entries;
+	unsigned int		offset;
+};
+
 #define LOCKSTAT_POINTS		4
 
 /*
@@ -100,7 +105,7 @@ struct lock_class {
 	 * IRQ/softirq usage tracking bits:
 	 */
 	unsigned long			usage_mask;
-	struct stack_trace		usage_traces[XXX_LOCK_USAGE_STATES];
+	struct lock_trace		usage_traces[XXX_LOCK_USAGE_STATES];
 
 	/*
 	 * Generation counter, when doing certain classes of graph walking,
@@ -188,7 +193,7 @@ struct lock_list {
 	struct list_head		entry;
 	struct lock_class		*class;
 	struct lock_class		*links_to;
-	struct stack_trace		trace;
+	struct lock_trace		trace;
 	int				distance;
 
 	/*
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -434,18 +434,14 @@ static void print_lockdep_off(const char
 #endif
 }
 
-static int save_trace(struct stack_trace *trace)
+static int save_trace(struct lock_trace *trace)
 {
-	trace->nr_entries = 0;
-	trace->max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
-	trace->entries = stack_trace + nr_stack_trace_entries;
-
-	trace->skip = 3;
-
-	save_stack_trace(trace);
-
-	trace->max_entries = trace->nr_entries;
+	unsigned long *entries = stack_trace + nr_stack_trace_entries;
+	unsigned int max_entries;
 
+	trace->offset = nr_stack_trace_entries;
+	max_entries = MAX_STACK_TRACE_ENTRIES - nr_stack_trace_entries;
+	trace->nr_entries = stack_trace_save(entries, max_entries, 3);
 	nr_stack_trace_entries += trace->nr_entries;
 
 	if (nr_stack_trace_entries >= MAX_STACK_TRACE_ENTRIES-1) {
@@ -1196,7 +1192,7 @@ static struct lock_list *alloc_list_entr
 static int add_lock_to_list(struct lock_class *this,
 			    struct lock_class *links_to, struct list_head *head,
 			    unsigned long ip, int distance,
-			    struct stack_trace *trace)
+			    struct lock_trace *trace)
 {
 	struct lock_list *entry;
 	/*
@@ -1415,6 +1411,13 @@ static inline int __bfs_backwards(struct
  * checking.
  */
 
+static void print_lock_trace(struct lock_trace *trace, unsigned int spaces)
+{
+	unsigned long *entries = stack_trace + trace->offset;
+
+	stack_trace_print(entries, trace->nr_entries, spaces);
+}
+
 /*
  * Print a dependency chain entry (this is only done when a deadlock
  * has been detected):
@@ -1427,8 +1430,7 @@ print_circular_bug_entry(struct lock_lis
 	printk("\n-> #%u", depth);
 	print_lock_name(target->class);
 	printk(KERN_CONT ":\n");
-	print_stack_trace(&target->trace, 6);
-
+	print_lock_trace(&target->trace, 6);
 	return 0;
 }
 
@@ -1740,7 +1742,7 @@ static void print_lock_class_header(stru
 
 			len += printk("%*s   %s", depth, "", usage_str[bit]);
 			len += printk(KERN_CONT " at:\n");
-			print_stack_trace(class->usage_traces + bit, len);
+			print_lock_trace(class->usage_traces + bit, len);
 		}
 	}
 	printk("%*s }\n", depth, "");
@@ -1765,7 +1767,7 @@ print_shortest_lock_dependencies(struct
 	do {
 		print_lock_class_header(entry->class, depth);
 		printk("%*s ... acquired at:\n", depth, "");
-		print_stack_trace(&entry->trace, 2);
+		print_lock_trace(&entry->trace, 2);
 		printk("\n");
 
 		if (depth == 0 && (entry != root)) {
@@ -1878,14 +1880,14 @@ print_bad_irq_dependency(struct task_str
 	print_lock_name(backwards_entry->class);
 	pr_warn("\n... which became %s-irq-safe at:\n", irqclass);
 
-	print_stack_trace(backwards_entry->class->usage_traces + bit1, 1);
+	print_lock_trace(backwards_entry->class->usage_traces + bit1, 1);
 
 	pr_warn("\nto a %s-irq-unsafe lock:\n", irqclass);
 	print_lock_name(forwards_entry->class);
 	pr_warn("\n... which became %s-irq-unsafe at:\n", irqclass);
 	pr_warn("...");
 
-	print_stack_trace(forwards_entry->class->usage_traces + bit2, 1);
+	print_lock_trace(forwards_entry->class->usage_traces + bit2, 1);
 
 	pr_warn("\nother info that might help us debug this:\n\n");
 	print_irq_lock_scenario(backwards_entry, forwards_entry,
@@ -2161,9 +2163,9 @@ check_prev_add(struct task_struct *curr,
 	       struct held_lock *next, int distance)
 {
 	struct lock_list *uninitialized_var(target_entry);
-	struct stack_trace trace;
 	struct lock_list *entry;
 	struct lock_list this;
+	struct lock_trace trace;
 	int ret;
 
 	if (!hlock_class(prev)->key || !hlock_class(next)->key) {
@@ -2705,6 +2707,10 @@ static inline int validate_chain(struct
 {
 	return 1;
 }
+
+static void print_lock_trace(struct lock_trace *trace, unsigned int spaces)
+{
+}
 #endif
 
 /*
@@ -2801,7 +2807,7 @@ print_usage_bug(struct task_struct *curr
 	print_lock(this);
 
 	pr_warn("{%s} state was registered at:\n", usage_str[prev_bit]);
-	print_stack_trace(hlock_class(this)->usage_traces + prev_bit, 1);
+	print_lock_trace(hlock_class(this)->usage_traces + prev_bit, 1);
 
 	print_irqtrace_events(curr);
 	pr_warn("\nother info that might help us debug this:\n");


