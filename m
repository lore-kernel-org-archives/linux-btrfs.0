Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52376 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFWLAm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 07:00:42 -0400
Received: by mail-wi0-f173.google.com with SMTP id cc10so3995357wib.0
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Jun 2014 04:00:38 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/6 v5] Btrfs: send, bump stream version
Date: Mon, 23 Jun 2014 13:00:18 +0100
Message-Id: <1403524818-32439-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This increases the send stream version from version 1 to version 2, adding
new commands:

1) total data size - used to tell the receiver how much file data the stream
   will add or update;

2) fallocate - used to pre-allocate space for files and to punch holes in files;

3) inode set flags;

4) set inode otime.

This is preparation work for subsequent changes that implement the new features.

A version 2 stream is only produced if the send ioctl caller passes in one of the
new flags (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | BTRFS_SEND_FLAG_STREAM_V2), meaning
old clients are unaffected.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: A v2 stream is now only produced if the send ioctl caller passes in one of
    the new flags (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | BTRFS_SEND_FLAG_SUPPORT_FALLOCATE)
    to avoid breaking old clients.
V3: Removed BTRFS_SEND_FLAG_SUPPORT_FALLOCATE and added BTRFS_SEND_FLAG_STREAM_V2,
    added commands for inode set flags and otime.
V4: There's no v4, bumped directly to v5 to make all patches in the series have the same
    version.
V5: Rebased against latest chris/integration branch.

 fs/btrfs/send.c            |  7 ++++++-
 fs/btrfs/send.h            | 21 ++++++++++++++++++++-
 include/uapi/linux/btrfs.h | 21 ++++++++++++++++++++-
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa6..d7ef14b 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -637,7 +637,10 @@ static int send_header(struct send_ctx *sctx)
 	struct btrfs_stream_header hdr;
 
 	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
-	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
+	if (sctx->flags & BTRFS_SEND_FLAG_STREAM_V2)
+		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_2);
+	else
+		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_1);
 
 	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
 					&sctx->send_off);
@@ -5572,6 +5575,8 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	INIT_LIST_HEAD(&sctx->name_cache_list);
 
 	sctx->flags = arg->flags;
+	if (sctx->flags & BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE)
+		sctx->flags |= BTRFS_SEND_FLAG_STREAM_V2;
 
 	sctx->send_filp = fget(arg->send_fd);
 	if (!sctx->send_filp) {
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 48d425a..96f583c 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -20,7 +20,8 @@
 #include "ctree.h"
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
-#define BTRFS_SEND_STREAM_VERSION 1
+#define BTRFS_SEND_STREAM_VERSION_1 1
+#define BTRFS_SEND_STREAM_VERSION_2 2
 
 #define BTRFS_SEND_BUF_SIZE (1024 * 64)
 #define BTRFS_SEND_READ_SIZE (1024 * 48)
@@ -87,6 +88,15 @@ enum btrfs_send_cmd {
 
 	BTRFS_SEND_C_END,
 	BTRFS_SEND_C_UPDATE_EXTENT,
+
+	/*
+	 * The following commands were added in stream version 2.
+	 */
+	BTRFS_SEND_C_TOTAL_DATA_SIZE,
+	BTRFS_SEND_C_FALLOCATE,
+	BTRFS_SEND_C_INODE_SET_FLAGS,
+	BTRFS_SEND_C_UTIMES2, /* Same as UTIMES, but it includes OTIME too. */
+
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
@@ -125,10 +135,19 @@ enum {
 	BTRFS_SEND_A_CLONE_OFFSET,
 	BTRFS_SEND_A_CLONE_LEN,
 
+	/*
+	 * The following attributes were added in stream version 2.
+	 */
+	BTRFS_SEND_A_FALLOCATE_FLAGS, /* 32 bits */
+	BTRFS_SEND_A_INODE_FLAGS,     /* 32 bits */
+
 	__BTRFS_SEND_A_MAX,
 };
 #define BTRFS_SEND_A_MAX (__BTRFS_SEND_A_MAX - 1)
 
+#define BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE   (1 << 0)
+#define BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE  (1 << 1)
+
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
 #endif
diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
index 6f9c38c..62440d8 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -477,10 +477,29 @@ struct btrfs_ioctl_received_subvol_args {
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
1.9.1

