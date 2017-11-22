Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38218 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752096AbdKVVQP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 16:16:15 -0500
Received: by mail-qt0-f194.google.com with SMTP id q13so14125889qtb.5
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 13:16:15 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
To: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>
Subject: [PATCH v2 04/11] lib: add a __fprop_add_percpu_max
Date: Wed, 22 Nov 2017 16:15:59 -0500
Message-Id: <1511385366-20329-5-git-send-email-josef@toxicpanda.com>
In-Reply-To: <1511385366-20329-1-git-send-email-josef@toxicpanda.com>
References: <1511385366-20329-1-git-send-email-josef@toxicpanda.com>
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
index 0d348e011a6e..9f88684bf0a0 100644
--- a/include/linux/flex_proportions.h
+++ b/include/linux/flex_proportions.h
@@ -83,8 +83,8 @@ struct fprop_local_percpu {
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
@@ -99,4 +99,11 @@ void fprop_inc_percpu(struct fprop_global *p, struct fprop_local_percpu *pl)
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
index b0343ae71f5e..fd95791a2c93 100644
--- a/lib/flex_proportions.c
+++ b/lib/flex_proportions.c
@@ -255,8 +255,9 @@ void fprop_fraction_percpu(struct fprop_global *p,
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
@@ -267,6 +268,6 @@ void __fprop_inc_percpu_max(struct fprop_global *p,
 			return;
 	} else
 		fprop_reflect_period_percpu(p, pl);
-	percpu_counter_add_batch(&pl->events, 1, PROP_BATCH);
-	percpu_counter_add(&p->events, 1);
+	percpu_counter_add_batch(&pl->events, nr, PROP_BATCH);
+	percpu_counter_add(&p->events, nr);
 }
-- 
2.7.5

