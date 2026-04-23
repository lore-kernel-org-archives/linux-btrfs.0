Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6CF3806D8
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 11:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776944376; cv=none; b=tx3r5FOrCm2+XZ3ZE3V6BIh6u/v3a+QtIrHskw5Ei13T5GS7OJcUpX+vYFRUzAWRTqZ0cT78QeFvc/lN9a88HEJg7864KeKryMG+wLJWFYGosECp+gxK5T7D0dJcJ9h+4uA1H5xhJwQEMkUeTG8+6c3t+rhf3qNNzXufoUUFQfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776944376; c=relaxed/simple;
	bh=QrT7sxutPTuKEhIjT59sQEf2yLIJF6OC6I0UpuOaKto=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QtOFKMCJEzPwtCzR9Qcgvq3oIEPEZDqnlGS5Tm07/N4a80rG+mofm4ildoYeEgoTuFdNlWw5+zngG4T35TIhLujPlg0tJL5K9wupr0WiCZ2FXYfRnEZjwToJaX4voADdhy/c4zbOWHg2NaKb10nbesIYt3tLflusaA0hrL770jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sv3KDkp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sv3KDkp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE6D5C2BCAF
	for <linux-btrfs@vger.kernel.org>; Thu, 23 Apr 2026 11:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776944376;
	bh=QrT7sxutPTuKEhIjT59sQEf2yLIJF6OC6I0UpuOaKto=;
	h=From:To:Subject:Date:From;
	b=Sv3KDkp2xIyGUMEvHFXJ9NjlSsIAqi/Wrcuyv/RF7e8qWOteCkruiH0TdRcD6FN3C
	 EBBwE8K9TRkdPHQmHJd8wQeu41Tj4zMWpi6BHQUH68yE/4EF7u+641ulbK/oNDVaF/
	 LE6j6edaAsctVl20Anc+wmh/3m0Ypv6BDb+WZSTyB7qcO44h+RMAAXPrx/YDLf8Pp6
	 2U6JZyISwmFW3DTSqazRLuxLAHwA2GGmhYue3G8kq1hSaUSLaAhmjz0460GMkWs5xn
	 kfzq/MJq+gLlro6lauvM6sUPDhZmECnq0bWlBfLGqSZ2+LFs7bQzwZXQiyuwrtDvyO
	 WMfTcypVnLZnA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: add missing unlikely to if branches leading to a DEBUG_WARN()
Date: Thu, 23 Apr 2026 12:39:33 +0100
Message-ID: <3eb99befd57ed1a4df3c6d52b426bed2c5b2f1c5.1776944354.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

If statement branches that lead to a DEBUG_WARN() are unexpected to happen
and in most places we surround their expressions with the unlikely tag,
however a few places are missing. Add the unlikely tag to those missing
places to make it explicit to a reader that it's not expected and to allow
a compiler to generate better code.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/block-group.c     |  2 +-
 fs/btrfs/disk-io.c         |  2 +-
 fs/btrfs/extent-tree.c     |  2 +-
 fs/btrfs/free-space-tree.c |  2 +-
 fs/btrfs/inode.c           |  2 +-
 fs/btrfs/qgroup.c          | 16 ++++++++--------
 fs/btrfs/volumes.c         |  8 ++++----
 7 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 015603070143..a0cb0db68c9a 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4117,7 +4117,7 @@ int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type)
 	struct btrfs_space_info *space_info;
 
 	space_info = btrfs_find_space_info(trans->fs_info, type);
