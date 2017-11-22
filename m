Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:17746 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751216AbdKVGxE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Nov 2017 01:53:04 -0500
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id 085E6482D01B
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Nov 2017 14:52:58 +0800 (CST)
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: Allow to open filesystem with some broken tree roots
Date: Wed, 22 Nov 2017 14:52:53 +0800
Message-ID: <1511333573-10807-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Repair the miss modify in
commit 8698a2b9ba89 ("btrfs-progs: Allow inspect dump-tree to show specified tree block even some tree roots are corrupted")

Due to above modify, the decompressed file of
tests/fuzz-tests/images/bko-172811.raw.xz can not be open by
btrfs-debug-tree, because the csum tree's bytenr is not correct.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-inspect-dump-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-inspect-dump-tree.c b/cmds-inspect-dump-tree.c
index 4e72c08a..9ae4eb23 100644
--- a/cmds-inspect-dump-tree.c
+++ b/cmds-inspect-dump-tree.c
@@ -219,7 +219,7 @@ int cmd_inspect_dump_tree(int argc, char **argv)
 	int uuid_tree_only = 0;
 	int roots_only = 0;
 	int root_backups = 0;
-	unsigned open_ctree_flags = OPEN_CTREE_FS_PARTIAL;
+	unsigned open_ctree_flags = OPEN_CTREE_PARTIAL;
 	u64 block_only = 0;
 	struct btrfs_root *tree_root_scan;
 	u64 tree_id = 0;
-- 
2.14.3



