Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BB14446ED;
	Tue,  4 Aug 2026 15:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858293; cv=none; b=V01J8WLvPS7zWtGeSDz4crZd9F6cnwDflREooq4oVIpQeEyzQNf7FgBNpev3SHAi1a2mUFRu9fcS+nU7uqynf0rDYQOmz+uRImeLULB0wFgmm1trb3cHY2t6AoZiB4vs6EyRNtoEJ1+hJrpc17bh4IHLmkZp6Gyp6WV3PqjeZBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858293; c=relaxed/simple;
	bh=SesH10CprPHiL4F/9NJfV1Bwr2tG3coz+xIULq2gPBA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fv4CYmneSTS3o0cjis2VcUR49eI2K+Y7AN7Mt8B8iQCDDeD+Ec6k8VbCJrLMRbTU8AioTVF7HrRTqN5M4i60PU5pjRjBC9yZCjFFWfvqTnrh6F1sSgYGHPu7ujMqnVwlxgTCigSu/F7W+zHj60zkk+/WzEwEnEyclXyw6t9yqNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fe1nhBYM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fe1nhBYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09531F00A3E;
	Tue,  4 Aug 2026 15:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785858290;
	bh=Xrv4R7OK6OePmDuDYMrX2WVaMn0ORsRTONpLfBbBmUs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Fe1nhBYMEqA5LBa5/n4N8W9GuoclwIalM8PdmL1IblmnKQKnXHqD42VwgV9xj3Yvs
	 P09JEtSqrXYZrgDmGCbI1V8vmsaHneC0GA6mWTKmBV3TLow8VlG1LaOLJ/Z4Qu2oyN
	 ERNAb+fxgGS5kXX6Xo/JBY9XoQqEJGB4GgW1yX35tuyk6mC8WI0nTqluYqcaW1A1mx
	 E0aqpPUlpriuL5PugTsaSNBnWsdAUxfUazjQSJnLdoWMszho+WN8ytORxxp2xcI5lA
	 AD/KF+f/qDnehQM4Lrbl4tJu4gQ5Jn9jiqOVQwVQHGDT8ndjb7npArO947C7VvIgfn
	 v86HechtTTSpQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 04 Aug 2026 11:44:34 -0400
Subject: [PATCH v2 2/5] btrfs: split btrfs_insert_delayed_dir_index() into
 prealloc and commit phases
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-btrfs-enomem-v2-2-4d923170e8c1@kernel.org>
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
In-Reply-To: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8441; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=SesH10CprPHiL4F/9NJfV1Bwr2tG3coz+xIULq2gPBA=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqcgjvA98ApuCVPY+vI5gP4js3uCo2AMP39insN
 mNR0/ESACSJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCanII7wAKCRAADmhBGVaC
 Fcx5D/9jaYk1xeuMk4JBq+0LkunOypeeIisfkyHRi6b1Lf4QJStxqeeM+Es96REIsK295q61GqN
 oGqi1Tt43OPZAe4MLifUVaO5x31Htd/8ajlycNGejWc6d3tQ7C+bMdfJhVpoB9KD7Zb1ujIU6Jp
 KfrDG0CaFOegnmGWKq41CTC4vfFC8in2r9NFTCg4ChW5WMpK0IQPKh27vKbIDLSj6ed/vPlNsaa
 wgOaHXgvI7BoSbv9WZPYG0zmf86puFn3iRKnm87umvaCRW/VEj/Qqz8SQb2Sdhu+vsrKgE1Mjd6
 nk28iFJp665+ADvw0BsVjQsKVNflE0CB521DwsbNL91PVRUpRrAFz2RfjPsNmo51MCnL2jqnxl0
 iedsxvPy1ok9Sz1aTjvAc8HlK1osQe1gGUi7joWVn3ylkx7p9hHAg1zYlNETKDiKlb5OW888mXp
 wW2cl/IWGpO0ApIau7Dz/PcxoWOUidULQGt9PhqsMZWiWBy40tvTGOiQ+Va/Krpc1wN83zQbkoO
 ffn2x0Dt+BwMfpcy75jxI/Tt3y1tqFdnCDvy/KuU1y8V0Hq2AwN0Sb937Ux2r60JmaHck788i1W
 1v+RiiQi5egXSEBq69dKPz8yWVtsnekkL5+AXWwSp4u/cHf17TGpksQTrioj62UUp5Uvl7MSYEC
 ds3OjAsYsI+qsCw==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Split btrfs_insert_delayed_dir_index() into three functions using a new
btrfs_dir_index_prealloc struct to bundle the pre-allocated resources:

- btrfs_prealloc_delayed_dir_index(): performs the two GFP_NOFS
  allocations (delayed node + delayed item) that can fail with -ENOMEM.
- btrfs_insert_delayed_dir_index_prealloc(): populates the item data,
  inserts into the rb-tree, and reserves metadata space. Cannot fail
  with -ENOMEM since all allocations were done in the prealloc step.
- btrfs_free_delayed_dir_index_prealloc(): frees pre-allocated
  resources when the caller's btree insertion fails.

