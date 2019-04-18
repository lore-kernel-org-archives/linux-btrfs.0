Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E240C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6820D2184B
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 09:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388683AbfDRJIF (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 05:08:05 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:34157 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388674AbfDRJIE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 05:08:04 -0400
Received: from localhost ([127.0.0.1] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hH309-0001su-Qw; Thu, 18 Apr 2019 11:06:38 +0200
Message-Id: <20190418084254.729689921@linutronix.de>
User-Agent: quilt/0.65
Date:   Thu, 18 Apr 2019 10:41:37 +0200
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
Subject: [patch V2 18/29] lockdep: Move stack trace logic into check_prev_add()
References: <20190418084119.056416939@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is only one caller of check_prev_add() which hands in a zeroed struct
stack trace and a function pointer to save_stack(). Inside check_prev_add()
the stack_trace struct is checked for being empty, which is always
true. Based on that one code path stores a stack trace which is unused. The
comment there does not make sense either. It's all leftovers from
historical lockdep code (cross release).

Move the variable into check_prev_add() itself and cleanup the nonsensical
checks and the pointless stack trace recording.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/locking/lockdep.c |   30 ++++++++----------------------
 1 file changed, 8 insertions(+), 22 deletions(-)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2158,10 +2158,10 @@ check_deadlock(struct task_struct *curr,
  */
 static int
 check_prev_add(struct task_struct *curr, struct held_lock *prev,
-	       struct held_lock *next, int distance, struct stack_trace *trace,
-	       int (*save)(struct stack_trace *trace))
+	       struct held_lock *next, int distance)
 {
 	struct lock_list *uninitialized_var(target_entry);
+	struct stack_trace trace;
 	struct lock_list *entry;
 	struct lock_list this;
 	int ret;
@@ -2196,17 +2196,8 @@ check_prev_add(struct task_struct *curr,
 	this.class = hlock_class(next);
 	this.parent = NULL;
 	ret = check_noncircular(&this, hlock_class(prev), &target_entry);
-	if (unlikely(!ret)) {
-		if (!trace->entries) {
-			/*
-			 * If @save fails here, the printing might trigger
-			 * a WARN but because of the !nr_entries it should
-			 * not do bad things.
-			 */
-			save(trace);
-		}
+	if (unlikely(!ret))
 		return print_circular_bug(&this, target_entry, next, prev);
-	}
 	else if (unlikely(ret < 0))
 		return print_bfs_bug(ret);
 
@@ -2253,7 +2244,7 @@ check_prev_add(struct task_struct *curr,
 		return print_bfs_bug(ret);
 
 
-	if (!trace->entries && !save(trace))
+	if (!save_trace(&trace))
 		return 0;
 
 	/*
@@ -2262,14 +2253,14 @@ check_prev_add(struct task_struct *curr,
 	 */
 	ret = add_lock_to_list(hlock_class(next), hlock_class(prev),
 			       &hlock_class(prev)->locks_after,
-			       next->acquire_ip, distance, trace);
+			       next->acquire_ip, distance, &trace);
 
 	if (!ret)
 		return 0;
 
 	ret = add_lock_to_list(hlock_class(prev), hlock_class(next),
 			       &hlock_class(next)->locks_before,
-			       next->acquire_ip, distance, trace);
+			       next->acquire_ip, distance, &trace);
 	if (!ret)
 		return 0;
 
@@ -2287,12 +2278,6 @@ check_prevs_add(struct task_struct *curr
 {
 	int depth = curr->lockdep_depth;
 	struct held_lock *hlock;
-	struct stack_trace trace = {
-		.nr_entries = 0,
-		.max_entries = 0,
-		.entries = NULL,
-		.skip = 0,
-	};
 
 	/*
 	 * Debugging checks.
@@ -2318,7 +2303,8 @@ check_prevs_add(struct task_struct *curr
 		 * added:
 		 */
 		if (hlock->read != 2 && hlock->check) {
-			int ret = check_prev_add(curr, hlock, next, distance, &trace, save_trace);
+			int ret = check_prev_add(curr, hlock, next, distance);
+
 			if (!ret)
 				return 0;
 


