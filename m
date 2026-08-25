Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3F633CEB0;
	Tue, 25 Aug 2026 16:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787673900; cv=none; b=TzmWzZoiaOI1ZI99LWV576RnKOmECx0oqOM5E68RLdaRPpMa3JvHu3WkjHGDa9wHSm4vU/Rq44VWG0kle8+tRblSbYBcIwYNJRQrFY6NhgnBz0ZRWX31jNhQS7BV0uQjbZNGTAgzLec3UVFi0I8rIL8so398fqY3tQJqez9nUWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787673900; c=relaxed/simple;
	bh=SuoQyOL5OoixGIQjHqn4nzB0MprTrfikfwtDwZ15904=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=SG5BYFddRAX5XSI99aamjRIJrFRHoddgz7B0AcCPMvPnQ+H8ObcPPd6pNH4n4gADUDjZB6p18HsOney/3AoArDWODFhlmfuzMHwSLxYPQpSDV4aGTrPJqBlvOw0yLKXzt3Be4mMxlauiuhMMCRrXHVi0HkVHzLo/qPTnVO/H4aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MwuDGG4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MwuDGG4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E70A1F00A3A;
	Tue, 25 Aug 2026 16:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787673898;
	bh=b9PWBl+4Ny6MgSuhtKT5CkWx640e44bnpWLCqG0SP9A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MwuDGG4jGVH6ACG3IHHxQRWlN7G2Voso7nTg62FOIgq3YSxdd5pEBVKVSNJzL5GoU
	 Mqc0W+psesnTPUA7bAWQm0rnQVdLZKQ6tKbRqRMHBBp8iQ+4nBX2YtW8NuOWsgYLRp
	 lGG627xKSpSb5SYElHgSu8VHKtHTz8FO8/C02+XVMMEFtNRN3o8Sh5+3URM7BQg0HF
	 LO0KwD9EkeBGTYJ0TGtO7oCg3H2OE5E26GjW4FZ4OSJEpHtY4yfLT7YbnrCDBYUo4h
	 G8ZQGGeVEGLklCRKPZzTmZJBS6D32fhKl+dKk3qnr1K6ayiT70I3fZjIJOSmBsG4Zu
	 IVZfg1G4/LQ0A==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 25 Aug 2026 12:04:18 -0400
Subject: [PATCH v4 2/4] btrfs: pre-allocate delayed dir index before btree
 modification
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260825-btrfs-enomem-v4-2-b9363fa8714a@kernel.org>
References: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
In-Reply-To: <20260825-btrfs-enomem-v4-0-b9363fa8714a@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=8619; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=SuoQyOL5OoixGIQjHqn4nzB0MprTrfikfwtDwZ15904=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqjb0nWIZFZuz1fGM6yNp56J5XaPpV/Mxc5ekvA
 iLHI7Vq77aJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCao29JwAKCRAADmhBGVaC
 FWehEACyzonSjGx1EWycW1jXMdOktgWrVmKn6gimBomyBvWR9H+qYmOuM5jcXBUV5tW1n7jwam7
 SpO+zBvhTt2dzz8Dq0to80ap3gvs7at/tAUnwQtyrnmHzKurhJTCFMv+noPj5Z/PYz68az++x2c
 arRWghe2H5yzQJdNcFXkePZTgbDaqnpvBgPOr8oDVnZiSa++18S2vILruR9MuP/up5FEtAesxrx
 3fNp+88Y867rpkUHC7CVRqZeLwxfM1NLTL19esgQvMT2nEDIvuE0xkCm+kRJ0rcSeaY7c300cxy
 21SQgfgBFyuvlSaTtYaObjyIgtVMLJZA8oJ1s8XPbuquIh1gX/bpvOd3i9n7uBjbhURp6wMnZQj
 9xzPbCxc79dYLYRqZQZ5SF3Mc7s9chsfPvlfzetQrQVo090PjRBYRqnInn5IjAJZnFG1W9gabjp
 oxltJ7ubaPHdTp3CHbdWyER0IW1esYZCH1HmI79i7HvmllYIAcoDo4J6AgcqR0inqEL8TMlEAP6
 sdnVT+bRla5/AbbE8GoJa03jE3cntEBorSV5/wCgWu6Fs3kykAqFpcW4nha7ymrt1EElNysUlaa
 UptNbclFDwakXAOzQloAPEg0ZKf96MpfjDaeDWn2dnEOEVSLFwPsx2eX44dHXnXAOVtBicfIVQs
 eNwyXP3jJpmBPlQ==
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

