Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4783A901F
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790967358; cv=none; b=Hlp3iKzHQ4qRmTH4EkkLWDSpCeCC6GprsSp0n9RrPCisgc+kQTjdCzF2fR4/nLjuTeYY/mBqm5m48ue4jptBSlsNIjbUYlLXm9lYbR7jbabKM3ZzfyvwagCX9jcqhchmIM1YQt5Sv8lS0e04OAUNRLVPPli/JBENJAKL8NmMvwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790967358; c=relaxed/simple;
	bh=L0VAem068wO9OpiutTMYpy0siIeiRadNw5g7dXgDWuY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABygY5xGdMzZgLiQ2kMzT7nU5ti2/RY+fynzxfIgnIRsXfaU5rIl5KSw+07YZXLA/6fsJbGgw2iONeXkgi6b4YJuHFDnaK37K2Pa/yy/UQy4lEGy/NRt9hq1Md1qjTYXxPBq9+TcH9sR2LT3MWDr3BxCi9ASNUTDueLwQ6iqun0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKXuGzh/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKXuGzh/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9851F00898
	for <linux-btrfs@vger.kernel.org>; Fri,  2 Oct 2026 18:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967355;
	bh=EgDIMoIeY2FpfEf2LH/JaCuUOmh9gsvPms6MSSxPVHE=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=lKXuGzh/ioRpHMlTxCVhhYgkPomLFmWcxcKtbb523B6slunxcn1ixLFeQ+cU8wlhn
	 WqMaDWj8OVCIrYbF23pkhLkdakI4fDiTYS59kTclt+uQwFp/MROPOG3gRmc1uPpzft
	 gQth5BPxYLJ1jg36/uQHXYS2yI6I/YFj8BcGFb+B7m632w7/FWyCizPwSZ3WOrCSkT
	 RzAuNpRM+xf3GClgq7I2HF33VQWVCYPBbJnoJdtCZFZTWGiCuEhkeYTKct1ML81kZW
	 uM6z7RPV2o071sFNVoTIPcrdfmsoIKn4S0RlPYuhs96Ck9tJFRGDZ8Fghg6XC48IV+
	 c3YiH6KrwMYeA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 4/6] btrfs: qgroup: merge error labels in btrfs_quota_enable()
Date: Fri,  2 Oct 2026 19:55:45 +0100
Message-ID: <40436d61da8f99a8c302d7210093552f3be4acd1.1790967259.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1790967259.git.fdmanana@suse.com>
References: <cover.1790967259.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

There is no need to have 3 different labels to which we goto on error.
Simplify this and have a single one, named 'out', where we always free
the path and put the root, as btrfs_free_path() and btrfs_put_root()
accept NULL arguments and do nothing in that case.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/qgroup.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 9f21b091c545..c9fc3b6a5132 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -999,7 +999,7 @@ static int btrfs_clean_quota_tree(struct btrfs_trans_handle *trans,
 int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		       struct btrfs_ioctl_quota_ctl_args *quota_ctl_args)
 {
-	struct btrfs_root *quota_root;
+	struct btrfs_root *quota_root = NULL;
 	struct btrfs_root *tree_root = fs_info->tree_root;
 	struct btrfs_path *path = NULL;
 	struct btrfs_qgroup_status_item *ptr;
@@ -1076,6 +1076,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	quota_root = btrfs_create_tree(trans, BTRFS_QUOTA_TREE_OBJECTID);
 	if (IS_ERR(quota_root)) {
 		ret =  PTR_ERR(quota_root);
+		quota_root = NULL;
 		btrfs_abort_transaction(trans, ret);
 		goto out;
 	}
@@ -1084,7 +1085,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	if (unlikely(!path)) {
 		ret = -ENOMEM;
 		btrfs_abort_transaction(trans, ret);
-		goto out_free_root;
+		goto out;
 	}
 
 	key.objectid = 0;
@@ -1095,7 +1096,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 				      sizeof(*ptr));
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
-		goto out_free_path;
+		goto out;
 	}
 
 	leaf = path->nodes[0];
