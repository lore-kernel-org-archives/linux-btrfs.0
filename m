Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:45284 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaDOPlK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Apr 2014 11:41:10 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so9790666wgh.7
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Apr 2014 08:41:09 -0700 (PDT)
From: Filipe David Borba Manana <fdmanana@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Filipe David Borba Manana <fdmanana@gmail.com>
Subject: [PATCH 3/4] Btrfs-progs: send, implement fallocate command callback
Date: Tue, 15 Apr 2014 17:40:50 +0100
Message-Id: <1397580051-26643-3-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
References: <1397580051-26643-1-git-send-email-fdmanana@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The fallocate send stream command, added in stream version 2, is used to
pre-allocate space for files and punch file holes. This change implements
the callback for that new command, using the fallocate function from the
standard C library to carry out the specified action (allocate file space
or punch a file hole).

Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
---
 cmds-receive.c | 38 ++++++++++++++++++++++++++++++++++++++
 send-stream.c  | 13 +++++++++++++
 send-stream.h  |  2 ++
 3 files changed, 53 insertions(+)

diff --git a/cmds-receive.c b/cmds-receive.c
index 19300fc..3f30066 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -41,6 +41,7 @@
 #include <sys/types.h>
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
+#include <linux/falloc.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -887,6 +888,42 @@ out:
 	return ret;
 }
 
+static int process_fallocate(const char *path, u32 flags, u64 offset,
+			     u64 len, void *user)
+{
+	struct btrfs_receive *r = user;
+	char *full_path = path_cat(r->full_subvol_path, path);
+	int mode = 0;
+	int ret;
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
+	ret = open_inode_for_write(r, full_path);
+	if (ret < 0)
+		goto out;
+
+	ret = fallocate(r->write_fd, mode, offset, len);
+	if (ret) {
+		ret = -errno;
+		fprintf(stderr,
+			"ERROR: fallocate against %s failed. %s\n",
+			path, strerror(-ret));
+		goto out;
+	}
+	update_progress(r, len);
+
+out:
+	free(full_path);
+	return ret;
+}
 
 static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
@@ -910,6 +947,7 @@ static struct btrfs_send_ops send_ops = {
 	.chown = process_chown,
 	.utimes = process_utimes,
 	.total_data_size = process_total_data_size,
+	.fallocate = process_fallocate,
 };
 
 static int do_receive(struct btrfs_receive *r, const char *tomnt, int r_fd)
diff --git a/send-stream.c b/send-stream.c
index 474d012..f117533 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -425,6 +425,19 @@ static int read_and_process_cmd(struct btrfs_send_stream *s)
 		TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &tmp);
 		ret = s->ops->total_data_size(tmp, s->user);
 		break;
+	case BTRFS_SEND_C_FALLOCATE:
+		{
+			u32 flags;
+			u64 len;
+
+			TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+			TLV_GET_U32(s, BTRFS_SEND_A_FALLOCATE_FLAGS, &flags);
+			TLV_GET_U64(s, BTRFS_SEND_A_FILE_OFFSET, &offset);
+			TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &len);
+			ret = s->ops->fallocate(path, flags, offset, len,
+						s->user);
+		}
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/send-stream.h b/send-stream.h
index 3a653a9..479e40c 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -55,6 +55,8 @@ struct btrfs_send_ops {
 		      void *user);
 	int (*update_extent)(const char *path, u64 offset, u64 len, void *user);
 	int (*total_data_size)(u64 size, void *user);
+	int (*fallocate)(const char *path, u32 flags, u64 offset,
+			 u64 len, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
-- 
1.9.1

