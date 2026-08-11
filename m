Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA73353A8E;
	Tue, 11 Aug 2026 18:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472119; cv=none; b=r7YwWwA/xogyxDO1bkAfgNfykYwAFa/3EWbgEEyqy5od3EbJgDu5NtIM/6fGXBmtNn33tntNWSb3RRvRY2Kw43gbWpEfkaVm6VBjsrvUJoYeamx255kDw1U3jbOhEHxwVK3MBp4LveCY7nwZ3r+UXXuAQBAF6dIzp4joqo91+wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472119; c=relaxed/simple;
	bh=v8a82oH3QarP6I8CBddMNieJTg8G5gwPz33bnEBPH1I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=N2AXgjRyyLmCUPUw2MUGtK2BuwsSepqCp8jDd08I9yDiLKPnXQ8EuXfRPK6QnUT9pUzut+NgqqK2/3F9F0ChlkO1xpmOsKIzKN3Zb+vfj5rfF4zp62ccnzRv7rQR96dbABwg2O7LkkfzyJvEOT70smU6xFvyuw6KMihtw1ajRJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=clno6O/Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="clno6O/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7B61F00A3F;
	Tue, 11 Aug 2026 18:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786472113;
	bh=OXnftdUGJlC4cntuhv3BMGFqzvt2LM1k7YzvH1mHMHQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=clno6O/Z+k4l5ZF/Ksp86hxQf+9C5YOITr0V0kjfjiY1W+MQfFxB+dKzLGpYxQrXR
	 0/3xbBwQsCuzaVBjpIQnBjK6aCwiEcqLjmloZ2omYN25GiP35wEdCRJNRQBEX2rxAn
	 CIG//bl8sJjwnEujClkW+Znhx0DX0qiI2jNpbiPzIieN46FjTHxHUH3m5ISPZmvxhG
	 hG7Wq2musWv9d9WPF8fBDTRPElb/NlxJSGhjPRIohTZA6bnJBmY8e+775OLrfjDeBB
	 wHQPbRH7vYwixT7pofifTEolgjqmHic1YSg2KS7sNsYPjh5dUwPmbxiqCtinFH17QF
	 VocWZpwrJCN2w==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 11 Aug 2026 14:14:59 -0400
Subject: [PATCH v3 6/6] btrfs: pre-allocate delayed dir index for
 non-overwrite rename
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-btrfs-enomem-v3-6-46a993fc3fe5@kernel.org>
References: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
In-Reply-To: <20260811-btrfs-enomem-v3-0-46a993fc3fe5@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7243; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=v8a82oH3QarP6I8CBddMNieJTg8G5gwPz33bnEBPH1I=;
 b=owEBbQKS/ZANAwAKAQAOaEEZVoIVAcsmYgBqe2arc2/r4Mvv0cPl8IiNahyaae65akZfL2ij1
 aRlodrXNWeJAjMEAAEKAB0WIQRLwNeyRHGyoYTq9dMADmhBGVaCFQUCantmqwAKCRAADmhBGVaC
 FQSJEADPqKwCteozx2yXw6skrgyxhq0OYVPRNSqsMwqDWopohroiFNAMKCOZflZVKjW2N6rq2+l
 +OkOIcOGqHWv8mb3L6aBh4/TIEzdZ4LPCD2dcn1xMhLDVrxMTJ+RMIf5gKxvBZFKOH5ovlBOr4c
 Ogl6RnpWzq+atJUb2Oh36nARK0gIlLzj7KgLDpbbvy6vI5tHtb38WLgPEvCcwpnSqcMLz7Yb0kr
 hF0nycQcD7pJ6kj7ZNLQ2jsY/Svb5RguAI2pySRSrUez9Gk35iiwcR4s1mNEuHY9RB9FoKwiffz
 3mYs5fs38u/gNbv5o3I01B5xDflr0MsMXoZ4SnbwOm1HscO3EvsaEjVaHuNRIk6HCMypXo/eK49
 nK6mpDtPE3vRuIVMvYZP+chygR3coPF5Q41/7AvUF6uDl6qejmGXByLs6/KJmwgxE2xxsKS3gSP
 qBznQ9jAxLy5hkCU/HmiP2fH7A3vFwmhybsTM1FXFZS3k7LcnqxWW+GZe2ZdTVejQRNOFBDdIQM
 gq55srO8tyzBQ7fOdSSpJKr91XWKAOz3n0Jcyq5YZtgPHx75itpqlDGJCKnAfHyPyMmCcQsBFXq
 oqYA2CEeemxavAC9ucnmJ9bwPTyxCXtqV4wKK6RucKHR2usPCl1SLuAje6OPwxEtY+6oEHQLAF4
 2ob8xtdgyIIZNwQ==
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
-ENOMEM is returned before any btree state has changed. The local
prealloc pointer is cleared once ownership passes to btrfs_add_link(),
so the out_fail path only frees one we still own.

