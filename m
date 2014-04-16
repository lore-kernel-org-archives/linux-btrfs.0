Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:54218 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161051AbaDPNyG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Apr 2014 09:54:06 -0400
Received: by mail-we0-f176.google.com with SMTP id x48so10965728wes.35
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Apr 2014 06:54:04 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/4 v2] Btrfs-progs: send, bump stream version
Date: Wed, 16 Apr 2014 15:54:38 +0100
Message-Id: <1397660078-7897-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
References: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This increases the send stream version from version 1 to version 2, adding
2 new commands:

1) total data size - used to tell the receiver how much file data the stream
   will add or update;

2) fallocate - used to pre-allocate space for files and to punch holes in files.

This is preparation work for subsequent changes that implement the new features
(computing total data size and use fallocate for better performance).

This doesn't break compatibility with older kernels or clients. In order to get
a version 2 send stream, new flags must be passed to the send ioctl.

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---

V2: Added new send ioctl flag BTRFS_SEND_FLAG_SUPPORT_FALLOCATE. A version 2
    stream is now only produced is the ioctl caller specifies at least one of
    the new send flags (BTRFS_SEND_FLAG_SUPPORT_FALLOCATE or
    BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE).

 ioctl.h | 18 ++++++++++++++++++
 send.h  | 13 ++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/ioctl.h b/ioctl.h
index 231660a..e2c506b 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -392,6 +392,24 @@ struct btrfs_ioctl_received_subvol_args {
  */
 #define BTRFS_SEND_FLAG_OMIT_END_CMD		0x4
 
+/*
+ * The sum of all length fields the receiver will get in write, clone and
+ * fallocate commands.
+ * This can be used by the receiver to compute progress, at the expense of some
+ * initial metadata scan performed by the sender (kernel).
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
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
 	__u64 clone_sources_count;	/* in */
diff --git a/send.h b/send.h
index e8da785..69e81fb 100644
--- a/send.h
+++ b/send.h
@@ -24,7 +24,7 @@ extern "C" {
 #endif
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
-#define BTRFS_SEND_STREAM_VERSION 1
+#define BTRFS_SEND_STREAM_VERSION 2
 
 #define BTRFS_SEND_BUF_SIZE (1024 * 64)
 #define BTRFS_SEND_READ_SIZE (1024 * 48)
@@ -91,6 +91,11 @@ enum btrfs_send_cmd {
 
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
@@ -129,10 +134,16 @@ enum {
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
-- 
1.9.1

