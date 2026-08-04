Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5719B468C3A;
	Tue,  4 Aug 2026 15:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858293; cv=none; b=ZnPcoZdEzEAMKzFZ0hBsFfZEJIeZQBwcToDb37oKT9yX230pQ0RopfM5LWnNgFMyZt/DWaDFV7xNYgENO7snWX/R5gxGKyQ1x64zEK3LVtVrCg6nRb2hKMATZESK4+CqWAxesubTqdbIaD8lKCsqXhZSZxj/ROMRZXQPIwrNcL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858293; c=relaxed/simple;
	bh=Shkh1sZbKyWa3sAJXLyv+r0Hg/03/WIqVHZgJLk/lTs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pz2n4JsWPDPfkPD8AYT86kijnxGxBCPLEgALoCUKvfcCb/YjRO5YABAxiM+telUOlz58AjQNLAvt+1lZvK8A0RdAXh8HhNmdnqJQWNO/202qpf3ryUO8LBZk+f2efkUK7Y6kxYTay1TyYIJrdSkSgo7mZX0ip17gtPrbtaqTNK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTyWexji; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTyWexji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771B31F00AC4;
	Tue,  4 Aug 2026 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785858291;
	bh=1U+cMeYTsqCxuW8znWLZHQCalgwOpdQYETdxwXVKlXA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HTyWexji/I3Fa+EIB3VOkuFfuGwEzgEex38p7pZhEjN3t5Z544NyEjPVDIWgYP/1z
	 9khVN71Kn8q/tnPAkF+IlCsbCtckTv9moy6d85RDK+bqH+g3zHw4z1ReiizZKSmQS/
	 1R1x9uYjZiNzg/zNp+dK25ZSu2QFWJaI73rmKUMUWvqn3z4deh9Psw7ZbeVy5JO3LN
	 ckIfUh0mDm2ICEzYXlxtoi81RdFLLEvzxGQN/EiM5CTN9lRdH3zKPbuI5j0vJG5511
	 xX8cb/94cyxaaB8FZD4imOQwnqdtz8Lp0IveK4Tc8Kp4bqbMUNdrnh0oYsg0H39NtG
	 q2j1eHrQlUIRw==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 04 Aug 2026 11:44:35 -0400
Subject: [PATCH v2 3/5] btrfs: pre-allocate delayed dir index before btree
 modification
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-btrfs-enomem-v2-3-4d923170e8c1@kernel.org>
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
In-Reply-To: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7421; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=Shkh1sZbKyWa3sAJXLyv+r0Hg/03/WIqVHZgJLk/lTs=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqcgjv3dX0MXN4GbiIJ7ZbFPdh4SGG7DrBISFQn
 HvBbqy0hjyJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCanII7wAKCRAADmhBGVaC
 FRFFD/90GNYvnzA85ZxBzG3BEsFKN4TNIkTKOWdvo3aWru1iA4ECuxb6w17sGr3Gbrz00CecPc7
 YMGzURbpEyk8ORkzdwnP7imCVMCzPg2Uz/rN7r6Ef9JGkq20mSPB6Ti26DmLuqtaKCGwNU5t1yk
 f2M0oWJJKmVDdur37nd035S1dmGZ2+J/2iMudYd7hg4g8X9uXiXtWH45WVs9/yG45z8gwTlTXrJ
 IaRzjenBKGmYIVSNLXZMAklK/dWhrx2oygTqPJhkXZcXgegLCYgxs2O1YmAJ9zVGfxaOTNCrDno
 48FboI4tx14ExkCCbIIbMnGzwVoitMqwb9woYV46jloHhO2onwSB62NbS6f4fgfIiLsdFWMOqzs
 EWCNYLwnMVVvDMfwvE9aS2LRjkh3KjalMHQv4d0KCjQj+M2rsRg8SGtwxyYxgIVW2/PkWHMp7Po
 jUR7dnYtMITJPeysfFfktV8jHF8X2PGcNBGzf82uVgS1GILHxQS0GaOZhP8YRcKIxzzL4abUBiN
 MvgV/W3j6ynuOfv7NU5P80ZpsQL3qN6rYefhVDQv280vsNF2eUj+DgoEMWKIV7PXDnaD5IOSXww
 ghWRDuOD/TdXemnr9xwLqEIUs24U54yrSlxYAh+TqQmA2rzA2RF2o+BsI617fg2UwO+EAuF3CZM
 m7q60jEMzHB5NnA==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Move the delayed dir index allocation in btrfs_insert_dir_item() before
the insert_with_overflow() call that modifies the btree. Previously, the
allocations happened after the DIR_ITEM was already inserted, meaning an
ENOMEM failure left the btree in a partially-modified state that could
only be resolved by aborting the transaction.

Add an optional caller-provided btrfs_dir_index_prealloc parameter to
btrfs_insert_dir_item(). When non-NULL, ownership of the prealloc
transfers to btrfs_insert_dir_item(). When NULL, it allocates internally.
All existing callers pass NULL to preserve the current behavior.

Remove the btrfs_insert_delayed_dir_index() wrapper, as there are no
more callers.

Assisted-by: LLM
Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/delayed-inode.c | 21 ---------------------
 fs/btrfs/delayed-inode.h |  5 -----
 fs/btrfs/dir-item.c      | 30 ++++++++++++++++++++++++------
 fs/btrfs/dir-item.h      |  5 +++--
 fs/btrfs/inode.c         |  2 +-
 fs/btrfs/transaction.c   |  2 +-
 6 files changed, 29 insertions(+), 36 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 95d2dca80444..d9de7f269874 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1608,27 +1608,6 @@ int btrfs_insert_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
