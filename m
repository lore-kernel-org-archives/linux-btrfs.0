Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47561 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab3AHVsM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Jan 2013 16:48:12 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: ablock84@googlemail.com, Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 1/3] btrfs-progs: Add support for BTRFS_SEND_FLAG_NO_FILE_DATA
Date: Tue,  8 Jan 2013 13:41:42 -0800
Message-Id: <1357681304-2978-2-git-send-email-mfasheh@suse.de>
In-Reply-To: <1357681304-2978-1-git-send-email-mfasheh@suse.de>
References: <1357681304-2978-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The flag and command are synced from kernel to user. Also, this patch adds a
callback for the BTRFS_SEND_C_UPDATE_EXTENT in struct btrfs_send_ops.
read_and_process_cmd() is updated to decode BTRFS_SEND_C_UPDATE_EXTENT and
send the values through the right callback. I did not add a callback
definition to cmds-receive.c as that code never uses
BTRFS_SEND_FLAG_NO_FILE_DATA.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 ioctl.h       |    7 +++++++
 send-stream.c |    6 ++++++
 send-stream.h |    1 +
 send.h        |    1 +
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/ioctl.h b/ioctl.h
index 6fda3a1..b7f1ce3 100644
--- a/ioctl.h
+++ b/ioctl.h
@@ -321,6 +321,13 @@ struct btrfs_ioctl_received_subvol_args {
 	__u64	reserved[16];		/* in */
 };
 
+/*
+ * Caller doesn't want file data in the send stream, even if the
+ * search of clone sources doesn't find an extent. UPDATE_EXTENT
+ * commands will be sent instead of WRITE commands.
+ */
+#define	BTRFS_SEND_FLAG_NO_FILE_DATA	0x1
+
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
 	__u64 clone_sources_count;	/* in */
diff --git a/send-stream.c b/send-stream.c
index 55fa728..a3628e4 100644
--- a/send-stream.c
+++ b/send-stream.c
@@ -418,6 +418,12 @@ static int read_and_process_cmd(struct btrfs_send_stream *s)
 		TLV_GET_TIMESPEC(s, BTRFS_SEND_A_CTIME, &ct);
 		ret = s->ops->utimes(path, &at, &mt, &ct, s->user);
 		break;
+	case BTRFS_SEND_C_UPDATE_EXTENT:
+		TLV_GET_STRING(s, BTRFS_SEND_A_PATH, &path);
+		TLV_GET_U64(s, BTRFS_SEND_A_FILE_OFFSET, &offset);
+		TLV_GET_U64(s, BTRFS_SEND_A_SIZE, &tmp);
+		ret = s->ops->update_extent(path, offset, tmp, s->user);
+		break;
 	case BTRFS_SEND_C_END:
 		ret = 1;
 		break;
diff --git a/send-stream.h b/send-stream.h
index b69b7f1..9a17e32 100644
--- a/send-stream.h
+++ b/send-stream.h
@@ -49,6 +49,7 @@ struct btrfs_send_ops {
 	int (*utimes)(const char *path, struct timespec *at,
 		      struct timespec *mt, struct timespec *ct,
 		      void *user);
+	int (*update_extent)(const char *path, u64 offset, u64 len, void *user);
 };
 
 int btrfs_read_and_process_send_stream(int fd,
diff --git a/send.h b/send.h
index 9934e94..48d425a 100644
--- a/send.h
+++ b/send.h
@@ -86,6 +86,7 @@ enum btrfs_send_cmd {
 	BTRFS_SEND_C_UTIMES,
 
 	BTRFS_SEND_C_END,
+	BTRFS_SEND_C_UPDATE_EXTENT,
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
-- 
1.7.7

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-
