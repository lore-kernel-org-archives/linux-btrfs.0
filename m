Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:50955 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753037AbeE1CSa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 27 May 2018 22:18:30 -0400
Received: by mail-it0-f68.google.com with SMTP id p3-v6so13195281itc.0
        for <linux-btrfs@vger.kernel.org>; Sun, 27 May 2018 19:18:30 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>
Subject: [PATCH v2 3/6] Btrfs-progs: send, implement fallocate command callback
Date: Sun, 27 May 2018 22:14:38 -0400
Message-Id: <20180528021443.13923-10-linux@hmclauchlan.com>
In-Reply-To: <20180528021443.13923-1-linux@hmclauchlan.com>
References: <20180528021443.13923-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Filipe Manana <fdmanana@gmail.com>

The fallocate send stream command, added in stream version 2, is used to
pre-allocate space for files and punch file holes. This change implements
the callback for that new command, using the fallocate function from the
standard C library to carry out the specified action (allocate file space
or punch a file hole).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-receive.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 send-stream.c  | 13 +++++++++++++
 send-stream.h  |  2 ++
 3 files changed, 59 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index d8ff5194..510b6bc8 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -39,6 +39,7 @@
 #include <sys/types.h>
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
+#include <linux/falloc.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -1149,6 +1150,48 @@ static int process_update_extent(const char *path, u64 offset, u64 len,
 	return 0;
 }
 
+static int process_fallocate(const char *path, u32 flags, u64 offset,
+			     u64 len, void *user)
+{
+	struct btrfs_receive *rctx = user;
+	int mode = 0;
+	int ret;
+	char full_path[PATH_MAX];
+
+	ret = path_cat_out(full_path, rctx->full_subvol_path, path);
+	if (ret < 0) {
+		error("fallocate: path invalid: %s", path);
+		goto out;
+	}
+
+	if (flags & BTRFS_SEND_A_FALLOCATE_FLAG_KEEP_SIZE)
+		mode |= FALLOC_FL_KEEP_SIZE;
+	if (flags & BTRFS_SEND_A_FALLOCATE_FLAG_PUNCH_HOLE)
+		mode |= FALLOC_FL_PUNCH_HOLE;
+
+	if (g_verbose >= 2)
+		fprintf(stderr,
+			"fallocate %s - flags %u, offset %llu, len %llu\n",
+			path, flags, offset, len);
+
+	ret = open_inode_for_write(rctx, full_path);
+	if (ret < 0)
+		goto out;
+
+	ret = fallocate(rctx->write_fd, mode, offset, len);
+	if (ret) {
+		ret = -errno;
+		fprintf(stderr,
+			"ERROR: fallocate against %s failed. %s\n",
+			path, strerror(-ret));
+		goto out;
+	}
+	update_progress(rctx, len);
+
+out:
+	return ret;
+}
+
 static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
 	.snapshot = process_snapshot,
@@ -1172,6 +1215,7 @@ static struct btrfs_send_ops send_ops = {
 	.utimes = process_utimes,
 	.update_extent = process_update_extent,
 	.total_data_size = process_total_data_size,
+	.fallocate = process_fallocate,
 };
 
 static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
diff --git a/send-stream.c b/send-stream.c
index d30fd5a7..74ec37dd 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -457,6 +457,19 @@ static int read_and_process_cmd(struct btrfs_send_stream *sctx)
 		TLV_GET_U64(sctx, BTRFS_SEND_A_SIZE, &tmp);
 		ret = sctx->ops->total_data_size(tmp, sctx->user);
 		break;
+	case BTRFS_SEND_C_FALLOCATE:
+		{
+			u32 flags;
+			u64 len;
+
+			TLV_GET_STRING(sctx, BTRFS_SEND_A_PATH, &path);
+			TLV_GET_U32(sctx, BTRFS_SEND_A_FALLOCATE_FLAGS, &flags);
+			TLV_GET_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, &offset);
+			TLV_GET_U64(sctx, BTRFS_SEND_A_SIZE, &len);
+			ret = sctx->ops->fallocate(path, flags, offset, len,
+						sctx->user);
+		}
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/send-stream.h b/send-stream.h
index 5b244ab6..89e64043 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -67,6 +67,8 @@ struct btrfs_send_ops {
 		      void *user);
 	int (*update_extent)(const char *path, u64 offset, u64 len, void *user);
 	int (*total_data_size)(u64 size, void *user);
+	int (*fallocate)(const char *path, u32 flags, u64 offset,
+			 u64 len, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
-- 
2.17.0

