Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:63049 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbaKZIxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 03:53:06 -0500
Received: by mail-pd0-f176.google.com with SMTP id y10so2410037pdj.7
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Nov 2014 00:53:05 -0800 (PST)
Received: from localhost.localdomain.localdomain ([112.23.171.71])
        by mx.google.com with ESMTPSA id bn13sm3671603pdb.4.2014.11.26.00.53.04
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Nov 2014 00:53:05 -0800 (PST)
From: Wang Shilong <wangshilong1991@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v3] Btrfs: deal with all 'subvol=xxx' options once
Date: Wed, 26 Nov 2014 16:51:29 +0800
Message-Id: <1416991889-8403-1-git-send-email-wangshilong1991@gmail.com>
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
v3: avoid loop way that David addressed.
---
 fs/btrfs/super.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 21c60ee..cac8e36 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1117,44 +1117,50 @@ static inline int is_subvolume_inode(struct inode *inode)
  */
 static char *setup_root_args(char *args)
 {
-	unsigned len = strlen(args) + 2 + 1;
-	char *src, *dst, *buf;
+	unsigned len;
+	char *src = args;
+	char *p = args;
+	char *dst, *buf;
 
 	/*
 	 * We need the same args as before, but with this substitution:
 	 * s!subvol=[^,]+!subvolid=0!
 	 *
 	 * Since the replacement string is up to 2 bytes longer than the
-	 * original, allocate strlen(args) + 2 + 1 bytes.
+	 * original, allocate strlen(args) + 2 * N + 1 bytes.
 	 */
-
-	src = strstr(args, "subvol=");
+	p = strstr(src, "subvol=");
 	/* This shouldn't happen, but just in case.. */
-	if (!src)
+	if (!p)
 		return NULL;
 
+	len = strlen(args) + 1;
+	while (p) {
+		len += 2;
+		p = strchr(p, ',');
+		if (!p)
+			break;
+		p = strstr(p, "subvol=");
+	}
+
 	buf = dst = kmalloc(len, GFP_NOFS);
 	if (!buf)
 		return NULL;
 
-	/*
-	 * If the subvol= arg is not at the start of the string,
-	 * copy whatever precedes it into buf.
-	 */
-	if (src != args) {
-		*src++ = '\0';
-		strcpy(buf, args);
-		dst += strlen(args);
+	/* loop and replace all subvol=xxx string */
+	while ((p = strstr(src, "subvol="))) {
+		strncat(dst, src, p - src);
+		dst += p - src;
+		strcpy(dst, "subvolid=0");
+		dst += strlen("subvolid=0");
+		src = p = strchr(p, ',');
+		if (!src)
+			break;
 	}
-
-	strcpy(dst, "subvolid=0");
-	dst += strlen("subvolid=0");
-
 	/*
 	 * If there is a "," after the original subvol=... string,
 	 * copy that suffix into our buffer.  Otherwise, we're done.
 	 */
-	src = strchr(src, ',');
 	if (src)
 		strcpy(dst, src);
 
-- 
2.1.0

