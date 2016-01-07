Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49498 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422AbcAGBIr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jan 2016 20:08:47 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (unknown [10.167.33.83])
	by cn.fujitsu.com (Postfix) with ESMTP id 9725141887DE
	for <linux-btrfs@vger.kernel.org>; Thu,  7 Jan 2016 09:08:26 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Subject: [PATCH v3 13/16] btrfs: dedup: Add support for on-disk hash search
Date: Thu, 7 Jan 2016 09:08:14 +0800
Message-ID: <1452128897-5433-14-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
References: <1452128897-5433-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Now on-disk backend should be able to search hash now.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
v2:
  Newly introduced
v3:
  None
---
 fs/btrfs/dedup.c | 169 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/dedup.h |   3 +
 2 files changed, 171 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/dedup.c b/fs/btrfs/dedup.c
index 5edb923..4bcdf5d 100644
--- a/fs/btrfs/dedup.c
+++ b/fs/btrfs/dedup.c
@@ -493,6 +493,172 @@ int btrfs_dedup_disable(struct btrfs_fs_info *fs_info)
 }
 
 /*
+ * Return 0 for not found
+ * Return >0 for found and set bytenr_ret
+ * Return <0 for error
+ */
+static int ondisk_search_hash(struct btrfs_dedup_info *dedup_info, u8 *hash,
+			      u64 *bytenr_ret, u64 *num_bytes_ret)
+{
+	struct btrfs_path *path;
+	struct btrfs_key key;
+	struct btrfs_root *dedup_root = dedup_info->dedup_root;
+	u8 *buf = NULL;
+	u64 hash_key;
+	int hash_len = btrfs_dedup_sizes[dedup_info->hash_type];
+	int ret;
+
+	path = btrfs_alloc_path();
+	if (!path)
+		return -ENOMEM;
+
+	buf = kmalloc(hash_len, GFP_NOFS);
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	memcpy(&hash_key, hash + hash_len - 8, 8);
+	key.objectid = hash_key;
+	key.type = BTRFS_DEDUP_HASH_ITEM_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, dedup_root, &key, path, 0, 0);
+	if (ret < 0)
+		goto out;
+	WARN_ON(ret == 0);
+	while (1) {
+		struct extent_buffer *node;
+		struct btrfs_dedup_hash_item *hash_item;
+		int slot;
+
+		ret = btrfs_previous_item(dedup_root, path, hash_key,
+					  BTRFS_DEDUP_HASH_ITEM_KEY);
+		if (ret < 0)
+			goto out;
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+
+		node = path->nodes[0];
+		slot = path->slots[0];
+		btrfs_item_key_to_cpu(node, &key, slot);
+
+		if (key.type != BTRFS_DEDUP_HASH_ITEM_KEY ||
+		    memcmp(&key.objectid, hash + hash_len - 8, 8))
+			break;
+		hash_item = btrfs_item_ptr(node, slot,
+				struct btrfs_dedup_hash_item);
+		read_extent_buffer(node, buf, (unsigned long)(hash_item + 1),
+				   hash_len);
+		if (!memcmp(buf, hash, hash_len)) {
+			ret = 1;
+			*bytenr_ret = key.offset;
+			*num_bytes_ret = btrfs_dedup_hash_len(node, hash_item);
+			break;
+		}
+	}
+out:
+	kfree(buf);
+	btrfs_free_path(path);
+	return ret;
+}
+
+static int ondisk_search(struct inode *inode, u64 file_pos,
+			 struct btrfs_dedup_hash *hash)
+{
+	int ret;
+	struct btrfs_root *root = BTRFS_I(inode)->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct btrfs_trans_handle *trans = NULL;
+	struct btrfs_delayed_ref_root *delayed_refs;
+	struct btrfs_delayed_ref_head *head;
+	struct btrfs_dedup_info *dedup_info = fs_info->dedup_info;
+	u64 old_bytenr;
+	u64 bytenr;
+	u64 num_bytes;
+
+	/*
+	 * TODO: Opitmized the superhot mutex.
+	 */
+	mutex_lock(&dedup_info->ondisk_lock);
+	ret = ondisk_search_hash(dedup_info, hash->hash, &bytenr, &num_bytes);
+	mutex_unlock(&dedup_info->ondisk_lock);
+	if (ret <= 0)
+		goto out;
+
+	trans = btrfs_join_transaction(root);
+	if (IS_ERR(trans))
+		return PTR_ERR(trans);
+
+again:
+	delayed_refs = &trans->transaction->delayed_refs;
+
+	spin_lock(&delayed_refs->lock);
+	head = btrfs_find_delayed_ref_head(trans, bytenr);
+	if (!head || head->processing == 1) {
+		/*
+		 * Somebody else may be trying to run the refs, the found
+		 * duplicated extent may be freed, so here we just
+		 * choose to abort this dedup handle.
+		 * XXX: we need to find a better method to improve it.
+		 */
+		spin_unlock(&delayed_refs->lock);
+		ret = 0;
+		goto out;
+	}
+
+	ret = btrfs_delayed_ref_lock(trans, head);
+	spin_unlock(&delayed_refs->lock);
+	if (ret == -EAGAIN) {
+		mutex_lock(&dedup_info->ondisk_lock);
+		ret = ondisk_search_hash(dedup_info, hash->hash, &bytenr,
+					 &num_bytes);
+		mutex_unlock(&dedup_info->ondisk_lock);
+		if (ret <= 0)
+			goto out;
+		goto again;
+	}
+	/*
+	 * Still need to search the hash again to ensure the hash is not
+	 * deleted in run_delayed_refs
+	 */
+	old_bytenr = bytenr;
+	mutex_lock(&dedup_info->ondisk_lock);
+	ret = ondisk_search_hash(dedup_info, hash->hash, &bytenr, &num_bytes);
+	if (ret <= 0) {
+		mutex_unlock(&dedup_info->ondisk_lock);
+		mutex_unlock(&head->mutex);
+		goto out;
+	}
+
+	/* bytenr changed, we need to relock the delayed_ref head */
+	if (old_bytenr != bytenr) {
+		mutex_unlock(&dedup_info->ondisk_lock);
+		mutex_unlock(&head->mutex);
+		goto again;
+	}
+
+	/*
+	 * finally, we found the matching hash, increase extent ref right now
+	 * to avoid delayed ref run it
+	 */
+	btrfs_inc_extent_ref(trans, root, bytenr, num_bytes, 0,
+			     root->root_key.objectid,
+			     btrfs_ino(inode), file_pos);
+	hash->bytenr = bytenr;
+	hash->num_bytes = num_bytes;
+	mutex_unlock(&dedup_info->ondisk_lock);
+	mutex_unlock(&head->mutex);
+	ret = 1;
+out:
+	if (trans)
+		btrfs_end_transaction(trans, root);
+	return ret;
+}
+
+/*
  * Caller must ensure the corresponding ref head is not being run.
  */
 static struct inmem_hash *
@@ -646,7 +812,8 @@ int btrfs_dedup_search(struct inode *inode, u64 file_pos,
 
 	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_INMEMORY)
 		ret = inmem_search(inode, file_pos, hash);
-
+	if (dedup_info->backend == BTRFS_DEDUP_BACKEND_ONDISK)
+		ret = ondisk_search(inode, file_pos, hash);
 	/* It's possible hash->bytenr/num_bytenr already changed */
 	if (ret == 0) {
 		hash->num_bytes = 0;
diff --git a/fs/btrfs/dedup.h b/fs/btrfs/dedup.h
index 0503b98..03cc818 100644
--- a/fs/btrfs/dedup.h
+++ b/fs/btrfs/dedup.h
@@ -138,6 +138,9 @@ int btrfs_dedup_calc_hash(struct btrfs_root *root, struct inode *inode,
  * Return > 0 for a hash match, and the extent ref will be
  * INCREASED.
  * Return 0 for a hash miss. Nothing is done
+ * Return <0 for error.
+ *
+ * Only on-disk backedn may return error though.
  */
 int btrfs_dedup_search(struct inode *inode, u64 file_pos,
 		       struct btrfs_dedup_hash *hash);
-- 
2.6.4



