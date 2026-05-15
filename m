Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 508324F7992
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778864441; cv=none; b=rFq4uyqb9cwCYNX9UIyZ6tCtlVrdB5s23omQtc/oNvXrGn50f5P3cP7Q2ohYk4JuxpsISp2JEJZtvSYkSm0Io6LmQn3I4MyL9dreokiicp+PCihEkUVZ0V4PahNEYRTmC7PNpr2zvzKfafSirJ7nJysdTcSRKHtqF0ieFGyBdp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778864441; c=relaxed/simple;
	bh=g5GNWNH9M83iN631+TfY2qlTvavqxtcgwjTbRGzwvIo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phH5OlvDUJot4gjAi2Se8EmOHj5B0GBoSRk8tMnKfQ4956hOh3tR8TUzyperUFrIX0zInqL90T2nBMpP0/pwSFJ7YRCXVSfESwfHFcPcmOraZlK0rPgQoNVuPAYaS0dlzm1tOarofL+GBkedzz9lLr7u4KCUtGm90BAmUccJaIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNW2EKFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNW2EKFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD55C2BCB3
	for <linux-btrfs@vger.kernel.org>; Fri, 15 May 2026 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778864441;
	bh=g5GNWNH9M83iN631+TfY2qlTvavqxtcgwjTbRGzwvIo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=aNW2EKFhmDv6z9jxHPjQlklFglO4V1iPRBKEOxIYHFbg8J3zNsvbhVeSBI8E3EC3C
	 jDTlSOm2WO2BoUp8P+F4ooAACxQ3os6S6EsSFQq8Lh+UIA47WWHfI5ByZ9gubulGvj
	 P4HVtqeHxS9cHqJcJUf1kRpKxXtSO9G0pHmjdNCS0OoGmTmrddf/+tdQ8CcdXTpAD9
	 MVyqz8a2sN3VafBEzVkYLTVmrz+iSMIYwm2V0doAuvDZS9Izq190lBYFffB8DyYX/Z
	 7+cnTRUZ0zfsF9XZw3SkEBj9RUItEg9QGjpfAjRiElnlM+juOy8jfibOTvnBWz70I2
	 hXuetWLgkXUuQ==
From: fdmanana@kernel.org
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 12/28] btrfs: tracepoints: add trace event for when fsync finishes
Date: Fri, 15 May 2026 18:00:09 +0100
Message-ID: <d35c709027313d25a9c7b6fb0c22973badef9594.1778776707.git.fdmanana@suse.com>
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

Currently we only have a trace event for when a fsync operation starts,
but this alone is not very helpful. Add a trace event for when fsync
finishes, which reports its return value, so that using tracing we can
see which other trace events happened in between (several will be added
soon for inode logging steps) and even measure execution time.

So rename the existing trace event btrfs_sync_file to
btrfs_sync_file_enter and add the trace event btrfs_sync_file_exit.
The naming is similar to what ext4 does (ext4_sync_file_enter and
ext4_sync_file_exit) and with similar information reported.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
---
 fs/btrfs/file.c              |  4 +++-
 include/trace/events/btrfs.h | 28 +++++++++++++++++++++++++++-
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index f77ccef837b9..d786b9666755 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1564,7 +1564,7 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 		btrfs_assert_inode_locked(inode);
 	}
 
-	trace_btrfs_sync_file(file, datasync);
+	trace_btrfs_sync_file_enter(file, datasync);
 
 	btrfs_init_log_ctx(&ctx, inode);
 
@@ -1810,6 +1810,8 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	err = file_check_and_advance_wb_err(file);
 	if (!ret)
 		ret = err;
+	trace_btrfs_sync_file_exit(file, ret);
+
 	return ret;
 
 out_release_extents:
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index 801f4793e002..1b19364eabff 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -808,7 +808,7 @@ TRACE_EVENT(btrfs_writepage_end_io_hook,
 		  __entry->end, __entry->uptodate)
 );
 
-TRACE_EVENT(btrfs_sync_file,
+TRACE_EVENT(btrfs_sync_file_enter,
 
 	TP_PROTO(const struct file *file, int datasync),
 
@@ -840,6 +840,32 @@ TRACE_EVENT(btrfs_sync_file,
 		  __entry->datasync)
 );
 
+TRACE_EVENT(btrfs_sync_file_exit,
+
+	TP_PROTO(const struct file *file, int ret),
+
+	TP_ARGS(file, ret),
+
+	TP_STRUCT__entry_btrfs(
+		__field(	u64,	ino		)
+		__field(	int,    ret		)
+		__field(	u64,    root_objectid	)
+	),
+
+	TP_fast_assign(
+		struct btrfs_inode *inode = BTRFS_I(file_inode(file));
+
+		TP_fast_assign_fsid(inode->root->fs_info);
+		__entry->root_objectid	= btrfs_root_id(inode->root);
+		__entry->ino		= btrfs_ino(inode);
+		__entry->ret		= ret;
+	),
+
+	TP_printk_btrfs("root=%llu(%s) ino=%llu ret=%d",
+			show_root_type(__entry->root_objectid),
+			__entry->ino, __entry->ret)
+);
+
 TRACE_EVENT(btrfs_sync_fs,
 
 	TP_PROTO(const struct btrfs_fs_info *fs_info, int wait),
-- 
2.47.2

