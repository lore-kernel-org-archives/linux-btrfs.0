Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mxf2.bahnhof.se ([213.80.101.26]:56424 "EHLO mxf2.bahnhof.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbCTBKT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 21:10:19 -0400
Received: from localhost (mxf2.local [127.0.0.1])
	by mxf2-reinject (Postfix) with ESMTP id A8D511E9490
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:10:17 +0100 (CET)
Received: from mxf2.bahnhof.se ([127.0.0.1])
	by localhost (mxf2.bahnhof.se [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PY3R-1MZfINt for <linux-btrfs@vger.kernel.org>;
	Fri, 20 Mar 2015 02:10:16 +0100 (CET)
Received: from miria.naju.se (h-219-91.a163.priv.bahnhof.se [85.24.219.91])
	by mxf2.bahnhof.se (Postfix) with ESMTP id 020891E944F
	for <linux-btrfs@vger.kernel.org>; Fri, 20 Mar 2015 02:10:15 +0100 (CET)
Received: from sebban (helo=localhost)
	by miria.naju.se with local-esmtp (Exim 4.80)
	(envelope-from <sebth@naju.se>)
	id 1YYlS3-0006yz-ON
	for linux-btrfs@vger.kernel.org; Fri, 20 Mar 2015 02:10:15 +0100
Date: Fri, 20 Mar 2015 02:10:15 +0100 (CET)
From: Sebastian Thorarensen <sebth@naju.se>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH v2 1/4] btrfs-progs: mkfs: Move out some nodesize code
In-Reply-To: <cover.1426812639.git.sebth@naju.se>
Message-ID: <bda701e20f009123fc1130320abc96ef145298ec.1426812639.git.sebth@naju.se>
References: <cover.1426812639.git.sebth@naju.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Move the constant DEFAULT_MKFS_LEAF_SIZE to utils.h and rename it to
BTRFS_MKFS_DEFAULT_NODE_SIZE for consistency. Move the function
check_leaf_or_node_size to utils.c and rename it to
check_node_or_leaf_size.

Signed-off-by: Sebastian Thorarensen <sebth@naju.se>
---
 mkfs.c  |   26 ++------------------------
 utils.c |   21 +++++++++++++++++++++
 utils.h |    2 ++
 3 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index f83554d..b846090 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -47,8 +47,6 @@ static u64 index_cnt = 2;
 #define DEFAULT_MKFS_FEATURES	(BTRFS_FEATURE_INCOMPAT_EXTENDED_IREF \
 		| BTRFS_FEATURE_INCOMPAT_SKINNY_METADATA)
 
-#define DEFAULT_MKFS_LEAF_SIZE 16384
-
 struct directory_name_entry {
 	char *dir_name;
 	char *path;
@@ -1057,27 +1055,6 @@ static int zero_output_file(int out_fd, u64 size, u32 sectorsize)
 	return ret;
 }
 
-static int check_leaf_or_node_size(u32 size, u32 sectorsize)
-{
-	if (size < sectorsize) {
-		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (smaller than %u)\n",
-			size, sectorsize);
-		return -1;
-	} else if (size > BTRFS_MAX_METADATA_BLOCKSIZE) {
-		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (larger than %u)\n",
-			size, BTRFS_MAX_METADATA_BLOCKSIZE);
-		return -1;
-	} else if (size & (sectorsize - 1)) {
-		fprintf(stderr,
-			"Illegal leafsize (or nodesize) %u (not align to %u)\n",
-			size, sectorsize);
-		return -1;
-	}
-	return 0;
-}
-
 static int is_ssd(const char *file)
 {
 	blkid_probe probe;
@@ -1230,7 +1207,8 @@ int main(int ac, char **av)
 	u64 alloc_start = 0;
 	u64 metadata_profile = 0;
 	u64 data_profile = 0;
-	u32 leafsize = max_t(u32, sysconf(_SC_PAGESIZE), DEFAULT_MKFS_LEAF_SIZE);
+	u32 leafsize = max_t(u32, sysconf(_SC_PAGESIZE),
+			BTRFS_MKFS_DEFAULT_NODE_SIZE);
 	u32 sectorsize = 4096;
 	u32 nodesize = leafsize;
 	u32 stripesize = 4096;
diff --git a/utils.c b/utils.c
index 6228c7f..ba01e0c 100644
--- a/utils.c
+++ b/utils.c
@@ -2720,3 +2720,24 @@ int btrfs_tree_search2_ioctl_supported(int fd)
 
 	return v2_supported;
 }
+
+int check_node_or_leaf_size(u32 size, u32 sectorsize)
+{
+	if (size < sectorsize) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (smaller than %u)\n",
+			size, sectorsize);
+		return -1;
+	} else if (size > BTRFS_MAX_METADATA_BLOCKSIZE) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (larger than %u)\n",
+			size, BTRFS_MAX_METADATA_BLOCKSIZE);
+		return -1;
+	} else if (size & (sectorsize - 1)) {
+		fprintf(stderr,
+			"Illegal leafsize (or nodesize) %u (not align to %u)\n",
+			size, sectorsize);
+		return -1;
+	}
+	return 0;
+}
diff --git a/utils.h b/utils.h
index 82ab5e8..30b6a57 100644
--- a/utils.h
+++ b/utils.h
@@ -25,6 +25,7 @@
 
 #define BTRFS_MKFS_SYSTEM_GROUP_SIZE (4 * 1024 * 1024)
 #define BTRFS_MKFS_SMALL_VOLUME_SIZE (1024 * 1024 * 1024)
+#define BTRFS_MKFS_DEFAULT_NODE_SIZE 16384
 
 #define BTRFS_SCAN_MOUNTED	(1ULL << 0)
 #define BTRFS_SCAN_LBLKID	(1ULL << 1)
@@ -208,5 +209,6 @@ static inline u64 div_factor(u64 num, int factor)
 }
 
 int btrfs_tree_search2_ioctl_supported(int fd);
+int check_node_or_leaf_size(u32 size, u32 sectorsize);
 
 #endif
-- 
1.7.10.4

