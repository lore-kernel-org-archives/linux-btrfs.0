Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF98E42DA5F;
	Fri, 17 Jul 2026 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784307190; cv=none; b=hOQ7QNxNBOWQYiEaa66DKNkgLCalZbwF/j7Mdtu5dEPPN0lxFcYMGpDlW8NLwfoXdgfCSLFf5U2N3DSvU5KyAF11fNMdH2BkW+hRXRFVIsOTn7uKK1X2V9qfAXE4htrvgyhiSEC8Zir5f1VKpXwfZZkDKlF1Mi0F3+v/T4sAeos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784307190; c=relaxed/simple;
	bh=GiFkt3z4iWkrkW0beJu+hXDQGatXHi0Pk0MMlGkGZbg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=L0uru1Cvsj0j8JE9btP8oAL5yHVbgCzrgvoaXVD6Rr24nrlpGcp2mI9iK53fbtBsNiOHiciGHdkE2wZyL3XHvBNcwHTlO0Wi1m5UgB1nEtPl5I0ZXLIdnvxkhjPUj0rrnS9Bzb/tP1R6a7M/6OvSKr1hjumK8ucU9ktRqaBRJ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fvCv+b0r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fvCv+b0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC55A1F00A3D;
	Fri, 17 Jul 2026 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784307188;
	bh=PCojI2O4xN+3K0m+1+ou+NHnFebGObdzYZMuDTbziz8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fvCv+b0rqLE8v/sWBt9PYNJbeCckhNd7AIiiRNarSUOfcq0Cl4xD5mU+ncj4Vs/md
	 rMc8Zu7tuuYwHQg/KUANvlfUrpPYUQob0RClnQJotJT/zqCofofITSgwOBXojEF6yx
	 FtqE/smsSiALGwkDkjDM7xJWUZbpgl/ZqauTQSmE/QdWF6bnT1OM7z6M6TokY7CbK6
	 2yLkXf+6wZFTYRnse442Ns7yZ0UHB+NG+hQcISXwKjXV1lncxTOeGeGbH6O9QrSKEN
	 0860f57yiFYM7YH5EBxBptlRRPagcqUAeEhoQbZyKBWw8JQ/PxbUC/bQJv1pKek9Hy
	 ETKvz/1Z4zqEA==
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 17 Jul 2026 12:52:39 -0400
Subject: [PATCH 4/4] btrfs: pre-allocate delayed dir index for
 non-overwrite rename
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-btrfs-enomem-v1-4-cdc9c0e265d0@kernel.org>
References: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
In-Reply-To: <20260717-btrfs-enomem-v1-0-cdc9c0e265d0@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kernel-team@fb.com, Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7257; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=GiFkt3z4iWkrkW0beJu+hXDQGatXHi0Pk0MMlGkGZbg=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqWl3wFsdn2Yvj+T+zTE/iLBeX/f+ys/hHqr1JR
 kwb+oaD9YiJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCalpd8AAKCRAADmhBGVaC
 FRuDD/wK6+Q9n8eW02QzFdLbK8nn3MNSIFdecU+fLX5CMuZrANw04yjxzlZfd4k/z/D3kzBX4Kw
 1LGloCxb0yUDi8ZKYVgembPsDS5n/HAywikQKXy4XGrhiD5biC/Zfuz3bZBdPTse0Readf3qcEp
 FYRR34wD1le4I+NiTM1YIZDRu5J4XV/UOaza5onDGMgzFBZTnpP3aZL3SN/APXhVseZXi7UDNpT
 lnjFLBOYuBjBQB2rtBtVvxCum2MJqYC0pOEzwOsJyKevsnE8KZQ8hL8UAA7/X8W8gg/U+j6aSgv
 WqZm6/dr4NFP8+G8x9Nz1ZPQu6u5bmI5gUG/aH4gdyXc7wgzL1otDJ1eACBmrglYSEVgoieJa31
 YhrvbWTSVdFJa5VH7qUTbkTckfa2xndTIyjfEHJpuxkLJA0JnnJaGv5qzFdwrIJ78R0fPR6F9tQ
 vJL1qxDHlxx/P+WyGYh0kzpgugZODhRuplet2m48z/FPB880OWVNMzFR3OD4SDlq/QxzCYOGag3
 HQL5ZgXoykeF+kkZa3s4xmcCiNVyr9ATiQmI9yu+x0+dU/8jtApraogM55ihiX88/b5lWcPqmBc
 djcZhVr98fMpQQTHFoOhO+o7vHPeRtCdF4FLJbxy/kKSvhMEsvWyIx9GFYFNIB9p9KoM2EO8PUk
 ivEd6h4y5lcv+/g==
X-Developer-Key: i=jlayton@kernel.org; a=openpgp;
 fpr=4BC0D7B24471B2A184EAF5D3000E684119568215

For rename() without an overwrite target, pre-allocate the delayed
dir index before any btree modifications so that ENOMEM can be returned
before the source is unlinked from the old directory.

Add a prealloc parameter to btrfs_add_link() that allows callers to
pass pre-allocated delayed dir index resources. When provided,
btrfs_add_link() takes ownership: it either passes the prealloc to
btrfs_insert_dir_item() (which commits or frees it), or frees it
on early error. All existing callers pass NULL to preserve the current
behavior.

In btrfs_rename(), when new_inode is NULL (no overwrite), call
btrfs_prealloc_delayed_dir_index() before the first btree modification
and pass the result through to btrfs_add_link(). If the prealloc fails,
-ENOMEM is returned before any btree state has changed.

