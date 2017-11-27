Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59951 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750844AbdK0DKP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 22:10:15 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH 2/3] btrfs-progs: check: record returned errors after walk_down_tree_v2()
Date: Mon, 27 Nov 2017 11:13:52 +0800
Message-ID: <20171127031353.9338-3-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In lowmem mode with '--repair', check_chunks_and_extents_v2()
will fix accounting in block groups and clear the error
bit BG_ACCOUNTING_ERROR.
However, return value of check_btrfs_root() is 0 either 1 instead of
error bits.

If extent tree is on error, lowmem repair always prints error and
returns nonzero value even the filesystem is fine after repair.

So let @err contains bits after walk_down_tree_v2().

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index 3a72f8e3877d..c7b570bef9c3 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -6607,7 +6607,7 @@ static int check_btrfs_root(struct btrfs_trans_handle *trans,
 		ret = walk_down_tree_v2(trans, root, &path, &level, &nrefs,
 					ext_ref, check_all);
 
-		err |= !!ret;
+		err |= ret;
 
 		/* if ret is negative, walk shall stop */
 		if (ret < 0) {
-- 
2.15.0



