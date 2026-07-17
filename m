Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9323ECBE2;
	Fri, 17 Jul 2026 16:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307188; cv=none; b=Y6FaIht5P5xymUatAFuoNHWFECXN85WIkBTd8T6VRup6St7Knk5TSG07r1JXlS0Mop22bRq2ljeOcnf5V6szpjzwzYKmYrYnbT+WPAjluQn4QV4XKycpuXlH2H8oVOmIl+FrmrVTeaEU9jEo1y9m101dwG+h4rKdjS0jF61XqYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307188; c=relaxed/simple;
	bh=MxdERwye36AER3QylwxpVQ26/YFmLLKDtHNFy+corwE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hrXRQBP/8fINFCqTfM5cayynVUYDLejeUC1Lv52sPhTP+OOwfs/IGTiQcAxBlPSHTVhMG6MhP7RsmL379vhL9YmOzP8q9T4i1xJSXyADGZX42aSB5FSCC2ZoykeFnfMPIpm2A/vJwUccUj6BbZ4vGitCrJ70sY/UbHxcJKRa3tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X6K8boQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X6K8boQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C7D1F00A3E;
	Fri, 17 Jul 2026 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307187;
	bh=Mwqk2zH3wC+9JE29CQ0H0khHk9v+glGkYTbNuXjg0S8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=X6K8boQScxsUTPAw1G7TpAovoSVvTwuF3fGR6o4WqEEdBk89VOydJm6hRCuQbZTAx
	 YRGrgyIaNVt3oEpI0zDaRGC/QX694rUK6UqTCEawQR1WcM/NjO3XUc+lNb97z4Gckw
	 DCD6Fftxregf4PdFY/nmNgBqWIvd7O2IQnSEPZiT2ekPbbN5c4tz2jKa8yt4Xv6PkO
	 eI06y5hcWVYMYLAsmKUb0dQnRrC+KFvuzB65keas6cuDDmsQSSPeZDVxgYCR2NbNce
	 1pHAgmmUWN0A58ZrLhGpBVhduW09clkZGN9dlKR+3uXCNESzjX/119uXqYQ3x2rY69
	 qX8gRwNqgJyKQ==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 17 Jul 2026 12:52:37 -0400
Subject: [PATCH 2/4] btrfs: pre-allocate delayed dir index before btree
 modification
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-btrfs-enomem-v1-2-cdc9c0e265d0@kernel.org>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
In-Reply-To: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@fb.com, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5752; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=MxdERwye36AER3QylwxpVQ26/YFmLLKDtHNFy+corwE=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqWl3wJBm3N3WjqyDid9ZEKOCShalFw2BlyS4+O
 kHfjg7n5P2JAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCalpd8AAKCRAADmhBGVaC
 FQvpEACwfjBz7GjPlfiP4hkrjsU0yl3JelC0Yebq25XfpCFw7qyEzMGoYDZ6RE5K+764/5kDG/x
 XT9AUNDNgDqw1MJWhBMjVr0OgBXOBC29sXiQ7vGfB2FIKUDFdKEryX/zsXpDaRIre5qVmkprJJx
 453AP0pigkELHsSuU42Gp7CqYPgbeYcfNFx3vhmF22pON1G/YOEiOsTDjMP/GY/spzjXu+vE2R5
 V9GadaiUMS3Y6fEVfuPHeMwQZJJgtldTlLTevDYyb/hW35HEj+9HAeUH1iOu0YbsG6OtAWYj2dF
 ww9BVTxyaC4BKFH6r8ffShzMPhvugChtW1dhDOO5pW8CQrFca1klbYYmUQIFPNceEAquBR89Ygl
 RBFKSeK+FoiyeV2OJ3mgiQy1GWDoyTgtoALinsvwTT1898ougqS/m4SNsTzHjVX+7xvUPEfn2KH
 tmp5shaa4MUGpaxQ9jwbsyODWh2E+7dTujo5m9eF7ThXBHkv6BZBwBfuVn70wwjtC+YJ/AVxe70
 +LZ7aIOGlU4Cp5VpQIcazSMfrBiiEg46TODxzP9xsIyYoIGIASJIlMjG4rDWzwCjp2C5gMA3KUQ
 Le92NLXq5Vf0tdNT/Yqx9D9V7As8twp+KN2PRk8HFcNstkgZYUAlUYQILv2VCkiC+LeDW8h0ljI
 3GQBt65s6lKcKjg==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

Move the delayed dir index allocation in btrfs_insert_dir_item() before
the insert_with_overflow() call that modifies the btree. Previously, the
allocations happened after the DIR_ITEM was already inserted, meaning an
ENOMEM failure left the btree in a partially-modified state that could
only be resolved by aborting the transaction.

With the pre-allocation, if the GFP_NOFS allocations fail, -ENOMEM is
returned before any on-disk state has changed. The caller can then
handle the error gracefully. If the btree insertion itself fails, the
pre-allocated resources are freed.

Add an optional caller-provided btrfs_dir_index_prealloc parameter to
btrfs_insert_dir_item(). When non-NULL, ownership of the prealloc
transfers to btrfs_insert_dir_item(). When NULL, it allocates internally.
All existing callers pass NULL to preserve the current behavior.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/dir-item.c    | 30 ++++++++++++++++++++++++------
 fs/btrfs/dir-item.h    |  5 +++--
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/transaction.c |  2 +-
 4 files changed, 29 insertions(+), 10 deletions(-)

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
index 272598f6ae77..b7b4e6177135 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6737,7 +6737,7 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 		return ret;
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
-				    btrfs_inode_type(inode), index);
+				    btrfs_inode_type(inode), index, NULL);
 	if (ret == -EEXIST || ret == -EOVERFLOW)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8f9419728100..3a2d4520c79a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1886,7 +1886,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
 				    parent_inode, &key, BTRFS_FT_DIR,
-				    index);
+				    index, NULL);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto fail;

-- 
2.55.0

