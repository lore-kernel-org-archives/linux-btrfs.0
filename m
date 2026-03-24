Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE76402B8F
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364617; cv=none; b=NhcNz0os/7SH7ZlNz3/A/1FFCzGQqu1iNbsuAj7kyyxj0WqHtUvuy/dVkDCZijR/f+gnEhllzW5nUlyjRshxvCEe13assmZzy9fenuLI70OcXqj7p75nnY7z8uZgiO6rCNJNtZIp7KMBPzKDxCG9UAekd/gJrcSnReXVSIaX50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364617; c=relaxed/simple;
	bh=CHsMhkba49mQNw+JScRkEpYeBuiBNuGUv5sgQyHaeGI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZAC/vzktmvIgxeZu24Jf4vubcS4xXyyF5/6GkeDa8XO3vwj2IIOmjGZwqlxF+E2McBaec4q1B/ptZ6WhCQNwMIT/WDGoHXZYFVDzt4upAm/zjDBrJURGUa8aiiyV5GNCyZRmx7tDJmxQIq0+omvLcJOScBEEmYPRmYYEyniK3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YtvTZqY4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtvTZqY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A3DC2BC87
	for <linux-btrfs@vger.kernel.org>; Tue, 24 Mar 2026 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774364617;
	bh=CHsMhkba49mQNw+JScRkEpYeBuiBNuGUv5sgQyHaeGI=;
	h=From:To:Subject:Date:From;
	b=YtvTZqY4lkZu74had05hHfvg/onU9TWQm9LOi9DjA5veNA7RE3STDfBby4TMikWmb
	 f8RBuMZXFt9hydKnSdKWef9Ju+fa3r8z+73fataTBTEO54l9HV+8P6tdxgrwDVfdGG
	 ZNwMhhM+xvUHOkEYX/xHKGfwrmffw9XDim98ZNQCS60Sj/Gsq2IUA/yqrMT9Pfs8G4
	 PuWr9oW6Di+0VlRbFBgVSyHVCK3wq7OM+Iz2LJwp3GiO/dm+H/lirOL/apEu/gfOka
	 PklxdM+IiDBoHsU5vhIvEafqqE4j8LXz0amWSHY/LR1Om/lTiv7VT3y+MlAbAlEa5h
	 oFDuhXca9RDbQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: make btrfs_free_log() and btrfs_free_log_root_tree() return void
Date: Tue, 24 Mar 2026 15:03:33 +0000
Message-ID: <ef83fd57b6c94993091a6ad52cb2a828b3557724.1774364595.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

These functions never fail, always return success (0) and none of the
callers care about their return values. Change their return type from int
to void.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c | 8 +++-----
 fs/btrfs/tree-log.h | 4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index de4707b1227e..f883d9d979d4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -3681,25 +3681,23 @@ static void free_log_tree(struct btrfs_trans_handle *trans,
  * free all the extents used by the tree log.  This should be called
  * at commit time of the full transaction
  */
-int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
+void btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root)
 {
 	if (root->log_root) {
 		free_log_tree(trans, root->log_root);
 		root->log_root = NULL;
 		clear_bit(BTRFS_ROOT_HAS_LOG_TREE, &root->state);
 	}
-	return 0;
 }
 
-int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
-			     struct btrfs_fs_info *fs_info)
+void btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info)
 {
 	if (fs_info->log_root_tree) {
 		free_log_tree(trans, fs_info->log_root_tree);
 		fs_info->log_root_tree = NULL;
 		clear_bit(BTRFS_ROOT_HAS_LOG_TREE, &fs_info->tree_root->state);
 	}
-	return 0;
 }
 
 static bool mark_inode_as_not_logged(const struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.h b/fs/btrfs/tree-log.h
index 41e47fda036d..ad4e82e86bf9 100644
--- a/fs/btrfs/tree-log.h
+++ b/fs/btrfs/tree-log.h
@@ -71,8 +71,8 @@ static inline int btrfs_need_log_full_commit(struct btrfs_trans_handle *trans)
 
 int btrfs_sync_log(struct btrfs_trans_handle *trans,
 		   struct btrfs_root *root, struct btrfs_log_ctx *ctx);
-int btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
-int btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
+void btrfs_free_log(struct btrfs_trans_handle *trans, struct btrfs_root *root);
+void btrfs_free_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_recover_log_trees(struct btrfs_root *tree_root);
 int btrfs_log_dentry_safe(struct btrfs_trans_handle *trans,
-- 
2.47.2

