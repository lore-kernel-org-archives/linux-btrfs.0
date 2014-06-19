Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42711 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756482AbaFSBb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 21:31:58 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s5J1VGuB019653
	for <linux-btrfs@vger.kernel.org>; Thu, 19 Jun 2014 09:31:16 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/6] Btrfs-progs: fsck: switch to is_fstree()
Date: Thu, 19 Jun 2014 09:27:04 +0800
Message-ID: <1403141229-25565-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 cmds-check.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index c56da2a..26baab0 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2049,13 +2049,10 @@ skip_walking:
 
 static int fs_root_objectid(u64 objectid)
 {
-	if (objectid == BTRFS_FS_TREE_OBJECTID ||
-	    objectid == BTRFS_TREE_RELOC_OBJECTID ||
-	    objectid == BTRFS_DATA_RELOC_TREE_OBJECTID ||
-	    (objectid >= BTRFS_FIRST_FREE_OBJECTID &&
-	     objectid <= BTRFS_LAST_FREE_OBJECTID))
+	if (objectid == BTRFS_TREE_RELOC_OBJECTID ||
+	    objectid == BTRFS_DATA_RELOC_TREE_OBJECTID)
 		return 1;
-	return 0;
+	return is_fstree(objectid);
 }
 
 static int check_fs_roots(struct btrfs_root *root,
-- 
1.9.0

