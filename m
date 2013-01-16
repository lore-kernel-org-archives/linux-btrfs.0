Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711Ab3APWg6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jan 2013 17:36:58 -0500
From: Mark Fasheh <mfasheh@suse.de>
To: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Cc: ablock84@googlemail.com, aschnell@suse.de, Anand.Jain@oracle.com,
        Mark Fasheh <mfasheh@suse.de>
Subject: [PATCH 0/4] btrfs-progs: better support for external users of send, V2
Date: Wed, 16 Jan 2013 14:30:04 -0800
Message-Id: <1358375408-25285-1-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

	The following 4 patches make changes to btrfs-progs in order to
provide support for external software that wants to make use of the
excellent btrfs send ioctl.

The first patch introduces support for the BTRFS_SEND_FLAG_NO_FILE_DATA flag
which is introduced in my kernel patch titled:

	btrfs: add "no file data" flag to btrfs send ioctl

which can be found on the btrfs list, and for convenience is also attached
at the end of this e-mail.

The 2nd patch creates a libbtrfs and links the rest of the build to it. The
functionality I chose to export as of right now centers on send support. 
With this library, an external program has a much easier time processing the
stream which a send ioctl provides. It's worth nothing btw that this patch
can stand alone if need be.

The 3rd patch introduces send-test, a small piece of software (not built by
default) to allow for testing of the send ioctl (including our new flag). As
send-test is a client of libbtrfs it might also serve as example code for
developers looking to make use of send.

The final patch makes minor changes so that libbtrfs is usable from C++.

The patches can also be viewed on github:

https://github.com/markfasheh/btrfs-progs-patches/tree/no-data-and-libify

Testing has been pretty straight-forward - I build the software, verify that
things work by making a file system or using send-test.

Please review. Thanks,
	--Mark

Changelog:

- Fixed whitespace error in patch 3 (thanks to Anand Jain for reporting)

- "make version; make install" should work now (again, thanks to Anand Jain)

- included patch by Arvin Schnell to make it possible to use libbtrfs from C++
  - From this patch I removed some code from cmds-send.c that was added
    by mistake.

- libbtrfs properly links to libuuid and libm (Reported by Arvin)

- library symlinks are now properly installed (Reported by Arvin)


From: Mark Fasheh <mfasheh@suse.de>

[PATCH] btrfs: add "no file data" flag to btrfs send ioctl

This patch adds the flag, BTRFS_SEND_FLAG_NO_FILE_DATA to the btrfs send
ioctl code. When this flag is set, the btrfs send code will never write file
data into the stream (thus also avoiding expensive reads of that data in the
first place). BTRFS_SEND_C_UPDATE_EXTENT commands will be sent (instead of
BTRFS_SEND_C_WRITE) with an offset, length pair indicating the extent in
question.

This patch does not affect the operation of BTRFS_SEND_C_CLONE commands -
they will continue to be sent when a search finds an appropriate extent to
clone from.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.h |    7 +++++++
 fs/btrfs/send.c  |   48 ++++++++++++++++++++++++++++++++++++++++++++----
 fs/btrfs/send.h  |    1 +
 3 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
index 731e287..1f6cfdd 100644
--- a/fs/btrfs/ioctl.h
+++ b/fs/btrfs/ioctl.h
@@ -363,6 +363,13 @@ struct btrfs_ioctl_received_subvol_args {
 	__u64	reserved[16];		/* in */
 };
 
+/*
+ * Caller doesn't want file data in the send stream, even if the
+ * search of clone sources doesn't find an extent. UPDATE_EXTENT
+ * commands will be sent instead of WRITE commands.
+ */
+#define BTRFS_SEND_FLAG_NO_FILE_DATA     0x1
+
 struct btrfs_ioctl_send_args {
 	__s64 send_fd;			/* in */
 	__u64 clone_sources_count;	/* in */
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e78b297..8d0c6b4 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -85,6 +85,7 @@ struct send_ctx {
 	u32 send_max_size;
 	u64 total_send_size;
 	u64 cmd_send_size[BTRFS_SEND_C_MAX + 1];
+	u64 flags;	/* 'flags' member of btrfs_ioctl_send_args is u64 */
 
 	struct vfsmount *mnt;
 
@@ -3707,6 +3708,39 @@ out:
 	return ret;
 }
 
+/*
+ * Send an update extent command to user space.
+ */
+static int send_update_extent(struct send_ctx *sctx,
+			      u64 offset, u32 len)
+{
+	int ret = 0;
+	struct fs_path *p;
+
+	p = fs_path_alloc(sctx);
+	if (!p)
+		return -ENOMEM;
+
+	ret = begin_cmd(sctx, BTRFS_SEND_C_UPDATE_EXTENT);
+	if (ret < 0)
+		goto out;
+
+	ret = get_cur_path(sctx, sctx->cur_ino, sctx->cur_inode_gen, p);
+	if (ret < 0)
+		goto out;
+
+	TLV_PUT_PATH(sctx, BTRFS_SEND_A_PATH, p);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_FILE_OFFSET, offset);
+	TLV_PUT_U64(sctx, BTRFS_SEND_A_SIZE, len);
+
+	ret = send_cmd(sctx);
+
+tlv_put_failure:
+out:
+	fs_path_free(sctx, p);
+	return ret;
+}
+
 static int send_write_or_clone(struct send_ctx *sctx,
 			       struct btrfs_path *path,
 			       struct btrfs_key *key,
@@ -3742,7 +3776,11 @@ static int send_write_or_clone(struct send_ctx *sctx,
 		goto out;
 	}
 
-	if (!clone_root) {
+	if (clone_root) {
+		ret = send_clone(sctx, offset, len, clone_root);
+	} else if (sctx->flags & BTRFS_SEND_FLAG_NO_FILE_DATA) {
+		ret = send_update_extent(sctx, offset, len);
+	} else {
 		while (pos < len) {
 			l = len - pos;
 			if (l > BTRFS_SEND_READ_SIZE)
@@ -3755,10 +3793,7 @@ static int send_write_or_clone(struct send_ctx *sctx,
 			pos += ret;
 		}
 		ret = 0;
-	} else {
-		ret = send_clone(sctx, offset, len, clone_root);
 	}
-
 out:
 	return ret;
 }
@@ -4570,6 +4605,11 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	INIT_RADIX_TREE(&sctx->name_cache, GFP_NOFS);
 	INIT_LIST_HEAD(&sctx->name_cache_list);
 
+	if (arg->flags & ~BTRFS_SEND_FLAG_NO_FILE_DATA)
+		return -EINVAL;
+
+	sctx->flags = arg->flags;
+
 	sctx->send_filp = fget(arg->send_fd);
 	if (IS_ERR(sctx->send_filp)) {
 		ret = PTR_ERR(sctx->send_filp);
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 1bf4f32..8bb18f7 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -86,6 +86,7 @@ enum btrfs_send_cmd {
 	BTRFS_SEND_C_UTIMES,
 
 	BTRFS_SEND_C_END,
+	BTRFS_SEND_C_UPDATE_EXTENT,
 	__BTRFS_SEND_C_MAX,
 };
 #define BTRFS_SEND_C_MAX (__BTRFS_SEND_C_MAX - 1)
-- 
1.7.7

