Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05EF8248B
	for <linux-btrfs@vger.kernel.org>; Tue, 29 Sep 2026 00:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790641246; cv=none; b=q0eizGz/PVVcWPmKIGaSyL58b1jAeB8QWg3+c083TIIkraZkoW/v5dE90zXQEbOjPRpoZ9ZR7vEeA4CXmZSveMkGo/qHRq59HlnBvreuFFutRGqPdeLypB5ZDTgD+Sp5hZ51iBv1/y2QEKpnhKCd3f7hm29S00II564RDM6uXd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790641246; c=relaxed/simple;
	bh=vCSnSeGqrkM1zRIzOHwPX/jBxCWJAQbKkSEZU+h0cPg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQvfVuLo4LZtOz471AmdQNxXXRkeTAdpfpH1ZSwMQaiWGvC6C4ci33WEm4gbXDKw9QytbCKZvYeb49qKUzSyMCujziqnXdBGMIOP+DqRTUu94muB7AxCtI0iQBlbDVwjMbnr9ati7GDpYH3ticxj/TAx5v1AjdhXPDTUFiPfZ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io; spf=pass smtp.mailfrom=bur.io; dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b=L1LPk8NY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=EJmSWwcR; arc=none smtp.client-ip=103.168.172.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bur.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bur.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bur.io header.i=@bur.io header.b="L1LPk8NY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="EJmSWwcR"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id A92191400083;
	Mon, 28 Sep 2026 20:20:43 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Mon, 28 Sep 2026 20:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
	:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1790641243; x=
	1790727643; bh=eOeMftMYr2BZosYsEOxdQC+cQ8xAk8Ed2EIEuSjwDOU=; b=L
	1LPk8NY35s5WNtNNppClORlDeXIxRPFeQU67qL5O/ufDfpEWDW6Y63A3v57RTBJE
	Ll44Oqs+Qv7EA8zSHGIzHUEXEFlmiB2If9GCQyvtB8lxVdcG0SvvIaiLvWG1P4DR
	w8oPxiRygdbBD5SAjVbPXzbwb4N80fLGp1RBcPySWNNk1QRmX8nbsfJZMU0r1JZE
	MmNTnBr21LZWovzlQZPZw9q+oPDJokFUWe3WK0Nci6Zq9JFUn4OuNJEcRFoyfEWx
	5AZGLvRMGnZ/A6MKAiJiAt3IW1Qm6gS5N5BwEi0cPuSLpzgbQEp447LUqsL+O0rc
	JzliL4RXxddgecnS19Zlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:date:feedback-id:feedback-id:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm1; t=1790641243; x=1790727643; bh=eOeMftMYr2BZosYsEOxdQC+cQ8xA
	k8Ed2EIEuSjwDOU=; b=EJmSWwcRLToh+53LRlHm5FpjRo2tsFczVmwhmoRG3feq
	lLKQs9GR6V6o9EZpazYy4BeWde6E2dKxnhoeNQgPc6aubJsu3rIU/YeVP38X2SwM
	MdW6Fn5s74TOvSw1PBDe7yel5Vt2UOK4Xk44uZm9+q+jiBfdpJRzLn7xUjEiDYE4
	RQRJ15cBJ7+mqKN4qsYGYNc7M+4sA26uGeNWQhuxh9rCDorxn7OS9iFoV3QQ2yGC
	Zi0wXe1CKJIItu8L6zJxTkBOn1lB2GjIsH83W5tQp8+ZjoXD+sH9uQ5i6JT8pmE9
	ipmbsfjgh76iGVK8NhpPJW4isTUNnw0EKXjpwdpMtg==
X-ME-Sender: <xms:WwS7aiDjfCWhM45ebP9HdVgpt-9Q4_nIiQaui10HiKUUKHSQVeKBHw>
    <xme:WwS7aigUTySO9yCJ4Z2CjtQquXDo-0vIUX_tV_LLAi4mB55vmUYNdo0vGISL4c4Ix
    1LEDV1WGp58WWS5YhxBI5Vb_gzkRWgUdJpYXn6vwigUmTTkCmoc3_f1>
