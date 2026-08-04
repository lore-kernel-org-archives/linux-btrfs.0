Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7BE46D55C;
	Tue,  4 Aug 2026 15:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785858296; cv=none; b=us/aXEq0nmRnaCi9qs9MYyqd1yhRZaULGEES/BJ0zmGRXbp4tnxuk3vrXODzDcWA1BjglMjsF9hwCi6BrhXn0ijpYH78746LsQ8nZHAZIvHwdGB8tB2nRRe+4H023qkocYGI3nlc7MffFU4DERKgcTbW0ZOTL2DwaGgFdtx1dQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785858296; c=relaxed/simple;
	bh=tehTwQbwPDfz4Sc6CDZyu6UtOWqk+hSO5jmEuNuZDpU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jzc6DoLmvHAsGfXhZEe4BpCzqbXjnNdDR0AopL6uFMtbu2XGHUH5vFU36ti5IdYLOyxycSy7czUGU3PXoOjtYxio82yjHN14Q9KB+DeXM1P1YxjMWdPf/iJjci2MK4HZqi8mHZ9vPuVVne0lv7cGdcaREx0IuoLl/bGgL6tHKbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VCVnb8yO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VCVnb8yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F851F00ACA;
	Tue,  4 Aug 2026 15:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785858292;
	bh=PPPazqAQRZNPvNq+6vbzaaoTW9rB8N91g5P3iAp90dI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VCVnb8yO5A9lw7ciWixWq0GyVVjXsV7UvedlQDTQGPlyWGOjiDifvrWWmsM04vEav
	 MrcMgWglHR0EkI4ngb3zX3+x5yJNVznie4G5hRt41gpY80anTm86Ym0Q5SWVzPbcRe
	 9sOweSQcOcYF79SkRzz3DO54Ao9v1vMQRNhYySXvAq8J49ASTMM9qACkUgWAYZy8vz
	 qgELHw138ANJrqpwN1f3iSofytSNeqzN9qTjvt48/2APvReEH45MwijiCa50/DzhZG
	 v3QODXa4johTMhLgGC3ZmbrWLZoczBQJouS962lqiPvDO3D5IrnCocmAaDCE7dgnGE
	 UXQ+vKvmzkmjw==
From: Jeff Layton <jlayton@kernel.org>
Date: Tue, 04 Aug 2026 11:44:37 -0400
Subject: [PATCH v2 5/5] btrfs: pre-allocate delayed dir index for
 non-overwrite rename
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260804-btrfs-enomem-v2-5-4d923170e8c1@kernel.org>
References: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
In-Reply-To: <20260804-btrfs-enomem-v2-0-4d923170e8c1@kernel.org>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@fb.com, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7224; i=jlayton@kernel.org;
 h=from:subject:message-id; bh=tehTwQbwPDfz4Sc6CDZyu6UtOWqk+hSO5jmEuNuZDpU=;
 b=kA0DAAoBAA5oQRlWghUByyZiAGpyCO+hScPaI5RegKBepbB37CjowDQi3PJwAmJOB4sZrcshQ
 4kCMwQAAQoAHRYhBEvA17JEcbKhhOr10wAOaEEZVoIVBQJqcgjvAAoJEAAOaEEZVoIVPHMP/RZ0
 mQ7ru2Gh3uhcXkGIwAH4A4bYTvjUCN8ed1vb6RDkGBv/VbEwnv/sf9oV7nyao/coq9q8GptwzJj
 P9GgRbZEOz+eeb/oMpimG3SNSaEM5o9zlhFXdRBqvkp9NYJt44j7APgUpuB9ytE+hg9g68iylWL
 3N6M62W3Hxq8qQq3xGXN7EypVO4qi8qDffd4vPkzkI2KRr5l3NVYpbsySSdgYwiw4wMfydtyYp9
 24Up30Ld6+S3t3n65EoMtngIPkD/uFC3BsDSa+IP9TdV85w7MsSXWXWYTd6eu/zU0llG1iFrSGI
 GMgBtJkFBfi9q89PntPaYvylA9/AHjbN1qG3fmLJhGBS6uhgX0fAlZSQXqMv9jz6+UaLhs8PupQ
 4wNuDwWQ7zIo2bu8/OvlfbEiHZmB6NRDYj/1w5kWRN+Il+O058QrOyMyFq1hIhvFgIm9xHUaPgU
 6IMnoDcq0XMghz9keqJvcNxHi/ILYoNPmYzORqD4VXX6rgaz/gnS1f5AQ6BRh61uIngeiT4RRty
 /AatcqEPok9St8bkyjMtNt5gcl05eDb3EyOT3/SvTmJfmnzdSmJ0iLTPD80Fr3KGRO0EFa6ripx
 QLFzE5HKPHgI7Fa3yIGzx9qGVi9pwB9jAxx2adUQQ1IZJWGBzcxt99XMoDVFlb+4rJOB9gkoVmA
 2gaAd
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
index 99e990c592f6..9f6a631d83a3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6862,7 +6862,7 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 		}
 	} else {
 		ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode), name,
-				     false, BTRFS_I(inode)->dir_index);
+				     false, BTRFS_I(inode)->dir_index, NULL);
 		if (ret == -ENOMEM) {
 			clear_nlink(inode);
 			/*
@@ -6904,7 +6904,8 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
  */
 int btrfs_add_link(struct btrfs_trans_handle *trans,
 		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
-		   const struct fscrypt_str *name, bool add_backref, u64 index)
+		   const struct fscrypt_str *name, bool add_backref, u64 index,
+		   struct btrfs_dir_index_prealloc *prealloc)
 {
 	int ret = 0;
 	struct btrfs_key key;
@@ -6930,11 +6931,14 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
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
@@ -7088,7 +7092,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
 	inode_set_ctime_current(inode);
 
 	ret = btrfs_add_link(trans, BTRFS_I(dir), BTRFS_I(inode),
-			     &fname.disk_name, true, index);
+			     &fname.disk_name, true, index, NULL);
 	if (ret)
 		goto fail;
 
@@ -8502,14 +8506,14 @@ static int btrfs_rename_exchange(struct inode *old_dir,
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
@@ -8582,6 +8586,7 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	struct inode *new_inode = d_inode(new_dentry);
 	struct inode *old_inode = d_inode(old_dentry);
 	struct btrfs_rename_ctx rename_ctx;
+	struct btrfs_dir_index_prealloc prealloc = { };
 	u64 index = 0;
 	int ret;
 	int ret2;
@@ -8705,6 +8710,24 @@ static int btrfs_rename(struct mnt_idmap *idmap,
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
@@ -8800,7 +8823,9 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 	}
 
 	ret = btrfs_add_link(trans, BTRFS_I(new_dir), BTRFS_I(old_inode),
-			     &new_fname.disk_name, false, index);
+			     &new_fname.disk_name, false, index,
+			     prealloc.item ? &prealloc : NULL);
+	prealloc.item = NULL;
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
 		goto out_fail;
@@ -8825,6 +8850,8 @@ static int btrfs_rename(struct mnt_idmap *idmap,
 		}
 	}
 out_fail:
+	if (prealloc.item)
+		btrfs_free_delayed_dir_index_prealloc(trans, &prealloc);
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

