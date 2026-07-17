Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B71344D92;
	Fri, 17 Jul 2026 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307187; cv=none; b=S02RuQHegBLDGkouxTvA5OfEme2BxEPPQDrH/pyDPCP2k2DSJBFlhoAnLZGyIIi5H+rOmyAlvhAitpbtrgeg/WOl6YoYuoOlJRr7UIWm71wSgAj1jYJd7Ua74bIpf7MoeRZxrFDNEM/otjJ5bfOQ8t37FU0bKb8HNpnn6ZhhiRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307187; c=relaxed/simple;
	bh=NdKAuaLuNewy/k63oi5OEDmdnoEMQaYx06SVbYpFGMs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mAkw7VhP5UIs7NWo6ItL0dRbF7MfRgeDDuOCbw6U29qLOsndabsKwY6bwFikpw2fuSxzEC2r82+FzQk7qVYlWht3cNbRuyJ9WiKbkMHZe8iuZilDQBiQcmdlRffvWZN8abIfojM+HQsG6Ij1LUBemfTWrBerw0CotH7Ua6hYFrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHy4Gst6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHy4Gst6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E176C1F00A3D;
	Fri, 17 Jul 2026 16:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307186;
	bh=chNnEUS4ou1ewRr5tiT5ffA/oK+d9tifbMacz+ARlPk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VHy4Gst6qim3PoxXrlkcQdv8iWEI+CusiRKKwfSlfYoFTJADPluWZJgku9QUd25RC
	 NU4b+RKNSF8Va+qCTLaFpKWu3GeJzEDLBenMLMkRMn7qaek841qELSrB75W9+C5rsp
	 oBPIhv74YRu2HE8cbVppPdeMhZJAecythOxT1omH/P0zxmLy03t16wCTZWlaim6cT9
	 H6yaMInFUS9KaW9vBDTtcAzB6rPtozGpP8PcI715MXxP8rcH3Op7vYYVEoUZdCpwuv
	 EUcsadqaXtUA8bg383nn5LPz7iuNqFb+0laZB1iRUMyA7i22zYPPj6QaLe0eRDMkDs
	 qsebzJ20TadPA==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 17 Jul 2026 12:52:36 -0400
Subject: [PATCH 1/4] btrfs: split btrfs_insert_delayed_dir_index() into
 prealloc and commit phases
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-btrfs-enomem-v1-1-cdc9c0e265d0@kernel.org>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
In-Reply-To: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@fb.com, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8189; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=NdKAuaLuNewy/k63oi5OEDmdnoEMQaYx06SVbYpFGMs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqWl3v52jA/vgS/n1Zp/BrUG7LRkB+sl0A1/Sux
 tNzRRNxxOGJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCalpd7wAKCRAADmhBGVaC
 FUPgD/sE0B06KoUGFgIf1v3+epAUTW+I77MhDtYEQG+9+4Lhg2570qhxGOm0TkHInX3VuM+vV7V
 PkPxaDKdq8/WarpnPx3v2tLdYf4TDlo8W1pBASqn24E1bUzzME05eOnT0uidbEiuNkIJ4nnI0as
 9YBTzs8uXPrNGzM6sWzDnW8E2Bn8mijePQls/yOpa38izfJMWwIuTSDpBNCWMme8arGC613y6EO
 AaXpoF3Jn7D40EiRDMC/1/c438LyqsX154ssywq+GpySiBshAPXq92ZiF8LgiV4qSrB6wEWMX44
 o9mkz3bLpRA8v3BqsrPkpFwJ80TEa90iWVUl7zss7ZQqoVX5WWjdvwI5MIVD4n3qEKH29y6SJre
 XA8rGPHBV+PXf/rjF/1ybMSMT/HbbP0XJN31dx0CXAKLVumMb12NkucROfuyqkR3o2Rdk8BQJEh
 Omdli/hRxpHQLy7zdPGgDkaj4UrR0wVmrNxLx6llKriC4IIh4Ls19Bkq1tXO1/mo0xjW8npMZ1r
 M9Wkbd6t5wH04icpF0lBHuoQ0MFNZwf/KzN0RtcQtusStUgGw/lFfV9cYi/d4/GoVsnIpb0Lf39
 nartylHWS91Kaxlzr72AGdqVL3vKkb2ssAkSu6sR7GUa2c07or3JeFTZK/GlEZotZN5L9aOa0jl
 /0rYlVk+csJ5GUg==
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
 fs/btrfs/delayed-inode.c | 109 ++++++++++++++++++++++++++++++++++++-----------
 fs/btrfs/delayed-inode.h |  17 ++++++++
 2 files changed, 102 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 09795439b9fb..9d7343934eea 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1469,35 +1469,73 @@ static void btrfs_release_dir_index_item_space(struct btrfs_trans_handle *trans)
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
@@ -1506,7 +1544,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_dir_data_len(dir_item, 0);
 	btrfs_set_stack_dir_name_len(dir_item, name_len);
 	btrfs_set_stack_dir_flags(dir_item, flags);
-	memcpy((char *)(dir_item + 1), name, name_len);
+	/* Name was already copied into delayed_item->data by the caller. */
 
 	data_len = delayed_item->data_len + sizeof(struct btrfs_item);
 
@@ -1524,7 +1562,9 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
 	if (unlikely(ret)) {
 		btrfs_err(trans->fs_info,
 "error adding delayed dir index item, name: %.*s, index: %llu, root: %llu, dir: %llu, dir->index_cnt: %llu, delayed_node->index_cnt: %llu, error: %d",
-			  name_len, name, index, btrfs_root_id(delayed_node->root),
+			  name_len,
+			  (const char *)(dir_item + 1),
+			  index, btrfs_root_id(delayed_node->root),
 			  delayed_node->inode_id, dir->index_cnt,
 			  delayed_node->index_cnt, ret);
 		btrfs_release_delayed_item(delayed_item);
@@ -1562,10 +1602,31 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
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

