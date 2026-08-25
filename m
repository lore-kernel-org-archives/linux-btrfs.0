Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25F433B97B;
	Tue, 25 Aug 2026 16:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673899; cv=none; b=hKx3LIzVeQMyNvLds6Tmc3g4fQGm/1pAnMqMZyALNQIMHUAm6mHT0d4RSgE0ZnQAXCVVfR585BLkPVYNkALXMaDtREOdUDjjfJv3BPzZWUEing9WvDN1k8CVl0E81h0N31tn+EmHEfIZB/yJYk/Ykt1Gglp30rBFFMOrERDtUVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673899; c=relaxed/simple;
	bh=2+jFO/P3BGcWQvUFK4ldginqeIuydNFf7qjazms8PEo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=AuW0AGuAKqnn7YsmvXF3Iw3Zkkl5tGEgu8/UGHM6NoR+qtGsIyhRQCkPrSHbvmrlFKsAC1Ui9jXKLoeCHeDoBAFzHUQS39L3/A7yFC1rD8ANXJfWLs9FbigsIi4K1yibKw6I6UCiXqgt1hufguKJQLppUumUsBvqyCPJgQKtjRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ePKUg6/A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ePKUg6/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3001F00A3D;
	Tue, 25 Aug 2026 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673897;
	bh=3mntvJAHhytu5viFQowYsbS7QVsCCWaixajcjCeZSQw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ePKUg6/APGCFmXCpoGy72o/ErmD0SH8XyliuRmlaRVZ6piO4Xz54L04rev0E7MzFh
	 KMQwG6ZgoWaSnSHv90/xbF8rvxdh5p8tRXd5FRIksVtEoi346S8ifde9E6skQG/FZz
	 FlkoUAPP/4aCnBb8t+PezsNk7rpL1cQJoG9blTps8gNpVZVkUWtvWYPOXui3pMSAD0
	 I3XndnJklNFSCX2sErQwF8jE1Yjr1lKkWlmgskyIThLxyKqGY3QX91XOuxSKp/XbR9
	 Fkvb5Pc8Bz7L1kU8pMlYFYvz9LyOaDCtL7Qrw+Gu7TkeF13FiauaonprXN2UcujzAo
	 3PzzZIWSkHEpw==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 25 Aug 2026 12:04:17 -0400
Subject: [PATCH v4 1/4] btrfs: split btrfs_insert_delayed_dir_index() into
 prealloc and commit phases
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-btrfs-enomem-v4-1-b9363fa8714a@kernel.org>
References: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
In-Reply-To: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=9478; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=2+jFO/P3BGcWQvUFK4ldginqeIuydNFf7qjazms8PEo=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqjb0n7nNMqp9kQBxVhe/4LQp7Cmk01ny/ons1l
 jNybCq3APyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCao29JwAKCRAADmhBGVaC
 Fb4+EACRATjRSXmGLABGFbyLMS/zJQv2Vn2Ju6nXBHFtrKkIvwG3TEcavZ14sg2SK40KeQ2sXI/
 PNjaKpiexrTmQXJn4yib8tm8SXenG80VsFz7cKztvkMA42MTXN/YoZWgHLXxbfzpkEuXRVqOyoU
 ygd7VtCDR0cfHdTSMdp7HmhAFZXu7OeVIFZzpj1NVa32kLLJCkIna2Evb5bLsJEBmhF3cHkD3UC
 nWj6YLyo+eOWAL24RG+qbqfhzwNqXoOXPHEoWUkmnU2QrOf3QiSGNVVGnusg4irw73dtD76c8io
 rdDbE828BAmykM70iF20tnIDLivpqNyDIxtEoV9iPo0B811QH0SfFQ3QHqRJtG/O8jeufiqH/Wi
 GRTlFSniZBi9uyjR9SGzWwRXp9I2DQIQ2V7BLGEm0Xbd/kiJRXP2RaJB5oMQyXFM+JS7VmiREXY
 +hDYqcXw+7CfroZ7oeJpzlUXKb73keGc0JYdhBTI7AeYKFnLB2eVQktsB8Lp65XWXalXrEwS387
 XvpYE5//WltUQJtPo3/0WgZmJADjz+3wNz/8bNLDvOeo4QippqyF1EEFvDbPT9qukPl4wTpeOu2
 7qpTQ2Fasm+qog6viQjKKVhjjSvOfonmDBcxa6RVzzjDs+m1qNDecY/a5zqsDJtatP3PwaNbQLc
 uK3CMadgYJMoDoQ==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Split btrfs_insert_delayed_dir_index() into three functions using a new
btrfs_dir_index_prealloc struct to bundle the pre-allocated resources:

