Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:59182 "EHLO song.cn.fujitsu.com"
        rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751597AbcJKG6S (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Oct 2016 02:58:18 -0400
Received: from localhost.localdomain (unknown [10.167.226.107])
        by cn.fujitsu.com (Postfix) with ESMTP id 640844243520
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Oct 2016 14:53:28 +0800 (CST)
From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [RFC] btrfs: make max inline data can be equal to sectorsize
Date: Tue, 11 Oct 2016 14:47:42 +0800
Message-Id: <20161011064742.17364-1-wangxg.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If we use mount option "-o max_inline=sectorsize", say 4096, indeed
even for a fresh fs, say nodesize is 16k, we can not make the first
4k data completely inline, I found this conditon causing this issue:
  !compressed_size && (actual_end & (root->sectorsize - 1)) == 0

If it retuns true, we'll not make data inline. For 4k sectorsize,
0~4094 dara range, we can make it inline, but 0~4095, it can not.
I don't think this limition is useful, so here remove it which will
make max inline data can be equal to sectorsize.

Signed-off-by: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
---
 fs/btrfs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index ea15520..c0db393 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -267,8 +267,6 @@ static noinline int cow_file_range_inline(struct btrfs_root *root,
 	if (start > 0 ||
 	    actual_end > root->sectorsize ||
 	    data_len > BTRFS_MAX_INLINE_DATA_SIZE(root) ||
-	    (!compressed_size &&
-	    (actual_end & (root->sectorsize - 1)) == 0) ||
 	    end + 1 < isize ||
 	    data_len > root->fs_info->max_inline) {
 		return 1;
-- 
2.9.0



