Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0158947CC61
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791202428; cv=none; b=O+FB+ah5ZydCNVpk5oh37u9ALhTL2p55RIrPUGp0Xqfx87EX783UCtwfQeZkmHAreyX9LGIkZm6J2fCa4ZYmAcMOdC8IkB6rj22O26N1cD1Tvh6shLbFAxnPgL1D94PvBd04nzPgMtTtOwlrwMtchgwSWQljgMniswcrQgn7UVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791202428; c=relaxed/simple;
	bh=vRA/eOQE4NSWYIZblVX1GdK7M0/1v+fc7J3iQ+RnelA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMiiLE9DPfJOBWSGPVri4CKtCBSWhSzH5hQiKY1bgWqpz0jcDA1TKhChT3jgPOj93kV6s8CjM/5uIVN/HeQCSJIOjW2CtqxFnLt+GVlZKUnvsf5o1c9D3kHZAquACEV7kfqCj5rIccc4ATi5nXf0gbIBqPhVG0GWC2WOw1QOwaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TeoNAVyl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TeoNAVyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211A01F00898
	for <linux-btrfs@vger.kernel.org>; Mon,  5 Oct 2026 12:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791202424;
	bh=+dJQ6UA7fCzhV+jrb6XMt47/+VYQi3ADt4G28LBBR9I=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=TeoNAVyl4tR/HN1RuUxaHEwdJSyDgq7yJYwNOxEm4BvPYlAoKIZMQfHq5265znXO+
	 /9p2Toruc/iaj3DsaK3aIahPzKYE7h4meN4EzTv6Q2249K2d64w+isMGALfyhpRZw2
	 KzBC46KdCaYc2LOmWaBL9Vd76qABWaKZ/IJb6n7rtCT6ehmEP6ZOXhyrg88NRSrcCW
	 /oxHg+QweR3+zt96gA3XrNosFwLpIf3bGdLqlBgnit2Ot9+fA8yVUwcRykhBnRtLaT
	 6ltfwa2Mh+HwS0qR5afPtM4FAmW1GHXUayYLRqOjBQf3YqM5LPpp3tZFryWXOBXyiV
	 EjgK7u2DkVtUw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/2] btrfs: qgroup: make btrfs_record_squota_delta() return void
Date: Mon,  5 Oct 2026 13:13:38 +0100
Message-ID: <7ee129528cb761e212c063fb333e17aa4654cc89.1791202322.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1791202322.git.fdmanana@suse.com>
References: <cover.1791202322.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

The function never returns any error, so simplify it and its callers by
making it return void.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/extent-tree.c | 10 +++-------
 fs/btrfs/qgroup.c      | 14 +++++---------
 fs/btrfs/qgroup.h      |  4 ++--
 3 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 15b4ed56ce71..9b0a5c6b96f3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1658,7 +1658,7 @@ static int run_delayed_data_ref(struct btrfs_trans_handle *trans,
 						 href->owning_root);
 		free_head_ref_squota_rsv(trans->fs_info, href);
 		if (!ret)
-			ret = btrfs_record_squota_delta(trans->fs_info, &delta);
+			btrfs_record_squota_delta(trans->fs_info, &delta);
 	} else if (node->action == BTRFS_ADD_DELAYED_REF) {
 		ret = __btrfs_inc_extent_ref(trans, node, extent_op);
 	} else if (node->action == BTRFS_DROP_DELAYED_REF) {
@@ -3180,11 +3180,7 @@ static int do_free_extent_accounting(struct btrfs_trans_handle *trans,
 		}
 	}
 
-	ret = btrfs_record_squota_delta(trans->fs_info, delta);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
-		return ret;
-	}
+	btrfs_record_squota_delta(trans->fs_info, delta);
 
 	/* If remapped, FST has already been taken care of in remove_range_from_remap_tree(). */
 	if (!remapped) {
@@ -5228,7 +5224,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
 	if (ret)
 		btrfs_pin_extent(trans, ins->objectid, ins->offset);
 	else
-		ret = btrfs_record_squota_delta(fs_info, &delta);
+		btrfs_record_squota_delta(fs_info, &delta);
 	btrfs_put_block_group(block_group);
 	return ret;
 }
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 54d82d6fd4bb..cf8dfd5c692b 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -4966,10 +4966,9 @@ void btrfs_qgroup_destroy_extent_records(struct btrfs_transaction *trans)
 	xa_destroy(&trans->delayed_refs.dirty_extents);
 }
 
-int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
-			      const struct btrfs_squota_delta *delta)
+void btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
+			       const struct btrfs_squota_delta *delta)
 {
-	int ret;
 	struct btrfs_qgroup *qgroup;
 	struct btrfs_qgroup *qg;
 	LIST_HEAD(qgroup_list);
@@ -4979,24 +4978,22 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 
 	if (btrfs_qgroup_mode(fs_info) != BTRFS_QGROUP_MODE_SIMPLE &&
 	    !test_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags))
-		return 0;
+		return;
 
 	if (!btrfs_is_fstree(root))
-		return 0;
+		return;
 
 	/* If the extent predates enabling quotas, don't count it. */
 	if (delta->generation < fs_info->qgroup_enable_gen)
-		return 0;
+		return;
 
 	spin_lock(&fs_info->qgroup_lock);
 	qgroup = find_qgroup_rb(fs_info, root);
 	if (WARN_ON_ONCE(!qgroup)) {
 		btrfs_warn(fs_info, "squota failed to find qgroup for root %llu", root);
-		ret = 0;
 		goto out;
 	}
 
-	ret = 0;
 	qgroup_iterator_add(&qgroup_list, qgroup);
 	list_for_each_entry(qg, &qgroup_list, iterator) {
 		struct btrfs_qgroup_list *glist;
@@ -5022,5 +5019,4 @@ int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
 
 out:
 	spin_unlock(&fs_info->qgroup_lock);
-	return ret;
 }
diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
index c64b26b09c22..a29b4e216f25 100644
--- a/fs/btrfs/qgroup.h
+++ b/fs/btrfs/qgroup.h
@@ -427,7 +427,7 @@ int btrfs_qgroup_trace_subtree_after_cow(struct btrfs_trans_handle *trans,
 		struct btrfs_root *root, struct extent_buffer *eb);
 void btrfs_qgroup_destroy_extent_records(struct btrfs_transaction *trans);
 bool btrfs_check_quota_leak(const struct btrfs_fs_info *fs_info);
-int btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
-			      const struct btrfs_squota_delta *delta);
+void btrfs_record_squota_delta(struct btrfs_fs_info *fs_info,
+			       const struct btrfs_squota_delta *delta);
 
 #endif
-- 
2.47.2

