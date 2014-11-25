Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:40939 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKYIVq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 03:21:46 -0500
Received: by mail-pd0-f171.google.com with SMTP id y13so113486pdi.16
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 00:21:45 -0800 (PST)
Received: from localhost.localdomain.localdomain ([112.23.171.71])
        by mx.google.com with ESMTPSA id yc4sm748964pab.27.2014.11.25.00.21.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Nov 2014 00:21:45 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2] Btrfs: deal with all 'subvol=xxx' options once
Date: Tue, 25 Nov 2014 16:20:11 +0800
Message-Id: <1416903611-29812-1-git-send-email-wangshilong1991@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sdb
 # mount -t btrfs /dev/sdb /mnt
 # btrfs sub create /mnt/dir
 # mount -t btrfs /dev/sdb /mnt -o subvol=dir,subvol=dir

It fails with:
 mount: mount(2) failed: No such file or directory

Btrfs deal with subvolume mounting in a recursive way,
to avoid looping, it will stripe out 'subvol=xxxx' string,
then next loop will stop.Problem here is it only deal one
string once, if users specify mount option multiple times.
It will loop several times which is not good, and above
reproducing steps will also return confusing results.

Fix this problem by striping out all 'subvol=xxx' options,
only last is valid.

Signed-off-by: Wang Shilong <wangshilong1991@gmail.com>
---
v1->v2: error handling and comment update
---
 fs/btrfs/super.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 54bd91e..42f3176 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1115,7 +1115,7 @@ static inline int is_subvolume_inode(struct inode *inode)
  * subvolid=0 to make sure we get the actual tree root for path walking to the
  * subvol we want.
  */
-static char *setup_root_args(char *args)
+static char *__setup_root_args(char *args)
 {
 	unsigned len = strlen(args) + 2 + 1;
 	char *src, *dst, *buf;
@@ -1129,13 +1129,12 @@ static char *setup_root_args(char *args)
 	 */
 
 	src = strstr(args, "subvol=");
-	/* This shouldn't happen, but just in case.. */
 	if (!src)
 		return NULL;
 
 	buf = dst = kmalloc(len, GFP_NOFS);
 	if (!buf)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	/*
 	 * If the subvol= arg is not at the start of the string,
@@ -1161,6 +1160,27 @@ static char *setup_root_args(char *args)
 	return buf;
 }
 
+static char *setup_root_args(char *args)
+{
+	char *p, *new_args;
+
+	p = new_args = __setup_root_args(args);
+	/* in case users specify subvol=xxx option multiple times */
+	while (p) {
+		p = __setup_root_args(new_args);
+		if (!p)
+			break;
+		if (!IS_ERR(p)) {
+			kfree(new_args);
+			new_args = p;
+		} else {
+			kfree(new_args);
+			return NULL;
+		}
+	}
+	return new_args;
+}
+
 static struct dentry *mount_subvol(const char *subvol_name, int flags,
 				   const char *device_name, char *data)
 {
-- 
1.7.12.4

