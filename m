Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16118 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750902AbdEBDRc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 May 2017 23:17:32 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: check: Fix memory leak in check_chunks_and_extents
Date: Tue, 2 May 2017 11:17:25 +0800
Message-ID: <20170502031725.10312-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

fsck/003-shift-offsets makes valgrinds complaining about memory leaks.
==5910==
==5910== HEAP SUMMARY:
==5910==     in use at exit: 1,112 bytes in 11 blocks
==5910==   total heap usage: 161 allocs, 150 frees, 164,800 bytes allocated
==5910==
==5910== 216 (72 direct, 144 indirect) bytes in 1 blocks are definitely lost in loss record 3 of 5
==5910==    at 0x4C2AF1F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==5910==    by 0x4815A3: add_root_item_to_list (cmds-check.c:9683)
==5910==    by 0x481CE2: check_chunks_and_extents (cmds-check.c:9886)
==5910==    by 0x48888B: cmd_check (cmds-check.c:12977)
==5910==    by 0x40A8C5: main (btrfs.c:246)
==5910==

The check_chunks_and_extents() memory leaks are caused by not freeing
added root items of normal_trees and dropping_trees.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 cmds-check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 17b7efbf..897b1587 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -9972,6 +9972,8 @@ out:
 	free_extent_cache_tree(&pending);
 	free_extent_cache_tree(&reada);
 	free_extent_cache_tree(&nodes);
+	free_root_item_list(&normal_trees);
+	free_root_item_list(&dropping_trees);
 	return ret;
 loop:
 	free_corrupt_blocks_tree(root->fs_info->corrupt_blocks);
-- 
2.12.2



