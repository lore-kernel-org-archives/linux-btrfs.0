Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6789239E9A
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776278701; cv=none; b=ggaUQ9aP154Jh0SqeW5TPYCsWhMNURg6cwwOaU3d2rktP6wMUQTgLOuJK+Getwp1ru6SER7XwuaFbBiA9CcXTNrYK09Om1AJm8ToY5f7YWh7/6fGzYEi0D94fNKyvjzYII+22DpIdvRqvFG0vgMPBXk9tQjVyiMvCUJCENAVx40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776278701; c=relaxed/simple;
	bh=lTskhoaGJcLQ4yIpsR9t/fvKY6LJmnKnnotMtQbIxYA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdODuQy6sib2kOjUDbRk7EJQ99MsV1OFnjx3YkA+53ZonuTmX3bfuKe7tDgUAwgy9iOpyMxCEtIUN0H1au/A3Kt4qDhHLarLpFwESbQ3rsRXvt9JjKwT3v9Y+pr61XjdfnCN23xjUD34/4ZoCuq1bcDUKH8DzP8ut3yPL9WmhW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6vcWjoM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6vcWjoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222CFC2BCB4
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Apr 2026 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776278701;
	bh=lTskhoaGJcLQ4yIpsR9t/fvKY6LJmnKnnotMtQbIxYA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=L6vcWjoMwaGAuixJ+IAFIzq1uVVbfVzMh6QWrTX/ZWlMoRm/e9Fdaox2Yb5DmnNbh
	 p1IpLtUxgVRv74XwOjxImdOrYpCtna92u43A/XPciWJqyLZWX7QYjB8YgXyBBEdEOQ
	 icL0kAAWhp0GGaxgdh0O8PcjEOZOtRqMxmvQfiroFof2tRackwWidQkJt8dhcIhxDd
	 H0T09RmY63ISenJxuQOzCPT7lz7vWJ9DE8IAlP4c89Rzx6LPEdtbjwhj5Hqn93fetC
	 a2BBcQ8LlgdDXMq1L9DeaEKKdHLue9T+LLR7iCFXdhy6Sgchub37fzXHLwEyDwj713
	 ZPfkuQu8sZozA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 07/10] btrfs: remove op field from struct btrfs_free_space_ctl
Date: Wed, 15 Apr 2026 19:44:45 +0100
Message-ID: <f06ff7d3c1edd0576345ec8d66447e90f9235087.1776278490.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1776278490.git.fdmanana@suse.com>
References: <cover.1776278490.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The op field always points to the same use_bitmap function, the only
exception is during self tests where we make it temporarily point to a
different function. So just because of this op pointer field we are
increasing the structure size by 8 bytes.

Instead of storing a pointer to a use_bitmap function in struct
btrfs_free_space_ctl, move the pointer to struct btrfs_info, make
insert_into_bitmap() use that pointer if we are running the self tests
and initialize that pointer to the current, default use_bitmap function
(now exported for the tests as btrfs_use_bitmap). This way we reduce
the size of struct btrfs_free_space_ctl from 136 to 128 bytes and can
now fit 32 structures in a 4K page instead of 30. This also avoids the
cost of the indirection of a function pointer call when we are not
running the self tests.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/free-space-cache.c       | 24 +++++++++++-------------
 fs/btrfs/free-space-cache.h       |  8 ++------
 fs/btrfs/fs.h                     |  7 +++++++
 fs/btrfs/tests/btrfs-tests.c      |  1 +
 fs/btrfs/tests/free-space-tests.c | 24 ++++++++++--------------
 5 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 9b33f68f43ec..0d8bc55449b0 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -2257,7 +2257,8 @@ static u64 add_bytes_to_bitmap(struct btrfs_free_space_ctl *ctl,
 
 }
 
-static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
+EXPORT_FOR_TESTS
+bool btrfs_use_bitmap(struct btrfs_free_space_ctl *ctl,
 		      struct btrfs_free_space *info)
 {
 	struct btrfs_block_group *block_group = ctl->block_group;
@@ -2307,15 +2308,11 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
 	return true;
 }
 
