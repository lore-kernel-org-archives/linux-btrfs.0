Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:28458 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2INGCN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 02:02:13 -0400
From: Anand jain <Anand.Jain@oracle.com>
To: linux-btrfs@vger.kernel.org
Cc: chris.mason@fusionio.com, hugo@carfax.org.uk
Subject: [PATCH] Btrfs: write_buf is now callable outside send.c
Date: Fri, 14 Sep 2012 14:04:21 +0800
Message-Id: <1347602661-7576-3-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1347602661-7576-1-git-send-email-Anand.Jain@oracle.com>
References: <5052C5A0.4090803@oracle.com>
 <1347602661-7576-1-git-send-email-Anand.Jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Anand Jain <anand.jain@oracle.com>

Developing service cmds needs it.

Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/send.c |   11 ++++++-----
 fs/btrfs/send.h |    1 +
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index fb5ffe9..89411b3 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -377,7 +377,7 @@ static struct btrfs_path *alloc_path_for_send(void)
 	return path;
 }
 
-static int write_buf(struct send_ctx *sctx, const void *buf, u32 len)
+int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
 {
 	int ret;
 	mm_segment_t old_fs;
@@ -387,8 +387,7 @@ static int write_buf(struct send_ctx *sctx, const void *buf, u32 len)
 	set_fs(KERNEL_DS);
 
 	while (pos < len) {
-		ret = vfs_write(sctx->send_filp, (char *)buf + pos, len - pos,
-				&sctx->send_off);
+		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
 		/* TODO handle that correctly */
 		/*if (ret == -ERESTARTSYS) {
 			continue;
@@ -544,7 +543,8 @@ static int send_header(struct send_ctx *sctx)
 	strcpy(hdr.magic, BTRFS_SEND_STREAM_MAGIC);
 	hdr.version = cpu_to_le32(BTRFS_SEND_STREAM_VERSION);
 
-	return write_buf(sctx, &hdr, sizeof(hdr));
+	return write_buf(sctx->send_filp, &hdr, sizeof(hdr),
+					&sctx->send_off);
 }
 
 /*
@@ -581,7 +581,8 @@ static int send_cmd(struct send_ctx *sctx)
 	crc = crc32c(0, (unsigned char *)sctx->send_buf, sctx->send_size);
 	hdr->crc = cpu_to_le32(crc);
 
-	ret = write_buf(sctx, sctx->send_buf, sctx->send_size);
+	ret = write_buf(sctx->send_filp, sctx->send_buf, sctx->send_size,
+					&sctx->send_off);
 
 	sctx->total_send_size += sctx->send_size;
 	sctx->cmd_send_size[le16_to_cpu(hdr->cmd)] += sctx->send_size;
diff --git a/fs/btrfs/send.h b/fs/btrfs/send.h
index 9934e94..1bf4f32 100644
--- a/fs/btrfs/send.h
+++ b/fs/btrfs/send.h
@@ -130,4 +130,5 @@ enum {
 
 #ifdef __KERNEL__
 long btrfs_ioctl_send(struct file *mnt_file, void __user *arg);
+int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off);
 #endif
-- 
1.7.1

