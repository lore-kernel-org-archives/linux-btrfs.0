Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F5E4C042E
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864451; cv=none; b=hqhaVKjAeZ8Eo4tODLL1LDV0nfDSdHG0dFizS7ybnLlABa5hp9EMfam4RSqBrbOrJUdiJfLC/JeUs5tYjq5ymEOzxR0+q3+ABxd+hdrQDcNP6iJdiJuj7FsU/0BQplshAHfRt/+1UB2o14KIXiEs8w3/mt4nym4C5aC98v2So+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864451; c=relaxed/simple;
	bh=NpWrV7siICnfHYgy9i3nVa+dUsXe2vCJiEj/Mt9dszQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZoScZEX6UO0A2Cn7I2jPnMSGu8HQq93vuFYdRvoqDswqoG5dnJjRdL/u9l+8KkxjmS1ZIfMqras0pLsmviMfJXKplN/GhFj3cPqQwryRhqHRIhsK4p0AvsH2XvmXT1FlNHWUkNtzRhBA5DKy764wih6Re9Nw67ueA8wuPZ8a+Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+odysgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+odysgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13FDC2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864451;
	bh=NpWrV7siICnfHYgy9i3nVa+dUsXe2vCJiEj/Mt9dszQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=T+odysgdYKgaARSV3ObzBm6n7iJI+LaQ5E6MpujVg4RCoI6bUMjBkNt7h3mVfLxVQ
	 poiQlSZ/w30FaYEoLou+Fp77oezvd8Zvxnl8ZWqgH62jGxOGOrw6SEoy+cYDdid2Nl
	 o0Z30Hg8MOX+UCGw+S4BczJI5C77YYjAb21xczu9I9eTT6Vhv3kflH5RdXyq1F7ypv
	 DFfeG1B55knxXH4muurFB66F8Kh1wVAkajuItPoUChAFqjXjaqDtNmm4RRfktgR6ir
	 DAETwl39Qb1NJqe21q05XpoBTxBzIReqskwgI+n35It3JLPmaUye3yvj0k32R/OpVn
	 VzdNYCAKqDEyw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 23/28] btrfs: tracepoints: add trace event for btrfs_record_unlink_dir()
Date: Fri, 15 May 2026 18:00:20 +0100
Message-ID: <8d37ab159367a0e235ca8dd65ce8cfb4e0ea3430.1778776707.git.fdmanana@suse.com>
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

btrfs_record_unlink_dir() is an important operation that affects inode
logging and is called during unlink and rename operations. Add a trace
event for it to help debug issues.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          |  2 ++
 include/trace/events/btrfs.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 7a1cd93c4582..c9421279bbc0 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -7939,6 +7939,8 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 			     struct btrfs_inode *dir, struct btrfs_inode *inode,
 			     bool for_rename)
 {
+	trace_btrfs_record_unlink_dir(trans, dir, inode, for_rename);
+
 	/*
 	 * when we're logging a file, if it hasn't been renamed
 	 * or unlinked, and its inode is fully committed on disk,
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 36e592bbc616..182e4823d218 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1400,6 +1400,37 @@ TRACE_EVENT(btrfs_log_new_delayed_dentries_exit,
 			__entry->ino, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_record_unlink_dir,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *dir,
+		 const struct btrfs_inode *inode,
+		 bool for_rename),
+
+	TP_ARGS(trans, dir, inode, for_rename),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ino			)
+		__field(	u64,	 	dir			)
+		__field(	bool,	 	for_rename		)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ino			= btrfs_ino(inode);
+		__entry->dir			= btrfs_ino(dir);
+		__entry->for_rename		= for_rename;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ino=%llu dir=%llu for_rename=%d",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ino, __entry->dir, __entry->for_rename)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

