Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27392 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751431AbdCCJCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:25 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 15/17] fs, btrfs: convert scrub_parity.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:24 +0200
Message-Id: <1488531326-21271-16-git-send-email-elena.reshetova@intel.com>
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
 fs/btrfs/scrub.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 08895d8..4d15112 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -142,7 +142,7 @@ struct scrub_parity {
 
 	int			stripe_len;
 
-	atomic_t		refs;
+	refcount_t		refs;
 
 	struct list_head	spages;
 
@@ -2822,12 +2822,12 @@ static inline int scrub_calc_parity_bitmap_len(int nsectors)
 
 static void scrub_parity_get(struct scrub_parity *sparity)
 {
-	atomic_inc(&sparity->refs);
+	refcount_inc(&sparity->refs);
 }
 
 static void scrub_parity_put(struct scrub_parity *sparity)
 {
-	if (!atomic_dec_and_test(&sparity->refs))
+	if (!refcount_dec_and_test(&sparity->refs))
 		return;
 
 	scrub_parity_check_and_repair(sparity);
@@ -2879,7 +2879,7 @@ static noinline_for_stack int scrub_raid56_parity(struct scrub_ctx *sctx,
 	sparity->scrub_dev = sdev;
 	sparity->logic_start = logic_start;
 	sparity->logic_end = logic_end;
-	atomic_set(&sparity->refs, 1);
+	refcount_set(&sparity->refs, 1);
 	INIT_LIST_HEAD(&sparity->spages);
 	sparity->dbitmap = sparity->bitmap;
 	sparity->ebitmap = (void *)sparity->bitmap + bitmap_len;
-- 
2.7.4

