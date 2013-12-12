Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:32198 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3LLHe5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 02:34:57 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: sandeen@redhat.com
Subject: [PATCH v2 8/16] btrfs-progs: fix resource leak in scrub_start()
Date: Thu, 12 Dec 2013 15:34:16 +0800
Message-Id: <1386833656-32217-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

Resolves-Coverity-CID: 1125934
Resolves-Coverity-CID: 1125935
Resolves-Coverity-CID: 1125936
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
v1->v2:
	make sure we are returning right value
---
 cmds-scrub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/cmds-scrub.c b/cmds-scrub.c
index 605af45..b36e2b1 100644
--- a/cmds-scrub.c
+++ b/cmds-scrub.c
@@ -1096,6 +1096,7 @@ static int scrub_start(int argc, char **argv, int resume)
 	void *terr;
 	u64 devid;
 	DIR *dirstream = NULL;
+	int nothing_to_resume = 0;
 
 	optind = 1;
 	while ((c = getopt(argc, argv, "BdqrRc:n:")) != -1) {
@@ -1261,7 +1262,8 @@ static int scrub_start(int argc, char **argv, int resume)
 		if (!do_quiet)
 			printf("scrub: nothing to resume for %s, fsid %s\n",
 			       path, fsid);
-		return 2;
+		nothing_to_resume = 1;
+		goto out;
 	}
 
 	ret = prg_fd = socket(AF_UNIX, SOCK_STREAM, 0);
@@ -1497,6 +1499,8 @@ out:
 	}
 	close_file_or_dir(fdmnt, dirstream);
 
+	if (nothing_to_resume)
+		return 2;
 	if (err)
 		return 1;
 	if (e_correctable)
-- 
1.8.3.1

