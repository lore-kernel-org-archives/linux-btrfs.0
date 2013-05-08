Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48116 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3EHHw1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 May 2013 03:52:27 -0400
Received: from m2.gw.fujitsu.co.jp (unknown [10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 74EB63EE0BB
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 16:52:25 +0900 (JST)
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 6288C45DE4D
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 16:52:25 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 4B98745DDCF
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 16:52:25 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id 3A7301DB8038
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 16:52:25 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id D96DC1DB803C
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 16:52:24 +0900 (JST)
Received: from m1000.css.fujitsu.com (m1000 [127.0.0.1])
	by m1000.s.css.fujitsu.com (Postfix) with ESMTP id AEDF261691
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 16:52:24 +0900 (JST)
Received: from FM-323941448.jp.fujitsu.com (unknown [10.124.101.141])
	by m1000.s.css.fujitsu.com (Postfix) with SMTP id 7C68C61690
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 16:52:24 +0900 (JST)
Message-Id: <201305080751.AA00030@FM-323941448.jp.fujitsu.com>
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Date: Wed, 08 May 2013 16:51:52 +0900
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] Btrfs: cleanup unused arguments in send.c
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

sctx is removed from the argument of the function that
doesn't use sctx.

Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
---
 fs/btrfs/send.c | 189 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 90 insertions(+), 99 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index ff40f1c..fedec7b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -158,7 +158,7 @@ static void fs_path_reset(struct fs_path *p)
 	}
 }
 
-static struct fs_path *fs_path_alloc(struct send_ctx *sctx)
+static struct fs_path *fs_path_alloc(void)
 {
 	struct fs_path *p;
 
@@ -173,11 +173,11 @@ static struct fs_path *fs_path_alloc(struct send_ctx *sctx)
 	return p;
 }
 
-static struct fs_path *fs_path_alloc_reversed(struct send_ctx *sctx)
+static struct fs_path *fs_path_alloc_reversed(void)
 {
 	struct fs_path *p;
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return NULL;
 	p->reversed = 1;
@@ -185,7 +185,7 @@ static struct fs_path *fs_path_alloc_reversed(struct send_ctx *sctx)
 	return p;
 }
 
