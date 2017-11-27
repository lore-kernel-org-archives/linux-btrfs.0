Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59951 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750914AbdK0DKL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Nov 2017 22:10:11 -0500
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <quwenruo.btrfs@gmx.com>
Subject: [PATCH 1/3] btrfs-progs: check: release path in repair_extent_data_item()
Date: Mon, 27 Nov 2017 11:13:51 +0800
Message-ID: <20171127031353.9338-2-suy.fnst@cn.fujitsu.com>
In-Reply-To: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
References: <20171127031353.9338-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In repair_extent_data_item(), path is not be released if some
errors occurs which causes extent buffer leak.

So release path in end of the function.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 cmds-check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cmds-check.c b/cmds-check.c
index e746ee7b281d..3a72f8e3877d 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -11974,7 +11974,6 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 		btrfs_mark_buffer_dirty(eb);
 		ret = btrfs_update_block_group(trans, extent_root, disk_bytenr,
 					       num_bytes, 1, 0);
-		btrfs_release_path(&path);
 	}
 
 	if (nrefs->full_backref[0])
@@ -11998,6 +11997,7 @@ static int repair_extent_data_item(struct btrfs_trans_handle *trans,
 
 	err &= ~BACKREF_MISSING;
 out:
+	btrfs_release_path(&path);
 	if (ret)
 		error("can't repair root %llu extent data item[%llu %llu]",
 		      root->objectid, disk_bytenr, num_bytes);
-- 
2.15.0



