Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:45922 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaDOPk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 11:40:27 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so9503904wes.25
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 08:40:26 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 1/4] Btrfs: send, bump stream version
Date: Tue, 15 Apr 2014 17:40:18 +0100
Message-Id: <1397580021-26598-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This increases the send stream version from version 1 to version 2, adding
2 new commands:

1) total data size - used to tell the receiver how much file data the stream
   will add or update;

2) fallocate - used to pre-allocate space for files and to punch holes in files.

This is preparation work for subsequent changes that implement the new features
(computing total data size and use fallocate for better performance).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 fs/btrfs/send.h            | 13 ++++++++++++-
 include/uapi/linux/btrfs.h | 13 ++++++++++++-
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 48d425a..7b5df08 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -20,7 +20,7 @@
 #include "ctree.h"
 
 #define BTRFS_SEND_STREAM_MAGIC "btrfs-stream"
-#define BTRFS_SEND_STREAM_VERSION 1
+#define BTRFS_SEND_STREAM_VERSION 2
 
 #define BTRFS_SEND_BUF_SIZE (1024 * 64)
 #define BTRFS_SEND_READ_SIZE (1024 * 48)
@@ -87,6 +87,11 @@ enum btrfs_send_cmd {
 
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
@@ -125,10 +130,16 @@ enum {
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
index b4d6909..444893d 100644
--- a/include/uapi/linux/btrfs.h
+++ b/include/uapi/linux/btrfs.h
@@ -464,10 +464,21 @@ struct btrfs_ioctl_received_subvol_args {
  */
 #define BTRFS_SEND_FLAG_OMIT_END_CMD		0x4
 
+/*
+ * Calculate the amount (in bytes) of new file data between the send and
+ * parent snapshots, or in case of a full send, the total amount of file data
+ * we will send.
+ * This corresponds to the sum of the data lengths of each write, clone and
+ * fallocate commands that are sent through the send stream. The receiving end
+ * can use this information to compute progress.
+ */
+#define BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE	0x8
+
 #define BTRFS_SEND_FLAG_MASK \
 	(BTRFS_SEND_FLAG_NO_FILE_DATA | \
 	 BTRFS_SEND_FLAG_OMIT_STREAM_HEADER | \
-	 BTRFS_SEND_FLAG_OMIT_END_CMD)
+	 BTRFS_SEND_FLAG_OMIT_END_CMD | \
+	 BTRFS_SEND_FLAG_CALCULATE_DATA_SIZE)
 
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
-- 
1.9.1