For overwrite rename (new_inode != NULL), the transaction still aborts
on ENOMEM since earlier unlink operations have already made irreversible
btree modifications.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  4 +++-
 fs/btrfs/inode.c       | 43 +++++++++++++++++++++++++++++++++++--------
 fs/btrfs/tree-log.c    |  4 ++--
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index d5d81f9546c3..176648f6e7b6 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -523,9 +523,11 @@ int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
 int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 		       struct btrfs_inode *dir, struct btrfs_inode *inode,
 		       const struct fscrypt_str *name);
+struct btrfs_dir_index_prealloc;
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
-		   const struct fscrypt_str *name, bool add_backref, u64 index);
+		   const struct fscrypt_str *name, bool add_backref, u64 index,
+		   struct btrfs_dir_index_prealloc *prealloc);
 int btrfs_delete_subvolume(struct btrfs_inode *dir, struct dentry *dentry);
 int btrfs_truncate_block(struct btrfs_inode *inode, u64 offset, u64 start, u64 end);
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4d9947ae08f7..9a717d21f713 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6675,7 +6675,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 		}
 	} else {
 		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
-				     false, BTRFS_I(inode)->dir_index);
+				     false, BTRFS_I(inode)->dir_index, NULL);
 		if (ret == -ENOMEM) {
 			/*
 			 * The ENOMEM came before the DIR_ITEM was inserted,
@@ -6720,7 +6720,8 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
  */
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
-		   const struct fscrypt_str *name, bool add_backref, u64 index)
+		   const struct fscrypt_str *name, bool add_backref, u64 index,
+		   struct btrfs_dir_index_prealloc *prealloc)
 {
 	int ret = 0;
 	struct btrfs_key key;
@@ -6746,11 +6747,14 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	}
 
 	/* Nothing to clean up yet */
-	if (ret)
+	if (ret) {
+		if (prealloc)
+			btrfs_free_delayed_dir_index_prealloc(trans, prealloc);
 		return ret;
+	}
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
-				    btrfs_inode_type(inode), index, NULL);
+				    btrfs_inode_type(inode), index, prealloc);
 	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
@@ -6904,7 +6908,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	inode_set_ctime_current(inode);
 
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
-			     &fname.disk_name, true, index);
+			     &fname.disk_name, true, index, NULL);
 	if (ret)
 		goto fail;
 
@@ -8311,14 +8315,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
-			     new_name, false, old_idx);
+			     new_name, false, old_idx, NULL);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(old_dir), BTRFS_I(new_inode),
-			     old_name, false, new_idx);
+			     old_name, false, new_idx, NULL);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
@@ -8391,6 +8395,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	struct inode *new_inode = d_inode(new_dentry);
 	struct inode *old_inode = d_inode(old_dentry);
 	struct btrfs_rename_ctx rename_ctx;
+	struct btrfs_dir_index_prealloc prealloc = { };
 	u64 index = 0;
 	int ret;
 	int ret2;
@@ -8514,6 +8519,24 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	if (ret)
 		goto out_fail;
 
+	/*
+	 * When not overwriting an existing entry, pre-allocate the delayed
+	 * dir index now so that ENOMEM is returned before any btree
+	 * modifications. For the overwrite case, too many btree changes
+	 * have already happened by the time btrfs_add_link() is called.
+	 */
+	if (!new_inode) {
+		ret = btrfs_prealloc_delayed_dir_index(
+				BTRFS_I(new_dir),
+				new_fname.disk_name.name,
+				new_fname.disk_name.len,
+				&prealloc);
+		if (ret)
+			goto out_fail;
+		memcpy(prealloc.item->data + sizeof(struct btrfs_dir_item),
+		       new_fname.disk_name.name, new_fname.disk_name.len);
+	}
+
 	BTRFS_I(old_inode)->dir_index = 0ULL;
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		/* force full log commit if subvolume involved. */
@@ -8609,7 +8632,9 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
-			     &new_fname.disk_name, false, index);
+			     &new_fname.disk_name, false, index,
+			     prealloc.item ? &prealloc : NULL);
+	prealloc.item = NULL;
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
@@ -8634,6 +8659,8 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 		}
 	}
 out_fail:
+	if (prealloc.item)
+		btrfs_free_delayed_dir_index_prealloc(trans, &prealloc);
 	if (logs_pinned) {
 		btrfs_end_log_trans(root);
 		btrfs_end_log_trans(dest);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 875e4ddc68ea..86a924d7cd43 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1700,7 +1700,7 @@ static noinline int add_inode_ref(struct walk_control *wc)
 			}
 
 			/* insert our name */
-			ret = btrfs_add_link(trans, dir, inode, &name, false, ref_index);
+			ret = btrfs_add_link(trans, dir, inode, &name, false, ref_index, NULL);
 			if (ret) {
 				btrfs_abort_log_replay(wc, ret,
 "failed to add link for inode %llu in dir %llu ref_index %llu name %.*s root %llu",
@@ -2048,7 +2048,7 @@ static noinline int insert_one_name(struct btrfs_trans_handle *trans,
 		return PTR_ERR(dir);
 	}
 
-	ret = btrfs_add_link(trans, dir, inode, name, true, index);
+	ret = btrfs_add_link(trans, dir, inode, name, true, index, NULL);
 
 	/* FIXME, put inode into FIXUP list */
 

-- 
2.55.0