-int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   const char *name, int name_len,
-				   struct btrfs_inode *dir,
-				   const struct btrfs_disk_key *disk_key, u8 flags,
-				   u64 index)
-{
-	struct btrfs_dir_index_prealloc prealloc;
-	int ret;
-
-	ret = btrfs_prealloc_delayed_dir_index(dir, name, name_len, &prealloc);
-	if (ret)
-		return ret;
-
-	memcpy(prealloc.item->data + sizeof(struct btrfs_dir_item), name,
-	       name_len);
-
-	return btrfs_insert_delayed_dir_index_prealloc(trans, dir, &prealloc,
-						       disk_key, flags, index);
-}
-
 static bool btrfs_delete_delayed_insertion_item(struct btrfs_delayed_node *node,
 						u64 index)
 {
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index e310a257c9a6..878d70aee2f9 100644
--- a/fs/btrfs/delayed-inode.h
+++ b/fs/btrfs/delayed-inode.h
@@ -115,11 +115,6 @@ struct btrfs_delayed_item {
 };
 
 void btrfs_init_delayed_root(struct btrfs_delayed_root *delayed_root);
-int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   const char *name, int name_len,
-				   struct btrfs_inode *dir,
-				   const struct btrfs_disk_key *disk_key, u8 flags,
-				   u64 index);
 
 struct btrfs_dir_index_prealloc {
 	struct btrfs_delayed_node *node;
diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
index 84f1c64423d3..1b956df2c571 100644
--- a/fs/btrfs/dir-item.c
+++ b/fs/btrfs/dir-item.c
@@ -106,8 +106,11 @@ int btrfs_insert_xattr_item(struct btrfs_trans_handle *trans,
  * Will return 0 or -ENOMEM
  */
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
-			  const struct fscrypt_str *name, struct btrfs_inode *dir,
-			  const struct btrfs_key *location, u8 type, u64 index)
+			  const struct fscrypt_str *name,
+			  struct btrfs_inode *dir,
+			  const struct btrfs_key *location, u8 type,
+			  u64 index,
+			  struct btrfs_dir_index_prealloc *prealloc)
 {
 	int ret = 0;
 	int ret2 = 0;
@@ -119,6 +122,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_disk_key disk_key;
 	u32 data_size;
+	const bool need_delayed_index = (root != root->fs_info->tree_root);
+	struct btrfs_dir_index_prealloc local_prealloc;
 
 	key.objectid = btrfs_ino(dir);
 	key.type = BTRFS_DIR_ITEM_KEY;
@@ -130,6 +135,18 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 
 	btrfs_cpu_key_to_disk(&disk_key, location);
 
+	/* Pre-allocate the delayed dir index before modifying the btree. */
+	if (need_delayed_index && !prealloc) {
+		ret = btrfs_prealloc_delayed_dir_index(dir, name->name,
+						       name->len,
+						       &local_prealloc);
+		if (ret)
+			return ret;
+		memcpy(local_prealloc.item->data + sizeof(struct btrfs_dir_item),
+		       name->name, name->len);
+		prealloc = &local_prealloc;
+	}
+
 	data_size = sizeof(*dir_item) + name->len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name->name, name->len);
@@ -137,6 +154,8 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 		ret = PTR_ERR(dir_item);
 		if (ret == -EEXIST)
 			goto second_insert;
+		if (need_delayed_index)
+			btrfs_free_delayed_dir_index_prealloc(trans, prealloc);
 		goto out_free;
 	}
 
@@ -154,15 +173,14 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, name->name, name_ptr, name->len);
 
 second_insert:
-	/* FIXME, use some real flag for selecting the extra index */
-	if (root == root->fs_info->tree_root) {
+	if (!need_delayed_index) {
 		ret = 0;
 		goto out_free;
 	}
 	btrfs_release_path(path);
 
-	ret2 = btrfs_insert_delayed_dir_index(trans, name->name, name->len, dir,
-					      &disk_key, type, index);
+	ret2 = btrfs_insert_delayed_dir_index_prealloc(trans, dir, prealloc,
+						       &disk_key, type, index);
 out_free:
 	if (ret)
 		return ret;
diff --git a/fs/btrfs/dir-item.h b/fs/btrfs/dir-item.h
index e52174a8baf9..d7a7d0b66f37 100644
--- a/fs/btrfs/dir-item.h
+++ b/fs/btrfs/dir-item.h
@@ -16,9 +16,11 @@ struct btrfs_trans_handle;
 
 int btrfs_check_dir_item_collision(struct btrfs_root *root, u64 dir_ino,
 			  const struct fscrypt_str *name);
+struct btrfs_dir_index_prealloc;
 int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 			  const struct fscrypt_str *name, struct btrfs_inode *dir,
-			  const struct btrfs_key *location, u8 type, u64 index);
+			  const struct btrfs_key *location, u8 type, u64 index,
+			  struct btrfs_dir_index_prealloc *prealloc);
 struct btrfs_dir_item *btrfs_lookup_dir_item(struct btrfs_trans_handle *trans,
 					     struct btrfs_root *root,
 					     struct btrfs_path *path, u64 dir,
@@ -53,5 +55,4 @@ static inline u64 btrfs_name_hash(const char *name, int len)
 {
        return crc32c((u32)~1, name, len);
 }
-
 #endif
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3c10a0ef0002..3a2dca093c7d 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6924,7 +6924,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
-				    btrfs_inode_type(inode), index);
+				    btrfs_inode_type(inode), index, NULL);
 	if (ret == -EEXIST || ret == -EOVERFLOW)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index c641099d66e2..6fdfea5d35af 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1882,7 +1882,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
 				    parent_inode, &key, BTRFS_FT_DIR,
-				    index);
+				    index, NULL);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;

-- 
2.55.0

