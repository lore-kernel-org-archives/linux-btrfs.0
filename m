Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16545 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752747AbeAKIMg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Jan 2018 03:12:36 -0500
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <nborisov@suse.com>
CC: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Gu JinXiang <gujx@cn.fujitsu.com>
Subject: [PATCH v3 1/2] btrfs: use enum instead of constant value
Date: Thu, 11 Jan 2018 16:12:17 +0800
Message-ID: <1515658338-6781-1-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <69b34781-2275-ba9b-0df8-50f3c2752e45@suse.com>
References: <69b34781-2275-ba9b-0df8-50f3c2752e45@suse.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

populate_free_space_tree calls function btrfs_search_slot_for_read with
parameter int find_higher = 1, it means that, if no exact match is found,
then use the next higher item.
So in function populate_free_space_tree, use READA_FORWARD to read
forward ahead.

Changelog:
v2->v1: change enum from READA_BACK to READA_FORWARD, since according
to the logic of the source, it should reada_for_search forward, not
backward.
And, Reference:
commit e4058b54d1e4 ("btrfs: cleanup, use enum values for btrfs_path reada")

v3->v2: add commit message to make it easy to understand. And split it
to two patch.

Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/free-space-tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/free-space-tree.c b/fs/btrfs/free-space-tree.c
index fe5e0324dca9..d7b6c0017143 100644
--- a/fs/btrfs/free-space-tree.c
+++ b/fs/btrfs/free-space-tree.c
@@ -1071,7 +1071,7 @@ static int populate_free_space_tree(struct btrfs_trans_handle *trans,
 	path = btrfs_alloc_path();
 	if (!path)
 		return -ENOMEM;
-	path->reada = 1;
+	path->reada = READA_FORWARD;
 
 	path2 = btrfs_alloc_path();
 	if (!path2) {
-- 
2.14.3



