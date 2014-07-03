Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63066 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752118AbaGCCMH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 22:12:07 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s632C3ue013405
	for <linux-btrfs@vger.kernel.org>; Thu, 3 Jul 2014 10:12:03 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH 1/2] btrfs-progs: add ask_user confirmation for btrfstune clear seeding flag
Date: Thu, 3 Jul 2014 10:06:33 +0800
Message-ID: <1404353196-10914-1-git-send-email-guihc.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Clear the seeding flag may cause the original filesystem to be writable,
which is dangerous.
In this case, add user confirmation check when clearing seeding flag.
Also warn the user that the fs is in a dangerous condition when
the seeding flag is cleared if it it forced to.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfstune.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/btrfstune.c b/btrfstune.c
index 3f2f0cd..0e18088 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -56,6 +56,7 @@ static int update_seeding_flag(struct btrfs_root *root, int set_flag)
 			return 1;
 		}
 		super_flags &= ~BTRFS_SUPER_FLAG_SEEDING;
+		fprintf(stderr, "Warning: Seeding flag cleared. This could be dangerous!\n");
 	}
 
 	trans = btrfs_start_transaction(root, 1);
@@ -103,6 +104,7 @@ static void print_usage(void)
 	fprintf(stderr, "\t-S value\tpositive value will enable seeding, zero to disable, negative is not allowed\n");
 	fprintf(stderr, "\t-r \t\tenable extended inode refs\n");
 	fprintf(stderr, "\t-x \t\tenable skinny metadata extent refs\n");
+	fprintf(stderr, "\t-y \t\tsay yes to clear the seeding flag, make sure that you are aware of the danger\n");
 }
 
 int main(int argc, char *argv[])
@@ -113,11 +115,12 @@ int main(int argc, char *argv[])
 	int seeding_flag = 0;
 	u64 seeding_value = 0;
 	int skinny_flag = 0;
+	int force_clear = 0;
 	int ret;
 
 	optind = 1;
 	while(1) {
-		int c = getopt(argc, argv, "S:rx");
+		int c = getopt(argc, argv, "S:rxy");
 		if (c < 0)
 			break;
 		switch(c) {
@@ -131,6 +134,9 @@ int main(int argc, char *argv[])
 		case 'x':
 			skinny_flag = 1;
 			break;
+		case 'y':
+			force_clear = 1;
+			break;
 		default:
 			print_usage();
 			return 1;
@@ -151,6 +157,13 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (!seeding_flag && force_clear) {
+		fprintf(stderr,
+			"ERROR: -y option only work with -S option.\n");
+		print_usage();
+		return 1;
+	}
+
 	ret = check_mounted(device);
 	if (ret < 0) {
 		fprintf(stderr, "Could not check mount status: %s\n",
@@ -169,6 +182,15 @@ int main(int argc, char *argv[])
 	}
 
 	if (seeding_flag) {
+		if (!seeding_value && !force_clear) {
+			fprintf(stderr, "Warning: This is dangerous, clearing the seeding flag will make the original filesystem writable.\n");
+			ret = ask_user("We are going to clear the seeding flag, are you sure?");
+			if (!ret) {
+				fprintf(stderr, "Clear seeding flag canceled\n");
+				return 1;
+			}
+		}
+
 		ret = update_seeding_flag(root, seeding_value);
 		if (!ret)
 			success++;
-- 
1.8.1.4

