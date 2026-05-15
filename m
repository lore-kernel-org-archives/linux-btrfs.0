Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA23F2F7F05
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864446; cv=none; b=KBU9dcxsfWDcklUsnrbXLy7pUs+hi9fCrXOPHEz1KHLajQwl5DFvWTCKCHYOzce7v4f4YXPEqdBltvE2A/mYRoUmG9d8SJOHnD9W0c6OQmqQWzXoB+VSWesv3YTRpRkMSnRnRWZrYsj2ACvtwo+mZ8CXxSwR2BEKl/JtPBBcCvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864446; c=relaxed/simple;
	bh=fwSrr8otfSF5Fzqce5yv7ebj3a9two6QdImOxI4gdaM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAmWOsA762PVYYpKLhkYcyyWFcPqT/t8Kt14Nm4aI6+IpOL+MPglveEjvNmPAzyyhbUgXIEYoWM6WpdBAATzGdrH5L3qDcXT6spZ8a4F0Yyq+mH3F1dmy7oROD6tqMqRnQjtVvXSD3UuHjbnawUpuCqDPQ0WZ9uJA6sPa3Y6p50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gca+tgeI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gca+tgeI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECE1C2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864446;
	bh=fwSrr8otfSF5Fzqce5yv7ebj3a9two6QdImOxI4gdaM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=gca+tgeIKm1nFW8qkX1ctXJ74B+uj0P+pINfjds7mNPB3JM1Yk5hPrW2p5FSYmdBn
	 EYyDGpI/AKn2JW8Z0xqP1R+gd+DbRbbJvMfcapZtTts1egZ16j7eeeovlszCV7KZf1
	 m0UGuf8trTdJ4+hCf/KU+IuwlopE7OWQ3odBx/Pioy8/CEOSr7KZ8aRjet0uHbRK1B
	 V/WSewc2mI+CLy2efSqGygiciDJo24idryrrLISabHJmuey7Dt6SLyQVsieG293Wnm
	 ov/Vq4X6n3NUC6vyeN4SpIidioQeY66seZo0Rgo531TcWMSll+L1LbdOrMDcpE8dMt
	 nensTio/vW3RA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 18/28] btrfs: tracepoints: add trace event for log_new_dir_dentries()
Date: Fri, 15 May 2026 18:00:15 +0100
Message-ID: <6793730b9ead08d070c28e6e6f3e305de3e535e8.1778776707.git.fdmanana@suse.com>
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

log_new_dir_dentries() is an important step called during a fsync, as
well as during rename and link operations on inodes that were previously
logged. Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          | 10 +++++--
 include/trace/events/btrfs.h | 53 ++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f34dc9771dab..44c7d250b810 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5902,9 +5902,13 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 	struct btrfs_inode *curr_inode = start_inode;
 	int ret = 0;
 
+	trace_btrfs_log_new_dir_dentries_enter(trans, start_inode);
+
 	path = btrfs_alloc_path();
-	if (!path)
-		return -ENOMEM;
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	/* Pairs with btrfs_add_delayed_iput below. */
 	ihold(&curr_inode->vfs_inode);
@@ -6023,6 +6027,8 @@ static int log_new_dir_dentries(struct btrfs_trans_handle *trans,
 			kfree(dir_elem);
 	}
 
+	trace_btrfs_log_new_dir_dentries_exit(trans, start_inode, ret);
+
 	return ret;
 }
 
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d16de652a815..c13c1ce0b344 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1175,6 +1175,59 @@ TRACE_EVENT(btrfs_log_all_new_ancestors_exit,
 			__entry->transid, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_log_new_dir_dentries_enter,
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
+TRACE_EVENT(btrfs_log_new_dir_dentries_exit,
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
+		__field(	int,	 	ret			)
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

