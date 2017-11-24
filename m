Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30742 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753100AbdKXKlj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Nov 2017 05:41:39 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <lakshmipathi.g@gmail.com>
Subject: [PATCH 4/5] btrfs-progs: check null pointer before use it
Date: Fri, 24 Nov 2017 18:41:31 +0800
Message-ID: <1511520092-37101-4-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
References: <1511520092-37101-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The following test failed when trying to check tree below.
item 9 key (TREE_RELOC ROOT_ITEM 0) itemoff 1135 itemsize 439
Since it has a inconsistent level in root and root->node, Segment fault
accures when use btrfs_node_key after btrfs_search_slot.

So add null pointer check before use btrfs_node_key.

Here comes the error message:
$ sudo TEST=003\* make test-fuzz
failed (ignored, ret=139): /home/adam/btrfs/btrfs-progs/btrfs check --init-csum-tree /home/adam/btrfs/btrfs-progs/tests/fuzz-tests/images/bko-172811.raw.restored
mayfail: returned code 139 (SEGFAULT), not ignored
test failed for case 003-multi-check-unmounted

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 cmds-check.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cmds-check.c b/cmds-check.c
index 49b0792b..3f4244a2 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -4070,6 +4070,8 @@ static int check_fs_root(struct btrfs_root *root,
 		wret = btrfs_search_slot(NULL, root, &key, &path, 0, 0);
 		if (wret < 0)
 			goto skip_walking;
+		if (!path.nodes[level])
+			goto skip_walking;
 		btrfs_node_key(path.nodes[level], &found_key,
 				path.slots[level]);
 		WARN_ON(memcmp(&found_key, &root_item->drop_progress,
-- 
2.14.3



