Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0882F7EF3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864445; cv=none; b=Ygtx7gCbKQBxvrDkYn2CF7FuP9rXIOxiS9ej3/eMwp4I3cgrBDTFc7F98DmzsCFudfrXlnm5ZdSv6aUKP9pXwrQQLreaH0Q0444xMv62CYcj51C1RX6gZIGWbfw0yxNV7GMpPLyS+6sQthq4t2MuJyihDYpeVoY8ROlAPO2qE/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864445; c=relaxed/simple;
	bh=4LBQAadLsdkl8vptNdaxCA+pE0iOM7V9DVt/KMjSxao=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akt5PZ8hP5//7X6MI7EUCajeCEd6saXk9qjvtzwzO/Grp9Itg/Y90vuTkW2eurmN51G0/7upJ4CwNkMFNWMoJ1jAJcN6ArvMOmIFxHqZHAS6j/p8TAxNNtoecj9Mokb/mxBo/+BHq4qKSwig3FU5k9Gmv9BHROH0+UaupgHnSDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eutrw33N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eutrw33N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5976FC2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864444;
	bh=4LBQAadLsdkl8vptNdaxCA+pE0iOM7V9DVt/KMjSxao=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Eutrw33Nk8CqTfg9ItLNrN7z7SlazQBp0zg6xu5qcl5j2BZqvIqecT1qJWba9tuDQ
	 /TTIXdrwW4hcrfXCbhEFLHsV5H0DYLxTkTYgsHg5O1r7XTrUgWDmqI07bDo5tq+eZD
	 sW4syK+8IiRMYmlmtuuVuvLbUBSWuk3XuzO10rl6ygIxBNyRLZwEKB54u+b51VZT4i
	 3W0QrmQLowG093cwxWzjWT6wpvni7Cp3X98wFUCoOPR6R/GNUoKN0X7hE98X1/4oOJ
	 ZCEHPgwKk9g7jO1UdeyDUsMumIuZOhMQmhjBVM+o2QDNXo5cC2OTpJNf2w/wGCbBkc
	 xrTW/PTLPqPBw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 16/28] btrfs: tracepoints: add trace event for btrfs_log_all_parents()
Date: Fri, 15 May 2026 18:00:13 +0100
Message-ID: <aeba6d1601e6f8d02117c01fe815a015c5e36878.1778776707.git.fdmanana@suse.com>
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

btrfs_log_all_parents() is an important step called during a fsync, as
well as during rename and link operations on inodes that were previously
logged. Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          | 29 ++++++++++++++------
 include/trace/events/btrfs.h | 53 ++++++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 9 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 22066635f75f..90f5d1c830e4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7240,9 +7240,13 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 	struct btrfs_root *root = inode->root;
 	const u64 ino = btrfs_ino(inode);
 
+	trace_btrfs_log_all_parents_enter(trans, inode);
+
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	path->skip_locking = true;
 	path->search_commit_root = true;
 
@@ -7251,7 +7255,7 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 	key.offset = 0;
 	ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	while (true) {
 		struct extent_buffer *leaf = path->nodes[0];
@@ -7263,9 +7267,11 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
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
 
@@ -7318,8 +7324,10 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 			 * at both parents and the old parent B would still
 			 * exist.
 			 */
-			if (IS_ERR(dir_inode))
-				return PTR_ERR(dir_inode);
+			if (IS_ERR(dir_inode)) {
+				ret = PTR_ERR(dir_inode);
+				goto out;
+			}
 
 			if (!need_log_inode(trans, dir_inode)) {
 				btrfs_add_delayed_iput(dir_inode);
@@ -7332,11 +7340,14 @@ static int btrfs_log_all_parents(struct btrfs_trans_handle *trans,
 				ret = log_new_dir_dentries(trans, dir_inode, ctx);
 			btrfs_add_delayed_iput(dir_inode);
 			if (ret)
-				return ret;
+				goto out;
 		}
 		path->slots[0]++;
 	}
-	return 0;
+out:
+	trace_btrfs_log_all_parents_exit(trans, inode, ret);
+
+	return ret;
 }
 
 static int log_new_ancestors(struct btrfs_trans_handle *trans,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 9f195d0d5378..2c145240d809 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1067,6 +1067,59 @@ TRACE_EVENT(btrfs_log_inode_exit,
 			__entry->last_log_commit, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_log_all_parents_enter,
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
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(inode->root->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->ino			= btrfs_ino(inode);
+		__entry->transid		= trans->transid;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu transid=%llu",
+			show_root_type(__entry->root_objectid), __entry->ino,
+			__entry->transid)
+);
+
+TRACE_EVENT(btrfs_log_all_parents_exit,
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
+		__entry->ret			= ret;
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

