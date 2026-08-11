Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDEE369D61;
	Tue, 11 Aug 2026 18:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472116; cv=none; b=KSLfre/fUJ+rrWBhJ7oMPu24isi4rCeI5hJ6ceXTDW5VgVZe4ggh+7DMLZDtOAACxnsEWp6H+lrVKW8wbiEWabS0vHxMCvFjO4r7ELRnNyzb19FNK9fFCVRmlJ2nr+RhVoHyTJ+67DitvOGgjNPSEdeM2GUqR9ttoFzJNkz8mlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472116; c=relaxed/simple;
	bh=SuoQyOL5OoixGIQjHqn4nzB0MprTrfikfwtDwZ15904=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Vt1GrNA6XIqwYfh2Hamwuy+pyb9UWxtwifz6nBf1WUxduxOzfTUekG9lk/6oBrjBwBJ0fjRL3+5WB8xvshmVn+/3rw2tlEkzFy7QQM0F8hwsg+GONOacQuYW5QrGBO+LTHCdmaRHPvavw3idOTRhU3DhrnjYJpsvKGKUlHq9QwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSHgrNAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSHgrNAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3477C1F00AC4;
	Tue, 11 Aug 2026 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472111;
	bh=b9PWBl+4Ny6MgSuhtKT5CkWx640e44bnpWLCqG0SP9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dSHgrNAANwln0fa6wt4gxIU+IcrLIpz7dOZGI762DQPG2QluDdE3ZRU01O8nJ/JZV
	 B1ICjInBvNzS4iHm20wB2EQnUz0XynTWebnToZg5fC3nxicL8t9sIz1q3DlKZ3b6qO
	 +bwklAnIFt6t9mAbrfBeKWoQLsltix6S3dBOxCm89cjNoTV2dAxw4dk+GWa1FVaG39
	 DVleHQHVxdrRaBFJpzSeqdexP3V0FZLYx2lrKOgPaDbF4gM+vOkPhpiscNClegfZsI
	 dxo8Tbxj32eWiOyKipi0zB9bnQRuGxJcRnkzgkAiNpuoaQDJFfJZQgNsFPq6cCAEtL
	 DND4O17syWubw==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 11 Aug 2026 14:14:57 -0400
Subject: [PATCH v3 4/6] btrfs: pre-allocate delayed dir index before btree
 modification
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-btrfs-enomem-v3-4-46a993fc3fe5@kernel.org>
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
In-Reply-To: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8619; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=SuoQyOL5OoixGIQjHqn4nzB0MprTrfikfwtDwZ15904=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqe2arElK+AtgGFhdzSFxNQTC78GqJrQf5v+quO
 fQ3MywFU5uJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCantmqwAKCRAADmhBGVaC
 FcwJD/4kCGof62j78o0aI5ZutvjfZ8gi0BK+8Z60tKstE8K+Ejj4W+z1E+rHZh7/6srlxJvHFpI
 VAxRvfWROPlork/hedshRf9NpszSpOKwYDPWLvrE7b8HybsjO4zZRmM+IsnQ6NbEpu36DYeIo5W
 DdDS4AcaiN44OOONpSRlP6pr4/HLjmguTJ/crT723oObRXkulTZxVU4lDHMLW7OjTh3Z3Yq0XEi
 jAm0ac0Y9mOMnlImV+RgWq9WFXo1NN2qCHnmUF1caJK2Mn2DT2dPKA2EphXOgEMpQhS3V9J07/S
 rIC/l+pqpP/XYXj6shg0soE0zb0kiR1ekOqDkIbi4EhxGrvj4xlfWLpo59bak639660Z1pyjsZY
 YZ4GbuWVZlvZXehOkyklwgINxuUsw/UZfbQThSkIOjMgIqhI97NwOEmSUZ8TgX4PbNZuVxqJuYp
 1ENsX5wLdEcaf560Aro8TgerP0W2JasDwwXi5MUbMKOsz/USsQKLfMyqVhkVtVdqiPXwfR8vRFp
 G0jFGugedkqworUWdKXDyH9JXrt0pnTggmnw8k4QoodOLjyECRzba3xkegFyswhkcFfqg//23A1
 btmNLprIItLVmUvigLtXlYLBFVUrHy0fogvvKhyTZ6pWv2mMDfAAMzeDfWJy03j+UILUH8kktNr
 6LuvQjd368lV5bg==
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

Since ownership transfers, btrfs_insert_dir_item() must free the prealloc
on every path that does not commit it. Route all such exits (including
the early path allocation failure) through a common out_free_prealloc
label, rather than keying cleanup on need_delayed_index.

Remove the btrfs_insert_delayed_dir_index() wrapper, as there are no
more callers.

