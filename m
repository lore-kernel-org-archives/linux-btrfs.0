Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45391 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752592Ab3LRDzq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 22:55:46 -0500
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH V2] btrfs-progs: fix btrfstune silence on failure
Date: Wed, 18 Dec 2013 11:52:45 +0800
Message-Id: <1387338765-31962-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally, btrfstune will fail without any options, like this:

	# btrfstune /dev/sdb

An error prompt & usage should show up upon this condition.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
V1 -> V2:
	add optind assignment to make reviewers happy;
	print error msg if no options provided
---
 btrfstune.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 50724ba..da82f36 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -115,6 +115,7 @@ int main(int argc, char *argv[])
 	int skinny_flag = 0;
 	int ret;
 
+	optind = 1;
 	while(1) {
 		int c = getopt(argc, argv, "S:rx");
 		if (c < 0)
@@ -143,6 +144,13 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (!(seeding_flag + extrefs_flag + skinny_flag)) {
+		fprintf(stderr,
+			"ERROR: At least one option should be assigned.\n");
+		print_usage();
+		return 1;
+	}
+
 	if (check_mounted(device)) {
 		fprintf(stderr, "%s is mounted\n", device);
 		return 1;
@@ -176,6 +184,7 @@ int main(int argc, char *argv[])
 	} else {
 		root->fs_info->readonly = 1;
 		ret = 1;
+		fprintf(stderr, "btrfstune failed\n");
 	}
 	close_ctree(root);
 
-- 
1.8.0.1