- btrfs_prealloc_delayed_dir_index(): allocates the struct and performs
  the two GFP_NOFS allocations (delayed node + delayed item) that can
  fail with -ENOMEM. Returns the struct, or ERR_PTR on failure.
- btrfs_insert_delayed_dir_index_prealloc(): populates the item data,
  inserts into the rb-tree, and reserves metadata space. Cannot fail
  with -ENOMEM since all allocations were done in the prealloc step.
- btrfs_free_delayed_dir_index_prealloc(): frees pre-allocated
  resources when the caller's btree insertion fails. Tolerates NULL.

The prealloc is returned as a pointer rather than filled into a
caller-provided struct, so that a plain NULL means "no prealloc" and
callers do not need a separate flag to track whether one exists. It is
consumed (and freed) by either the commit or the free helper, so
ownership is unambiguous.

The original btrfs_insert_delayed_dir_index() is refactored into a thin
wrapper that calls the prealloc and commit functions.

This split allows callers to move the fallible memory allocations before
the point of no return (the DIR_ITEM btree insertion), so that -ENOMEM
can be returned cleanly without aborting the transaction.

Assisted-by: LLM
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/delayed-inode.c | 128 ++++++++++++++++++++++++++++++++++++++---------
 fs/btrfs/delayed-inode.h |  17 +++++++
 2 files changed, 121 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index db2ffab0941a..af5e6dbf60d3 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -6,6 +6,7 @@
 
 #include <linux/slab.h>
 #include <linux/iversion.h>
+#include <linux/error-injection.h>
 #include "ctree.h"
 #include "fs.h"
 #include "messages.h"
@@ -1469,35 +1470,93 @@ static void btrfs_release_dir_index_item_space(struct btrfs_trans_handle *trans)
 	trans->bytes_reserved -= bytes;
 }
 
