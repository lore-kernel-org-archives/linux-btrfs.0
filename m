Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:50845 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbaI1IrT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Sep 2014 04:47:19 -0400
Received: by mail-pd0-f181.google.com with SMTP id z10so1496442pdj.26
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Sep 2014 01:47:19 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] btrfs: fix sparse address space warnings
Date: Sun, 28 Sep 2014 01:48:11 -0700
Message-Id: <1411894092-28784-2-git-send-email-osandov@osandov.com>
In-Reply-To: <1411894092-28784-1-git-send-email-osandov@osandov.com>
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The buffer passed to vfs_write in send and several casts of ioctl fields are
missing the __user annotation. Also fixes a couple of related trivial style
issues.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/ioctl.c | 6 +++---
 fs/btrfs/send.c  | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8a8e298..0f9a5a1 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2176,7 +2176,7 @@ static noinline int btrfs_ioctl_tree_search_v2(struct file *file,
 
 	inode = file_inode(file);
 	ret = search_ioctl(inode, &args.key, &buf_size,
-			   (char *)(&uarg->buf[0]));
+			   (char __user *)(&uarg->buf[0]));
 	if (ret == 0 && copy_to_user(&uarg->key, &args.key, sizeof(args.key)))
 		ret = -EFAULT;
 	else if (ret == -EOVERFLOW &&
@@ -4247,7 +4247,7 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 		ipath->fspath->val[i] = rel_ptr;
 	}
 
-	ret = copy_to_user((void *)(unsigned long)ipa->fspath,
+	ret = copy_to_user((void __user *)(unsigned long)ipa->fspath,
 			   (void *)(unsigned long)ipath->fspath, size);
 	if (ret) {
 		ret = -EFAULT;
@@ -4322,7 +4322,7 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_root *root,
 	if (ret < 0)
 		goto out;
 
-	ret = copy_to_user((void *)(unsigned long)loi->inodes,
+	ret = copy_to_user((void __user *)(unsigned long)loi->inodes,
 			   (void *)(unsigned long)inodes, size);
 	if (ret)
 		ret = -EFAULT;
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa6..e0be577 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -515,7 +515,8 @@ static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
 	set_fs(KERNEL_DS);
 
 	while (pos < len) {
-		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
+		ret = vfs_write(filp, (__force const char __user *)buf + pos,
+				len - pos, off);
 		/* TODO handle that correctly */
 		/*if (ret == -ERESTARTSYS) {
 			continue;
@@ -639,8 +640,7 @@ static int send_header(struct send_ctx *sctx)
 	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
 	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
 
-	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
-					&sctx->send_off);
+	return write_buf(sctx->send_filp, &hdr, sizeof(hdr), &sctx->send_off);
 }
 
 /*
@@ -676,7 +676,7 @@ static int send_cmd(struct send_ctx *sctx)
 	hdr->crc = cpu_to_le32(crc);
 
 	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
-					&sctx->send_off);
+			&sctx->send_off);
 
 	sctx->total_send_size += sctx->send_size;
 	sctx->cmd_send_size[le16_to_cpu(hdr->cmd)] += sctx->send_size;
-- 
2.1.1

