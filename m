Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726702AbeHTQnr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 12:43:47 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2633CAD84
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Aug 2018 13:28:08 +0000 (UTC)
From: Nikolay Borisov <nborisov@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 1/2] btrfstune: Remove fs_info arg from change_device_uuid
Date: Mon, 20 Aug 2018 16:28:04 +0300
Message-Id: <1534771685-4924-2-git-send-email-nborisov@suse.com>
In-Reply-To: <1534771685-4924-1-git-send-email-nborisov@suse.com>
References: <1534771685-4924-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This function already takes an extent buffer that contains a reference
to the fs_info. Use that and reduce argument count. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 btrfstune.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/btrfstune.c b/btrfstune.c
index 889b931c55d8..723317a00f3a 100644
--- a/btrfstune.c
+++ b/btrfstune.c
@@ -179,10 +179,10 @@ static int change_extents_uuid(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
-static int change_device_uuid(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
-			      int slot)
+static int change_device_uuid(struct extent_buffer *eb, int slot)
 {
 	struct btrfs_dev_item *di;
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	int ret = 0;
 
 	di = btrfs_item_ptr(eb, slot, struct btrfs_dev_item);
@@ -217,7 +217,7 @@ static int change_devices_uuid(struct btrfs_fs_info *fs_info)
 		if (key.type != BTRFS_DEV_ITEM_KEY ||
 		    key.objectid != BTRFS_DEV_ITEMS_OBJECTID)
 			goto next;
-		ret = change_device_uuid(fs_info, path.nodes[0], path.slots[0]);
+		ret = change_device_uuid(path.nodes[0], path.slots[0]);
 		if (ret < 0)
 			goto out;
 next:
-- 
2.7.4
