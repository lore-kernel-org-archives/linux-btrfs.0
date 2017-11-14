Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:44883 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756847AbdKNV5D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 16:57:03 -0500
Received: by mail-qt0-f195.google.com with SMTP id 8so29725340qtv.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 13:57:03 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH 04/10] lib: add a __fprop_add_percpu_max
Date: Tue, 14 Nov 2017 16:56:50 -0500
Message-Id: <1510696616-8489-4-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1510696616-8489-1-git-send-email-josef@toxicpanda.com>
References: <1510696616-8489-1-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Josef Bacik <jbacik@fb.com>

This helper allows us to add an arbitrary amount to the fprop
structures.

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 include/linux/flex_proportions.h | 11 +++++++++--
 lib/flex_proportions.c           |  9 +++++----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/include/linux/flex_proportions.h b/include/linux/flex_proportions.h
index 853f4305d1b2..2d1a87331e5d 100644
--- a/include/linux/flex_proportions.h
+++ b/include/linux/flex_proportions.h
@@ -85,8 +85,8 @@ struct fprop_local_percpu {
 int fprop_local_init_percpu(struct fprop_local_percpu *pl, gfp_t gfp);
 void fprop_local_destroy_percpu(struct fprop_local_percpu *pl);
 void __fprop_inc_percpu(struct fprop_global *p, struct fprop_local_percpu *pl);
-void __fprop_inc_percpu_max(struct fprop_global *p, struct fprop_local_percpu *pl,
-			    int max_frac);
+void __fprop_add_percpu_max(struct fprop_global *p, struct fprop_local_percpu *pl,
+			    unsigned long nr, int max_frac);
 void fprop_fraction_percpu(struct fprop_global *p,
 	struct fprop_local_percpu *pl, unsigned long *numerator,
 	unsigned long *denominator);
@@ -101,4 +101,11 @@ void fprop_inc_percpu(struct fprop_global *p, struct fprop_local_percpu *pl)
 	local_irq_restore(flags);
 }
 
+static inline
+void __fprop_inc_percpu_max(struct fprop_global *p,
+			    struct fprop_local_percpu *pl, int max_frac)
+{
+	__fprop_add_percpu_max(p, pl, 1, max_frac);
+}
+
 #endif
diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
index 5552523b663a..2190180a81fe 100644
--- a/lib/flex_proportions.c
+++ b/lib/flex_proportions.c
@@ -254,8 +254,9 @@ void fprop_fraction_percpu(struct fprop_global *p,
  * Like __fprop_inc_percpu() except that event is counted only if the given
  * type has fraction smaller than @max_frac/FPROP_FRAC_BASE
  */
-void __fprop_inc_percpu_max(struct fprop_global *p,
-			    struct fprop_local_percpu *pl, int max_frac)
+void __fprop_add_percpu_max(struct fprop_global *p,
+			    struct fprop_local_percpu *pl, unsigned long nr,
+			    int max_frac)
 {
 	if (unlikely(max_frac < FPROP_FRAC_BASE)) {
 		unsigned long numerator, denominator;
@@ -266,6 +267,6 @@ void __fprop_inc_percpu_max(struct fprop_global *p,
 			return;
 	} else
 		fprop_reflect_period_percpu(p, pl);
-	percpu_counter_add_batch(&pl->events, 1, p->batch_size);
-	percpu_counter_add(&p->events, 1);
+	percpu_counter_add_batch(&pl->events, nr, p->batch_size);
+	percpu_counter_add(&p->events, nr);
 }
-- 
2.7.5

