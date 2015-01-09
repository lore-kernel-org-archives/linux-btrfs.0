Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13785 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754034AbbAIIMu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 9 Jan 2015 03:12:50 -0500
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id t098CDK3029997
	for <linux-btrfs@vger.kernel.org>; Fri, 9 Jan 2015 16:12:13 +0800
From: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs:btrfstune: choose to ignore error when setting seeding enabled
Date: Fri, 9 Jan 2015 16:11:41 +0800
Message-ID: <1420791102-9948-1-git-send-email-fancn.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Before with -S option, setting positive value on seeding-enabled btrfs
filesystem will cause error. So I add -i option which can ignore it.

Reported-by: Chen Hanxiao <chenhanxiao@cn.fujitsu.com>
Signed-off-by: Fan Chengniang <fancn.fnst@cn.fujitsu.com>
---
 Documentation/btrfstune.txt |  9 +++++++--
 btrfstune.c                 | 25 ++++++++++++++++++-------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/Documentation/btrfstune.txt b/Documentation/btrfstune.txt
index d49a974..494a716 100644
--- a/Documentation/btrfstune.txt
+++ b/Documentation/btrfstune.txt
@@ -18,8 +18,13 @@ OPTIONS
 -------
 -S <value>::
 Updates the seeding value.
-A positive value will enable seeding, zero will disable seeding, negtive is not allowed.
-Enable seeding forces a fs readonly so that you can use it to build other filesystems.
+A positive value will enable seeding, zero will disable seeding, negtive is not
+allowed. If seeding is already enabled, positive value will cause reporting
+error. Enable seeding forces a fs readonly so that you can use it to build other
+filesystems.
+-i::
+Use with -S option. If seeding is already enabled, ignore it and do not report
+error.
 -r::
 Enable extended inode refs.
 -x::
diff --git a/btrfstune.c b/btrfstune.c
index 050418a..9a9e855 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -34,7 +34,8 @@
 
 static char *device;
 
-static int update_seeding_flag(struct btrfs_root *root, int set_flag)
+static int update_seeding_flag(struct btrfs_root *root, int set_flag,
+		int ignore_enabled_seeding)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_super_block *disk_super;
@@ -44,9 +45,12 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 	super_flags = btrfs_super_flags(disk_super);
 	if (set_flag) {
 		if (super_flags & BTRFS_SUPER_FLAG_SEEDING) {
-			fprintf(stderr, "seeding flag is already set on %s\n",
-				device);
-			return 1;
+			if (!ignore_enabled_seeding) {
+				fprintf(stderr, "seeding flag is already set on %s\n",
+					device);
+				return 1;
+			}
+			return 0;
 		}
 		super_flags |= BTRFS_SUPER_FLAG_SEEDING;
 	} else {
@@ -101,7 +105,9 @@ static int enable_skinny_metadata(struct btrfs_root *root)
 static void print_usage(void)
 {
 	fprintf(stderr, "usage: btrfstune [options] device\n");
-	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
+	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed. "
+			"If seeding is already enabled, positive value will cause reporting error\n");
+	fprintf(stderr, "\t-i \t\tuse with -S option. If seeding is already enabled, ignore it and do not report error\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
 	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
 	fprintf(stderr, "\t-f \t\tforce to clear flags, make sure that you are aware of the dangers\n");
@@ -114,13 +120,14 @@ int main(int argc, char *argv[])
 	int extrefs_flag = 0;
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
+	int ignore_enabled_seeding = 0;
 	int skinny_flag = 0;
 	int force = 0;
 	int ret;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "S:rxf");
+		int c = getopt(argc, argv, "S:irxf");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -128,6 +135,9 @@ int main(int argc, char *argv[])
 			seeding_flag = 1;
 			seeding_value = arg_strtou64(optarg);
 			break;
+		case 'i':
+			ignore_enabled_seeding = 1;
+			break;
 		case 'r':
 			extrefs_flag = 1;
 			break;
@@ -185,7 +195,8 @@ int main(int argc, char *argv[])
 			}
 		}
 
-		ret = update_seeding_flag(root, seeding_value);
+		ret = update_seeding_flag(root, seeding_value,
+			ignore_enabled_seeding);
 		if (!ret)
 			success++;
 	}
-- 
1.9.1

