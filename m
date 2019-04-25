Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58FFFC282E1
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29487206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfDYKCn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:02:43 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:57939 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729371AbfDYKAN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:00:13 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJbA4-0001to-VQ; Thu, 25 Apr 2019 11:59:25 +0200
Message-Id: <20190425094802.622094226@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:45:09 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
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
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-arch@vger.kernel.org
Subject: [patch V3 16/29] drm: Simplify stacktrace handling
References: <20190425094453.875139013@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Replace the indirection through struct stack_trace by using the storage
array based interfaces.

The original code in all printing functions is really wrong. It allocates a
storage array on stack which is unused because depot_fetch_stack() does not
store anything in it. It overwrites the entries pointer in the stack_trace
struct so it points to the depot storage.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Daniel Vetter <daniel@ffwll.ch>
Cc: intel-gfx@lists.freedesktop.org
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
---
 drivers/gpu/drm/drm_mm.c                |   22 +++++++---------------
 drivers/gpu/drm/i915/i915_vma.c         |   11 ++++-------
 drivers/gpu/drm/i915/intel_runtime_pm.c |   21 +++++++--------------
 3 files changed, 18 insertions(+), 36 deletions(-)

--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -106,22 +106,19 @@
 static noinline void save_stack(struct drm_mm_node *node)
 {
 	unsigned long entries[STACKDEPTH];
-	struct stack_trace trace = {
-		.entries = entries,
-		.max_entries = STACKDEPTH,
-		.skip = 1
-	};
+	unsigned int n;
 
-	save_stack_trace(&trace);
+	n = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
 
 	/* May be called under spinlock, so avoid sleeping */
-	node->stack = depot_save_stack(&trace, GFP_NOWAIT);
+	node->stack = stack_depot_save(entries, n, GFP_NOWAIT);
 }
 
 static void show_leaks(struct drm_mm *mm)
 {
 	struct drm_mm_node *node;
-	unsigned long entries[STACKDEPTH];
+	unsigned long *entries;
+	unsigned int nr_entries;
 	char *buf;
 
 	buf = kmalloc(BUFSZ, GFP_KERNEL);
@@ -129,19 +126,14 @@ static void show_leaks(struct drm_mm *mm
 		return;
 
 	list_for_each_entry(node, drm_mm_nodes(mm), node_list) {
-		struct stack_trace trace = {
-			.entries = entries,
-			.max_entries = STACKDEPTH
-		};
-
 		if (!node->stack) {
 			DRM_ERROR("node [%08llx + %08llx]: unknown owner\n",
 				  node->start, node->size);
 			continue;
 		}
 
-		depot_fetch_stack(node->stack, &trace);
-		snprint_stack_trace(buf, BUFSZ, &trace, 0);
+		nr_entries = stack_depot_fetch(node->stack, &entries);
+		stack_trace_snprint(buf, BUFSZ, entries, nr_entries, 0);
 		DRM_ERROR("node [%08llx + %08llx]: inserted at\n%s",
 			  node->start, node->size, buf);
 	}
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -36,11 +36,8 @@
 
 static void vma_print_allocator(struct i915_vma *vma, const char *reason)
 {
-	unsigned long entries[12];
-	struct stack_trace trace = {
-		.entries = entries,
-		.max_entries = ARRAY_SIZE(entries),
-	};
+	unsigned long *entries;
+	unsigned int nr_entries;
 	char buf[512];
 
 	if (!vma->node.stack) {
@@ -49,8 +46,8 @@ static void vma_print_allocator(struct i
 		return;
 	}
 
-	depot_fetch_stack(vma->node.stack, &trace);
-	snprint_stack_trace(buf, sizeof(buf), &trace, 0);
+	nr_entries = stack_depot_fetch(vma->node.stack, &entries);
+	stack_trace_snprint(buf, sizeof(buf), entries, nr_entries, 0);
 	DRM_DEBUG_DRIVER("vma.node [%08llx + %08llx] %s: inserted at %s\n",
 			 vma->node.start, vma->node.size, reason, buf);
 }
--- a/drivers/gpu/drm/i915/intel_runtime_pm.c
+++ b/drivers/gpu/drm/i915/intel_runtime_pm.c
@@ -60,27 +60,20 @@
 static noinline depot_stack_handle_t __save_depot_stack(void)
 {
 	unsigned long entries[STACKDEPTH];
-	struct stack_trace trace = {
-		.entries = entries,
-		.max_entries = ARRAY_SIZE(entries),
-		.skip = 1,
-	};
+	unsigned int n;
 
-	save_stack_trace(&trace);
-	return depot_save_stack(&trace, GFP_NOWAIT | __GFP_NOWARN);
+	n = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
+	return stack_depot_save(entries, n, GFP_NOWAIT | __GFP_NOWARN);
 }
 
 static void __print_depot_stack(depot_stack_handle_t stack,
 				char *buf, int sz, int indent)
 {
-	unsigned long entries[STACKDEPTH];
-	struct stack_trace trace = {
-		.entries = entries,
-		.max_entries = ARRAY_SIZE(entries),
-	};
+	unsigned long *entries;
+	unsigned int nr_entries;
 
-	depot_fetch_stack(stack, &trace);
-	snprint_stack_trace(buf, sz, &trace, indent);
+	nr_entries = stack_depot_fetch(stack, &entries);
+	stack_trace_snprint(buf, sz, entries, nr_entries, indent);
 }
 
 static void init_intel_runtime_pm_wakeref(struct drm_i915_private *i915)


