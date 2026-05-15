Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66A14C042E
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864450; cv=none; b=gRV40JrbTDbDZp2mJt3YE+kI9iPfHqa0tdGb+LUvyCGp6vgzFPmGXj85xRJTsnAkkMYlZ6mG3xGJWP27b6EtNIeLhe9BMr9F0CiDLHGtrq3cH20lP8Bm39IZx2cqZNj1kusJHCe4iyLZ14jMlE+W3PT1X+w6ne0357eczGnwdZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864450; c=relaxed/simple;
	bh=Md0QzbODvz27HEYXDSnCDwqutZQtz6VixPGgKE/YKqE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qde8IwAe7qQcwZKeQHtVWdfYW9RDcyiQWbrScOc9ixCfVGXEgh6wDC6mInDDEI/bmGRU06ycSCRDVfWHwtZcjZVT2ndVocEXm5wqg35cXHgZ+6Azi2LGr9dnH2M8mE22E0ICQzv/5y9eWCZ4cCvtIKx2SarTO4WaGXOAGk077+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=trjIJWRe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="trjIJWRe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8E9C2BCB0
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864450;
	bh=Md0QzbODvz27HEYXDSnCDwqutZQtz6VixPGgKE/YKqE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=trjIJWReqeNcUKKEEcAcLtAJehCbwL02HjzOxhy2PwqqnXaLkOqXXj0jCXhdPNKrH
	 KQPoZtWYyr65ZZZSlIxRLrphKdiOYZ9ZaHYnIVaWLDLv/YgbTdergKf3j+wSyPpvlq
	 9biqUyuEloncirjUu+yITAQCmp2ZObn6dXe3FNOqh2peu+tutM0yTjSB7opkHIByDe
	 sfMLcuZtFm97LSMgjWYVPddmWU1RD2jZlDYfmfLnSX6iU8F6FQ9duq4ygm04y/G+pI
	 IKFeDUNV14dMaYKvMB/p80uebyGFdYdQZ7Hqf++vUAuH7qPp6Ou9AdXF9VW7xUA6Uq
	 BCmSEyL3XeS0Q==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 22/28] btrfs: tracepoints: add trace event for log_new_delayed_dentries()
Date: Fri, 15 May 2026 18:00:19 +0100
Message-ID: <8db81596d3e96b5ebdffc7201e69750658173690.1778776707.git.fdmanana@suse.com>
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

log_new_delayed_dentries() is an important step called during a fsync, as
well as during rename and link operations on inodes that were previously
logged. Add trace events for when entering and exiting that function.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          | 10 +++++++
 include/trace/events/btrfs.h | 53 ++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 6be98f8a3b43..7a1cd93c4582 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -6845,6 +6845,15 @@ static int log_new_delayed_dentries(struct btrfs_trans_handle *trans,
 	lockdep_assert_not_held(&inode->log_mutex);
 
 	ASSERT(!ctx->logging_new_delayed_dentries);
+
+	/*
+	 * Return early if empty list, avoid emitting redundant trace events
+	 * that generate noise only.
+	 */
+	if (list_empty(delayed_ins_list))
+		return 0;
+
+	trace_btrfs_log_new_delayed_dentries_enter(trans, inode);
 	ctx->logging_new_delayed_dentries = true;
 
 	list_for_each_entry(item, delayed_ins_list, log_list) {
@@ -6887,6 +6896,7 @@ static int log_new_delayed_dentries(struct btrfs_trans_handle *trans,
 
 	ctx->log_new_dentries = orig_log_new_dentries;
 	ctx->logging_new_delayed_dentries = false;
+	trace_btrfs_log_new_delayed_dentries_exit(trans, inode, ret);
 
 	return ret;
 }
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 8fd18365a3ac..36e592bbc616 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1347,6 +1347,59 @@ TRACE_EVENT(btrfs_log_conflicting_inodes_exit,
 			__entry->ctx_ino, __entry->ret)
 );
 
+TRACE_EVENT(btrfs_log_new_delayed_dentries_enter,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *inode),
+
+	TP_ARGS(trans, inode),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ino			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ino			= btrfs_ino(inode);
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ino=%llu",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ino)
+);
+
+TRACE_EVENT(btrfs_log_new_delayed_dentries_exit,
+
+	TP_PROTO(const struct btrfs_trans_handle *trans,
+		 const struct btrfs_inode *inode,
+		 int ret),
+
+	TP_ARGS(trans, inode, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,     	root_objectid		)
+		__field(	u64,		transid			)
+		__field(	u64,	 	ino			)
+		__field(	int,	 	ret			)
+	),
+
+	TP_fast_assign(
+		TP_fast_assign_fsid(trans->fs_info);
+		__entry->root_objectid		= btrfs_root_id(inode->root);
+		__entry->transid		= trans->transid;
+		__entry->ino			= btrfs_ino(inode);
+		__entry->ret			= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) transid=%llu ino=%llu ret=%d",
+			show_root_type(__entry->root_objectid), __entry->transid,
+			__entry->ino, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

