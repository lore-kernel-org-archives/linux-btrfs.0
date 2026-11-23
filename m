Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795461505;
	b=rpRlO+nMGsGnxxnQ2ht3nBS1igIxLiHap2eI/bzsnBWmXa7nPJvS/Pfwwd0U9l+1mLUo
	 DXYorgIbviUHjtc6LeXKX86QT28CcCJlxmUWgBa9bt+RyFnE+/ZJTznYfDNaa+ezrf+Ns
	 PPYEH71G+2Td6hc4dsI58ogmrzVJ9iMXzNiEyLhLM24pH4/MpO1+rQaYxeitXdj5u5Kxx
	 wLETI5xzbE7dsYkkzemZZMtdhFDyW4uDsImAMmC0x4qzEWkXImrjrgwGEJHjrqfwWBFyd
	 bVGf85yfbM6lfA+oO6ZEiLbyCelplmAhlxsjZq/LvtUDsurp92cMBZtx58trKu+E05Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795461505;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Gq3d/Hm+kzYA6KLXY0Mm0wJGUIT+RS/gB/blKA+GDa4=;
	b=pdByvyej69OQZ4UkJ2Mr88qKU6VaJyouCwSE5nQF9z+pGVi4GRdtGdMXvmXr2owZGkwG
	 NP9Rnri8hLp+r2TneMFvbREY/d5awcExJagk5sZibZURKVm2ific/JuBM8hzDXK1Uf/3l
	 o96ajymlt4BXCnijPdhhMrsrnkMxGnSJZULVdOzMuh2hd7q8cUxs3tkY5p3TYE5cL5UfU
	 3TzUIjk61C5b+ViivFTXa6ziNAuUaULjTu4fu13EpUEySyn0z1ZxitoqUdBEYK8C8YRbq
	 5YHxdhRftuRoXw59Zzv2hm6ZyWUz+HmsZlGQJNrNtXMTbp+fwRa/vVGcg87m7KTzAxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGndDvK3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB5A606A332
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 19:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eGndDvK3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A8D1F000CF
	for <linux-btrfs@vger.kernel.org>; Mon, 23 Nov 2026 19:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795461504;
	bh=Gq3d/Hm+kzYA6KLXY0Mm0wJGUIT+RS/gB/blKA+GDa4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=eGndDvK3LlgEd2ovXOLQOb6yyC+T7i5kolPVUjCzm+HYJFmY0jUS3vAulxbYqyDPl
	 x3av+b7JHKNOMyPJV2/0TWJbs6ApA2xPs53rqu+4SCBX/ewHaHaELEnHxHfHkB/dcX
	 VVZaXMjgCX8N9Bs1piSXUMb1L7OiCOk19vYhXnEsiPPGFWfyhbPgbHkB9FgSHTyJOR
	 awNk4K6H5jEmydw+kuvrqrzMos3tAPnU0q12wmNlUHDKdAqX/NQ6Skjmu00Bsh2jnU
	 71UEW4O38LjMiulR3GnN9S3Mu10y/5zDwl/fB8Ue0L+acLnVRU1s0FuntnJwM8JFjz
	 FAoDcCoV0zczw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: fix race between setting attributes and writeback with compress attempt
Date: Mon, 23 Nov 2026 19:18:18 +0000
Message-ID: <bd1f1a6c32bc00afea7ba59d8c56056f8c4787d2.1795461404.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <1a3e3bed8b8bb64943745a02167b68c3f41d38e0.1795376976.git.fdmanana@suse.com>
References: <1a3e3bed8b8bb64943745a02167b68c3f41d38e0.1795376976.git.fdmanana@suse.com>
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Post: <mailto:linux-btrfs@vger.kernel.org>
List-Help: <mailto:linux-btrfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-btrfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

When setting attributes (FS_IOC_SETFLAGS ioctl) we grab the inode's flags
into a local variable, make changes to the flags in the local variable and
then later assing the variable to the inode's flags member. This is all
done without any locking and therefore can race with a writeback that
attempts to compress data but falls back to uncompressed write since the
data is found incompressible, in which cases it sets the flag
BTRFS_INODE_NOCOMPRESS in the inode, also without any locking - this
happens in compress_file_range() under the 'mark_incompressible' label.
This leaves a time window where one task undoes what the other did:

  CPU 0 (ioctl)                   CPU 1 (Writeback)
  -------------                   -----------------
  btrfs_fileattr_set()
    inode_flags = inode->flags;
                                  compress_file_range()
                                    inode->flags |= BTRFS_INODE_NOCOMPRESS;
    inode->flags = inode_flags;

If CPU 0 updates inode->flags after CPU 1, it removes the flag
BTRFS_INODE_NOCOMPRESS from the inode, wasting CPU cycles on
incompressible data in the future.
Butif CPU 1's non-atomic update occurs last, it silently clobbers
the user's requested file attribute updates (chattr modifications).

