Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2IZHwQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Sep 2012 03:52:16 -0400
Received: by pbbrr4 with SMTP id rr4so1482808pbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2012 00:52:16 -0700 (PDT)
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH 1/2] btrfs-progs: limit the max value of leafsize and nodesize
Date: Wed, 26 Sep 2012 15:52:07 +0800
Message-Id: <1348645928-3432-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Using mkfs.btrfs like:

	mkfs.btrfs -l 131072 /dev/sda

will return no error, but after mount it, the dmesg will report:

	BTRFS: couldn't mount because metadata blocksize (131072) was too large

The user tools should use BTRFS_MAX_METADATA_BLOCKSIZE to limit leaf and node size.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 ctree.h |    6 ++++++
 mkfs.c  |    6 ++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/ctree.h b/ctree.h
index 7f55229..75c1e0a 100644
--- a/ctree.h
+++ b/ctree.h
@@ -111,6 +111,12 @@ struct btrfs_trans_handle;
 #define BTRFS_DEV_ITEMS_OBJECTID 1ULL
 
 /*
+ * the max metadata block size.  This limit is somewhat artificial,
+ * but the memmove costs go through the roof for larger blocks.
+ */
+#define BTRFS_MAX_METADATA_BLOCKSIZE 65536
+
+/*
  * we can actually store much bigger names, but lets not confuse the rest
  * of linux
  */
diff --git a/mkfs.c b/mkfs.c
index dff5eb8..bb01f64 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1291,11 +1291,13 @@ int main(int ac, char **av)
 		}
 	}
 	sectorsize = max(sectorsize, (u32)getpagesize());
-	if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
+	if (leafsize < sectorsize || leafsize > BTRFS_MAX_METADATA_BLOCKSIZE ||
+			(leafsize & (sectorsize - 1))) {
 		fprintf(stderr, "Illegal leafsize %u\n", leafsize);
 		exit(1);
 	}
-	if (nodesize < sectorsize || (nodesize & (sectorsize - 1))) {
+	if (nodesize < sectorsize || nodesize > BTRFS_MAX_METADATA_BLOCKSIZE ||
+			(nodesize & (sectorsize - 1))) {
 		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
 		exit(1);
 	}
-- 
1.7.3.2