@@ -1131,7 +1132,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		goto out_add_root;
 	if (unlikely(ret < 0)) {
 		btrfs_abort_transaction(trans, ret);
-		goto out_free_path;
+		goto out;
 	}
 
 	while (1) {
@@ -1150,14 +1151,14 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 			if (unlikely(!prealloc)) {
 				ret = -ENOMEM;
 				btrfs_abort_transaction(trans, ret);
-				goto out_free_path;
+				goto out;
 			}
 
 			ret = add_qgroup_item(trans, quota_root,
 					      found_key.offset);
 			if (unlikely(ret)) {
 				btrfs_abort_transaction(trans, ret);
-				goto out_free_path;
+				goto out;
 			}
 
 			qgroup = add_qgroup_rb(fs_info, prealloc, found_key.offset);
@@ -1165,13 +1166,13 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 			ret = btrfs_sysfs_add_one_qgroup(fs_info, qgroup);
 			if (unlikely(ret < 0)) {
 				btrfs_abort_transaction(trans, ret);
-				goto out_free_path;
+				goto out;
 			}
 			ret = btrfs_search_slot_for_read(tree_root, &found_key,
 							 path, 1, 0);
 			if (unlikely(ret < 0)) {
 				btrfs_abort_transaction(trans, ret);
-				goto out_free_path;
+				goto out;
 			}
 			if (ret > 0) {
 				/*
@@ -1188,7 +1189,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		ret = btrfs_next_item(tree_root, path);
 		if (unlikely(ret < 0)) {
 			btrfs_abort_transaction(trans, ret);
-			goto out_free_path;
+			goto out;
 		}
 		if (ret)
 			break;
@@ -1199,21 +1200,21 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 	ret = add_qgroup_item(trans, quota_root, BTRFS_FS_TREE_OBJECTID);
 	if (unlikely(ret)) {
 		btrfs_abort_transaction(trans, ret);
-		goto out_free_path;
+		goto out;
 	}
 
 	ASSERT(prealloc == NULL);
 	prealloc = kzalloc_obj(*prealloc, GFP_NOFS);
 	if (!prealloc) {
 		ret = -ENOMEM;
-		goto out_free_path;
+		goto out;
 	}
 	qgroup = add_qgroup_rb(fs_info, prealloc, BTRFS_FS_TREE_OBJECTID);
 	prealloc = NULL;
 	ret = btrfs_sysfs_add_one_qgroup(fs_info, qgroup);
 	if (unlikely(ret < 0)) {
 		btrfs_abort_transaction(trans, ret);
-		goto out_free_path;
+		goto out;
 	}
 
 	/*
@@ -1245,7 +1246,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 			clear_bit(BTRFS_FS_SQUOTA_ENABLING, &fs_info->flags);
 			fs_info->qgroup_enable_gen = 0;
 		}
-		goto out_free_path;
+		goto out;
 	}
 
 	/*
@@ -1262,7 +1263,7 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 
 	/* Skip rescan for simple qgroups. */
 	if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
-		goto out_free_path;
+		goto out;
 
 	ret = qgroup_rescan_init(fs_info, 0, 1);
 	if (!ret) {
@@ -1287,18 +1288,15 @@ int btrfs_quota_enable(struct btrfs_fs_info *fs_info,
 		ret = 0;
 	}
 
-out_free_path:
-	btrfs_free_path(path);
-out_free_root:
-	if (ret)
-		btrfs_put_root(quota_root);
 out:
+	btrfs_free_path(path);
 	if (ret) {
 		/*
 		 * Free all qgroups previously added with add_qgroup_rb() and
 		 * sysfs entries.
 		 */
 		btrfs_free_qgroup_config(fs_info);
+		btrfs_put_root(quota_root);
 	}
 	mutex_unlock(&fs_info->qgroup_ioctl_lock);
 	if (ret && trans)
-- 
2.47.2

