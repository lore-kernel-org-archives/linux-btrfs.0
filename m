Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216Ab3A3Wnn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 17:43:43 -0500
Date: Wed, 30 Jan 2013 14:43:41 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com
Subject: [RESEND][PATCH] btrfs: add "no file data" flag to btrfs send ioctl
Message-ID: <20130130224341.GZ12558@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This patch adds the flag, BTRFS_SEND_FLAG_NO_FILE_DATA to the btrfs send
ioctl code. When this flag is set, the btrfs send code will never write file
data into the stream (thus also avoiding expensive reads of that data in the
first place). BTRFS_SEND_C_UPDATE_EXTENT commands will be sent (instead of
BTRFS_SEND_C_WRITE) with an offset, length pair indicating the extent in
question.

This patch does not affect the operation of BTRFS_SEND_C_CLONE commands -
they will continue to be sent when a search finds an appropriate extent to
clone from.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.h |    7 +++++++
 fs/btrfs/send.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/send.h  |    1 +
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 731e287..1f6cfdd 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -363,6 +363,13 @@ struct btrfs_ioctl_received_subvol_args {
 	__u64	reserved[16];		/* in */
 };
 
+/*
+ * Caller doesn't want file data in the send stream, even if the
+ * search of clone sources doesn't find an extent. UPDATE_EXTENT
+ * commands will be sent instead of WRITE commands.
+ */
+#define BTRFS_SEND_FLAG_NO_FILE_DATA     0x1
+
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
 	__u64 clone_sources_count;	/* in */
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e78b297..8d0c6b4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -85,6 +85,7 @@ struct send_ctx {
 	u32 send_max_size;
 	u64 total_send_size;
 	u64 cmd_send_size[BTRFS_SEND_C_MAX + 1];
+	u64 flags;	/* 'flags' member of btrfs_ioctl_send_args is u64 */
 
 	struct vfsmount *mnt;
 
@@ -3707,6 +3708,39 @@ out:
 	return ret;
 }
 
+/*
+ * Send an update extent command to user space.
+ */
+static int send_update_extent(struct send_ctx *sctx,
+			      u64 offset, u32 len)
+{
+	int ret = 0;
+	struct fs_path *p;
+
+	p = fs_path_alloc(sctx);
+	if (!p)
+		return -ENOMEM;
+
+	ret = begin_cmd(sctx, BTRFS_SEND_C_UPDATE_EXTENT);
+	if (ret < 0)
+		goto out;
+
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto out;
+
+	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);
+
+	ret = send_cmd(sctx);
+
+tlv_put_failure:
+out:
+	fs_path_free(sctx, p);
+	return ret;
+}
+
 static int send_write_or_clone(struct send_ctx *sctx,
 			       struct btrfs_path *path,
 			       struct btrfs_key *key,
@@ -3742,7 +3776,11 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		goto out;
 	}
 
-	if (!clone_root) {
+	if (clone_root) {
+		ret = send_clone(sctx, offset, len, clone_root);
+	} else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
+		ret = send_update_extent(sctx, offset, len);
+	} else {
 		while (pos < len) {
 			l = len - pos;
 			if (l > BTRFS_SEND_READ_SIZE)
@@ -3755,10 +3793,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 			pos += ret;
 		}
 		ret = 0;
-	} else {
-		ret = send_clone(sctx, offset, len, clone_root);
 	}
-
 out:
 	return ret;
 }
@@ -4570,6 +4605,11 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	INIT_RADIX_TREE(&sctx->name_cache, GFP_NOFS);
 	INIT_LIST_HEAD(&sctx->name_cache_list);
 
+	if (arg->flags & ~BTRFS_SEND_FLAG_NO_FILE_DATA)
+		return -EINVAL;
+
+	sctx->flags = arg->flags;
+
 	sctx->send_filp = fget(arg->send_fd);
 	if (IS_ERR(sctx->send_filp)) {
 		ret = PTR_ERR(sctx->send_filp);
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 1bf4f32..8bb18f7 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -86,6 +86,7 @@ enum btrfs_send_cmd {
 	BTRFS_SEND_C_UTIMES,
 
 	BTRFS_SEND_C_END,
+	BTRFS_SEND_C_UPDATE_EXTENT,
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
-- 
1.7.10.4