-static const struct btrfs_free_space_op free_space_op = {
-	.use_bitmap		= use_bitmap,
-};
-
 static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 			      struct btrfs_free_space *info)
 {
 	struct btrfs_free_space *bitmap_info;
-	struct btrfs_block_group *block_group = NULL;
+	struct btrfs_block_group *block_group = ctl->block_group;
 	int added = 0;
 	u64 bytes, offset, bytes_added;
 	enum btrfs_trim_state trim_state;
@@ -2325,18 +2322,20 @@ static int insert_into_bitmap(struct btrfs_free_space_ctl *ctl,
 	offset = info->offset;
 	trim_state = info->trim_state;
 
-	if (!ctl->op->use_bitmap(ctl, info))
-		return 0;
-
-	if (ctl->op == &free_space_op)
-		block_group = ctl->block_group;
+	if (btrfs_is_testing(block_group->fs_info)) {
+		if (!block_group->fs_info->use_bitmap(ctl, info))
+			return 0;
+	} else {
+		if (!btrfs_use_bitmap(ctl, info))
+			return 0;
+	}
 again:
 	/*
 	 * Since we link bitmaps right into the cluster we need to see if we
 	 * have a cluster here, and if so and it has our bitmap we need to add
 	 * the free space to that bitmap.
 	 */
-	if (block_group && !list_empty(&block_group->cluster_list)) {
+	if (!list_empty(&block_group->cluster_list)) {
 		struct btrfs_free_cluster *cluster;
 		struct rb_node *node;
 		struct btrfs_free_space *entry;
@@ -2957,7 +2956,6 @@ void btrfs_init_free_space_ctl(struct btrfs_block_group *block_group,
 {
 	spin_lock_init(&ctl->tree_lock);
 	ctl->block_group = block_group;
-	ctl->op = &free_space_op;
 	ctl->free_space_bytes = RB_ROOT_CACHED;
 	INIT_LIST_HEAD(&ctl->trimming_ranges);
 	mutex_init(&ctl->cache_writeout_mutex);
diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
index c5d0f3e056cc..53fe8e293af1 100644
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -83,17 +83,11 @@ struct btrfs_free_space_ctl {
 	u64 free_space;
 	s32 discardable_extents[BTRFS_STAT_NR_ENTRIES];
 	s64 discardable_bytes[BTRFS_STAT_NR_ENTRIES];
-	const struct btrfs_free_space_op *op;
 	struct btrfs_block_group *block_group;
 	struct mutex cache_writeout_mutex;
 	struct list_head trimming_ranges;
 };
 
-struct btrfs_free_space_op {
-	bool (*use_bitmap)(struct btrfs_free_space_ctl *ctl,
-			   struct btrfs_free_space *info);
-};
-
 struct btrfs_io_ctl {
 	void *cur, *orig;
 	struct page *page;
@@ -170,6 +164,8 @@ bool btrfs_free_space_cache_v1_active(struct btrfs_fs_info *fs_info);
 int btrfs_set_free_space_cache_v1_active(struct btrfs_fs_info *fs_info, bool active);
 /* Support functions for running our sanity tests */
 #ifdef CONFIG_BTRFS_FS_RUN_SANITY_TESTS
+bool btrfs_use_bitmap(struct btrfs_free_space_ctl *ctl,
+		      struct btrfs_free_space *info);
 int test_add_free_space_entry(struct btrfs_block_group *cache,
 			      u64 offset, u64 bytes, bool bitmap);
 int test_check_exists(struct btrfs_block_group *cache, u64 offset, u64 bytes);
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 2c1626155645..64a4da4f7f42 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -485,6 +485,9 @@ struct btrfs_delayed_root {
 	wait_queue_head_t wait;
 };
 
+struct btrfs_free_space_ctl;
+struct btrfs_free_space;
+
 struct btrfs_fs_info {
 	u8 chunk_tree_uuid[BTRFS_UUID_SIZE];
 	unsigned long flags;
@@ -957,6 +960,10 @@ struct btrfs_fs_info {
 	spinlock_t eb_leak_lock;
 	struct list_head allocated_ebs;
 #endif
+
+	/* Used by self tests only. */
+	bool (*use_bitmap)(struct btrfs_free_space_ctl *ctl,
+			   struct btrfs_free_space *info);
 };
 
 #define folio_to_inode(_folio)	(BTRFS_I(_Generic((_folio),			\
diff --git a/fs/btrfs/tests/btrfs-tests.c b/fs/btrfs/tests/btrfs-tests.c
index 19c127ac6d10..6287d940323d 100644
--- a/fs/btrfs/tests/btrfs-tests.c
+++ b/fs/btrfs/tests/btrfs-tests.c
@@ -145,6 +145,7 @@ struct btrfs_fs_info *btrfs_alloc_dummy_fs_info(u32 nodesize, u32 sectorsize)
 	fs_info->csum_size = 4;
 	fs_info->csums_per_leaf = BTRFS_MAX_ITEM_SIZE(fs_info) /
 		fs_info->csum_size;
+	fs_info->use_bitmap = btrfs_use_bitmap;
 	set_bit(BTRFS_FS_STATE_DUMMY_FS_INFO, &fs_info->fs_state);
 
 	test_mnt->mnt_sb->s_fs_info = fs_info;
diff --git a/fs/btrfs/tests/free-space-tests.c b/fs/btrfs/tests/free-space-tests.c
index ebf68fcd2149..0425b3b68716 100644
--- a/fs/btrfs/tests/free-space-tests.c
+++ b/fs/btrfs/tests/free-space-tests.c
@@ -398,10 +398,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group *cache,
 	int ret;
 	u64 offset;
 	u64 max_extent_size;
-	const struct btrfs_free_space_op test_free_space_ops = {
-		.use_bitmap = test_use_bitmap,
-	};
-	const struct btrfs_free_space_op *orig_free_space_ops;
+	bool (*orig_use_bitmap)(struct btrfs_free_space_ctl *ctl,
+				struct btrfs_free_space *info);
 
 	test_msg("running space stealing from bitmap to extent tests");
 
@@ -423,8 +421,8 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group *cache,
 	 * that forces use of bitmaps as soon as we have at least 1
 	 * extent entry.
 	 */
-	orig_free_space_ops = cache->free_space_ctl->op;
-	cache->free_space_ctl->op = &test_free_space_ops;
+	orig_use_bitmap = cache->fs_info->use_bitmap;
+	cache->fs_info->use_bitmap = test_use_bitmap;
 
 	/*
 	 * Extent entry covering free space range [128Mb - 256Kb, 128Mb - 128Kb[
@@ -818,7 +816,7 @@ test_steal_space_from_bitmap_to_extent(struct btrfs_block_group *cache,
 	if (ret)
 		return ret;
 
-	cache->free_space_ctl->op = orig_free_space_ops;
+	cache->fs_info->use_bitmap = orig_use_bitmap;
 	btrfs_remove_free_space_cache(cache);
 
 	return 0;
@@ -832,10 +830,8 @@ static bool bytes_index_use_bitmap(struct btrfs_free_space_ctl *ctl,
 
 static int test_bytes_index(struct btrfs_block_group *cache, u32 sectorsize)
 {
-	const struct btrfs_free_space_op test_free_space_ops = {
-		.use_bitmap = bytes_index_use_bitmap,
-	};
-	const struct btrfs_free_space_op *orig_free_space_ops;
+	bool (*orig_use_bitmap)(struct btrfs_free_space_ctl *ctl,
+				struct btrfs_free_space *info);
 	struct btrfs_free_space_ctl *ctl = cache->free_space_ctl;
 	struct btrfs_free_space *entry;
 	struct rb_node *node;
@@ -892,8 +888,8 @@ static int test_bytes_index(struct btrfs_block_group *cache, u32 sectorsize)
 
 	/* Now validate bitmaps with different ->max_extent_size. */
 	btrfs_remove_free_space_cache(cache);
-	orig_free_space_ops = cache->free_space_ctl->op;
-	cache->free_space_ctl->op = &test_free_space_ops;
+	orig_use_bitmap = cache->fs_info->use_bitmap;
+	cache->fs_info->use_bitmap = bytes_index_use_bitmap;
 
 	ret = test_add_free_space_entry(cache, 0, sectorsize, 1);
 	if (ret) {
@@ -997,7 +993,7 @@ static int test_bytes_index(struct btrfs_block_group *cache, u32 sectorsize)
 		return -EINVAL;
 	}
 
-	cache->free_space_ctl->op = orig_free_space_ops;
+	cache->fs_info->use_bitmap = orig_use_bitmap;
 	btrfs_remove_free_space_cache(cache);
 	return 0;
 }
-- 
2.47.2