-	if (!space_info) {
+	if (unlikely(!space_info)) {
 		DEBUG_WARN();
 		return -EINVAL;
 	}
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c67faf61ed9a..2020351e715b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -4398,7 +4398,7 @@ void __cold close_ctree(struct btrfs_fs_info *fs_info)
 	ASSERT(list_empty(&fs_info->delayed_iputs));
 	set_bit(BTRFS_FS_CLOSING_DONE, &fs_info->flags);
 
-	if (btrfs_check_quota_leak(fs_info)) {
+	if (unlikely(btrfs_check_quota_leak(fs_info))) {
 		DEBUG_WARN("qgroup reserved space leaked");
 		btrfs_err(fs_info, "qgroup reserved space leaked");
 	}
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 420d52b097d9..ecc1acb1e340 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6655,7 +6655,7 @@ static int btrfs_trim_free_extents_throttle(struct btrfs_device *device,
 		start = max(start, cur_start);
 
 		/* Check if there are any CHUNK_* bits left */
-		if (start > device->total_bytes) {
+		if (unlikely(start > device->total_bytes)) {
 			DEBUG_WARN();
 			btrfs_warn(fs_info,
 "ignoring attempt to trim beyond device size: offset %llu length %llu device %s device size %llu",
diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index 472b3060e5ac..556622625412 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -109,7 +109,7 @@ struct btrfs_free_space_info *btrfs_search_free_space_info(
 	ret = btrfs_search_slot(trans, root, &key, path, 0, cow);
 	if (ret < 0)
 		return ERR_PTR(ret);
-	if (ret != 0) {
+	if (unlikely(ret != 0)) {
 		btrfs_warn(fs_info, "missing free space info for %llu",
 			   block_group->start);
 		DEBUG_WARN();
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 059e78ae248f..54ab104195ec 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -806,7 +806,7 @@ static inline int inode_need_compress(struct btrfs_inode *inode, u64 start,
 {
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
-	if (!btrfs_inode_can_compress(inode)) {
+	if (unlikely(!btrfs_inode_can_compress(inode))) {
 		DEBUG_WARN("BTRFS: unexpected compression for ino %llu", btrfs_ino(inode));
 		return 0;
 	}
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cdf736d3a4e5..0511b6dc72b0 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -1836,9 +1836,9 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	 * Thus its reserved space should all be zero, no matter if qgroup
 	 * is consistent or the mode.
 	 */
-	if (qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] ||
-	    qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] ||
-	    qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS]) {
+	if (unlikely(qgroup->rsv.values[BTRFS_QGROUP_RSV_DATA] ||
+		     qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PREALLOC] ||
+		     qgroup->rsv.values[BTRFS_QGROUP_RSV_META_PERTRANS])) {
 		DEBUG_WARN();
 		btrfs_warn_rl(fs_info,
 "to be deleted qgroup %u/%llu has non-zero numbers, data %llu meta prealloc %llu meta pertrans %llu",
@@ -1857,8 +1857,8 @@ int btrfs_remove_qgroup(struct btrfs_trans_handle *trans, u64 qgroupid)
 	 */
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_FULL &&
 	    !(fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT)) {
-		if (qgroup->rfer || qgroup->excl ||
-		    qgroup->rfer_cmpr || qgroup->excl_cmpr) {
+		if (unlikely(qgroup->rfer || qgroup->excl ||
+			     qgroup->rfer_cmpr || qgroup->excl_cmpr)) {
 			DEBUG_WARN();
 			qgroup_mark_inconsistent(fs_info,
 				"to be deleted qgroup %u/%llu has non-zero numbers, rfer %llu rfer_cmpr %llu excl %llu excl_cmpr %llu",
@@ -4800,9 +4800,9 @@ int btrfs_qgroup_add_swapped_blocks(struct btrfs_root *subvol_root,
 
 		entry = rb_entry(node, struct btrfs_qgroup_swapped_block, node);
 
-		if (entry->subvol_generation != block->subvol_generation ||
-		    entry->reloc_bytenr != block->reloc_bytenr ||
-		    entry->reloc_generation != block->reloc_generation) {
+		if (unlikely(entry->subvol_generation != block->subvol_generation ||
+			     entry->reloc_bytenr != block->reloc_bytenr ||
+			     entry->reloc_generation != block->reloc_generation)) {
 			/*
 			 * Duplicated but mismatch entry found.  Shouldn't happen.
 			 * Marking qgroup inconsistent should be enough for end
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 0dd86589ed0f..579c6a116710 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6081,7 +6081,7 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 
 	lockdep_assert_held(&info->chunk_mutex);
 
-	if (!alloc_profile_is_valid(type, 0)) {
+	if (unlikely(!alloc_profile_is_valid(type, 0))) {
 		DEBUG_WARN("invalid alloc profile for type %llu", type);
 		return ERR_PTR(-EINVAL);
 	}
@@ -6092,7 +6092,7 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 		return ERR_PTR(-ENOSPC);
 	}
 
-	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
+	if (unlikely(!(type & BTRFS_BLOCK_GROUP_TYPE_MASK))) {
 		btrfs_err(info, "invalid chunk type 0x%llx requested", type);
 		DEBUG_WARN();
 		return ERR_PTR(-EINVAL);
@@ -6262,7 +6262,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans)
 
 	alloc_profile = btrfs_metadata_alloc_profile(fs_info);
 	meta_space_info = btrfs_find_space_info(fs_info, alloc_profile);
-	if (!meta_space_info) {
+	if (unlikely(!meta_space_info)) {
 		DEBUG_WARN();
 		return -EINVAL;
 	}
@@ -6272,7 +6272,7 @@ static noinline int init_first_rw_device(struct btrfs_trans_handle *trans)
 
 	alloc_profile = btrfs_system_alloc_profile(fs_info);
 	sys_space_info = btrfs_find_space_info(fs_info, alloc_profile);
-	if (!sys_space_info) {
+	if (unlikely(!sys_space_info)) {
 		DEBUG_WARN();
 		return -EINVAL;
 	}
-- 
2.47.2

