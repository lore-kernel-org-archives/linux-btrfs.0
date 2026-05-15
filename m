Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B0E4EA38E
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864452; cv=none; b=HELygy05JZSOll1henzSJBjQT4buK5imfPIn/nvlfDlVn5cKawvlRUE58miH6I6tiyX97ZfJUmLVp5r71I4CZERIhy3eM3NpLDX2L0cDaKL9s7aJjzefBAeq96YPh+5/ctm2HxJBB9sC7C1O7fzx+igyUrwhlvOqtV+LqZlimFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864452; c=relaxed/simple;
	bh=GDgDkqu0OEh/wiea5rZqYNeMxoScOrkOPXXfPPv0jgg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9UNRCQPHTWl0wdacso51zHviUx+knPOiPBZuuezOK7Gzl4VKNoiaaISWLqlY4aNLNBlVGNpive9GLXlJrNR2GV/IauFiWEzAHKhHVIMtf04xn9+WkzKPkWcOf0m6oBzDg4n8Y8PplOAUveDa3v9ZMz/thSOfvDiuUxNKGBebQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaczWbOE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaczWbOE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4332C2BCC7
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864452;
	bh=GDgDkqu0OEh/wiea5rZqYNeMxoScOrkOPXXfPPv0jgg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HaczWbOEZj3IlFSzzNtriBdh9/oiPozn4CmpSXxrHcgXX0yeJK3Rz/dT0zVJ0QbNj
	 JTOTzDc9MY/no902X28+b1Kvi+U9VkZKOPGA56POUHSa7n9Ozx7OJZlYBQllkl03ww
	 ElAf3D1asz8kZZSZnAzxrHQ7ONLK9RhTUmv6Wv7I13ju/ygNecU+TLhmDw6hN6Z8Pj
	 nC9yVHq/XX92LN8UXvv93mpUIMvgMsKx6Ty4qiOw3ArEUCTiXnafEmZla+WMYILZKe
	 7Gp9Q9mR8Kq09aJjvdQnPTQPBxQeftFVu+9cGtk4PQAfzKRyaOT1iW33BcXXRBXSsp
	 a1OA9B0TYpuIw==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 24/28] btrfs: tracepoints: add trace event for btrfs_record_snapshot_destroy()
Date: Fri, 15 May 2026 18:00:21 +0100
Message-ID: <d8392d7a11b9569d6dc63932033c7a3de58e9db4.1778776707.git.fdmanana@suse.com>
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

btrfs_record_snapshot_destroy() is an important operation that affects
inode logging and is called during subvolume/snapshot deletion as well as
during rmdir. Add a trace event for it to help debug issues.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/tree-log.c          |  2 ++
 include/trace/events/btrfs.h | 25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c9421279bbc0..49258c5624f4 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -8003,6 +8003,8 @@ void btrfs_record_unlink_dir(struct btrfs_trans_handle *trans,
 void btrfs_record_snapshot_destroy(struct btrfs_trans_handle *trans,
 				   struct btrfs_inode *dir)
 {
+	trace_btrfs_record_snapshot_destroy(trans, dir);
+
 	mutex_lock(&dir->log_mutex);
 	dir->last_unlink_trans = trans->transid;
 	mutex_unlock(&dir->log_mutex);
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 182e4823d218..abfedcd4663b 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1431,6 +1431,31 @@ TRACE_EVENT(btrfs_record_unlink_dir,
 			__entry->ino, __entry->dir, __entry->for_rename)
 );
 
+TRACE_EVENT(btrfs_record_snapshot_destroy,
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

