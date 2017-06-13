Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26681 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752549AbdFMJTr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Jun 2017 05:19:47 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
Subject: [PATCH 07/19] btrfs-progs: btrfstune: Refactor change_devices_uuid to use btrfs_fs_info
Date: Tue, 13 Jun 2017 17:19:23 +0800
Message-ID: <20170613091935.23277-8-quwenruo@cn.fujitsu.com>
In-Reply-To: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
References: <20170613091935.23277-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
 btrfstune.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 580fb401..2d85b041 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -177,10 +177,9 @@ out:
 	return ret;
 }
 
-static int change_device_uuid(struct btrfs_root *root, struct extent_buffer *eb,
+static int change_device_uuid(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
 			      int slot)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_dev_item *di;
 	int ret = 0;
 
@@ -216,7 +215,7 @@ static int change_devices_uuid(struct btrfs_fs_info *fs_info)
 		if (key.type != BTRFS_DEV_ITEM_KEY ||
 		    key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
 			goto next;
-		ret = change_device_uuid(root, path.nodes[0], path.slots[0]);
+		ret = change_device_uuid(fs_info, path.nodes[0], path.slots[0]);
 		if (ret < 0)
 			goto out;
 next:
-- 
2.13.1



