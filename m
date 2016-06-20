Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:45023 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbcFTBdH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jun 2016 21:33:07 -0400
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: fdmanana@kernel.org
Subject: [PATCH] btrfs: fix WARNING in btrfs_select_ref_head()
Date: Mon, 20 Jun 2016 09:18:52 +0800
Message-Id: <1466385532-6005-1-git-send-email-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This issue was found when testing in-band dedupe enospc behaviour,
sometimes run_one_delayed_ref() may fail for enospc reason, then
__btrfs_run_delayed_refs（）will return, but forget to add num_heads_read
back, which will trigger "WARN_ON(delayed_refs->num_heads_ready == 0)" in
btrfs_select_ref_head().

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6146729..eeedff3 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -2665,7 +2665,10 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
 
 		btrfs_free_delayed_extent_op(extent_op);
 		if (ret) {
+			spin_lock(&delayed_refs->lock);
 			locked_ref->processing = 0;
+			delayed_refs->num_heads_ready++;
+			spin_unlock(&delayed_refs->lock);
 			btrfs_delayed_ref_unlock(locked_ref);
 			btrfs_put_delayed_ref(ref);
 			btrfs_debug(fs_info, "run_one_delayed_ref returned %d", ret);
-- 
1.8.3.1



