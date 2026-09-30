Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CC336196E
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783264; cv=none; b=KxKbaJyZibFlLhJApaGflOpJyEebQBU3/sSkpYZ8sqa7Er0iydTXQQYz8uC0asNPr9YFBvQ7WiNh0fYdsnYDafZRBPWviqzpkX5/Alwn4d5eK4o70IasTvNpmZc4zEoq4b7uIGtzwbo7SILIua+1FQ6sCHdxnP4FtupQ8UlelhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783264; c=relaxed/simple;
	bh=cDAIINgrSlyBLNgN7/kI8mWK08BdGqTRzY+Cpe6Ir4o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nKBeTybBzAmnquN9qSv1GTY6w3kkKYaE50xqVW5NhmzkXjhpd2yRBQ1fb75DIFjMQs9ZUVf21s6Tm1TTn0YGkqm0dasNXKiD1Z8mozD3t2wkdIpvdoAmgjlKxuomq5SsPK0zWM+sdFxI9e780WWFKS1F8l/bDhUdGE1CwipM+do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A7AK7iUJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A7AK7iUJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74BB1F0089A
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Sep 2026 15:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790783260;
	bh=rMFLl+TNTI3ZykB0tvKpTc65xRXh1GKPB1D5T1uY4MM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=A7AK7iUJeFdFD7Umx5A+3foy8olSyTOUUJ7DiYLjEJSpDPPhI41zLrB1+Khevj+Od
	 gaklQngU8ScSmnimorjFG8sE1LSN4TAKhBg+Ync7QWb7dpyem5WT0c4Yr1HVv9uLTj
	 6u6JDB1exl+iB2xeC4+fEUAjxoyy2yBVa/0FtD6mE4brnyo/7LdRA5ojY+ifER8WyH
	 xjfymbhU1RSt15fgq0Ofxy5bZzVgt3XAMYOTzrERQ1RMe/I2FYmtx0hxhegof69qaZ
	 qOsc5tk3l/eWiPDQfdknvznA6s1ocEl/rF7j3knT++j5myloDFC90ghgvYTljnl/Wp
	 Mhk/9PZmdkUSQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 1/3] btrfs: remove fs_info argument from btrfs_block_rsv_add()
Date: Wed, 30 Sep 2026 16:47:34 +0100
Message-ID: <ffdf6cb7991afb428e0443527713a974d960ad96.1790783086.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790783086.git.fdmanana@suse.com>
References: <cover.1790783086.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The fs_info argument is not used, so remove it.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c   | 5 ++---
 fs/btrfs/block-rsv.c     | 3 +--
 fs/btrfs/block-rsv.h     | 3 +--
 fs/btrfs/delayed-inode.c | 3 +--
 fs/btrfs/props.c         | 3 +--
 fs/btrfs/relocation.c    | 2 +-
 fs/btrfs/root-tree.c     | 3 +--
 fs/btrfs/transaction.c   | 3 +--
 8 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index c148b9d6e597..8ff21dde9a46 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4613,9 +4613,8 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 	if (ret && need_system_chunk)
 		return;
 
-	ret = btrfs_block_rsv_add(fs_info,
-				    &fs_info->chunk_block_rsv,
-				    bytes, BTRFS_RESERVE_NO_FLUSH);
+	ret = btrfs_block_rsv_add(&fs_info->chunk_block_rsv, bytes,
+				  BTRFS_RESERVE_NO_FLUSH);
 	if (!ret)
 		trans->chunk_bytes_reserved += bytes;
 }
diff --git a/fs/btrfs/block-rsv.c b/fs/btrfs/block-rsv.c
index c68a8f4b7d19..ecbf66d6cc73 100644
--- a/fs/btrfs/block-rsv.c
+++ b/fs/btrfs/block-rsv.c
@@ -209,8 +209,7 @@ void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
 	kfree(rsv);
 }
 
