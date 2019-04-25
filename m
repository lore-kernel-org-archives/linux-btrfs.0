Return-Path: <SRS0=mBNC=S3=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EED8C10F03
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06391218FE
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Apr 2019 10:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730006AbfDYKBD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Apr 2019 06:01:03 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:58112 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfDYKBB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Apr 2019 06:01:01 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hJb9v-0001rW-1P; Thu, 25 Apr 2019 11:59:15 +0200
Message-Id: <20190425094801.963261479@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 25 Apr 2019 11:45:02 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        kasan-dev@googlegroups.com, linux-mm@kvack.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: [patch V3 09/29] mm/kasan: Simplify stacktrace handling
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
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org
---
 mm/kasan/common.c |   30 ++++++++++++------------------
 mm/kasan/report.c |    7 ++++---
 2 files changed, 16 insertions(+), 21 deletions(-)

--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -48,34 +48,28 @@ static inline int in_irqentry_text(unsig
 		 ptr < (unsigned long)&__softirqentry_text_end);
 }
 
-static inline void filter_irq_stacks(struct stack_trace *trace)
+static inline unsigned int filter_irq_stacks(unsigned long *entries,
+					     unsigned int nr_entries)
 {
-	int i;
+	unsigned int i;
 
-	if (!trace->nr_entries)
-		return;
-	for (i = 0; i < trace->nr_entries; i++)
-		if (in_irqentry_text(trace->entries[i])) {
+	for (i = 0; i < nr_entries; i++) {
+		if (in_irqentry_text(entries[i])) {
 			/* Include the irqentry function into the stack. */
-			trace->nr_entries = i + 1;
-			break;
+			return i + 1;
 		}
+	}
+	return nr_entries;
 }
 
 static inline depot_stack_handle_t save_stack(gfp_t flags)
 {
 	unsigned long entries[KASAN_STACK_DEPTH];
-	struct stack_trace trace = {
-		.nr_entries = 0,
-		.entries = entries,
-		.max_entries = KASAN_STACK_DEPTH,
-		.skip = 0
-	};
+	unsigned int nr_entries;
 
-	save_stack_trace(&trace);
-	filter_irq_stacks(&trace);
-
-	return depot_save_stack(&trace, flags);
+	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 0);
+	nr_entries = filter_irq_stacks(entries, nr_entries);
+	return stack_depot_save(entries, nr_entries, flags);
 }
 
 static inline void set_track(struct kasan_track *track, gfp_t flags)
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -100,10 +100,11 @@ static void print_track(struct kasan_tra
 {
 	pr_err("%s by task %u:\n", prefix, track->pid);
 	if (track->stack) {
-		struct stack_trace trace;
+		unsigned long *entries;
+		unsigned int nr_entries;
 
-		depot_fetch_stack(track->stack, &trace);
-		print_stack_trace(&trace, 0);
+		nr_entries = stack_depot_fetch(track->stack, &entries);
+		stack_trace_print(entries, nr_entries, 0);
 	} else {
 		pr_err("(stack is not available)\n");
 	}


