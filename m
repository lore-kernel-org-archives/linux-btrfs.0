Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7352 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCCJCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:25 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 16/17] fs, btrfs: convert scrub_ctx.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:25 +0200
Message-Id: <1488531326-21271-17-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

refcount_t type and corresponding API should be
used instead of atomic_t when the variable is used as
a reference counter. This allows to avoid accidental
refcounter overflows that might lead to use-after-free
situations.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: David Windsor <dwindsor@gmail.com>
---
 fs/btrfs/scrub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 4d15112..ace634e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -202,7 +202,7 @@ struct scrub_ctx {
 	 * doesn't free the scrub context before or while the workers are
 	 * doing the wakeup() call.
 	 */
-	atomic_t                refs;
+	refcount_t                refs;
 };
 
 struct scrub_fixup_nodatasum {
@@ -305,7 +305,7 @@ static void scrub_put_ctx(struct scrub_ctx *sctx);
 
 static void scrub_pending_bio_inc(struct scrub_ctx *sctx)
 {
-	atomic_inc(&sctx->refs);
+	refcount_inc(&sctx->refs);
 	atomic_inc(&sctx->bios_in_flight);
 }
 
@@ -356,7 +356,7 @@ static void scrub_pending_trans_workers_inc(struct scrub_ctx *sctx)
 {
 	struct btrfs_fs_info *fs_info = sctx->fs_info;
 
-	atomic_inc(&sctx->refs);
+	refcount_inc(&sctx->refs);
 	/*
 	 * increment scrubs_running to prevent cancel requests from
 	 * completing as long as a worker is running. we must also
@@ -447,7 +447,7 @@ static noinline_for_stack void scrub_free_ctx(struct scrub_ctx *sctx)
 
 static void scrub_put_ctx(struct scrub_ctx *sctx)
 {
-	if (atomic_dec_and_test(&sctx->refs))
+	if (refcount_dec_and_test(&sctx->refs))
 		scrub_free_ctx(sctx);
 }
 
@@ -462,7 +462,7 @@ struct scrub_ctx *scrub_setup_ctx(struct btrfs_device *dev, int is_dev_replace)
 	sctx = kzalloc(sizeof(*sctx), GFP_KERNEL);
 	if (!sctx)
 		goto nomem;
-	atomic_set(&sctx->refs, 1);
+	refcount_set(&sctx->refs, 1);
 	sctx->is_dev_replace = is_dev_replace;
 	sctx->pages_per_rd_bio = SCRUB_PAGES_PER_RD_BIO;
 	sctx->curr = -1;
-- 
2.7.4

