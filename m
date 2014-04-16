Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41436 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161469AbaDPPQ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 11:16:27 -0400
Received: by mail-wi0-f173.google.com with SMTP id z2so1563057wiv.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 08:16:25 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/4 v3] Btrfs: send, use fallocate command to punch holes
Date: Wed, 16 Apr 2014 17:16:59 +0100
Message-Id: <1397665019-21410-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580021-26598-3-git-send-email-fdmanana@gmail.com>
References: <1397580021-26598-3-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of sending a write command with a data buffer filled with 0 value bytes,
use the fallocate command, introduced in the send stream version 2, to tell the
receiver to punch a file hole using the fallocate system call.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: A v2 stream is now only produced if the send ioctl caller passes in one of
    the new flags (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | BTRFS_SEND_FLAG_SUPPORT_FALLOCATE)
    to avoid breaking old clients.
V3: Added missing path allocation, messed up rebase.

 fs/btrfs/send.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/send.h |  4 ++++
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index f5db492..bb9afea 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -564,6 +564,7 @@ static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 		return tlv_put(sctx, attr, &__tmp, sizeof(__tmp));	\
 	}
 
+TLV_PUT_DEFINE_INT(32)
 TLV_PUT_DEFINE_INT(64)
 
 static int tlv_put_string(struct send_ctx *sctx, u16 attr,
@@ -4483,18 +4484,59 @@ out:
 	return ret;
 }
 
+static int send_fallocate(struct send_ctx *sctx, u32 flags,
+			  u64 offset, u64 len)
+{
+	struct fs_path *p = NULL;
+	int ret = 0;
+
+	ASSERT(sctx->flags & BTRFS_SEND_FLAG_SUPPORT_FALLOCATE);
+
+	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
+		sctx->total_data_size += len;
+		return 0;
+	}
+
+	p = fs_path_alloc();
+	if (!p)
+		return -ENOMEM;
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto out;
+
+	ret = begin_cmd(sctx, BTRFS_SEND_C_FALLOCATE);
+	if (ret < 0)
+		goto out;
+	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
+	TLV_PUT_U32(sctx, BTRFS_SEND_A_FALLOCATE_FLAGS, flags);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);
+	ret = send_cmd(sctx);
+
+tlv_put_failure:
+out:
+	fs_path_free(p);
+	return ret;
+}
+
 static int send_hole(struct send_ctx *sctx, u64 end)
 {
 	struct fs_path *p = NULL;
 	u64 offset = sctx->cur_inode_last_extent;
-	u64 len;
+	u64 len = end - offset;
 	int ret = 0;
 
 	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
-		sctx->total_data_size += end - offset;
+		sctx->total_data_size += len;
 		return 0;
 	}
 
+	if (sctx->flags & BTRFS_SEND_FLAG_SUPPORT_FALLOCATE)
+		return send_fallocate(sctx,
+				      BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+				      offset,
+				      len);
+
 	p = fs_path_alloc();
 	if (!p)
 		return -ENOMEM;
@@ -4551,7 +4593,8 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
 	}
 
-	if (offset + len > sctx->cur_inode_size)
+	if (offset < sctx->cur_inode_size &&
+	    offset + len > sctx->cur_inode_size)
 		len = sctx->cur_inode_size - offset;
 	if (len == 0) {
 		ret = 0;
@@ -4568,6 +4611,12 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		ret = send_clone(sctx, offset, len, clone_root);
 	} else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
 		ret = send_update_extent(sctx, offset, len);
+	} else if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0 &&
+		   type != BTRFS_FILE_EXTENT_INLINE &&
+		   (sctx->flags & BTRFS_SEND_FLAG_SUPPORT_FALLOCATE) &&
+		   offset < sctx->cur_inode_size) {
+		ret = send_fallocate(sctx, BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+				     offset, len);
 	} else {
 		while (pos < len) {
 			l = len - pos;
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 367030d..a632c0d 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -141,6 +141,10 @@ enum {
 #define BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE   (1 << 0)
 #define BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE  (1 << 1)
 
+#define BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS        \
+	(BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE |  \
+	 BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE)
+
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
 #endif
-- 
1.9.1

