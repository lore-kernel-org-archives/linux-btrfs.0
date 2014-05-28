Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21000 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752710AbaE1LYY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 May 2014 07:24:24 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s4SBOMnf029419
	for <linux-btrfs@vger.kernel.org>; Wed, 28 May 2014 19:24:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] Btrfs-progs: fsck: only allow partial opening under repair mode
Date: Wed, 28 May 2014 19:20:38 +0800
Message-ID: <1401276041-18349-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index db7df80..0e4e042 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6810,8 +6810,7 @@ int cmd_check(int argc, char **argv)
 	int option_index = 0;
 	int init_csum_tree = 0;
 	int qgroup_report = 0;
-	enum btrfs_open_ctree_flags ctree_flags =
-		OPEN_CTREE_PARTIAL | OPEN_CTREE_EXCLUSIVE;
+	enum btrfs_open_ctree_flags ctree_flags = OPEN_CTREE_EXCLUSIVE;
 
 	while(1) {
 		int c;
@@ -6877,6 +6876,10 @@ int cmd_check(int argc, char **argv)
 		goto err_out;
 	}
 
+	/* only allow partial opening under repair mode */
+	if (repair)
+		ctree_flags |= OPEN_CTREE_PARTIAL;
+
 	info = open_ctree_fs_info(argv[optind], bytenr, 0, ctree_flags);
 	if (!info) {
 		fprintf(stderr, "Couldn't open file system\n");
-- 
1.9.0

