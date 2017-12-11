Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:42760 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdLKVzp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Dec 2017 16:55:45 -0500
Received: by mail-qt0-f193.google.com with SMTP id g9so42510275qth.9
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Dec 2017 13:55:45 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v3 04/10] writeback: convert the flexible prop stuff to bytes
Date: Mon, 11 Dec 2017 16:55:29 -0500
Message-Id: <1513029335-5112-5-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1513029335-5112-1-git-send-email-josef@toxicpanda.com>
References: <1513029335-5112-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

The flexible proportions were all page based, but now that we are doing
metadata writeout that can be smaller or larger than page size we need
to account for this in bytes instead of number of pages.

Signed-off-by: Josef Bacik <jbacik@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 lib/flex_proportions.c |  2 +-
 mm/page-writeback.c    | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
index 31003989d34a..fd95791a2c93 100644
--- a/lib/flex_proportions.c
+++ b/lib/flex_proportions.c
@@ -166,7 +166,7 @@ void fprop_fraction_single(struct fprop_global *p,
 /*
  * ---- PERCPU ----
  */
-#define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
+#define PROP_BATCH (8*PAGE_SIZE*(1+ilog2(nr_cpu_ids)))
 
 int fprop_local_init_percpu(struct fprop_local_percpu *pl, gfp_t gfp)
 {
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e4563645749a..2a1994194cc1 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -574,11 +574,11 @@ static unsigned long wp_next_time(unsigned long cur_time)
 	return cur_time;
 }
 
-static void wb_domain_writeout_inc(struct wb_domain *dom,
+static void wb_domain_writeout_add(struct wb_domain *dom,
 				   struct fprop_local_percpu *completions,
-				   unsigned int max_prop_frac)
+				   long bytes, unsigned int max_prop_frac)
 {
-	__fprop_inc_percpu_max(&dom->completions, completions,
+	__fprop_add_percpu_max(&dom->completions, completions, bytes,
 			       max_prop_frac);
 	/* First event after period switching was turned off? */
 	if (unlikely(!dom->period_time)) {
@@ -602,12 +602,12 @@ static inline void __wb_writeout_add(struct bdi_writeback *wb, long bytes)
 	struct wb_domain *cgdom;
 
 	__add_wb_stat(wb, WB_WRITTEN_BYTES, bytes);
-	wb_domain_writeout_inc(&global_wb_domain, &wb->completions,
+	wb_domain_writeout_add(&global_wb_domain, &wb->completions, bytes,
 			       wb->bdi->max_prop_frac);
 
 	cgdom = mem_cgroup_wb_domain(wb);
 	if (cgdom)
-		wb_domain_writeout_inc(cgdom, wb_memcg_completions(wb),
+		wb_domain_writeout_add(cgdom, wb_memcg_completions(wb), bytes,
 				       wb->bdi->max_prop_frac);
 }
 
-- 
2.7.5

