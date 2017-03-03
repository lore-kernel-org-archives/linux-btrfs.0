Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25204 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751278AbdCCJCZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Mar 2017 04:02:25 -0500
From: Elena Reshetova <elena.reshetova@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        peterz@infradead.org, gregkh@linuxfoundation.org, jbacik@fb.com,
        clm@fb.com, dsterba@suse.com,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>
Subject: [PATCH 17/17] fs, btrfs: convert btrfs_raid_bio.refs from atomic_t to refcount_t
Date: Fri,  3 Mar 2017 10:55:26 +0200
Message-Id: <1488531326-21271-18-git-send-email-elena.reshetova@intel.com>
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
 fs/btrfs/raid56.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 1571bf2..a8954f5 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -149,7 +149,7 @@ struct btrfs_raid_bio {
 
 	int generic_bio_cnt;
 
-	atomic_t refs;
+	refcount_t refs;
 
 	atomic_t stripes_pending;
 
@@ -389,7 +389,7 @@ static void __remove_rbio_from_cache(struct btrfs_raid_bio *rbio)
 		if (bio_list_empty(&rbio->bio_list)) {
 			if (!list_empty(&rbio->hash_list)) {
 				list_del_init(&rbio->hash_list);
-				atomic_dec(&rbio->refs);
+				refcount_dec(&rbio->refs);
 				BUG_ON(!list_empty(&rbio->plug_list));
 			}
 		}
@@ -480,7 +480,7 @@ static void cache_rbio(struct btrfs_raid_bio *rbio)
 
 	/* bump our ref if we were not in the list before */
 	if (!test_and_set_bit(RBIO_CACHE_BIT, &rbio->flags))
-		atomic_inc(&rbio->refs);
+		refcount_inc(&rbio->refs);
 
 	if (!list_empty(&rbio->stripe_cache)){
 		list_move(&rbio->stripe_cache, &table->stripe_cache);
@@ -689,7 +689,7 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 			    test_bit(RBIO_CACHE_BIT, &cur->flags) &&
 			    !test_bit(RBIO_RMW_LOCKED_BIT, &cur->flags)) {
 				list_del_init(&cur->hash_list);
-				atomic_dec(&cur->refs);
+				refcount_dec(&cur->refs);
 
 				steal_rbio(cur, rbio);
 				cache_drop = cur;
@@ -738,7 +738,7 @@ static noinline int lock_stripe_add(struct btrfs_raid_bio *rbio)
 		}
 	}
 lockit:
-	atomic_inc(&rbio->refs);
+	refcount_inc(&rbio->refs);
 	list_add(&rbio->hash_list, &h->hash_list);
 out:
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -784,7 +784,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 		}
 
 		list_del_init(&rbio->hash_list);
-		atomic_dec(&rbio->refs);
+		refcount_dec(&rbio->refs);
 
 		/*
 		 * we use the plug list to hold all the rbios
@@ -801,7 +801,7 @@ static noinline void unlock_stripe(struct btrfs_raid_bio *rbio)
 			list_del_init(&rbio->plug_list);
 
 			list_add(&next->hash_list, &h->hash_list);
-			atomic_inc(&next->refs);
+			refcount_inc(&next->refs);
 			spin_unlock(&rbio->bio_list_lock);
 			spin_unlock_irqrestore(&h->lock, flags);
 
@@ -843,8 +843,7 @@ static void __free_raid_bio(struct btrfs_raid_bio *rbio)
 {
 	int i;
 
-	WARN_ON(atomic_read(&rbio->refs) < 0);
-	if (!atomic_dec_and_test(&rbio->refs))
+	if (!refcount_dec_and_test(&rbio->refs))
 		return;
 
 	WARN_ON(!list_empty(&rbio->stripe_cache));
@@ -997,7 +996,7 @@ static struct btrfs_raid_bio *alloc_rbio(struct btrfs_fs_info *fs_info,
 	rbio->stripe_npages = stripe_npages;
 	rbio->faila = -1;
 	rbio->failb = -1;
-	atomic_set(&rbio->refs, 1);
+	refcount_set(&rbio->refs, 1);
 	atomic_set(&rbio->error, 0);
 	atomic_set(&rbio->stripes_pending, 0);
 
-- 
2.7.4

