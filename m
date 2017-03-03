Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27392 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751262AbdCCJCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:24 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 12/17] fs, btrfs: convert scrub_recover.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:21 +0200
Message-Id: <1488531326-21271-13-git-send-email-elena.reshetova@intel.com>
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
index b0251eb..c9406bf 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -64,7 +64,7 @@ struct scrub_ctx;
 #define SCRUB_MAX_PAGES_PER_BLOCK	16	/* 64k per node/leaf/sector */
 
 struct scrub_recover {
-	atomic_t		refs;
+	refcount_t		refs;
 	struct btrfs_bio	*bbio;
 	u64			map_length;
 };
@@ -857,12 +857,12 @@ static void scrub_fixup_nodatasum(struct btrfs_work *work)
 
 static inline void scrub_get_recover(struct scrub_recover *recover)
 {
-	atomic_inc(&recover->refs);
+	refcount_inc(&recover->refs);
 }
 
 static inline void scrub_put_recover(struct scrub_recover *recover)
 {
-	if (atomic_dec_and_test(&recover->refs)) {
+	if (refcount_dec_and_test(&recover->refs)) {
 		btrfs_put_bbio(recover->bbio);
 		kfree(recover);
 	}
@@ -1343,7 +1343,7 @@ static int scrub_setup_recheck_block(struct scrub_block *original_sblock,
 			return -ENOMEM;
 		}
 
-		atomic_set(&recover->refs, 1);
+		refcount_set(&recover->refs, 1);
 		recover->bbio = bbio;
 		recover->map_length = mapped_length;
 
-- 
2.7.4

