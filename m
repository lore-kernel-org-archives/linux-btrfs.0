Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31551 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1757612AbcHYFZO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 01:25:14 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH 1/3] btrfs-progs: check: remove unused found_key variable in walk_down_tree()
Date: Thu, 25 Aug 2016 13:20:59 +0800
Message-Id: <20160825052101.25864-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 cmds-check.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 0ddfd24..1cd0421 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3737,7 +3737,6 @@ static int check_fs_root(struct btrfs_root *root,
 		path.slots[level] = 0;
 	} else {
 		struct btrfs_key key;
-		struct btrfs_disk_key found_key;
 
 		btrfs_disk_key_to_cpu(&key, &root_item->drop_progress);
 		level = root_item->drop_level;
@@ -3745,10 +3744,6 @@ static int check_fs_root(struct btrfs_root *root,
 		wret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 		if (wret < 0)
 			goto skip_walking;
-		btrfs_node_key(path.nodes[level], &found_key,
-				path.slots[level]);
-		WARN_ON(memcmp(&found_key, &root_item->drop_progress,
-					sizeof(found_key)));
 	}
 
 	while (1) {
-- 
2.9.0



