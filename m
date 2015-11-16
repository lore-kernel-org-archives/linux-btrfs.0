Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:51004 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbbKPHJP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 02:09:15 -0500
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 16 Nov 2015 12:39:13 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id CD1601258096
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:39:17 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tAG78wPc16056326
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:59 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tAG78u0C027375
	for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 12:38:58 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: linux-btrfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, jbacik@fb.com, clm@fb.com,
        bo.li.liu@oracle.com, dsterba@suse.cz, chandan@mykolab.com
Subject: [RFC PATCH V12 12/14] Revert "btrfs: fix lockups from btrfs_clear_path_blocking"
Date: Mon, 16 Nov 2015 12:38:39 +0530
Message-Id: <1447657721-10025-13-git-send-email-chandan@linux.vnet.ibm.com>
In-Reply-To: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1447657721-10025-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This reverts commit f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
---
 fs/btrfs/ctree.c   | 14 ++++++++++++--
 fs/btrfs/locking.c | 24 +++---------------------
 fs/btrfs/locking.h |  2 --
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 6afb6b8..79c613f 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -80,6 +80,13 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 {
 	int i;
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/* lockdep really cares that we take all of these spinlocks
+	 * in the right order.  If any of the locks in the path are not
+	 * currently blocking, it is going to complain.  So, make really
+	 * really sure by forcing the path to blocking before we clear
+	 * the path blocking.
+	 */
 	if (held) {
 		btrfs_set_lock_blocking_rw(held, held_rw);
 		if (held_rw == BTRFS_WRITE_LOCK)
@@ -88,6 +95,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 			held_rw = BTRFS_READ_LOCK_BLOCKING;
 	}
 	btrfs_set_path_blocking(p);
+#endif
 
 	for (i = BTRFS_MAX_LEVEL - 1; i >= 0; i--) {
 		if (p->nodes[i] && p->locks[i]) {
@@ -99,8 +107,10 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 		}
 	}
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (held)
 		btrfs_clear_lock_blocking_rw(held, held_rw);
+#endif
 }
 
 /* this also releases the path */
@@ -2904,7 +2914,7 @@ cow_done:
 					}
 					p->locks[level] = BTRFS_WRITE_LOCK;
 				} else {
-					err = btrfs_tree_read_lock_atomic(b);
+					err = btrfs_try_tree_read_lock(b);
 					if (!err) {
 						btrfs_set_path_blocking(p);
 						btrfs_tree_read_lock(b);
@@ -3036,7 +3046,7 @@ again:
 			}
 
 			level = btrfs_header_level(b);
-			err = btrfs_tree_read_lock_atomic(b);
+			err = btrfs_try_tree_read_lock(b);
 			if (!err) {
 				btrfs_set_path_blocking(p);
 				btrfs_tree_read_lock(b);
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index 8077461..e3eac69 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -134,26 +134,6 @@ again:
 }
 
 /*
- * take a spinning read lock.
- * returns 1 if we get the read lock and 0 if we don't
- * this won't wait for blocking writers
- */
-int btrfs_tree_read_lock_atomic(struct extent_buffer *eb)
-{
-	if (atomic_read(&eb->blocking_writers))
-		return 0;
-
-	read_lock(&eb->lock);
-	if (atomic_read(&eb->blocking_writers)) {
-		read_unlock(&eb->lock);
-		return 0;
-	}
-	atomic_inc(&eb->read_locks);
-	atomic_inc(&eb->spinning_readers);
-	return 1;
-}
-
-/*
  * returns 1 if we get the read lock and 0 if we don't
  * this won't wait for blocking writers
  */
@@ -184,7 +164,9 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
 	    atomic_read(&eb->blocking_readers))
 		return 0;
 
-	write_lock(&eb->lock);
+	if (!write_trylock(&eb->lock))
+		return 0;
+
 	if (atomic_read(&eb->blocking_writers) ||
 	    atomic_read(&eb->blocking_readers)) {
 		write_unlock(&eb->lock);
diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
index c44a9d5..b81e0e9 100644
--- a/fs/btrfs/locking.h
+++ b/fs/btrfs/locking.h
@@ -35,8 +35,6 @@ void btrfs_clear_lock_blocking_rw(struct extent_buffer *eb, int rw);
 void btrfs_assert_tree_locked(struct extent_buffer *eb);
 int btrfs_try_tree_read_lock(struct extent_buffer *eb);
 int btrfs_try_tree_write_lock(struct extent_buffer *eb);
-int btrfs_tree_read_lock_atomic(struct extent_buffer *eb);
-
 
 static inline void btrfs_tree_unlock_rw(struct extent_buffer *eb, int rw)
 {
-- 
2.1.0

