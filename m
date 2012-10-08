Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:54399 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899Ab2JHIKx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2012 04:10:53 -0400
Received: by mail-da0-f46.google.com with SMTP id n41so1433320dak.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Oct 2012 01:10:52 -0700 (PDT)
From: Robin Dong <robin.k.dong@gmail.com>
To: linux-btrfs@vger.kernel.org
Cc: Robin Dong <sanbai@taobao.com>
Subject: [PATCH v3 1/2] btrfs-progs: limit the max value of leafsize and nodesize
Date: Mon,  8 Oct 2012 16:10:40 +0800
Message-Id: <1349683841-27981-1-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

Using mkfs.btrfs like:

	mkfs.btrfs -l 131072 /dev/sda

will return no error, but after mount it, the dmesg will report:

	BTRFS: couldn't mount because metadata blocksize (131072) was too large

The leafsize and nodesize are equal at present, so we just use one function
"check_leaf_or_node_size" to limit leaf and node size below BTRFS_MAX_METADATA_BLOCKSIZE.

Signed-off-by: Robin Dong <sanbai@taobao.com>
Reviewed-by: David Sterba <dave@jikos.cz>
---
 ctree.h |    6 ++++++
 mkfs.c  |   29 +++++++++++++++++++++++------
 2 files changed, 29 insertions(+), 6 deletions(-)

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
index dff5eb8..93672b9 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1201,6 +1201,27 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
 	return ret;
 }
 
+static int check_leaf_or_node_size(u32 size, u32 sectorsize)
+{
+	if (size < sectorsize) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (smaller than sectorsize %u)\n",
+			size, sectorsize);
+		return -1;
+	} else if (size > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (larger than %u)\n",
+			size, BTRFS_MAX_METADATA_BLOCKSIZE);
+		return -1;
+	} else if (size & (sectorsize - 1)) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (not aligned to %u)\n",
+			size, sectorsize);
+		return -1;
+	}
+	return 0;
+}
+
 int main(int ac, char **av)
 {
 	char *file;
@@ -1291,14 +1312,10 @@ int main(int ac, char **av)
 		}
 	}
 	sectorsize = max(sectorsize, (u32)getpagesize());
-	if (leafsize < sectorsize || (leafsize & (sectorsize - 1))) {
-		fprintf(stderr, "Illegal leafsize %u\n", leafsize);
+	if (check_leaf_or_node_size(leafsize, sectorsize))
 		exit(1);
-	}
-	if (nodesize < sectorsize || (nodesize & (sectorsize - 1))) {
-		fprintf(stderr, "Illegal nodesize %u\n", nodesize);
+	if (check_leaf_or_node_size(nodesize, sectorsize))
 		exit(1);
-	}
 	ac = ac - optind;
 	if (ac == 0)
 		print_usage();
-- 
1.7.3.2

