Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab3LMKCa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 05:02:30 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBDA2SWx008642
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 18:02:28 +0800
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs-progs: fix btrfstune silence on failure
Date: Fri, 13 Dec 2013 17:59:46 +0800
Message-Id: <1386928786-4976-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Originally, btrfstune will fail without any options and just exit
with no failure prompt.
Now, the number of arguments are checked before parse options
and error msg will show up upon failure.

Signed-off-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
---
 btrfstune.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/btrfstune.c b/btrfstune.c
index 50724ba..ecaf13d 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -115,6 +115,11 @@ int main(int argc, char *argv[])
 	int skinny_flag = 0;
 	int ret;
 
+	if (argc < 3) {
+		print_usage();
+		return 1;
+	}
+
 	while(1) {
 		int c = getopt(argc, argv, "S:rx");
 		if (c < 0)
@@ -176,6 +181,7 @@ int main(int argc, char *argv[])
 	} else {
 		root->fs_info->readonly = 1;
 		ret = 1;
+		fprintf(stderr, "btrfstune failed\n");
 	}
 	close_ctree(root);
 
-- 
1.8.0.1

