Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42711 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756848AbaFSBb7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:31:59 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1VMU9019662
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:31:22 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 4/6] Btrfs-progs: btrfs-restore,output resason why it fails to read root
Date: Thu, 19 Jun 2014 09:27:07 +0800
Message-ID: <1403141229-25565-4-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Previously if restore could not read users specified fs root, it would
output following message:

 Error reading root

With this patch, it will output message like:

 Fail to read root 1000: No such file or directory

Signed-off-byr Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cmds-restore.c b/cmds-restore.c
index 48c46ff..8267ab6 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1257,7 +1257,8 @@ int cmd_restore(int argc, char **argv)
 		key.offset = (u64)-1;
 		root = btrfs_read_fs_root(orig_root->fs_info, &key);
 		if (IS_ERR(root)) {
-			fprintf(stderr, "Error reading root\n");
+			fprintf(stderr, "fail to read root %llu: %s\n",
+					root_objectid, strerror(-PTR_ERR(root)));
 			root = orig_root;
 			ret = 1;
 			goto out;
-- 
1.9.0

