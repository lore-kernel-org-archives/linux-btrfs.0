Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48082 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752888AbeDQXkL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 19:40:11 -0400
From: Howard McLauchlan <hmclauchlan@fb.com>
To: <linux-btrfs@vger.kernel.org>
CC: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Omar Sandoval <osandov@osandov.com>,
        <kernel-team@fb.com>, Howard McLauchlan <hmclauchlan@fb.com>
Subject: [PATCH] btrfs-progs: add chattr support for send/receive
Date: Tue, 17 Apr 2018 16:39:36 -0700
Message-ID: <20180417233936.30629-2-hmclauchlan@fb.com>
In-Reply-To: <20180417233936.30629-1-hmclauchlan@fb.com>
References: <20180417233936.30629-1-hmclauchlan@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Presently, btrfs send/receive does not propagate inode attribute flags;
all chattr operations are effectively discarded upon transmission.

This patch adds userspace support for inode attribute flags. Kernel
support can be found under the commit:

    btrfs: add chattr support for send/receive

An associated xfstest can also be found at:

    btrfs: verify chattr support for send/receive test

A caveat is that a user with an updated kernel (aware of chattrs) and an
older version of btrfs-progs (unaware of chattrs) will fail to receive
if a chattr is included in the send stream.

Signed-off-by: Howard McLauchlan <hmclauchlan@fb.com>
---
 cmds-receive.c | 31 +++++++++++++++++++++++++++++++
 send-dump.c    |  8 +++++++-
 send-stream.c  |  5 +++++
 send-stream.h  |  1 +
 send.h         |  2 ++
 5 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/cmds-receive.c b/cmds-receive.c
index 68123a31..883aee4e 100644
--- a/cmds-receive.c
+++ b/cmds-receive.c
@@ -38,6 +38,7 @@
 #include <sys/types.h>
 #include <sys/xattr.h>
 #include <uuid/uuid.h>
+#include <linux/fs.h>
 
 #include "ctree.h"
 #include "ioctl.h"
@@ -1059,6 +1060,35 @@ static int process_update_extent(const char *path, u64 offset, u64 len,
 	return 0;
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
+	ret = ioctl(fd, FS_IOC_SETFLAGS, &_flags);
+
+	if (ret < 0) {
+		ret = -errno;
+		error("chattr %s failed: %s", path, strerror(-ret));
+		goto out;
+	}
+
+out:
+	return ret;
+}
 static struct btrfs_send_ops send_ops = {
 	.subvol = process_subvol,
 	.snapshot = process_snapshot,
@@ -1081,6 +1111,7 @@ static struct btrfs_send_ops send_ops = {
 	.chown = process_chown,
 	.utimes = process_utimes,
 	.update_extent = process_update_extent,
+	.chattr = process_chattr,
 };
 
 static int do_receive(struct btrfs_receive *rctx, const char *tomnt,
diff --git a/send-dump.c b/send-dump.c
index 1591e0cc..757ed5ec 100644
--- a/send-dump.c
+++ b/send-dump.c
@@ -316,6 +316,11 @@ static int print_update_extent(const char *path, u64 offset, u64 len,
 			  offset, len);
 }
 
+static int print_chattr(const char *path, u64 flags, void *user)
+{
+	return PRINT_DUMP(user, path, "chattr", "flags=%llu", flags);
+}
+
 struct btrfs_send_ops btrfs_print_send_ops = {
 	.subvol = print_subvol,
 	.snapshot = print_snapshot,
@@ -337,5 +342,6 @@ struct btrfs_send_ops btrfs_print_send_ops = {
 	.chmod = print_chmod,
 	.chown = print_chown,
 	.utimes = print_utimes,
-	.update_extent = print_update_extent
+	.update_extent = print_update_extent,
+	.chattr = print_chattr,
 };
diff --git a/send-stream.c b/send-stream.c
index 78f2571a..2c927af2 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -453,6 +453,11 @@ static int read_and_process_cmd(struct btrfs_send_stream *sctx)
 		TLV_GET_U64(sctx, BTRFS_SEND_A_SIZE, &tmp);
 		ret = sctx->ops->update_extent(path, offset, tmp, sctx->user);
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
index 39901f86..2446f22d 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -66,6 +66,7 @@ struct btrfs_send_ops {
 		      struct timespec *mt, struct timespec *ct,
 		      void *user);
 	int (*update_extent)(const char *path, u64 offset, u64 len, void *user);
+	int (*chattr)(const char *path, u64 flags, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
diff --git a/send.h b/send.h
index fe613cbb..fd07495f 100644
--- a/send.h
+++ b/send.h
@@ -94,6 +94,7 @@ enum btrfs_send_cmd {
 
 	BTRFS_SEND_C_END,
 	BTRFS_SEND_C_UPDATE_EXTENT,
+	BTRFS_SEND_C_CHATTR,
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
@@ -131,6 +132,7 @@ enum {
 	BTRFS_SEND_A_CLONE_PATH,
 	BTRFS_SEND_A_CLONE_OFFSET,
 	BTRFS_SEND_A_CLONE_LEN,
+	BTRFS_SEND_A_CHATTR,
 
 	__BTRFS_SEND_A_MAX,
 };
-- 
2.17.0