-int btrfs_block_rsv_add(struct btrfs_fs_info *fs_info,
-			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
+int btrfs_block_rsv_add(struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			enum btrfs_reserve_flush_enum flush)
 {
 	int ret;
diff --git a/fs/btrfs/block-rsv.h b/fs/btrfs/block-rsv.h
index 8359fb96bc3c..992272a01964 100644
--- a/fs/btrfs/block-rsv.h
+++ b/fs/btrfs/block-rsv.h
@@ -69,8 +69,7 @@ void btrfs_init_metadata_block_rsv(struct btrfs_fs_info *fs_info,
 				   enum btrfs_rsv_type type);
 void btrfs_free_block_rsv(struct btrfs_fs_info *fs_info,
 			  struct btrfs_block_rsv *rsv);
-int btrfs_block_rsv_add(struct btrfs_fs_info *fs_info,
-			struct btrfs_block_rsv *block_rsv, u64 num_bytes,
+int btrfs_block_rsv_add(struct btrfs_block_rsv *block_rsv, u64 num_bytes,
 			enum btrfs_reserve_flush_enum flush);
 int btrfs_block_rsv_check(struct btrfs_block_rsv *block_rsv, int min_percent);
 int btrfs_block_rsv_refill(struct btrfs_fs_info *fs_info,
diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 1f20148c1fd4..333ce8b52489 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -600,8 +600,7 @@ static int btrfs_delayed_inode_reserve_metadata(
 		ret = btrfs_qgroup_reserve_meta_prealloc(root, num_bytes, true, true);
 		if (ret < 0)
 			return ret;
-		ret = btrfs_block_rsv_add(fs_info, dst_rsv, num_bytes,
-					  BTRFS_RESERVE_NO_FLUSH);
+		ret = btrfs_block_rsv_add(dst_rsv, num_bytes, BTRFS_RESERVE_NO_FLUSH);
 		/* NO_FLUSH could only fail with -ENOSPC */
 		ASSERT(ret == 0 || ret == -ENOSPC);
 		if (ret)
diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c
index bb77d46376d4..7cc82366a1df 100644
--- a/fs/btrfs/props.c
+++ b/fs/btrfs/props.c
@@ -440,8 +440,7 @@ int btrfs_inode_inherit_props(struct btrfs_trans_handle *trans,
 		 */
 		if (need_reserve) {
 			num_bytes = btrfs_calc_insert_metadata_size(fs_info, 1);
-			ret = btrfs_block_rsv_add(fs_info, trans->block_rsv,
-						  num_bytes,
+			ret = btrfs_block_rsv_add(trans->block_rsv, num_bytes,
 						  BTRFS_RESERVE_NO_FLUSH);
 			if (ret)
 				return ret;
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index da54db75e7a9..b7de08c7e9e2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -1795,7 +1795,7 @@ int prepare_to_merge(struct reloc_control *rc, int err)
 again:
 	if (!err) {
 		num_bytes = rc->merging_rsv_size;
-		ret = btrfs_block_rsv_add(fs_info, rc->block_rsv, num_bytes,
+		ret = btrfs_block_rsv_add(rc->block_rsv, num_bytes,
 					  BTRFS_RESERVE_FLUSH_ALL);
 		if (ret)
 			err = ret;
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 2e4c3efbd02f..524210671ec4 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -510,8 +510,7 @@ int btrfs_subvolume_reserve_metadata(struct btrfs_root *root,
 	num_bytes = btrfs_calc_insert_metadata_size(fs_info, items);
 	rsv->space_info = btrfs_find_space_info(fs_info,
 					    BTRFS_BLOCK_GROUP_METADATA);
-	ret = btrfs_block_rsv_add(fs_info, rsv, num_bytes,
-				  BTRFS_RESERVE_FLUSH_ALL);
+	ret = btrfs_block_rsv_add(rsv, num_bytes, BTRFS_RESERVE_FLUSH_ALL);
 
 	if (ret == -ENOSPC && use_global_rsv)
 		ret = btrfs_block_rsv_migrate(global_rsv, rsv, num_bytes, true);
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index cc71ad8f5e82..da4ffa7bda00 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1767,8 +1767,7 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	btrfs_reloc_pre_snapshot(pending, &to_reserve);
 
 	if (to_reserve > 0) {
-		pending->error = btrfs_block_rsv_add(fs_info,
-						     &pending->block_rsv,
+		pending->error = btrfs_block_rsv_add(&pending->block_rsv,
 						     to_reserve,
 						     BTRFS_RESERVE_NO_FLUSH);
 		if (unlikely(pending->error))
-- 
2.47.2

