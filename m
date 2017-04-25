Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43447 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1428266AbdDYIk3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Apr 2017 04:40:29 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
Subject: [PATCH] btrfs-progs: Use more restrict check to read out tree root
Date: Tue, 25 Apr 2017 16:40:16 +0800
Message-ID: <20170425084016.26278-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For fuzzed image bko-156811-bad-parent-ref-qgroup-verify.raw, it cause
qgroup to report -ENOMEM.

But the fact is, such image is heavy damaged so there is not valid root
item for extent tree.

Normal extent tree key in root tree should be (EXTENT_TREE ROOT_ITEM 0),
while in that fuzzed image, we got (EXTENT_TREE EXXTENT_DATA SOME_NUMBER).

It's btrfs_find_last_root() that only checks the objectid, not caring
key type leads to such problem.

Fix by doing extra check on key type for such case.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 root-tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/root-tree.c b/root-tree.c
index ab01a140..6b8f8c1c 100644
--- a/root-tree.c
+++ b/root-tree.c
@@ -51,7 +51,8 @@ int btrfs_find_last_root(struct btrfs_root *root, u64 objectid,
 	l = path->nodes[0];
 	slot = path->slots[0] - 1;
 	btrfs_item_key_to_cpu(l, &found_key, slot);
-	if (found_key.objectid != objectid) {
+	if (found_key.type != BTRFS_ROOT_ITEM_KEY ||
+	    found_key.objectid != objectid) {
 		ret = -ENOENT;
 		goto out;
 	}
-- 
2.12.2



