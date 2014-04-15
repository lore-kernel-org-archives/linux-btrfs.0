Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36284 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaDOPke (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 11:40:34 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so9557056wgg.33
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 08:40:33 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/4] Btrfs: send, use fallocate command to punch holes
Date: Tue, 15 Apr 2014 17:40:20 +0100
Message-Id: <1397580021-26598-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of sending a write command with a data buffer filled with 0 value bytes,
use the fallocate command, introduced in the send stream version 2, to tell the
receiver to punch a file hole using the fallocate system call.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c | 51 +++++++++++++++++++++++++++++++--------------------
 fs/btrfs/send.h |  4 ++++
 2 files changed, 35 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 0cff503..26a09ba 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -564,6 +564,7 @@ static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 		return tlv_put(sctx, attr, &__tmp, sizeof(__tmp));	\
 	}
 
+TLV_PUT_DEFINE_INT(32)
 TLV_PUT_DEFINE_INT(64)
 
 static int tlv_put_string(struct send_ctx *sctx, u16 attr,
@@ -4479,15 +4480,14 @@ out:
 	return ret;
 }
 
-static int send_hole(struct send_ctx *sctx, u64 end)
+static int send_fallocate(struct send_ctx *sctx, u32 flags,
+			  u64 offset, u64 len)
 {
 	struct fs_path *p = NULL;
-	u64 offset = sctx->cur_inode_last_extent;
-	u64 len;
 	int ret = 0;
 
 	if (sctx->phase == SEND_PHASE_COMPUTE_DATA_SIZE) {
-		sctx->total_data_size += end - offset;
+		sctx->total_data_size += len;
 		return 0;
 	}
 
@@ -4496,27 +4496,32 @@ static int send_hole(struct send_ctx *sctx, u64 end)
 		return -ENOMEM;
 	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
 	if (ret < 0)
-		goto tlv_put_failure;
-	memset(sctx->read_buf, 0, BTRFS_SEND_READ_SIZE);
-	while (offset < end) {
-		len = min_t(u64, end - offset, BTRFS_SEND_READ_SIZE);
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
 
-		ret = begin_cmd(sctx, BTRFS_SEND_C_WRITE);
-		if (ret < 0)
-			break;
-		TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
-		TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
-		TLV_PUT(sctx, BTRFS_SEND_A_DATA, sctx->read_buf, len);
-		ret = send_cmd(sctx);
-		if (ret < 0)
-			break;
-		offset += len;
-	}
 tlv_put_failure:
+out:
 	fs_path_free(p);
 	return ret;
 }
 
+static int send_hole(struct send_ctx *sctx, u64 end)
+{
+	u64 offset = sctx->cur_inode_last_extent;
+	u64 len = end - offset;
+
+	return send_fallocate(sctx, BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+			      offset, len);
+}
+
 static int send_write_or_clone(struct send_ctx *sctx,
 			       struct btrfs_path *path,
 			       struct btrfs_key *key,
@@ -4547,7 +4552,8 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		len = btrfs_file_extent_num_bytes(path->nodes[0], ei);
 	}
 
-	if (offset + len > sctx->cur_inode_size)
+	if (offset < sctx->cur_inode_size &&
+	    offset + len > sctx->cur_inode_size)
 		len = sctx->cur_inode_size - offset;
 	if (len == 0) {
 		ret = 0;
@@ -4564,6 +4570,11 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		ret = send_clone(sctx, offset, len, clone_root);
 	} else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
 		ret = send_update_extent(sctx, offset, len);
+	} else if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0 &&
+		   type != BTRFS_FILE_EXTENT_INLINE &&
+		   offset < sctx->cur_inode_size) {
+		ret = send_fallocate(sctx, BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+				     offset, len);
 	} else {
 		while (pos < len) {
 			l = len - pos;
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 7b5df08..a03f66c 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -140,6 +140,10 @@ enum {
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