The original btrfs_insert_delayed_dir_index() is refactored into a thin
wrapper that calls the prealloc and commit functions.

This split allows callers to move the fallible memory allocations before
the point of no return (the DIR_ITEM btree insertion), so that -ENOMEM
can be returned cleanly without aborting the transaction.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/delayed-inode.c | 111 +++++++++++++++++++++++++++++++++++++----------
 fs/btrfs/delayed-inode.h |  17 ++++++++
 2 files changed, 104 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index db2ffab0941a..95d2dca80444 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -6,6 +6,7 @@
 
 #include <linux/slab.h>
 #include <linux/iversion.h>
+#include <linux/error-injection.h>
 #include "ctree.h"
 #include "fs.h"
 #include "messages.h"
@@ -1469,35 +1470,74 @@ static void btrfs_release_dir_index_item_space(struct btrfs_trans_handle *trans)
 	trans->bytes_reserved -= bytes;
 }
 
-/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
-int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   const char *name, int name_len,
-				   struct btrfs_inode *dir,
-				   const struct btrfs_disk_key *disk_key, u8 flags,
-				   u64 index)
+/*
+ * Pre-allocate a delayed node and delayed item for a dir index insertion.
+ * Call this before modifying the btree so that ENOMEM can be returned
+ * before any on-disk state has changed.
+ *
+ * Returns 0 on success, -ENOMEM on allocation failure.
+ */
+int btrfs_prealloc_delayed_dir_index(struct btrfs_inode *dir,
+				     const char *name, int name_len,
+				     struct btrfs_dir_index_prealloc *prealloc)
+{
+	struct btrfs_delayed_node *node;
+	struct btrfs_delayed_item *item;
+
+	node = btrfs_get_or_create_delayed_node(dir, &prealloc->tracker);
+	if (IS_ERR(node))
+		return PTR_ERR(node);
+
+	item = btrfs_alloc_delayed_item(sizeof(struct btrfs_dir_item) + name_len,
+					node, BTRFS_DELAYED_INSERTION_ITEM);
+	if (!item) {
+		btrfs_release_delayed_node(node, &prealloc->tracker);
+		return -ENOMEM;
+	}
+
+	prealloc->node = node;
+	prealloc->item = item;
+	return 0;
+}
+ALLOW_ERROR_INJECTION(btrfs_prealloc_delayed_dir_index, ERRNO);
+
+/*
+ * Free resources from btrfs_prealloc_delayed_dir_index() when the btree
+ * insertion failed and we will not commit the delayed dir index.
+ */
+void btrfs_free_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
+					   struct btrfs_dir_index_prealloc *prealloc)
 {
+	btrfs_release_delayed_item(prealloc->item);
+	btrfs_release_dir_index_item_space(trans);
+	btrfs_release_delayed_node(prealloc->node, &prealloc->tracker);
+}
+
+/*
+ * Commit a pre-allocated delayed dir index item. The delayed node and item
+ * must have been returned by btrfs_prealloc_delayed_dir_index(). This
+ * populates the item, adds it to the delayed node's rb-tree, and reserves
+ * metadata space. It cannot fail with ENOMEM.
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
@@ -1506,7 +1546,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_dir_data_len(dir_item, 0);
 	btrfs_set_stack_dir_name_len(dir_item, name_len);
 	btrfs_set_stack_dir_flags(dir_item, flags);
-	memcpy((char *)(dir_item + 1), name, name_len);
+	/* Name was already copied into delayed_item->data by the caller. */
 
 	data_len = delayed_item->data_len + sizeof(struct btrfs_item);
 
@@ -1524,7 +1564,9 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
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
@@ -1562,10 +1604,31 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	mutex_unlock(&delayed_node->mutex);
 
 release_node:
-	btrfs_release_delayed_node(delayed_node, &delayed_node_tracker);
+	btrfs_release_delayed_node(delayed_node, tracker);
 	return ret;
 }
 
+/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
+int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
+				   const char *name, int name_len,
+				   struct btrfs_inode *dir,
+				   const struct btrfs_disk_key *disk_key, u8 flags,
+				   u64 index)
+{
+	struct btrfs_dir_index_prealloc prealloc;
+	int ret;
+
+	ret = btrfs_prealloc_delayed_dir_index(dir, name, name_len, &prealloc);
+	if (ret)
+		return ret;
+
+	memcpy(prealloc.item->data + sizeof(struct btrfs_dir_item), name,
+	       name_len);
+
+	return btrfs_insert_delayed_dir_index_prealloc(trans, dir, &prealloc,
+						       disk_key, flags, index);
+}
+
 static bool btrfs_delete_delayed_insertion_item(struct btrfs_delayed_node *node,
 						u64 index)
 {
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index fc752863f89b..e310a257c9a6 100644
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
+int btrfs_prealloc_delayed_dir_index(struct btrfs_inode *dir,
+				     const char *name, int name_len,
+				     struct btrfs_dir_index_prealloc *prealloc);
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

