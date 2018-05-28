Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:42137 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752958AbeE1CSX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:23 -0400
Received: by mail-io0-f196.google.com with SMTP id a10-v6so12477056ioc.9
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:22 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [RFC PATCH v2 1/6] btrfs: send, bump stream version
Date: Sun, 27 May 2018 22:14:30 -0400
Message-Id: <20180528021443.13923-2-linux@hmclauchlan.com>
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
References: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe David Borba Manana <fdmanana@gmail.com>

This increases the send stream version from version 1 to version 2, adding
new commands:

1) total data size - used to tell the receiver how much file data the stream
   will add or update;

2) fallocate - used to pre-allocate space for files and to punch holes in files;

3) inode set flags (chattr);

4) set inode otime;

5) sending compressed writes.

This is preparation work for subsequent changes that implement the new features.

A version 2 stream is only produced if the send ioctl caller passes in one of the
new flags (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | BTRFS_SEND_FLAG_STREAM_V2), meaning
old clients are unaffected.

[Howard: rebased on 4.17-rc7]
Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
Reviewed-by: Omar Sandoval <osandov@fb.com>
---
 fs/btrfs/send.c            |  7 ++++++-
 fs/btrfs/send.h            | 22 +++++++++++++++++++++-
 include/uapi/linux/btrfs.h | 21 ++++++++++++++++++++-
 3 files changed, 47 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index c0074d2d7d6d..eccd69387065 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -649,7 +649,10 @@ static int send_header(struct send_ctx *sctx)
 	struct btrfs_stream_header hdr;
 
 	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
-	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
+	if (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2)
+		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_2);
+	else
+		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_1);
 
 	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
 					&sctx->send_off);
@@ -6535,6 +6538,8 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	INIT_LIST_HEAD(&sctx->name_cache_list);
 
 	sctx->flags = arg->flags;
+	if (sctx->flags & BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE)
+		sctx->flags |= BTRFS_SEND_FLAG_STREAM_V2;
 
 	sctx->send_filp = fget(arg->send_fd);
 	if (!sctx->send_filp) {
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index ead397f7034f..152180304078 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -10,7 +10,8 @@
 #include "ctree.h"
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
-#define BTRFS_SEND_STREAM_VERSION 1
+#define BTRFS_SEND_STREAM_VERSION_1 1
+#define BTRFS_SEND_STREAM_VERSION_2 2
 
 #define BTRFS_SEND_BUF_SIZE SZ_64K
 #define BTRFS_SEND_READ_SIZE (48 * SZ_1K)
@@ -77,6 +78,16 @@ enum btrfs_send_cmd {
 
 	BTRFS_SEND_C_END,
 	BTRFS_SEND_C_UPDATE_EXTENT,
+
+	/*
+	 * The following commands were added in stream version 2.
+	 */
+	BTRFS_SEND_C_TOTAL_DATA_SIZE,
+	BTRFS_SEND_C_FALLOCATE,
+	BTRFS_SEND_C_CHATTR,
+	BTRFS_SEND_C_UTIMES2, /* Same as UTIMES, but it includes OTIME too. */
+	BTRFS_SEND_C_WRITE_COMPRESSED, /* to be implemented */
+
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
@@ -115,10 +126,19 @@ enum {
 	BTRFS_SEND_A_CLONE_OFFSET,
 	BTRFS_SEND_A_CLONE_LEN,
 
+	/*
+	 * The following attributes were added in stream version 2.
+	 */
+	BTRFS_SEND_A_FALLOCATE_FLAGS,
+	BTRFS_SEND_A_CHATTR,
+
 	__BTRFS_SEND_A_MAX,
 };
 #define BTRFS_SEND_A_MAX (__BTRFS_SEND_A_MAX - 1)
 
+#define BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE   (1 << 0)
+#define BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE  (1 << 1)
+
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index c8d99b9ca550..ed63176660d2 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -711,10 +711,29 @@ struct btrfs_ioctl_received_subvol_args {
  */
 #define BTRFS_SEND_FLAG_OMIT_END_CMD		0x4
 
+/*
+ * Calculate the amount (in bytes) of new file data between the send and
+ * parent snapshots, or in case of a full send, the total amount of file data
+ * we will send.
+ * This corresponds to the sum of the data lengths of each write, clone and
+ * fallocate commands that are sent through the send stream. The receiving end
+ * can use this information to compute progress.
+ *
+ * Added in send stream version 2, and implies producing a version 2 stream.
+ */
+#define BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE	0x8
+
+/*
+ * Used by a client to request a version 2 of the send stream.
+ */
+#define BTRFS_SEND_FLAG_STREAM_V2              0x10
+
 #define BTRFS_SEND_FLAG_MASK \
 	(BTRFS_SEND_FLAG_NO_FILE_DATA | \
 	 BTRFS_SEND_FLAG_OMIT_STREAM_HEADER | \
-	 BTRFS_SEND_FLAG_OMIT_END_CMD)
+	 BTRFS_SEND_FLAG_OMIT_END_CMD | \
+	 BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | \
+	 BTRFS_SEND_FLAG_STREAM_V2)
 
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
-- 
2.17.0