For overwrite rename (new_inode != NULL), the transaction still aborts
on ENOMEM since earlier unlink operations have already made irreversible
btree modifications.

Assisted-by: LLM
Signed-off-by: Jeff Layton <jlayton@kernel.org>
---
 fs/btrfs/btrfs_inode.h |  4 +++-
 fs/btrfs/inode.c       | 40 ++++++++++++++++++++++++++++++++--------
 fs/btrfs/tree-log.c    |  4 ++--
 3 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
index 1082fa92c145..d4280f152027 100644
--- a/fs/btrfs/btrfs_inode.h
+++ b/fs/btrfs/btrfs_inode.h
@@ -525,9 +525,11 @@ int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
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
index 5b79910d72f5..fd6d481f4d12 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6862,7 +6862,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 		}
 	} else {
 		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
-				     false, BTRFS_I(inode)->dir_index);
+				     false, BTRFS_I(inode)->dir_index, NULL);
 		if (ret == -ENOMEM) {
 			/*
 			 * Orphan the new inode instead of aborting. The inode
@@ -6914,7 +6914,8 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
  */
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
-		   const struct fscrypt_str *name, bool add_backref, u64 index)
+		   const struct fscrypt_str *name, bool add_backref, u64 index,
+		   struct btrfs_dir_index_prealloc *prealloc)
 {
 	int ret = 0;
 	struct btrfs_key key;
@@ -6940,11 +6941,13 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	}
 
 	/* Nothing to clean up yet */
-	if (ret)
+	if (ret) {
+		btrfs_free_delayed_dir_index_prealloc(trans, prealloc);
 		return ret;
+	}
 
 	ret = btrfs_insert_dir_item(trans, name, parent_inode, &key,
-				    btrfs_inode_type(inode), index, NULL);
+				    btrfs_inode_type(inode), index, prealloc);
 	if (ret == -EEXIST || ret == -EOVERFLOW || ret == -ENOMEM)
 		goto fail_dir_item;
 	else if (unlikely(ret)) {
@@ -7098,7 +7101,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	inode_set_ctime_current(inode);
 
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
-			     &fname.disk_name, true, index);
+			     &fname.disk_name, true, index, NULL);
 	if (ret)
 		goto fail;
 
@@ -8512,14 +8515,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
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
@@ -8592,6 +8595,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	struct inode *new_inode = d_inode(new_dentry);
 	struct inode *old_inode = d_inode(old_dentry);
 	struct btrfs_rename_ctx rename_ctx;
+	struct btrfs_dir_index_prealloc *prealloc = NULL;
 	u64 index = 0;
 	int ret;
 	int ret2;
@@ -8715,6 +8719,24 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	if (ret)
 		goto out_fail;
 
+	/*
+	 * When not overwriting an existing entry, pre-allocate the delayed
+	 * dir index now so that ENOMEM is returned before any btree
+	 * modifications. For the overwrite case, too many btree changes
+	 * have already happened by the time btrfs_add_link() is called.
+	 */
+	if (!new_inode) {
+		prealloc = btrfs_prealloc_delayed_dir_index(
+				BTRFS_I(new_dir),
+				new_fname.disk_name.name,
+				new_fname.disk_name.len);
+		if (IS_ERR(prealloc)) {
+			ret = PTR_ERR(prealloc);
+			prealloc = NULL;
+			goto out_fail;
+		}
+	}
+
 	BTRFS_I(old_inode)->dir_index = 0ULL;
 	if (unlikely(old_ino == BTRFS_FIRST_FREE_OBJECTID)) {
 		/* force full log commit if subvolume involved. */
@@ -8810,7 +8832,8 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
-			     &new_fname.disk_name, false, index);
+			     &new_fname.disk_name, false, index, prealloc);
+	prealloc = NULL;
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
@@ -8835,6 +8858,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 		}
 	}
 out_fail:
+	btrfs_free_delayed_dir_index_prealloc(trans, prealloc);
 	if (logs_pinned) {
 		btrfs_end_log_trans(root);
 		btrfs_end_log_trans(dest);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7ba7b6098aa5..a043611f82e1 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -1683,7 +1683,7 @@ static noinline int add_inode_ref(struct walk_control *wc)
 			}
 
 			/* insert our name */
-			ret = btrfs_add_link(trans, dir, inode, &name, false, ref_index);
+			ret = btrfs_add_link(trans, dir, inode, &name, false, ref_index, NULL);
 			if (ret) {
 				btrfs_abort_log_replay(wc, ret,
 "failed to add link for inode %llu in dir %llu ref_index %llu name %.*s root %llu",
@@ -2031,7 +2031,7 @@ static noinline int insert_one_name(struct btrfs_trans_handle *trans,
 		return PTR_ERR(dir);
 	}
 
-	ret = btrfs_add_link(trans, dir, inode, name, true, index);
+	ret = btrfs_add_link(trans, dir, inode, name, true, index, NULL);
 
 	/* FIXME, put inode into FIXUP list */
 

-- 
2.55.0

