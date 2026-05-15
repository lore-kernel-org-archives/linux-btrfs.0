Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98E6380FC2
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864453; cv=none; b=fligbsZ/P/C88Hwo+BHhNXxL5LNoVcdufMi4frmrKJ/xRDN4mqU03Gqz376KtTsIR776WH7GZGjLjMIMexrysURBhBV9HNy9uFf37IyT5VzlDZNsnhhja6ieoAw9F9J3V7PuuoIKFksK7ZEf1JsHkyXVn+fVDgKX+KiOI4Rx9bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864453; c=relaxed/simple;
	bh=FkFoeDsT73UHlLQ7lniX0u0spYWqnfQ2SJhDAmxPHjw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oInNA2j24e0qP7g9S90dINcbdXyRW+L3rsXDQYzyaPQxaZCZz1p+rNLpoJlCJPqgjYIeJ+IzIQIMrPSklRwa++nL5aXyZuAJAB3L1z9p/x7favHvULiXZPPQjpnOY+XR9OFsdFsHKPk9l2jgx9SInTKxkrkhsjJV+RTp9qwaHLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTZ9lXNP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTZ9lXNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D768CC2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864453;
	bh=FkFoeDsT73UHlLQ7lniX0u0spYWqnfQ2SJhDAmxPHjw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UTZ9lXNPwfagLiNdyWEyDr1OXSt4WI7/+1jzrfJJCoWfHH5HFdzZ8Kzvl7nfywl2j
	 RgiXOhiHHVvfOLzHfURQN0/hx1jXcj8n9XgKhY90j5HiBDKBUI2k0a1yej2OuZAZEE
	 4eOoazzjspVO/2TraMAESlY72mfOm7uNues9fGH26wO73m9bXM6Kn4Oj7Py6uc6tOP
	 a25qNIz4aZZ7r7y0/PJlJPd3XrvbKXNVze/ffMWbkpql/fQUh9SHJDmiNNvafOPNCP
	 R/cb2LOHPconSd3euNBIgWIcEnZ52goLSdSI4vMngxmxqqyelwsXJ7UqiMFLN7T44I
	 tCyan+fCIau0A==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 25/28] btrfs: tracepoints: add trace event for btrfs_record_new_subvolume()
Date: Fri, 15 May 2026 18:00:22 +0100
Message-ID: <7e8c56f827a33aee6f0139e928fe886eedec93a4.1778776707.git.fdmanana@suse.com>
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

btrfs_record_new_subvolume() is an important operation that affects
inode logging and is called during subvolume creation. Add a trace event
for it to help debug issues.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          |  2 ++
 include/trace/events/btrfs.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 49258c5624f4..4bc7e3726fb6 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -8025,6 +8025,8 @@ void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 void btrfs_record_new_subvolume(const struct btrfs_trans_handle *trans,
 				struct btrfs_inode *dir)
 {
+	trace_btrfs_record_new_subvolume(trans, dir);
+
 	mutex_lock(&dir->log_mutex);
 	dir->last_unlink_trans = trans->transid;
 	mutex_unlock(&dir->log_mutex);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index abfedcd4663b..a38367cf0187 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1456,6 +1456,31 @@ TRACE_EVENT(btrfs_record_snapshot_destroy,
 			__entry->dir)
 );
 
+TRACE_EVENT(btrfs_record_new_subvolume,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *dir),
+
+	TP_ARGS(trans, dir),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	dir			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(dir->root);
+		__entry->transid		= trans->transid;
+		__entry->dir			= btrfs_ino(dir);
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu dir=%llu",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->dir)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