X-ME-Received: <xmr:WwS7ajN78PrXKAAabUf5uBJK_BfQgY6GXCjA2LA6x7-r3kLIyOhtJXw>
X-ME-Proxy-Cause: dmFkZTEsnGc0Sn/bgLgWyfKxIhdNE7j7GWUHzWmyZxbkV4WBZRaFWWFBI1S27JJi1ggv+a
    d3o5M55SXmNA89Q7HYh838dv8j5nQE0mrtHfWGhvRREvniwfvJiZLN4XgU4DlNMeapCz6G
    GS6trNj5loAjujzN/hMn6nvoR1EYgnrhccI4/nfJutv8Dzm2j8pzv09ixP+++CVQ2jWebB
    ThnyxvbbtCVX7jsTvHo2CIaM9ldNsxVFVxocajiGvCl+Eo4hNvstnxKgVMF12TOFZskQWE
    1Z6AehbeX4D+G1ExyyNey/PjZXJZVcYjn2WIgFvNlpC2BxJA+7t7+yjafdl+1RlrykwgQx
    mMZTVC3VnM9HkvfUiVJmQfwja+osh/xzrnPNvX8X9V6o/wSePR2kS9dp7ORnOIceVu7p6h
    ntuDScJm2eQ1bTdHBD+pXv1YrWPI6KK2FrFwNTs75z+Xh/ncvBH/ab+GMv+cB74k6NkEcQ
    HUjZZdFucyCRndDNWCdkOymuCUmx5YH4NQtLycg1I8TZN7rl15UJBwW6r0ALbTQ/ZXkHcD
    NrQ1KRsW5doCZ0fLYi6LAbZzQ4fuyRebZ7oc2KcmnDmjOhHTIQeWT5bBTHEssVeimkKQft
    jgQSCNgavYaACPxAbVWhwGSV+kkVoTZKYZFd9ZMgFRfBo6MVLp+38pi5sXag
X-ME-Proxy: <xmx:WwS7ar6P8tsQWAhekcccElYLddmAnCz9-RepWrteVgBSv86CH-hi7w>
    <xmx:WwS7ap1lWsTo9TPbWB7vv_p0uTa65xMVtzwrWDWIT0gLm6oSS2eqZw>
    <xmx:WwS7akY9HEIlJnHP2q0GJlvrxqU6p_8sg2siwTWMKuQiofycq7EGog>
    <xmx:WwS7apCtL5FQ_KPZn3a4wcvdTkvYCLhLIB4euWB-3bJS3SmRr8vw5A>
    <xmx:WwS7akBAECA5YjrpvTPUZABuoZJqXBpgiBWQuOdjf9MdXFk3O1pYsnVH>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 20:20:43 -0400 (EDT)
From: Boris Burkov <boris@bur.io>
To: linux-btrfs@vger.kernel.org,
	kernel-team@fb.com
Subject: [PATCH v2 1/2] btrfs: allocate additional SYSTEM space earlier
Date: Mon, 28 Sep 2026 17:20:33 -0700
Message-ID: <91ad8b69a21473c84c9a79b239dbc948ec5ed379.1790641111.git.boris@bur.io>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790641111.git.boris@bur.io>
References: <cover.1790641111.git.boris@bur.io>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, reserve_chunk_space() allocates a new system chunk when the
space left is smaller than the reservation for a single chunk tree
update.

Therefore, a filesystem in single metadata mode on a very large block
device can accumulate tens of thousands (TB) of chunks while never
allocating more than the original 4MiB SYSTEM block group created by
mkfs. If it then fills up (with large fallocates for example) and then
that data is freed, en-masse, we end up trying to delete thousands of
block groups in a single transaction in btrfs_delete_unused_bgs().

This process touches most of the nodes and leaves of the chunk tree,
essentially trying to allocate roughly double the current usage of the
chunk tree for cow. When this runs into needing a fresh system chunk,
the fs is full of the empty bgs and we abort with ENOSPC in
btrfs_remove_chunk() like:

  BTRFS error (device loop0 state A): Transaction 30733 aborted (-ENOSPC)
  space_info SYSTEM (sub-group id 0) has 0 free, is not full
  space_info total=4194304, used=3276800, pinned=0, reserved=917504, may_use=0, readonly=0 zone_unusable=0
  BTRFS: error (device loop0 state A) in btrfs_remove_chunk:3643: errno=-28 No space left