Assisted-by: LLM
Suggested-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/delayed-inode.c | 21 ++-------------------
 fs/btrfs/delayed-inode.h |  5 -----
 fs/btrfs/dir-item.c      | 42 ++++++++++++++++++++++++++++--------------
 fs/btrfs/dir-item.h      |  5 +++--
 fs/btrfs/inode.c         |  2 +-
 fs/btrfs/transaction.c   |  2 +-
 6 files changed, 35 insertions(+), 42 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index af5e6dbf60d3..bd603525c133 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -687,7 +687,7 @@ static int btrfs_insert_delayed_item(struct btrfs_trans_handle *trans,
 	/*
 	 * For delayed items to insert, we track reserved metadata bytes based
 	 * on the number of leaves that we will use.
-	 * See btrfs_insert_delayed_dir_index() and
+	 * See btrfs_insert_delayed_dir_index_prealloc() and
 	 * btrfs_delayed_item_reserve_metadata()).
 	 */
 	ASSERT(first_item->bytes_reserved == 0);
@@ -1629,23 +1629,6 @@ int btrfs_insert_delayed_dir_index_prealloc(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-/* Will return 0, -ENOMEM or -EEXIST (index number collision, unexpected). */
-int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
-				   const char *name, int name_len,
-				   struct btrfs_inode *dir,
-				   const struct btrfs_disk_key *disk_key, u8 flags,
-				   u64 index)
-{
-	struct btrfs_dir_index_prealloc *prealloc;
-
-	prealloc = btrfs_prealloc_delayed_dir_index(dir, name, name_len);
-	if (IS_ERR(prealloc))
-		return PTR_ERR(prealloc);
-
-	return btrfs_insert_delayed_dir_index_prealloc(trans, dir, prealloc,
-						       disk_key, flags, index);
-}
-
 static bool btrfs_delete_delayed_insertion_item(struct btrfs_delayed_node *node,
 						u64 index)
 {
@@ -1661,7 +1644,7 @@ static bool btrfs_delete_delayed_insertion_item(struct btrfs_delayed_node *node,
 	/*
 	 * For delayed items to insert, we track reserved metadata bytes based
 	 * on the number of leaves that we will use.
-	 * See btrfs_insert_delayed_dir_index() and
+	 * See btrfs_insert_delayed_dir_index_prealloc() and
 	 * btrfs_delayed_item_reserve_metadata()).
 	 */
 	ASSERT(item->bytes_reserved == 0);
diff --git a/fs/btrfs/delayed-inode.h b/fs/btrfs/delayed-inode.h
index 6d12a145489f..57ba96cfaf9c 100644
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
index 84f1c64423d3..30ddafaf8d3d 100644
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
@@ -119,17 +122,28 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 	struct btrfs_key key;
 	struct btrfs_disk_key disk_key;
 	u32 data_size;
+	const bool need_delayed_index = (root != root->fs_info->tree_root);
 
 	key.objectid = btrfs_ino(dir);
 	key.type = BTRFS_DIR_ITEM_KEY;
 	key.offset = btrfs_name_hash(name->name, name->len);
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out_free_prealloc;
+	}
 
 	btrfs_cpu_key_to_disk(&disk_key, location);
 
+	/* Pre-allocate the delayed dir index before modifying the btree. */
+	if (need_delayed_index && !prealloc) {
+		prealloc = btrfs_prealloc_delayed_dir_index(dir, name->name,
+							    name->len);
+		if (IS_ERR(prealloc))
+			return PTR_ERR(prealloc);
+	}
+
 	data_size = sizeof(*dir_item) + name->len;
 	dir_item = insert_with_overflow(trans, root, path, &key, data_size,
 					name->name, name->len);
@@ -137,7 +151,7 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 		ret = PTR_ERR(dir_item);
 		if (ret == -EEXIST)
 			goto second_insert;
-		goto out_free;
+		goto out_free_prealloc;
 	}
 
 	if (IS_ENCRYPTED(&dir->vfs_inode))
@@ -154,21 +168,21 @@ int btrfs_insert_dir_item(struct btrfs_trans_handle *trans,
 	write_extent_buffer(leaf, name->name, name_ptr, name->len);
 
 second_insert:
-	/* FIXME, use some real flag for selecting the extra index */
-	if (root == root->fs_info->tree_root) {
+	if (!need_delayed_index) {
 		ret = 0;
-		goto out_free;
+		goto out_free_prealloc;
 	}
 	btrfs_release_path(path);
 
-	ret2 = btrfs_insert_delayed_dir_index(trans, name->name, name->len, dir,
-					      &disk_key, type, index);
-out_free:
+	ret2 = btrfs_insert_delayed_dir_index_prealloc(trans, dir, prealloc,
+						       &disk_key, type, index);
 	if (ret)
 		return ret;
-	if (ret2)
-		return ret2;
-	return 0;
+	return ret2;
+
+out_free_prealloc:
+	btrfs_free_delayed_dir_index_prealloc(trans, prealloc);
+	return ret;
 }
 
 static struct btrfs_dir_item *btrfs_lookup_match_dir(
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

