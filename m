Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab3LMKIc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 05:08:32 -0500
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id rBDA8Sk7008939
	for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 18:08:28 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] Btrfs: don't run delayed nodes again after all nodes flush
Date: Fri, 13 Dec 2013 18:09:37 +0800
Message-Id: <1386929381-3483-2-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
References: <1386929381-3483-1-git-send-email-miaox@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If the number of the delayed items is greater than the upper limit, we will
try to flush all the delayed items. After that, it is unnecessary to run
them again because they are being dealt with by the wokers or the number of
them is less than the lower limit.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/delayed-inode.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index e832621..bb101b0 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1395,6 +1395,7 @@ void btrfs_balance_delayed_items(struct btrfs_root *root)
 				break;
 		}
 		finish_wait(&delayed_root->wait, &__wait);
+		return;
 	}
 
 	btrfs_wq_run_delayed_node(delayed_root, root, BTRFS_DELAYED_BATCH);
-- 
1.8.3.1

