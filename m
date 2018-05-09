Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:52092 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933420AbeEICL5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 May 2018 22:11:57 -0400
Received: by mail-it0-f65.google.com with SMTP id n202-v6so18585856ita.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 May 2018 19:11:56 -0700 (PDT)
From: Howard McLauchlan <linux@hmclauchlan.com>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Filipe Manana <fdmanana@suse.com>,
        Omar Sandoval <osandov@osandov.com>,
        Howard McLauchlan <hmclauchlan@fb.com>
Subject: [RFC PATCH 6/6] btrfs-progs: add chattr support for send/receive
Date: Tue,  8 May 2018 22:11:37 -0400
Message-Id: <20180509021137.8342-6-linux@hmclauchlan.com>
In-Reply-To: <20180509021137.8342-1-linux@hmclauchlan.com>
References: <20180509021137.8342-1-linux@hmclauchlan.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Howard McLauchlan <hmclauchlan@fb.com>

Presently, btrfs send/receive does not propagate inode attribute flags;
all chattr operations are effectively discarded upon transmission.

This patch adds userspace support for inode attribute flags. Kernel
support can be found under the commit:

    btrfs: add chattr support for send/receive

An associated xfstest can also be found at:

    btrfs: verify chattr support for send/receive test

Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
---
 cmds-receive.c | 37 +++++++++++++++++++++++++++++++++++++
 send-dump.c    |  6 ++++++
 send-stream.c  |  5 +++++
 send-stream.h  |  1 +
 send.h         |  4 ++--
 5 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 20e593f7..2a841bfc 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -40,6 +40,7 @@
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
 #include <linux/falloc.h>
+#include <linux/fs.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -1201,6 +1202,41 @@ out:
 	return ret;
 }
 
+static int process_chattr(const char *path, u64 flags, void *user)
+{
+	int ret = 0;
+	int fd = 0;
+	int _flags = flags;
+	struct btrfs_receive *rctx = user;
+	char full_path[PATH_MAX];
+
+	ret = path_cat_out(full_path, rctx->full_subvol_path, path);
+	if (ret < 0) {
+		error("chattr: path invalid: %s", path);
+		goto out;
+	}
+
+	if (g_verbose >= 2)
+		fprintf(stderr, "chattr %s - flags=0%o\n", path, (int)flags);
+
+	fd = open(full_path, O_RDONLY);
+	if (fd < 0) {
+		ret = -errno;
+		error("cannot open %s: %s", path, strerror(-ret));
+		goto out;
+	}
+
+	ret = ioctl(fd, FS_IOC_SETFLAGS, &_flags);
+	if (ret < 0) {
+		ret = -errno;
+		error("chattr %s failed: %s", path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	return ret;
+}
+
 static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
 	.snapshot = process_snapshot,
@@ -1225,6 +1261,7 @@ static struct btrfs_send_ops send_ops = {
 	.update_extent = process_update_extent,
 	.total_data_size = process_total_data_size,
 	.fallocate = process_fallocate,
+	.chattr = process_chattr,
 };
 
 static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
diff --git a/send-dump.c b/send-dump.c
index c5a695a2..15aea402 100644
--- a/send-dump.c
+++ b/send-dump.c
@@ -331,6 +331,11 @@ static int print_fallocate(const char *path, u32 flags, u64 offset, u64 len,
 			  len);
 }
 
+static int print_chattr(const char *path, u64 flags, void *user)
+{
+	return PRINT_DUMP(user, path, "chattr", "flags=%llu", flags);
+}
+
 struct btrfs_send_ops btrfs_print_send_ops = {
 	.subvol = print_subvol,
 	.snapshot = print_snapshot,
@@ -355,4 +360,5 @@ struct btrfs_send_ops btrfs_print_send_ops = {
 	.update_extent = print_update_extent,
 	.total_data_size = print_total_data_size,
 	.fallocate = print_fallocate,
+	.chattr = print_chattr,
 };
diff --git a/send-stream.c b/send-stream.c
index 74ec37dd..4f26fae3 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -470,6 +470,11 @@ static int read_and_process_cmd(struct btrfs_send_stream *sctx)
 						sctx->user);
 		}
 		break;
+	case BTRFS_SEND_C_CHATTR:
+		TLV_GET_STRING(sctx, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(sctx, BTRFS_SEND_A_CHATTR, &tmp);
+		ret = sctx->ops->chattr(path, tmp, sctx->user);
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/send-stream.h b/send-stream.h
index 89e64043..a9f08d52 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -69,6 +69,7 @@ struct btrfs_send_ops {
 	int (*total_data_size)(u64 size, void *user);
 	int (*fallocate)(const char *path, u32 flags, u64 offset,
 			 u64 len, void *user);
+	int (*chattr)(const char *path, u64 flags, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
diff --git a/send.h b/send.h
index eb14fba3..5b5ada61 100644
--- a/send.h
+++ b/send.h
@@ -103,8 +103,8 @@ enum btrfs_send_cmd {
 	 */
 	BTRFS_SEND_C_TOTAL_DATA_SIZE,
 	BTRFS_SEND_C_FALLOCATE,
-	BTRFS_SEND_C_INODE_SET_FLAGS,
 	BTRFS_SEND_C_UTIMES2, /* Same as UTIMES, but it includes OTIME too. */
+	BTRFS_SEND_C_CHATTR,
 
 	__BTRFS_SEND_C_MAX,
 };
@@ -148,7 +148,7 @@ enum {
 	 * The following attributes were added in stream version 2.
 	 */
 	BTRFS_SEND_A_FALLOCATE_FLAGS, /* 32 bits */
-	BTRFS_SEND_A_INODE_FLAGS,     /* 32 bits */
+	BTRFS_SEND_A_CHATTR,	      /* 32 bits */
 
 	__BTRFS_SEND_A_MAX,
 };
-- 
2.17.0

