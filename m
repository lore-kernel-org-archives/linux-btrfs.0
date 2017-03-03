Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25204 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751478AbdCCJCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:24 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 14/17] fs, btrfs: convert scrub_block.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:23 +0200
Message-Id: <1488531326-21271-15-git-send-email-elena.reshetova@intel.com>
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
index 8299f64..08895d8 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -112,7 +112,7 @@ struct scrub_block {
 	struct scrub_page	*pagev[SCRUB_MAX_PAGES_PER_BLOCK];
 	int			page_count;
 	atomic_t		outstanding_pages;
-	atomic_t		refs; /* free mem on transition to zero */
+	refcount_t		refs; /* free mem on transition to zero */
 	struct scrub_ctx	*sctx;
 	struct scrub_parity	*sparity;
 	struct {
@@ -1998,12 +1998,12 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 
 static void scrub_block_get(struct scrub_block *sblock)
 {
-	atomic_inc(&sblock->refs);
+	refcount_inc(&sblock->refs);
 }
 
 static void scrub_block_put(struct scrub_block *sblock)
 {
-	if (atomic_dec_and_test(&sblock->refs)) {
+	if (refcount_dec_and_test(&sblock->refs)) {
 		int i;
 
 		if (sblock->sparity)
@@ -2255,7 +2255,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 
 	/* one ref inside this function, plus one for each page added to
 	 * a bio later on */
-	atomic_set(&sblock->refs, 1);
+	refcount_set(&sblock->refs, 1);
 	sblock->sctx = sctx;
 	sblock->no_io_error_seen = 1;
 
@@ -2555,7 +2555,7 @@ static int scrub_pages_for_parity(struct scrub_parity *sparity,
 
 	/* one ref inside this function, plus one for each page added to
 	 * a bio later on */
-	atomic_set(&sblock->refs, 1);
+	refcount_set(&sblock->refs, 1);
 	sblock->sctx = sctx;
 	sblock->no_io_error_seen = 1;
 	sblock->sparity = sparity;
-- 
2.7.4