Fix this by changing the ioctl to lock the inode's mmap semaphore, so
that no mmap writes can happen in parallel, and flush delalloc existing
delalloc, so that it can not race with writeback and no delalloc can
happen until it releases the mmap semaphore - the VFS's inode lock is
already held at the VFS level.

Link: https://sashiko.dev/#/bug/linux-249f973b-6e85-4fe0-80d5-5b42e7be3e22
Signed-off-by: Filipe Manana <fdmanana@suse.com>
---

V2: Use a different approach, to lock mmap semaphore and flush writeback
    so that it eleminates other races too (pointed by Sashiko).

 fs/btrfs/ioctl.c | 55 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 40 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 4271f7a6d48a..3de41987b5f5 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -284,7 +284,7 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	struct btrfs_inode *inode = BTRFS_I(d_inode(dentry));
 	struct btrfs_root *root = inode->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct btrfs_trans_handle *trans;
+	struct btrfs_trans_handle *trans = NULL;
 	unsigned int fsflags, old_fsflags;
 	int ret;
 	const char *comp = NULL;
@@ -297,15 +297,30 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	if (fileattr_has_fsx(fa))
 		return -EOPNOTSUPP;
 
+	/*
+	 * Lock the inode, flush delalloc and wait for any ordered extents
+	 * to complete. Otherwise a concurrent writeback could be modifying
+	 * the inode's flags (such as setting BTRFS_INODE_NOCOMPRESS when
+	 * dellaloc runs and we find the file's data is incompressible).
+	 * VFS already locked the inode's lock, so we only lock the mmap lock
+	 * to avoid races with mmap writes.
+	 */
+	btrfs_assert_inode_locked(inode);
+	down_write(&inode->i_mmap_lock);
+
+	ret = btrfs_wait_ordered_range(inode, 0, U64_MAX);
+	if (ret)
+		goto out;
+
 	fsflags = btrfs_mask_fsflags_for_type(&inode->vfs_inode, fa->flags);
 	old_fsflags = btrfs_inode_flags_to_fsflags(inode);
 	ret = check_fsflags(old_fsflags, fsflags);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = check_fsflags_compatible(fs_info, fsflags);
 	if (ret)
-		return ret;
+		goto out;
 
 	inode_flags = inode->flags;
 	if (fsflags & FS_SYNC_FL)
@@ -333,8 +348,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	if (!fa->flags_valid) {
 		/* 1 item for the inode */
 		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
 		goto update_flags;
 	}
 
@@ -383,8 +400,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	if (!((fsflags ^ old_fsflags) & (FS_COMPR_FL | FS_NOCOMP_FL))) {
 		/* 1 item for the inode */
 		trans = btrfs_start_transaction(root, 1);
-		if (IS_ERR(trans))
-			return PTR_ERR(trans);
+		if (IS_ERR(trans)) {
+			ret = PTR_ERR(trans);
+			goto out;
+		}
 		goto update_flags;
 	}
 
@@ -399,8 +418,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	} else if (fsflags & FS_COMPR_FL) {
 		enum btrfs_compression_type comp_type;
 
-		if (IS_SWAPFILE(&inode->vfs_inode))
-			return -ETXTBSY;
+		if (IS_SWAPFILE(&inode->vfs_inode)) {
+			ret = -ETXTBSY;
+			goto out;
+		}
 
 		inode_flags |= BTRFS_INODE_COMPRESS;
 		inode_flags &= ~BTRFS_INODE_NOCOMPRESS;
@@ -431,21 +452,23 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	 * 1 for property
 	 */
 	trans = btrfs_start_transaction(root, 2);
-	if (IS_ERR(trans))
-		return PTR_ERR(trans);
+	if (IS_ERR(trans)) {
+		ret = PTR_ERR(trans);
+		goto out;
+	}
 
 	if (comp) {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression",
 				     comp, strlen(comp), 0);
 		if (ret)
-			goto out_end_trans;
+			goto out;
 		prop_set = true;
 	} else {
 		ret = btrfs_set_prop(trans, inode, "btrfs.compression", NULL, 0, 0);
 		prop_set = (ret == 0);
 		/* If ret == -ENODATA ignore and proceed to update inode item. */
 		if (ret && ret != -ENODATA)
-			goto out_end_trans;
+			goto out;
 	}
 
 update_flags:
@@ -462,8 +485,10 @@ int btrfs_fileattr_set(const struct mnt_idmap *idmap,
 	if (unlikely(ret && prop_set))
 		btrfs_abort_transaction(trans, ret);
 
- out_end_trans:
-	btrfs_end_transaction(trans);
+out:
+	up_write(&inode->i_mmap_lock);
+	if (!IS_ERR_OR_NULL(trans))
+		btrfs_end_transaction(trans);
 	return ret;
 }
 
-- 
2.53.0

