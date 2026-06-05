Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE4C3446B9
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780677523; cv=none; b=ncBUOJOkPL7KLaFck4QY9OyTy6WdH9q80XFB9/sm/qjZdJqksXbnBwCr4LzTGqBvde7YqnVWrX1HiysnDPdxnKSzXXrPT7CtfiwrMuChiKwaoLux3Fqkqm7cqb6UEpZz2tKYG6SI3lz0XkVyy/1eqwEgqMrznzdRRhvnYXY9/34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780677523; c=relaxed/simple;
	bh=dvogrUyZLM0M+LETzE+DTZR/3PXclgX7rg6wTbLBE0c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GdJa/8wiQ1ud++Jno59Pvvy8zpryH07XMQNDiZoyRF3UMig6x6/J+r/kclGvHeSKvJdr8lJz2dp8XlmttPMWc8r1txBwD+ggYHK24Qvi4twBToNguTP4qhE3CUoVEo4IAcdJSDC+0cFE69wvg8DqvKD2jOMYUjCIi+er/q2Kn4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WonE/n3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WonE/n3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4940C1F00893
	for <linux-btrfs@vger.kernel.org>; Fri,  5 Jun 2026 16:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780677521;
	bh=sxxmBnUAPM+Fz6tJS1nGmaM0OUCLa9gOSY/qA8C6FDw=;
	h=From:To:Subject:Date;
	b=WonE/n3/47F/keUpR5M8xj2Nm3ZDrOLF4APUHMYcE1sxtRaZ0YTYi27GI2LFszUv1
	 y1jTg8sPhJQP8DFWinEfUAJi7HrjQKv2L3xaRN1CX/k0rYdgQzaY+tXpBg7s2Wtpl/
	 l4wZtRBXD+w5zs/bAY8n/bPQ+aTco1spXbILZ3ClY78XLy8Xe4ZFm6epTEfCpoz4kx
	 pho55aMlQobcnEAMXZ2+pP7lkKVvHC3T8H7XmuVVIt+rLYpAME7YlxaegHEuZOrsae
	 NAVMBYKry3zzIsotSr1BKv9QSyw5jfEjRaScV3fcpi+IyFhZabcHEDEwoC3CX0dI4T
	 JzH8UdREKTMYQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: move locking into btrfs_get_reloc_bg_bytenr()
Date: Fri,  5 Jun 2026 17:38:39 +0100
Message-ID: <c492fc55bfc660b3638fbf8ed2f7eaf5e8b06f16.1780677506.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

It does not make sense for the single caller to have the responsability
to lock the relocation mutex before calling the function and then have
the function to assert the lock is held. As this is a function in
relocation.c, move the locking details into it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/inode.c      | 2 --
 fs/btrfs/relocation.c | 7 ++++---
 fs/btrfs/relocation.h | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3c66853276b7..4a2f7ab39963 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -226,9 +226,7 @@ static void print_data_reloc_error(const struct btrfs_inode *inode, u64 file_off
 	u32 item_size;
 	int ret;
 
-	mutex_lock(&fs_info->reloc_mutex);
 	logical = btrfs_get_reloc_bg_bytenr(fs_info);
-	mutex_unlock(&fs_info->reloc_mutex);
 
 	if (logical == U64_MAX) {
 		btrfs_warn_rl(fs_info, "has data reloc tree but no running relocation");
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1af5d0d67af3..9771975dae99 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5905,14 +5905,15 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
  *
  * Return U64_MAX if no running relocation.
  */
-u64 btrfs_get_reloc_bg_bytenr(const struct btrfs_fs_info *fs_info)
+u64 btrfs_get_reloc_bg_bytenr(struct btrfs_fs_info *fs_info)
 {
 	u64 logical = U64_MAX;
 
-	lockdep_assert_held(&fs_info->reloc_mutex);
-
+	mutex_lock(&fs_info->reloc_mutex);
 	if (fs_info->reloc_ctl && fs_info->reloc_ctl->block_group)
 		logical = fs_info->reloc_ctl->block_group->start;
+	mutex_unlock(&fs_info->reloc_mutex);
+
 	return logical;
 }
 
diff --git a/fs/btrfs/relocation.h b/fs/btrfs/relocation.h
index d647823b5d13..bb7a86e7dbe3 100644
--- a/fs/btrfs/relocation.h
+++ b/fs/btrfs/relocation.h
@@ -41,7 +41,7 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 int btrfs_should_cancel_balance(const struct btrfs_fs_info *fs_info);
 struct btrfs_root *find_reloc_root(struct btrfs_fs_info *fs_info, u64 bytenr);
 bool btrfs_should_ignore_reloc_root(const struct btrfs_root *root);
-u64 btrfs_get_reloc_bg_bytenr(const struct btrfs_fs_info *fs_info);
+u64 btrfs_get_reloc_bg_bytenr(struct btrfs_fs_info *fs_info);
 int btrfs_translate_remap(struct btrfs_fs_info *fs_info, u64 *logical, u64 *length);
 int btrfs_remove_extent_from_remap_tree(struct btrfs_trans_handle *trans,
 					struct btrfs_path *path,
-- 
2.47.2