-/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
-int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   const char *name, int name_len,
-				   struct btrfs_inode *dir,
-				   const struct btrfs_disk_key *disk_key, u8 flags,
-				   u64 index)
+/*
+ * Pre-allocate a delayed node and delayed item for a dir index insertion and
+ * copy the name into the item. Call this before modifying the btree so that
+ * ENOMEM can be returned before any on-disk state has changed.
+ *
+ * The returned prealloc is consumed by either
+ * btrfs_insert_delayed_dir_index_prealloc() or
+ * btrfs_free_delayed_dir_index_prealloc(); it must not be used afterwards.
+ *
+ * Returns a prealloc on success, ERR_PTR on allocation failure.
+ */
+struct btrfs_dir_index_prealloc *btrfs_prealloc_delayed_dir_index(struct btrfs_inode *dir,
+								  const char *name,
+								  int name_len)
+{
+	struct btrfs_dir_index_prealloc *prealloc;
+	struct btrfs_delayed_node *node;
+	struct btrfs_delayed_item *item;
+
+	prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
+	if (!prealloc)
+		return ERR_PTR(-ENOMEM);
+
+	node = btrfs_get_or_create_delayed_node(dir, &prealloc->tracker);
+	if (IS_ERR(node)) {
+		kfree(prealloc);
+		return ERR_CAST(node);
+	}
+
+	item = btrfs_alloc_delayed_item(sizeof(struct btrfs_dir_item) + name_len,
+					node, BTRFS_DELAYED_INSERTION_ITEM);
+	if (!item) {
+		btrfs_release_delayed_node(node, &prealloc->tracker);
+		kfree(prealloc);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	memcpy(item->data + sizeof(struct btrfs_dir_item), name, name_len);
+
+	prealloc->node = node;
+	prealloc->item = item;
+	return prealloc;
+}
+ALLOW_ERROR_INJECTION(btrfs_prealloc_delayed_dir_index, ERRNO);
+
+/*
+ * Free resources from btrfs_prealloc_delayed_dir_index() when the btree
+ * insertion failed and we will not commit the delayed dir index. Does nothing
+ * if @prealloc is NULL.
+ */
+void btrfs_free_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
+					   struct btrfs_dir_index_prealloc *prealloc)
 {
+	if (!prealloc)
+		return;
+
+	btrfs_release_delayed_item(prealloc->item);
+	btrfs_release_dir_index_item_space(trans);
+	btrfs_release_delayed_node(prealloc->node, &prealloc->tracker);
+	kfree(prealloc);
+}
+
+/*
+ * Commit a pre-allocated delayed dir index item. @prealloc must have been
+ * returned by btrfs_prealloc_delayed_dir_index(). This populates the item,
+ * adds it to the delayed node's rb-tree, and reserves metadata space. It
+ * cannot fail with ENOMEM. @prealloc is freed here in all cases.
+ *
+ * Will return 0 or -EEXIST (index number collision, unexpected).
+ */
+int btrfs_insert_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
+					    struct btrfs_inode *dir,
+					    struct btrfs_dir_index_prealloc *prealloc,
+					    const struct btrfs_disk_key *disk_key,
+					    u8 flags, u64 index)
+{
+	struct btrfs_delayed_node *delayed_node = prealloc->node;
+	struct btrfs_ref_tracker *tracker = &prealloc->tracker;
+	struct btrfs_delayed_item *delayed_item = prealloc->item;
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	const unsigned int leaf_data_size = BTRFS_LEAF_DATA_SIZE(fs_info);
-	struct btrfs_delayed_node *delayed_node;
-	struct btrfs_ref_tracker delayed_node_tracker;
-	struct btrfs_delayed_item *delayed_item;
+	const int name_len = delayed_item->data_len - sizeof(struct btrfs_dir_item);
 	struct btrfs_dir_item *dir_item;
 	bool reserve_leaf_space;
 	u32 data_len;
 	int ret;
 
-	delayed_node = btrfs_get_or_create_delayed_node(dir, &delayed_node_tracker);
-	if (IS_ERR(delayed_node))
-		return PTR_ERR(delayed_node);
-
-	delayed_item = btrfs_alloc_delayed_item(sizeof(*dir_item) + name_len,
-						delayed_node,
-						BTRFS_DELAYED_INSERTION_ITEM);
-	if (!delayed_item) {
-		ret = -ENOMEM;
-		goto release_node;
-	}
-
 	delayed_item->index = index;
 
 	dir_item = (struct btrfs_dir_item *)delayed_item->data;
@@ -1506,7 +1565,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_dir_data_len(dir_item, 0);
 	btrfs_set_stack_dir_name_len(dir_item, name_len);
 	btrfs_set_stack_dir_flags(dir_item, flags);
-	memcpy((char *)(dir_item + 1), name, name_len);
+	/* Name was already copied by btrfs_prealloc_delayed_dir_index(). */
 
 	data_len = delayed_item->data_len + sizeof(struct btrfs_item);
 
@@ -1524,7 +1583,9 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	if (unlikely(ret)) {
 		btrfs_err(trans->fs_info,
 "error adding delayed dir index item, name: %.*s, index: %llu, root: %llu, dir: %llu, dir->index_cnt: %llu, delayed_node->index_cnt: %llu, error: %pe",
-			  name_len, name, index, btrfs_root_id(delayed_node->root),
+			  name_len,
+			  (const char *)(dir_item + 1),
+			  index, btrfs_root_id(delayed_node->root),
 			  delayed_node->inode_id, dir->index_cnt,
 			  delayed_node->index_cnt, ERR_PTR(ret));
 		btrfs_release_delayed_item(delayed_item);
@@ -1562,10 +1623,29 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_unlock(&delayed_node->mutex);
 
 release_node:
-	btrfs_release_delayed_node(delayed_node, &delayed_node_tracker);
+	/* Must release the node before freeing @tracker's containing struct. */
+	btrfs_release_delayed_node(delayed_node, tracker);
+	kfree(prealloc);
 	return ret;
 }
 
+/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
+int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   const char *name, int name_len,
+				   struct btrfs_inode *dir,
+				   const struct btrfs_disk_key *disk_key, u8 flags,
+				   u64 index)
+{
+	struct btrfs_dir_index_prealloc *prealloc;
+
+	prealloc = btrfs_prealloc_delayed_dir_index(dir, name, name_len);
+	if (IS_ERR(prealloc))
+		return PTR_ERR(prealloc);
+
+	return btrfs_insert_delayed_dir_index_prealloc(trans, dir, prealloc,
+						       disk_key, flags, index);
+}
+
 static bool btrfs_delete_delayed_insertion_item(struct btrfs_delayed_node *node,
 						u64 index)
 {
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index fc752863f89b..6d12a145489f 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -121,6 +121,23 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   const struct btrfs_disk_key *disk_key, u8 flags,
 				   u64 index);
 
+struct btrfs_dir_index_prealloc {
+	struct btrfs_delayed_node *node;
+	struct btrfs_ref_tracker tracker;
+	struct btrfs_delayed_item *item;
+};
+
+struct btrfs_dir_index_prealloc *btrfs_prealloc_delayed_dir_index(struct btrfs_inode *dir,
+								  const char *name,
+								  int name_len);
+void btrfs_free_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
+					   struct btrfs_dir_index_prealloc *prealloc);
+int btrfs_insert_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
+					    struct btrfs_inode *dir,
+					    struct btrfs_dir_index_prealloc *prealloc,
+					    const struct btrfs_disk_key *disk_key,
+					    u8 flags, u64 index);
+
 int btrfs_delete_delayed_dir_index(struct btrfs_trans_handle *trans,
 				   struct btrfs_inode *dir, u64 index);
 

-- 
2.55.0