-static void fs_path_free(struct send_ctx *sctx, struct fs_path *p)
+static void fs_path_free(struct fs_path *p)
 {
 	if (!p)
 		return;
@@ -753,8 +753,7 @@ typedef int (*iterate_inode_ref_t)(int num, u64 dir, int index,
  *
  * path must point to the INODE_REF or INODE_EXTREF when called.
  */
-static int iterate_inode_ref(struct send_ctx *sctx,
-			     struct btrfs_root *root, struct btrfs_path *path,
+static int iterate_inode_ref(struct btrfs_root *root, struct btrfs_path *path,
 			     struct btrfs_key *found_key, int resolve,
 			     iterate_inode_ref_t iterate, void *ctx)
 {
@@ -777,13 +776,13 @@ static int iterate_inode_ref(struct send_ctx *sctx,
 	unsigned long elem_size;
 	unsigned long ptr;
 
-	p = fs_path_alloc_reversed(sctx);
+	p = fs_path_alloc_reversed();
 	if (!p)
 		return -ENOMEM;
 
 	tmp_path = alloc_path_for_send();
 	if (!tmp_path) {
-		fs_path_free(sctx, p);
+		fs_path_free(p);
 		return -ENOMEM;
 	}
 
@@ -858,7 +857,7 @@ static int iterate_inode_ref(struct send_ctx *sctx,
 
 out:
 	btrfs_free_path(tmp_path);
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -874,8 +873,7 @@ typedef int (*iterate_dir_item_t)(int num, struct btrfs_key *di_key,
  *
  * path must point to the dir item when called.
  */
-static int iterate_dir_item(struct send_ctx *sctx,
-			    struct btrfs_root *root, struct btrfs_path *path,
+static int iterate_dir_item(struct btrfs_root *root, struct btrfs_path *path,
 			    struct btrfs_key *found_key,
 			    iterate_dir_item_t iterate, void *ctx)
 {
@@ -990,7 +988,7 @@ static int __copy_first_ref(int num, u64 dir, int index,
  * Retrieve the first path of an inode. If an inode has more then one
  * ref/hardlink, this is ignored.
  */
-static int get_inode_path(struct send_ctx *sctx, struct btrfs_root *root,
+static int get_inode_path(struct btrfs_root *root,
 			  u64 ino, struct fs_path *path)
 {
 	int ret;
@@ -1022,8 +1020,8 @@ static int get_inode_path(struct send_ctx *sctx, struct btrfs_root *root,
 		goto out;
 	}
 
-	ret = iterate_inode_ref(sctx, root, p, &found_key, 1,
-			__copy_first_ref, path);
+	ret = iterate_inode_ref(root, p, &found_key, 1,
+				__copy_first_ref, path);
 	if (ret < 0)
 		goto out;
 	ret = 0;
@@ -1314,8 +1312,7 @@ out:
 	return ret;
 }
 
-static int read_symlink(struct send_ctx *sctx,
-			struct btrfs_root *root,
+static int read_symlink(struct btrfs_root *root,
 			u64 ino,
 			struct fs_path *dest)
 {
@@ -1562,8 +1559,7 @@ out:
  * Looks up the first btrfs_inode_ref of a given ino. It returns the parent dir,
  * generation of the parent dir and the name of the dir entry.
  */
-static int get_first_ref(struct send_ctx *sctx,
-			 struct btrfs_root *root, u64 ino,
+static int get_first_ref(struct btrfs_root *root, u64 ino,
 			 u64 *dir, u64 *dir_gen, struct fs_path *name)
 {
 	int ret;
@@ -1628,8 +1624,7 @@ out:
 	return ret;
 }
 
-static int is_first_ref(struct send_ctx *sctx,
-			struct btrfs_root *root,
+static int is_first_ref(struct btrfs_root *root,
 			u64 ino, u64 dir,
 			const char *name, int name_len)
 {
@@ -1638,11 +1633,11 @@ static int is_first_ref(struct send_ctx *sctx,
 	u64 tmp_dir;
 	u64 tmp_dir_gen;
 
-	tmp_name = fs_path_alloc(sctx);
+	tmp_name = fs_path_alloc();
 	if (!tmp_name)
 		return -ENOMEM;
 
-	ret = get_first_ref(sctx, root, ino, &tmp_dir, &tmp_dir_gen, tmp_name);
+	ret = get_first_ref(root, ino, &tmp_dir, &tmp_dir_gen, tmp_name);
 	if (ret < 0)
 		goto out;
 
@@ -1654,7 +1649,7 @@ static int is_first_ref(struct send_ctx *sctx,
 	ret = !memcmp(tmp_name->start, name, name_len);
 
 out:
-	fs_path_free(sctx, tmp_name);
+	fs_path_free(tmp_name);
 	return ret;
 }
 
@@ -1783,11 +1778,11 @@ static int did_overwrite_first_ref(struct send_ctx *sctx, u64 ino, u64 gen)
 	if (!sctx->parent_root)
 		goto out;
 
-	name = fs_path_alloc(sctx);
+	name = fs_path_alloc();
 	if (!name)
 		return -ENOMEM;
 
-	ret = get_first_ref(sctx, sctx->parent_root, ino, &dir, &dir_gen, name);
+	ret = get_first_ref(sctx->parent_root, ino, &dir, &dir_gen, name);
 	if (ret < 0)
 		goto out;
 
@@ -1795,7 +1790,7 @@ static int did_overwrite_first_ref(struct send_ctx *sctx, u64 ino, u64 gen)
 			name->start, fs_path_len(name));
 
 out:
-	fs_path_free(sctx, name);
+	fs_path_free(name);
 	return ret;
 }
 
@@ -1979,11 +1974,11 @@ static int __get_cur_name_and_parent(struct send_ctx *sctx,
 	 * send_root or parent_root for ref lookup.
 	 */
 	if (ino < sctx->send_progress)
-		ret = get_first_ref(sctx, sctx->send_root, ino,
-				parent_ino, parent_gen, dest);
+		ret = get_first_ref(sctx->send_root, ino,
+				    parent_ino, parent_gen, dest);
 	else
-		ret = get_first_ref(sctx, sctx->parent_root, ino,
-				parent_ino, parent_gen, dest);
+		ret = get_first_ref(sctx->parent_root, ino,
+				    parent_ino, parent_gen, dest);
 	if (ret < 0)
 		goto out;
 
@@ -2070,7 +2065,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 	u64 parent_gen = 0;
 	int stop = 0;
 
-	name = fs_path_alloc(sctx);
+	name = fs_path_alloc();
 	if (!name) {
 		ret = -ENOMEM;
 		goto out;
@@ -2098,7 +2093,7 @@ static int get_cur_path(struct send_ctx *sctx, u64 ino, u64 gen,
 	}
 
 out:
-	fs_path_free(sctx, name);
+	fs_path_free(name);
 	if (!ret)
 		fs_path_unreverse(dest);
 	return ret;
@@ -2263,7 +2258,7 @@ static int send_truncate(struct send_ctx *sctx, u64 ino, u64 gen, u64 size)
 
 verbose_printk("btrfs: send_truncate %llu size=%llu\n", ino, size);
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -2281,7 +2276,7 @@ verbose_printk("btrfs: send_truncate %llu size=%llu\n", ino, size);
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -2292,7 +2287,7 @@ static int send_chmod(struct send_ctx *sctx, u64 ino, u64 gen, u64 mode)
 
 verbose_printk("btrfs: send_chmod %llu mode=%llu\n", ino, mode);
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -2310,7 +2305,7 @@ verbose_printk("btrfs: send_chmod %llu mode=%llu\n", ino, mode);
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -2321,7 +2316,7 @@ static int send_chown(struct send_ctx *sctx, u64 ino, u64 gen, u64 uid, u64 gid)
 
 verbose_printk("btrfs: send_chown %llu uid=%llu, gid=%llu\n", ino, uid, gid);
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -2340,7 +2335,7 @@ verbose_printk("btrfs: send_chown %llu uid=%llu, gid=%llu\n", ino, uid, gid);
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -2356,7 +2351,7 @@ static int send_utimes(struct send_ctx *sctx, u64 ino, u64 gen)
 
 verbose_printk("btrfs: send_utimes %llu\n", ino);
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -2397,7 +2392,7 @@ verbose_printk("btrfs: send_utimes %llu\n", ino);
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	btrfs_free_path(path);
 	return ret;
 }
@@ -2418,7 +2413,7 @@ static int send_create_inode(struct send_ctx *sctx, u64 ino)
 
 verbose_printk("btrfs: send_create_inode %llu\n", ino);
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -2459,7 +2454,7 @@ verbose_printk("btrfs: send_create_inode %llu\n", ino);
 
 	if (S_ISLNK(mode)) {
 		fs_path_reset(p);
-		ret = read_symlink(sctx, sctx->send_root, ino, p);
+		ret = read_symlink(sctx->send_root, ino, p);
 		if (ret < 0)
 			goto out;
 		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH_LINK, p);
@@ -2476,7 +2471,7 @@ verbose_printk("btrfs: send_create_inode %llu\n", ino);
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -2615,13 +2610,13 @@ static int record_ref(struct list_head *head, u64 dir,
 	return 0;
 }
 
-static void __free_recorded_refs(struct send_ctx *sctx, struct list_head *head)
+static void __free_recorded_refs(struct list_head *head)
 {
 	struct recorded_ref *cur;
 
 	while (!list_empty(head)) {
 		cur = list_entry(head->next, struct recorded_ref, list);
-		fs_path_free(sctx, cur->full_path);
+		fs_path_free(cur->full_path);
 		list_del(&cur->list);
 		kfree(cur);
 	}
@@ -2629,8 +2624,8 @@ static void __free_recorded_refs(struct send_ctx *sctx, struct list_head *head)
 
 static void free_recorded_refs(struct send_ctx *sctx)
 {
-	__free_recorded_refs(sctx, &sctx->new_refs);
-	__free_recorded_refs(sctx, &sctx->deleted_refs);
+	__free_recorded_refs(&sctx->new_refs);
+	__free_recorded_refs(&sctx->deleted_refs);
 }
 
 /*
@@ -2644,7 +2639,7 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 	int ret;
 	struct fs_path *orphan;
 
-	orphan = fs_path_alloc(sctx);
+	orphan = fs_path_alloc();
 	if (!orphan)
 		return -ENOMEM;
 
@@ -2655,7 +2650,7 @@ static int orphanize_inode(struct send_ctx *sctx, u64 ino, u64 gen,
 	ret = send_rename(sctx, path, orphan);
 
 out:
-	fs_path_free(sctx, orphan);
+	fs_path_free(orphan);
 	return ret;
 }
 
@@ -2746,7 +2741,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 	 */
 	BUG_ON(sctx->cur_ino <= BTRFS_FIRST_FREE_OBJECTID);
 
-	valid_path = fs_path_alloc(sctx);
+	valid_path = fs_path_alloc();
 	if (!valid_path) {
 		ret = -ENOMEM;
 		goto out;
@@ -2843,9 +2838,9 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		if (ret < 0)
 			goto out;
 		if (ret) {
-			ret = is_first_ref(sctx, sctx->parent_root,
-					ow_inode, cur->dir, cur->name,
-					cur->name_len);
+			ret = is_first_ref(sctx->parent_root,
+					   ow_inode, cur->dir, cur->name,
+					   cur->name_len);
 			if (ret < 0)
 				goto out;
 			if (ret) {
@@ -3024,7 +3019,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 out:
 	free_recorded_refs(sctx);
 	ulist_free(check_dirs);
-	fs_path_free(sctx, valid_path);
+	fs_path_free(valid_path);
 	return ret;
 }
 
@@ -3037,7 +3032,7 @@ static int __record_new_ref(int num, u64 dir, int index,
 	struct fs_path *p;
 	u64 gen;
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -3057,7 +3052,7 @@ static int __record_new_ref(int num, u64 dir, int index,
 
 out:
 	if (ret)
-		fs_path_free(sctx, p);
+		fs_path_free(p);
 	return ret;
 }
 
@@ -3070,7 +3065,7 @@ static int __record_deleted_ref(int num, u64 dir, int index,
 	struct fs_path *p;
 	u64 gen;
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -3090,7 +3085,7 @@ static int __record_deleted_ref(int num, u64 dir, int index,
 
 out:
 	if (ret)
-		fs_path_free(sctx, p);
+		fs_path_free(p);
 	return ret;
 }
 
@@ -3098,8 +3093,8 @@ static int record_new_ref(struct send_ctx *sctx)
 {
 	int ret;
 
-	ret = iterate_inode_ref(sctx, sctx->send_root, sctx->left_path,
-			sctx->cmp_key, 0, __record_new_ref, sctx);
+	ret = iterate_inode_ref(sctx->send_root, sctx->left_path,
+				sctx->cmp_key, 0, __record_new_ref, sctx);
 	if (ret < 0)
 		goto out;
 	ret = 0;
@@ -3112,8 +3107,8 @@ static int record_deleted_ref(struct send_ctx *sctx)
 {
 	int ret;
 
-	ret = iterate_inode_ref(sctx, sctx->parent_root, sctx->right_path,
-			sctx->cmp_key, 0, __record_deleted_ref, sctx);
+	ret = iterate_inode_ref(sctx->parent_root, sctx->right_path,
+				sctx->cmp_key, 0, __record_deleted_ref, sctx);
 	if (ret < 0)
 		goto out;
 	ret = 0;
@@ -3142,8 +3137,7 @@ static int __find_iref(int num, u64 dir, int index,
 	return 0;
 }
 
-static int find_iref(struct send_ctx *sctx,
-		     struct btrfs_root *root,
+static int find_iref(struct btrfs_root *root,
 		     struct btrfs_path *path,
 		     struct btrfs_key *key,
 		     u64 dir, struct fs_path *name)
@@ -3155,7 +3149,7 @@ static int find_iref(struct send_ctx *sctx,
 	ctx.name = name;
 	ctx.found_idx = -1;
 
-	ret = iterate_inode_ref(sctx, root, path, key, 0, __find_iref, &ctx);
+	ret = iterate_inode_ref(root, path, key, 0, __find_iref, &ctx);
 	if (ret < 0)
 		return ret;
 
@@ -3172,7 +3166,7 @@ static int __record_changed_new_ref(int num, u64 dir, int index,
 	int ret;
 	struct send_ctx *sctx = ctx;
 
-	ret = find_iref(sctx, sctx->parent_root, sctx->right_path,
+	ret = find_iref(sctx->parent_root, sctx->right_path,
 			sctx->cmp_key, dir, name);
 	if (ret == -ENOENT)
 		ret = __record_new_ref(num, dir, index, name, sctx);
@@ -3189,7 +3183,7 @@ static int __record_changed_deleted_ref(int num, u64 dir, int index,
 	int ret;
 	struct send_ctx *sctx = ctx;
 
-	ret = find_iref(sctx, sctx->send_root, sctx->left_path, sctx->cmp_key,
+	ret = find_iref(sctx->send_root, sctx->left_path, sctx->cmp_key,
 			dir, name);
 	if (ret == -ENOENT)
 		ret = __record_deleted_ref(num, dir, index, name, sctx);
@@ -3203,11 +3197,11 @@ static int record_changed_ref(struct send_ctx *sctx)
 {
 	int ret = 0;
 
-	ret = iterate_inode_ref(sctx, sctx->send_root, sctx->left_path,
+	ret = iterate_inode_ref(sctx->send_root, sctx->left_path,
 			sctx->cmp_key, 0, __record_changed_new_ref, sctx);
 	if (ret < 0)
 		goto out;
-	ret = iterate_inode_ref(sctx, sctx->parent_root, sctx->right_path,
+	ret = iterate_inode_ref(sctx->parent_root, sctx->right_path,
 			sctx->cmp_key, 0, __record_changed_deleted_ref, sctx);
 	if (ret < 0)
 		goto out;
@@ -3266,8 +3260,7 @@ static int process_all_refs(struct send_ctx *sctx,
 		     found_key.type != BTRFS_INODE_EXTREF_KEY))
 			break;
 
-		ret = iterate_inode_ref(sctx, root, path, &found_key, 0, cb,
-				sctx);
+		ret = iterate_inode_ref(root, path, &found_key, 0, cb, sctx);
 		btrfs_release_path(path);
 		if (ret < 0)
 			goto out;
@@ -3335,7 +3328,7 @@ static int __process_new_xattr(int num, struct btrfs_key *di_key,
 	struct fs_path *p;
 	posix_acl_xattr_header dummy_acl;
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -3362,7 +3355,7 @@ static int __process_new_xattr(int num, struct btrfs_key *di_key,
 	ret = send_set_xattr(sctx, p, name, name_len, data, data_len);
 
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -3375,7 +3368,7 @@ static int __process_deleted_xattr(int num, struct btrfs_key *di_key,
 	struct send_ctx *sctx = ctx;
 	struct fs_path *p;
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -3386,7 +3379,7 @@ static int __process_deleted_xattr(int num, struct btrfs_key *di_key,
 	ret = send_remove_xattr(sctx, p, name, name_len);
 
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -3394,8 +3387,8 @@ static int process_new_xattr(struct send_ctx *sctx)
 {
 	int ret = 0;
 
-	ret = iterate_dir_item(sctx, sctx->send_root, sctx->left_path,
-			sctx->cmp_key, __process_new_xattr, sctx);
+	ret = iterate_dir_item(sctx->send_root, sctx->left_path,
+			       sctx->cmp_key, __process_new_xattr, sctx);
 
 	return ret;
 }
@@ -3404,8 +3397,8 @@ static int process_deleted_xattr(struct send_ctx *sctx)
 {
 	int ret;
 
-	ret = iterate_dir_item(sctx, sctx->parent_root, sctx->right_path,
-			sctx->cmp_key, __process_deleted_xattr, sctx);
+	ret = iterate_dir_item(sctx->parent_root, sctx->right_path,
+			       sctx->cmp_key, __process_deleted_xattr, sctx);
 
 	return ret;
 }
@@ -3438,8 +3431,7 @@ static int __find_xattr(int num, struct btrfs_key *di_key,
 	return 0;
 }
 
-static int find_xattr(struct send_ctx *sctx,
-		      struct btrfs_root *root,
+static int find_xattr(struct btrfs_root *root,
 		      struct btrfs_path *path,
 		      struct btrfs_key *key,
 		      const char *name, int name_len,
@@ -3454,7 +3446,7 @@ static int find_xattr(struct send_ctx *sctx,
 	ctx.found_data = NULL;
 	ctx.found_data_len = 0;
 
-	ret = iterate_dir_item(sctx, root, path, key, __find_xattr, &ctx);
+	ret = iterate_dir_item(root, path, key, __find_xattr, &ctx);
 	if (ret < 0)
 		return ret;
 
@@ -3480,9 +3472,9 @@ static int __process_changed_new_xattr(int num, struct btrfs_key *di_key,
 	char *found_data = NULL;
 	int found_data_len  = 0;
 
-	ret = find_xattr(sctx, sctx->parent_root, sctx->right_path,
-			sctx->cmp_key, name, name_len, &found_data,
-			&found_data_len);
+	ret = find_xattr(sctx->parent_root, sctx->right_path,
+			 sctx->cmp_key, name, name_len, &found_data,
+			 &found_data_len);
 	if (ret == -ENOENT) {
 		ret = __process_new_xattr(num, di_key, name, name_len, data,
 				data_len, type, ctx);
@@ -3508,8 +3500,8 @@ static int __process_changed_deleted_xattr(int num, struct btrfs_key *di_key,
 	int ret;
 	struct send_ctx *sctx = ctx;
 
-	ret = find_xattr(sctx, sctx->send_root, sctx->left_path, sctx->cmp_key,
-			name, name_len, NULL, NULL);
+	ret = find_xattr(sctx->send_root, sctx->left_path, sctx->cmp_key,
+			 name, name_len, NULL, NULL);
 	if (ret == -ENOENT)
 		ret = __process_deleted_xattr(num, di_key, name, name_len, data,
 				data_len, type, ctx);
@@ -3523,11 +3515,11 @@ static int process_changed_xattr(struct send_ctx *sctx)
 {
 	int ret = 0;
 
-	ret = iterate_dir_item(sctx, sctx->send_root, sctx->left_path,
+	ret = iterate_dir_item(sctx->send_root, sctx->left_path,
 			sctx->cmp_key, __process_changed_new_xattr, sctx);
 	if (ret < 0)
 		goto out;
-	ret = iterate_dir_item(sctx, sctx->parent_root, sctx->right_path,
+	ret = iterate_dir_item(sctx->parent_root, sctx->right_path,
 			sctx->cmp_key, __process_changed_deleted_xattr, sctx);
 
 out:
@@ -3572,8 +3564,8 @@ static int process_all_new_xattrs(struct send_ctx *sctx)
 			goto out;
 		}
 
-		ret = iterate_dir_item(sctx, root, path, &found_key,
-				__process_new_xattr, sctx);
+		ret = iterate_dir_item(root, path, &found_key,
+				       __process_new_xattr, sctx);
 		if (ret < 0)
 			goto out;
 
@@ -3598,7 +3590,7 @@ static int send_write(struct send_ctx *sctx, u64 offset, u32 len)
 	int num_read = 0;
 	mm_segment_t old_fs;
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -3640,7 +3632,7 @@ verbose_printk("btrfs: send_write offset=%llu, len=%d\n", offset, len);
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	set_fs(old_fs);
 	if (ret < 0)
 		return ret;
@@ -3663,7 +3655,7 @@ verbose_printk("btrfs: send_clone offset=%llu, len=%d, clone_root=%llu, "
 		clone_root->root->objectid, clone_root->ino,
 		clone_root->offset);
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -3686,8 +3678,7 @@ verbose_printk("btrfs: send_clone offset=%llu, len=%d, clone_root=%llu, "
 			goto out;
 		ret = get_cur_path(sctx, clone_root->ino, gen, p);
 	} else {
-		ret = get_inode_path(sctx, clone_root->root,
-				clone_root->ino, p);
+		ret = get_inode_path(clone_root->root, clone_root->ino, p);
 	}
 	if (ret < 0)
 		goto out;
@@ -3704,7 +3695,7 @@ verbose_printk("btrfs: send_clone offset=%llu, len=%d, clone_root=%llu, "
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
@@ -3717,7 +3708,7 @@ static int send_update_extent(struct send_ctx *sctx,
 	int ret = 0;
 	struct fs_path *p;
 
-	p = fs_path_alloc(sctx);
+	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
 
@@ -3737,7 +3728,7 @@ static int send_update_extent(struct send_ctx *sctx,
 
 tlv_put_failure:
 out:
-	fs_path_free(sctx, p);
+	fs_path_free(p);
 	return ret;
 }
 
-- 
1.8.2.2

