Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54648 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341AbaDPNsa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 09:48:30 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so1405208wiv.13
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 06:48:28 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/4 v2] Btrfs: send, bump stream version
Date: Wed, 16 Apr 2014 15:48:46 +0100
Message-Id: <1397659726-30615-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
References: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This increases the send stream version from version 1 to version 2, adding
2 new commands:

1) total data size - used to tell the receiver how much file data the stream
   will add or update;

2) fallocate - used to pre-allocate space for files and to punch holes in files.

This is preparation work for subsequent changes that implement the new features
(computing total data size and use fallocate for better performance).

A version 2 stream is only produced if the send ioctl caller passes in one of the
new flags (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | BTRFS_SEND_FLAG_SUPPORT_FALLOCATE),
meaning old clients are unaffected.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: A v2 stream is now only produced if the send ioctl caller passes in one of
    the new flags (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE | BTRFS_SEND_FLAG_SUPPORT_FALLOCATE)
    to avoid breaking old clients.

 fs/btrfs/send.c            |  6 +++++-
 fs/btrfs/send.h            | 14 +++++++++++++-
 include/uapi/linux/btrfs.h | 24 +++++++++++++++++++++++-
 3 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 289e9f3..53712aa 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -632,7 +632,11 @@ static int send_header(struct send_ctx *sctx)
 	struct btrfs_stream_header hdr;
 
 	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
-	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
+	if (sctx->flags & (BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE |
+			   BTRFS_SEND_FLAG_SUPPORT_FALLOCATE))
+		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_2);
+	else
+		hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION_1);
 
 	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
 					&sctx->send_off);
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 48d425a..367030d 100644
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
@@ -87,6 +88,11 @@ enum btrfs_send_cmd {
 
 	BTRFS_SEND_C_END,
 	BTRFS_SEND_C_UPDATE_EXTENT,
+
+	/* added in stream version 2 */
+	BTRFS_SEND_C_TOTAL_DATA_SIZE,
+	BTRFS_SEND_C_FALLOCATE,
+
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
@@ -125,10 +131,16 @@ enum {
 	BTRFS_SEND_A_CLONE_OFFSET,
 	BTRFS_SEND_A_CLONE_LEN,
 
+	/* added in stream version 2 */
+	BTRFS_SEND_A_FALLOCATE_FLAGS,
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
index b4d6909..6611406 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -464,10 +464,32 @@ struct btrfs_ioctl_received_subvol_args {
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
+ * Added in send stream version 2.
+ */
+#define BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE	0x8
+
+/*
+ * Use fallocate command to pre-allocate file extents and punch file holes,
+ * instead of write commands with data buffers filled with 0 value bytes.
+ *
+ * Added in send stream version 2.
+ */
+#define BTRFS_SEND_FLAG_SUPPORT_FALLOCATE       0x10
+
 #define BTRFS_SEND_FLAG_MASK \
 	(BTRFS_SEND_FLAG_NO_FILE_DATA | \
 	 BTRFS_SEND_FLAG_OMIT_STREAM_HEADER | \
-	 BTRFS_SEND_FLAG_OMIT_END_CMD)
+	 BTRFS_SEND_FLAG_OMIT_END_CMD | \
+	 BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE |	\
+	 BTRFS_SEND_FLAG_SUPPORT_FALLOCATE)
 
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
-- 
1.9.1

