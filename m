Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2D8380FCA
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864454; cv=none; b=SuInx3NNiR3K7aWiVtMBTELzYH4pqdNxpkVk4xBq6Ttmc7g4wrJoBHF9aFnVjD4SMdhCj8j1Z6kzbvlwp+1cLBg6iPTdM2s46UytXU8aYOEW0sGMultd/Kqdwl0P3FEpfWD5gxM/YNNSuD7dCMmug2hvmLgBtGuNLGlp5PKJWog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864454; c=relaxed/simple;
	bh=81NKOV762dqs+GrdhWCjvMzhB4VWDYj4pdoYJU8/6Vw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IovQDQCrnQnmiMx7lWviUY+dwQCtAcVDd0WDiAFucNZL9+76ZyPiZhsVQ3t9SozIoCrnSxgCgpmk+G8cvDNApYZtZ54l5HUjXZywDGiC7Q/sCviRrOGJERPpqo1L6aWHJE3odeGNoCOtginwSdlVpoRZNL6GOhRWYu+fnquBDLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtXRygA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtXRygA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8BBC2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864454;
	bh=81NKOV762dqs+GrdhWCjvMzhB4VWDYj4pdoYJU8/6Vw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KtXRygA3IISzziGuJNmzffB4sUUbcPigDg1v6qVLNv5y6oKu/fBfJlGZrMshzVQp1
	 BZYCYnftdAIM55Y9tC0J8tbFo3nbh5JM+bOxzgruv9SHW2DeCwE4+TC3WHLV6d2LRb
	 ybOFAx/Z1kq612KLpJUTOWbkzAqofwtrTC9AfEb9hokrUrDUgvUbfdWB4wbO30Nljt
	 TKSmvOfYrekiHUQnWPUiX38ddP5/ZgbY91tHEVBQW+CcHQ6tGpUIr3HTBzTm/C5gVz
	 SD7QDPtO/5IGbO+ZPh1Czc2CS4sYdc/EK7oXuHERiK0cJrN86ueQga77eQgjZwsH/W
	 yCbcDhOArYOGA==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 26/28] btrfs: tracepoints: add trace event for btrfs_log_new_name()
Date: Fri, 15 May 2026 18:00:23 +0100
Message-ID: <7f37d8fa6fb506343b20aa4ce51fff4bd79a443e.1778776707.git.fdmanana@suse.com>
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

btrfs_log_new_name() is an important function that affects inode logging
and is called during link and rename operations. Add trace events for when
entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          |  7 ++--
 include/trace/events/btrfs.h | 66 ++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 4bc7e3726fb6..807747725509 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -8059,6 +8059,8 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	bool log_pinned = false;
 	int ret;
 
+	trace_btrfs_log_new_name_enter(trans, inode, old_dir, old_dir_index);
+
 	/* The inode has a new name (ref/extref), so make sure we log it. */
 	set_bit(BTRFS_INODE_COPY_EVERYTHING, &inode->runtime_flags);
 
@@ -8081,7 +8083,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		goto out;
 	} else if (ret == 0) {
 		if (!old_dir)
-			return;
+			goto out;
 		/*
 		 * If the inode was not logged and we are doing a rename (old_dir is not
 		 * NULL), check if old_dir was logged - if it was not we can return and
@@ -8091,7 +8093,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 		if (ret < 0)
 			goto out;
 		else if (ret == 0)
-			return;
+			goto out;
 	}
 	ret = 0;
 
@@ -8190,6 +8192,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
 	btrfs_log_inode_parent(trans, inode, parent, LOG_INODE_EXISTS, &ctx);
 	ASSERT(list_empty(&ctx.conflict_inodes));
 out:
+	trace_btrfs_log_new_name_exit(trans, inode, old_dir, ret);
 	/*
 	 * If an error happened mark the log for a full commit because it's not
 	 * consistent and up to date or we couldn't find out if one of the
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index a38367cf0187..4e5bb434f53a 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1481,6 +1481,72 @@ TRACE_EVENT(btrfs_record_new_subvolume,
 			__entry->dir)
 );
 
+TRACE_EVENT(btrfs_log_new_name_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *inode,
+		 const struct btrfs_inode *old_dir,
+		 u64 old_dir_index),
+
+	TP_ARGS(trans, inode, old_dir, old_dir_index),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ino			)
+		__field(	umode_t,	mode			)
+		__field(	u64,	 	old_dir_ino		)
+		__field(	u64,		old_dir_index		)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ino			= btrfs_ino(inode);
+		__entry->mode			= inode->vfs_inode.i_mode;
+		__entry->old_dir_ino		= old_dir ? btrfs_ino(old_dir) : 0;
+		__entry->old_dir_index		= old_dir_index;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ino=%llu type=%s"
+			" old_dir=%llu old_dir_index=%llu",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ino, show_inode_type(__entry->mode),
+			__entry->old_dir_ino, __entry->old_dir_index)
+);
+
+TRACE_EVENT(btrfs_log_new_name_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *inode,
+		 const struct btrfs_inode *old_dir,
+		 int ret),
+
+	TP_ARGS(trans, inode, old_dir, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ino			)
+		__field(	u64,	 	old_dir_ino		)
+		__field(	int,		ret			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ino			= btrfs_ino(inode);
+		__entry->old_dir_ino		= old_dir ? btrfs_ino(old_dir) : 0;
+		__entry->ret			= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ino=%llu old_dir=%llu ret=%d",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ino, __entry->old_dir_ino, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

