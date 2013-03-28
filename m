Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:53792 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab3C1IHR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 04:07:17 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r2S87Evi021664
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 16:07:15 +0800
Message-ID: <5153FA74.9030705@cn.fujitsu.com>
Date: Thu, 28 Mar 2013 16:08:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: [PATCH 1/4] Btrfs: fix wrong reservation of csums
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We reserve the space for csums only when we write data into a file, in
the other cases, such as tree log, log replay, we don't do reservation,
so we can use the reservation of the transaction handle just for the former.
And for the latter, we should use the tree's own reservation. But the
function - btrfs_csum_file_blocks() didn't differentiate between these
two types of the cases, fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/file-item.c | 2 --
 fs/btrfs/inode.c     | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index ec16020..b7e529d 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -728,7 +728,6 @@ int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
 		return -ENOMEM;
 
 	sector_sum = sums->sums;
-	trans->adding_csums = 1;
 again:
 	next_offset = (u64)-1;
 	found_next = 0;
@@ -899,7 +898,6 @@ next_sector:
 		goto again;
 	}
 out:
-	trans->adding_csums = 0;
 	btrfs_free_path(path);
 	return ret;
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1f268888..63eec5c 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1743,8 +1743,10 @@ static noinline int add_pending_csums(struct btrfs_trans_handle *trans,
 	struct btrfs_ordered_sum *sum;
 
 	list_for_each_entry(sum, list, list) {
+		trans->adding_csums = 1;
 		btrfs_csum_file_blocks(trans,
 		       BTRFS_I(inode)->root->fs_info->csum_root, sum);
+		trans->adding_csums = 0;
 	}
 	return 0;
 }
-- 
1.8.0.1