This was seen on a 30TiB production filesystem with 10TiB of unused
block groups and reproduces on a 30TiB sparse loop device: mkfs with
-m single, fallocate 1GiB files until ENOSPC, delete two of every three
adjacent files, sync.

To fix this, we should allocate the (relatively tiny) system chunks a
little bit more eagerly. If we do it when it is half full, we ensure we
can delete all of the block groups in one go. To fill up half of a 4MiB
system bg requires thousands of block_groups so this should only affect
very large fileystems.

Assisted-by: LLM
Signed-off-by: Boris Burkov <boris@bur.io>
---
 fs/btrfs/block-group.c | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 2eb09c9901c9..0a41b16ed270 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1574,6 +1574,19 @@ static bool btrfs_link_bg_list(struct btrfs_block_group *bg, struct list_head *l
 	return added;
 }
 
+/*
+ * Compute a rough bound on the bytes needed to modify every leaf in the chunk
+ * tree. Normally, we could just allocate a new system chunk then, but that can
+ * fail if there is no free space for a new dev extent. This can happen when
+ * we fill up a large filesystem then rapidly delete a large portion of it.
+ */
+static u64 system_space_target(struct btrfs_space_info *sinfo)
+{
+	lockdep_assert_held(&sinfo->lock);
+
+	return btrfs_space_info_used(sinfo, true) + sinfo->bytes_used;
+}
+
 /*
  * Process the unused_bgs list and remove any that don't have any allocated
  * space inside of them.
@@ -1661,6 +1674,9 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		if (btrfs_is_block_group_used(block_group) ||
 		    (block_group->ro && !(block_group->flags & BTRFS_BLOCK_GROUP_REMAPPED)) ||
 		    list_is_singular(&block_group->list) ||
+		    ((block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM) &&
+		     space_info->total_bytes - block_group->length <
+		     system_space_target(space_info)) ||
 		    test_bit(BLOCK_GROUP_FLAG_FULLY_REMAPPED, &block_group->runtime_flags)) {
 			/*
 			 * We want to bail if we made new allocations or have
@@ -1674,6 +1690,10 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 			 * next block group of this type would be created with a
 			 * "single" profile (even if we're in a raid fs) because
 			 * fs_info->avail_*_alloc_bits would be 0.
+			 *
+			 * Also bail out if this is a system block group that
+			 * system_space_target() relies on to ensure head room for
+			 * mass deletion.
 			 */
 			trace_btrfs_skip_unused_block_group(block_group);
 			spin_unlock(&block_group->lock);
@@ -4509,6 +4529,7 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *info;
 	u64 left;
+	bool want_system_chunk, need_system_chunk;
 	int ret = 0;
 
 	/*
@@ -4520,15 +4541,17 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 	info = btrfs_find_space_info(fs_info, BTRFS_BLOCK_GROUP_SYSTEM);
 	spin_lock(&info->lock);
 	left = info->total_bytes - btrfs_space_info_used(info, true);
+	want_system_chunk = info->total_bytes < system_space_target(info);
+	need_system_chunk = left < bytes;
 	spin_unlock(&info->lock);
 
-	if (left < bytes && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
+	if (need_system_chunk && btrfs_test_opt(fs_info, ENOSPC_DEBUG)) {
 		btrfs_info(fs_info, "left=%llu, need=%llu, flags=%llu",
 			   left, bytes, type);
 		btrfs_dump_space_info(info, 0, false);
 	}
 
-	if (left < bytes) {
+	if (want_system_chunk || need_system_chunk) {
 		u64 flags = btrfs_system_alloc_profile(fs_info);
 		struct btrfs_block_group *bg;
 		struct btrfs_space_info *space_info;
@@ -4572,13 +4595,14 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	if (!ret) {
-		ret = btrfs_block_rsv_add(fs_info,
-					  &fs_info->chunk_block_rsv,
-					  bytes, BTRFS_RESERVE_NO_FLUSH);
-		if (!ret)
-			trans->chunk_bytes_reserved += bytes;
-	}
+	if (ret && need_system_chunk)
+		return;
+
+	ret = btrfs_block_rsv_add(fs_info,
+				    &fs_info->chunk_block_rsv,
+				    bytes, BTRFS_RESERVE_NO_FLUSH);
+	if (!ret)
+		trans->chunk_bytes_reserved += bytes;
 }
 
 /*
-- 
2.55.0

