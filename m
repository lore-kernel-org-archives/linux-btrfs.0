Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7558 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752444AbcGDEfs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 00:35:48 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u644XfGb013901
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Jul 2016 00:35:48 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23x9ppexue-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 04 Jul 2016 00:35:47 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 4 Jul 2016 00:35:46 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: clm@fb.com, jbacik@fb.com, dsterba@suse.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH V20 12/19] Revert "btrfs: fix lockups from btrfs_clear_path_blocking"
Date: Mon,  4 Jul 2016 10:04:32 +0530
In-Reply-To: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
References: <1467606879-14181-1-git-send-email-chandan@linux.vnet.ibm.com>
Message-Id: <1467606879-14181-13-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The patch "Btrfs: subpage-blocksize: Prevent writes to an extent buffer
when PG_writeback flag is set" requires btrfs_try_tree_write_lock() to
be a true try lock w.r.t to both spinning and blocking locks. During
2015's Vault Conference Btrfs meetup, Chris Mason had suggested that he
will write up a suitable locking function to be used when writing dirty
pages that map metadata blocks. Until we have a suitable locking
function available, this patch temporarily disables the commit
f82c458a2c3ffb94b431fc6ad791a79df1b3713e.
---
 fs/btrfs/ctree.c   | 14 ++++++++++++--
 fs/btrfs/locking.c | 24 +++---------------------
 fs/btrfs/locking.h |  2 --
 3 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 0a56d1b..394ad8e 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -81,6 +81,13 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
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
@@ -89,6 +96,7 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 			held_rw = BTRFS_READ_LOCK_BLOCKING;
 	}
 	btrfs_set_path_blocking(p);
+#endif
 
 	for (i = BTRFS_MAX_LEVEL - 1; i >= 0; i--) {
 		if (p->nodes[i] && p->locks[i]) {
@@ -100,8 +108,10 @@ noinline void btrfs_clear_path_blocking(struct btrfs_path *p,
 		}
 	}
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
 	if (held)
 		btrfs_clear_lock_blocking_rw(held, held_rw);
+#endif
 }
 
 /* this also releases the path */
@@ -2922,7 +2932,7 @@ cow_done:
 					}
 					p->locks[level] = BTRFS_WRITE_LOCK;
 				} else {
-					err = btrfs_tree_read_lock_atomic(b);
+					err = btrfs_try_tree_read_lock(b);
 					if (!err) {
 						btrfs_set_path_blocking(p);
 						btrfs_tree_read_lock(b);
@@ -3054,7 +3064,7 @@ again:
 			}
 
 			level = btrfs_header_level(b);
-			err = btrfs_tree_read_lock_atomic(b);
+			err = btrfs_try_tree_read_lock(b);
 			if (!err) {
 				btrfs_set_path_blocking(p);
 				btrfs_tree_read_lock(b);
diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
index d13128c..8b50e60 100644
--- a/fs/btrfs/locking.c
+++ b/fs/btrfs/locking.c
@@ -132,26 +132,6 @@ again:
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
@@ -182,7 +162,9 @@ int btrfs_try_tree_write_lock(struct extent_buffer *eb)
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
2.5.5

