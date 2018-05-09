Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:56254 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933556AbeEICHv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 22:07:51 -0400
Received: by mail-it0-f68.google.com with SMTP id 144-v6so18538417iti.5
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 19:07:50 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: [RFC PATCH 3/6] btrfs: send, use fallocate command to punch holes
Date: Tue,  8 May 2018 22:06:48 -0400
Message-Id: <20180509020651.7946-4-linux@hmclauchlan.com>
In-Reply-To: <20180509020651.7946-1-linux@hmclauchlan.com>
References: <20180509020651.7946-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe David Borba Manana <fdmanana@gmail.com>

Instead of sending a write command with a data buffer filled with 0 value bytes,
use the fallocate command, introduced in the send stream version 2, to tell the
receiver to punch a file hole using the fallocate system call.

[Howard: rebased on 4.17-rc4]
Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++---
 fs/btrfs/send.h |  4 ++++
 2 files changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 7b184831812b..328c7a2857ae 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -581,6 +581,7 @@ static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
 		return tlv_put(sctx, attr, &__tmp, sizeof(__tmp));	\
 	}
 
+TLV_PUT_DEFINE_INT(32)
 TLV_PUT_DEFINE_INT(64)
 
 static int tlv_put_string(struct send_ctx *sctx, u16 attr,
@@ -5047,17 +5048,57 @@ static int send_update_extent(struct send_ctx *sctx,
 	return ret;
 }
 
+static int send_fallocate(struct send_ctx *sctx, u32 flags,
+			  u64 offset, u64 len)
+{
+	struct fs_path *p = NULL;
+	int ret = 0;
+
+	ASSERT(sctx->flags & BTRFS_SEND_FLAG_STREAM_V2);
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
+	if (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2)
+		return send_fallocate(sctx, BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+				      offset, len);
+
 	if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA)
 		return send_update_extent(sctx, offset, end - offset);
 
@@ -5304,7 +5345,8 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		ret = 0;
 		goto out;
 	}
-	if (offset + len > sctx->cur_inode_size)
+	if (offset < sctx->cur_inode_size &&
+	    offset + len > sctx->cur_inode_size)
 		len = sctx->cur_inode_size - offset;
 	if (len == 0) {
 		ret = 0;
@@ -5325,6 +5367,12 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		data_offset = btrfs_file_extent_offset(path->nodes[0], ei);
 		ret = clone_range(sctx, clone_root, disk_byte, data_offset,
 				  offset, len);
+	} else if (btrfs_file_extent_disk_bytenr(path->nodes[0], ei) == 0 &&
+		 type != BTRFS_FILE_EXTENT_INLINE &&
+		 (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2) &&
+		 offset < sctx->cur_inode_size) {
+		ret = send_fallocate(sctx, BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS,
+				     offset, len);
 	} else {
 		ret = send_extent_data(sctx, offset, len);
 	}
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index a9b5489d690e..a5830d216ac1 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -138,6 +138,10 @@ enum {
 #define BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE   (1 << 0)
 #define BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE  (1 << 1)
 
+#define BTRFS_SEND_PUNCH_HOLE_FALLOC_FLAGS        \
+	(BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE |  \
+	 BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE)
+
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg);
 #endif
-- 
2.17.0

