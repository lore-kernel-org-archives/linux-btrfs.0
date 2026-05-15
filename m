Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53E92F7EFC
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864446; cv=none; b=jICMdzZSX4M789KTcE+JTzve0R8VlC3H92M0sC9LK81SFkEAA8PLkhxY1yhm7RDexvhdRtXf9zgfxaRrMIQ0T3T8+yf3Ctz20eCJhK+Zb+D/n1rW6RUJoIaQfPi10Vjo1j3c4wt/9ApEmMiGaBvsFFKqYJrXvbJoFS3PvlQvyrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864446; c=relaxed/simple;
	bh=0GEH6lOLlJLD3vS42vAaiZtEpFe8MR28vatQCydb//E=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7mjzHOlH/BdBU9bxYOLhPUuAsEHRiKRe3Idd3z/w3XW7VTWEBMfctkKIQr6lAcJlZHPrhh9QsQ0i1KahLJMp+yP5Y7f7Q8NVPh5einT9J3Ifpe5VgpNvbbFtc/5J2hbAHRG6a/CnIZl7rMeJaxubUZqq86WFCH2bSQeSOZwltA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A67lOwZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A67lOwZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0BAC2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864445;
	bh=0GEH6lOLlJLD3vS42vAaiZtEpFe8MR28vatQCydb//E=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=A67lOwZpCQV9BXLDerjoX2fdZ2W7yZI9ZzGBBu2hQ1N/QsaABbYigdskox4plFi2o
	 goO+WrXA2KP1XXjpQU86mhB82NZInTvIpSygebvDKcESn1WPJZACzjLwnZukzR1C0r
	 +l2HeEUekduyEWn/ixFZLWUVa0NgNDku8sVJT4O4LX4FuKg708RZ2C/sDHuvCJeNQb
	 WwlU1rghRemQmFcHS+wkeAeg94tCXZjtER4Mjxca9yWxBPh5b49+kMPv2rtIKWjScQ
	 026Kmy26Y5Y8yoI+Oz4NVqWQYZZQd0Gv5GXBytVbNy4tH8T6MXUCkQDp/Fv9Fc/WLo
	 qTUYKk6+13e5Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 17/28] btrfs: tracepoints: add trace event for log_all_new_ancestors()
Date: Fri, 15 May 2026 18:00:14 +0100
Message-ID: <cae5d5b9d7bb0fea257e7f15e21a81e128877b1e.1778776707.git.fdmanana@suse.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <cover.1778776706.git.fdmanana@suse.com>
References: <cover.1778776706.git.fdmanana@suse.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Filipe Manana <fdmanana@suse.com>

log_all_new_ancestors() is an important step called during a fsync, as
well as during rename and link operations on inodes that were previously
logged. Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          | 34 ++++++++++++++--------
 include/trace/events/btrfs.h | 55 ++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 90f5d1c830e4..f34dc9771dab 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7462,16 +7462,22 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 	struct btrfs_key search_key;
 	int ret;
 
+	trace_btrfs_log_all_new_ancestors_enter(trans, inode);
+
 	/*
 	 * For a single hard link case, go through a fast path that does not
 	 * need to iterate the fs/subvolume tree.
 	 */
-	if (inode->vfs_inode.i_nlink < 2)
-		return log_new_ancestors_fast(trans, inode, parent, ctx);
+	if (inode->vfs_inode.i_nlink < 2) {
+		ret = log_new_ancestors_fast(trans, inode, parent, ctx);
+		goto out;
+	}
 
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	search_key.objectid = ino;
 	search_key.type = BTRFS_INODE_REF_KEY;
@@ -7479,7 +7485,7 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 again:
 	ret = btrfs_search_slot(NULL, root, &search_key, path, 0, 0);
 	if (ret < 0)
-		return ret;
+		goto out;
 	if (ret == 0)
 		path->slots[0]++;
 
@@ -7491,9 +7497,11 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 		if (slot >= btrfs_header_nritems(leaf)) {
 			ret = btrfs_next_leaf(root, path);
 			if (ret < 0)
-				return ret;
-			if (ret > 0)
+				goto out;
+			if (ret > 0) {
+				ret = 0;
 				break;
+			}
 			continue;
 		}
 
@@ -7509,8 +7517,10 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 		 * this loop, etc). So just return some error to fallback to
 		 * a transaction commit.
 		 */
-		if (found_key.type == BTRFS_INODE_EXTREF_KEY)
-			return -EMLINK;
+		if (found_key.type == BTRFS_INODE_EXTREF_KEY) {
+			ret = -EMLINK;
+			goto out;
+		}
 
 		/*
 		 * Logging ancestors needs to do more searches on the fs/subvol
@@ -7522,11 +7532,13 @@ static int log_all_new_ancestors(struct btrfs_trans_handle *trans,
 
 		ret = log_new_ancestors(trans, root, path, ctx);
 		if (ret)
-			return ret;
+			goto out;
 		btrfs_release_path(path);
 		goto again;
 	}
-	return 0;
+out:
+	trace_btrfs_log_all_new_ancestors_exit(trans, inode, ret);
+	return ret;
 }
 
 /*
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 2c145240d809..d16de652a815 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1120,6 +1120,61 @@ TRACE_EVENT(btrfs_log_all_parents_exit,
 			__entry->transid, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_log_all_new_ancestors_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *inode),
+
+	TP_ARGS(trans, inode),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,	 	ino			)
+		__field(	u64,		transid			)
+		__field(	unsigned int,	nlink			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(inode->root->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->ino			= btrfs_ino(inode);
+		__entry->transid		= trans->transid;
+		__entry->nlink			= inode->vfs_inode.i_nlink;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu transid=%llu nlink=%u",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			__entry->transid, __entry->nlink)
+);
+
+TRACE_EVENT(btrfs_log_all_new_ancestors_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *inode,
+		 int ret),
+
+	TP_ARGS(trans, inode, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,	 	ino			)
+		__field(	u64,		transid			)
+		__field(	int,		ret			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(inode->root->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->ino			= btrfs_ino(inode);
+		__entry->transid		= trans->transid;
+		__entry->ret		= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu transid=%llu ret=%d",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			__entry->transid, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

