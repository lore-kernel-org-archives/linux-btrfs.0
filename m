Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:22588 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbcGYHUG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jul 2016 03:20:06 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe Manana <fdmanana@gmail.com>
Subject: [PATCH RFC] btrfs: send: Disable clone detection
Date: Mon, 25 Jul 2016 15:19:59 +0800
Message-Id: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch will disable clone detection of send.

The main problem of clone detetion in send is its memory usage and long
execution time.

The clone detection is done by iterating all backrefs and adding backref
whose root is the source.

However iterating all backrefs is already quite a bad idea, we should
never try to do it in a loop, and unfortunately in-band/out-of-band and
reflink can easily create a file whose file extents are point to the
same extent.

In that case, btrfs will do backref walk for the same extent again and
again, until either OOM or soft lockup is triggered.

So disabling clone detection until we find a method that iterates
backrefs of one extent only once, just like what balance/qgroup is doing.

Cc: Filipe Manana <fdmanana@gmail.com>
Reported-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 fs/btrfs/send.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 2db8dc8..eed3f1c 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -1166,6 +1166,7 @@ struct backref_ctx {
 	int found_itself;
 };
 
+#if 0
 static int __clone_root_cmp_bsearch(const void *key, const void *elt)
 {
 	u64 root = (u64)(uintptr_t)key;
@@ -1177,6 +1178,7 @@ static int __clone_root_cmp_bsearch(const void *key, const void *elt)
 		return 1;
 	return 0;
 }
+#endif
 
 static int __clone_root_cmp_sort(const void *e1, const void *e2)
 {
@@ -1190,6 +1192,7 @@ static int __clone_root_cmp_sort(const void *e1, const void *e2)
 	return 0;
 }
 
+#if 0
 /*
  * Called for every backref that is found for the current extent.
  * Results are collected in sctx->clone_roots->ino/offset/found_refs
@@ -1445,6 +1448,7 @@ out:
 	kfree(backref_ctx);
 	return ret;
 }
+#endif
 
 static int read_symlink(struct btrfs_root *root,
 			u64 ino,
@@ -5291,7 +5295,6 @@ static int process_extent(struct send_ctx *sctx,
 			  struct btrfs_path *path,
 			  struct btrfs_key *key)
 {
-	struct clone_root *found_clone = NULL;
 	int ret = 0;
 
 	if (S_ISLNK(sctx->cur_inode_mode))
@@ -5333,12 +5336,27 @@ static int process_extent(struct send_ctx *sctx,
 		}
 	}
 
+	/*
+	 * Current clone detection is both time and memory consuming.
+	 *
+	 * Time consuming is caused by iterating all backref of extent.
+	 * Memory consuming is caused by allocating "found_clone" every
+	 * time for a backref.
+	 *
+	 * XXX: Disabling it is never the best method, but at least it
+	 * won't cause OOM nor super long execution time.
+	 * The root fix needs to change the iteration basis, from iterating
+	 * file extents to iterating extents, so find_parent_nodes() and
+	 * backref walk should be called only once for one extent.
+	 */
+#if 0
 	ret = find_extent_clone(sctx, path, key->objectid, key->offset,
 			sctx->cur_inode_size, &found_clone);
 	if (ret != -ENOENT && ret < 0)
 		goto out;
+#endif
 
-	ret = send_write_or_clone(sctx, path, key, found_clone);
+	ret = send_write_or_clone(sctx, path, key, NULL);
 	if (ret)
 		goto out;
 out_hole:
-- 
2.9.0



