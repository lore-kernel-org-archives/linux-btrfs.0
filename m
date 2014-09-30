Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52870 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144AbaI3WAs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Sep 2014 18:00:48 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so10881302pab.32
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Sep 2014 15:00:47 -0700 (PDT)
From: Omar Sandoval <osandov@osandov.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: David Sterba <dsterba@suse.cz>, Zach Brown <zab@zabbo.net>
Subject: [PATCH v2 1/3] btrfs: replace open-coded kernel_write
Date: Tue, 30 Sep 2014 15:01:40 -0700
Message-Id: <a6e4b5480b7e16bfcac28156381ba33fc8662570.1412114127.git.osandov@osandov.com>
In-Reply-To: <cover.1412114127.git.osandov@osandov.com>
References: <cover.1412114127.git.osandov@osandov.com>
In-Reply-To: <cover.1412114127.git.osandov@osandov.com>
References: <cover.1412114127.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

write_buf used by btrfs send has what is more or less a reimplementation of
kernel_write. This also gets rid of a sparse address space warning.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
---
 fs/btrfs/send.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa6..f6b2ec3 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -508,32 +508,23 @@ static struct btrfs_path *alloc_path_for_send(void)
 static int write_buf(struct file *filp, const void *buf, u32 len, loff_t *off)
 {
 	int ret;
-	mm_segment_t old_fs;
 	u32 pos = 0;
 
-	old_fs = get_fs();
-	set_fs(KERNEL_DS);
-
 	while (pos < len) {
-		ret = vfs_write(filp, (char *)buf + pos, len - pos, off);
+		ret = kernel_write(filp, buf + pos, len - pos, *off);
 		/* TODO handle that correctly */
 		/*if (ret == -ERESTARTSYS) {
 			continue;
 		}*/
 		if (ret < 0)
-			goto out;
-		if (ret == 0) {
-			ret = -EIO;
-			goto out;
-		}
+			return ret;
+		if (ret == 0)
+			return -EIO;
 		pos += ret;
+		*off += ret;
 	}
 
-	ret = 0;
-
-out:
-	set_fs(old_fs);
-	return ret;
+	return 0;
 }
 
 static int tlv_put(struct send_ctx *sctx, u16 attr, const void *data, int len)
-- 
2.1.1

