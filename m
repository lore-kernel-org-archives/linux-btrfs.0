Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 152ADC10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D11E2217D7
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfDYKBQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:01:16 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:58115 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729883AbfDYKBC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:01:02 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJb9m-0001qd-PK; Thu, 25 Apr 2019 11:59:06 +0200
Message-Id: <20190425094801.414574828@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:44:56 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Alexander Potapenko <glider@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
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
Subject: [patch V3 03/29] lib/stackdepot: Provide functions which operate on
 plain storage arrays
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The struct stack_trace indirection in the stack depot functions is a truly
pointless excercise which requires horrible code at the callsites.

Provide interfaces based on plain storage arrays.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Alexander Potapenko <glider@google.com>
---
V3: Fix kernel-doc
---
 include/linux/stackdepot.h |    4 ++
 lib/stackdepot.c           |   70 ++++++++++++++++++++++++++++++++-------------
 2 files changed, 55 insertions(+), 19 deletions(-)

--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -26,7 +26,11 @@ typedef u32 depot_stack_handle_t;
 struct stack_trace;
 
 depot_stack_handle_t depot_save_stack(struct stack_trace *trace, gfp_t flags);
+depot_stack_handle_t stack_depot_save(unsigned long *entries,
+				      unsigned int nr_entries, gfp_t gfp_flags);
 
 void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace);
+unsigned int stack_depot_fetch(depot_stack_handle_t handle,
+			       unsigned long **entries);
 
 #endif
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -194,40 +194,60 @@ static inline struct stack_record *find_
 	return NULL;
 }
 
-void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace)
+/**
+ * stack_depot_fetch - Fetch stack entries from a depot
+ *
+ * @handle:		Stack depot handle which was returned from
+ *			stack_depot_save().
+ * @entries:		Pointer to store the entries address
+ *
+ * Return: The number of trace entries for this depot.
+ */
+unsigned int stack_depot_fetch(depot_stack_handle_t handle,
+			       unsigned long **entries)
 {
 	union handle_parts parts = { .handle = handle };
 	void *slab = stack_slabs[parts.slabindex];
 	size_t offset = parts.offset << STACK_ALLOC_ALIGN;
 	struct stack_record *stack = slab + offset;
 
-	trace->nr_entries = trace->max_entries = stack->size;
-	trace->entries = stack->entries;
-	trace->skip = 0;
+	*entries = stack->entries;
+	return stack->size;
+}
+EXPORT_SYMBOL_GPL(stack_depot_fetch);
+
+void depot_fetch_stack(depot_stack_handle_t handle, struct stack_trace *trace)
+{
+	unsigned int nent = stack_depot_fetch(handle, &trace->entries);
+
+	trace->max_entries = trace->nr_entries = nent;
 }
 EXPORT_SYMBOL_GPL(depot_fetch_stack);
 
 /**
- * depot_save_stack - save stack in a stack depot.
- * @trace - the stacktrace to save.
- * @alloc_flags - flags for allocating additional memory if required.
+ * stack_depot_save - Save a stack trace from an array
+ *
+ * @entries:		Pointer to storage array
+ * @nr_entries:		Size of the storage array
+ * @alloc_flags:	Allocation gfp flags
  *
- * Returns the handle of the stack struct stored in depot.
+ * Return: The handle of the stack struct stored in depot
  */
-depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
-				    gfp_t alloc_flags)
+depot_stack_handle_t stack_depot_save(unsigned long *entries,
+				      unsigned int nr_entries,
+				      gfp_t alloc_flags)
 {
-	u32 hash;
-	depot_stack_handle_t retval = 0;
 	struct stack_record *found = NULL, **bucket;
-	unsigned long flags;
+	depot_stack_handle_t retval = 0;
 	struct page *page = NULL;
 	void *prealloc = NULL;
+	unsigned long flags;
+	u32 hash;
 
-	if (unlikely(trace->nr_entries == 0))
+	if (unlikely(nr_entries == 0))
 		goto fast_exit;
 
-	hash = hash_stack(trace->entries, trace->nr_entries);
+	hash = hash_stack(entries, nr_entries);
 	bucket = &stack_table[hash & STACK_HASH_MASK];
 
 	/*
@@ -235,8 +255,8 @@ depot_stack_handle_t depot_save_stack(st
 	 * The smp_load_acquire() here pairs with smp_store_release() to
 	 * |bucket| below.
 	 */
-	found = find_stack(smp_load_acquire(bucket), trace->entries,
-			   trace->nr_entries, hash);
+	found = find_stack(smp_load_acquire(bucket), entries,
+			   nr_entries, hash);
 	if (found)
 		goto exit;
 
@@ -264,10 +284,10 @@ depot_stack_handle_t depot_save_stack(st
 
 	spin_lock_irqsave(&depot_lock, flags);
 
-	found = find_stack(*bucket, trace->entries, trace->nr_entries, hash);
+	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
 		struct stack_record *new =
-			depot_alloc_stack(trace->entries, trace->nr_entries,
+			depot_alloc_stack(entries, nr_entries,
 					  hash, &prealloc, alloc_flags);
 		if (new) {
 			new->next = *bucket;
@@ -297,4 +317,16 @@ depot_stack_handle_t depot_save_stack(st
 fast_exit:
 	return retval;
 }
+EXPORT_SYMBOL_GPL(stack_depot_save);
+
+/**
+ * depot_save_stack - save stack in a stack depot.
+ * @trace - the stacktrace to save.
+ * @alloc_flags - flags for allocating additional memory if required.
+ */
+depot_stack_handle_t depot_save_stack(struct stack_trace *trace,
+				      gfp_t alloc_flags)
+{
+	return stack_depot_save(trace->entries, trace->nr_entries, alloc_flags);
+}
 EXPORT_SYMBOL_GPL(depot_save_stack);


