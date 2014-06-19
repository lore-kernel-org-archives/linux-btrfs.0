Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1557 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755962AbaFSBb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:31:58 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1VKhK019659
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:31:20 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 3/6] Btrfs-progs: btrfs-restore, fix wrong return value if it fails to read specified fs root
Date: Thu, 19 Jun 2014 09:27:06 +0800
Message-ID: <1403141229-25565-3-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
References: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Steps to reproduce:
 # mkfs.btrfs -f /dev/sda9
 # btrfs restore -f 1 -o /tmp /dev/sda9
 # echo $?

Fix to return 1 in this failure path.

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-restore.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cmds-restore.c b/cmds-restore.c
index 934755a..48c46ff 100644
--- a/cmds-restore.c
+++ b/cmds-restore.c
@@ -1233,6 +1233,7 @@ int cmd_restore(int argc, char **argv)
 		root->node = read_tree_block(root, fs_location, root->leafsize, 0);
 		if (!root->node) {
 			fprintf(stderr, "Failed to read fs location\n");
+			ret = 1;
 			goto out;
 		}
 	}
-- 
1.9.0

