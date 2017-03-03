Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7352 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751394AbdCCJCY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:24 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 13/17] fs, btrfs: convert scrub_page.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:22 +0200
Message-Id: <1488531326-21271-14-git-send-email-elena.reshetova@intel.com>
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
 fs/btrfs/scrub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index c9406bf..8299f64 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -79,7 +79,7 @@ struct scrub_page {
 	u64			logical;
 	u64			physical;
 	u64			physical_for_dev_replace;
-	atomic_t		refs;
+	refcount_t		refs;
 	struct {
 		unsigned int	mirror_num:8;
 		unsigned int	have_csum:1;
@@ -2017,12 +2017,12 @@ static void scrub_block_put(struct scrub_block *sblock)
 
 static void scrub_page_get(struct scrub_page *spage)
 {
-	atomic_inc(&spage->refs);
+	refcount_inc(&spage->refs);
 }
 
 static void scrub_page_put(struct scrub_page *spage)
 {
-	if (atomic_dec_and_test(&spage->refs)) {
+	if (refcount_dec_and_test(&spage->refs)) {
 		if (spage->page)
 			__free_page(spage->page);
 		kfree(spage);
-- 
2.7.4

