Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:29150 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751278AbeEVJrK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 05:47:10 -0400
From: Gu Jinxiang <gujx@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <nborisov@suse.com>
Subject: [PATCH 2/2] btrfs: propagate failures of __exclude_logged_extent to upper caller
Date: Tue, 22 May 2018 17:46:51 +0800
Message-ID: <1526982411-9243-2-git-send-email-gujx@cn.fujitsu.com>
In-Reply-To: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
References: <1526982411-9243-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Function btrfs_exclude_logged_extents may call __exclude_logged_extent
which may fail.
Propagate the failures of __exclude_logged_extent to upper caller.

Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 2e85e99b5e6f..28fd71579141 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -6468,6 +6468,7 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
 	struct btrfs_key key;
 	int found_type;
 	int i;
+	int ret = 0;
 
 	if (!btrfs_fs_incompat(fs_info, MIXED_GROUPS))
 		return 0;
@@ -6484,10 +6485,14 @@ int btrfs_exclude_logged_extents(struct btrfs_fs_info *fs_info,
 			continue;
 		key.objectid = btrfs_file_extent_disk_bytenr(eb, item);
 		key.offset = btrfs_file_extent_disk_num_bytes(eb, item);
-		__exclude_logged_extent(fs_info, key.objectid, key.offset);
+		ret = __exclude_logged_extent(fs_info, key.objectid,
+				key.offset);
+		if (ret)
+			goto out;
 	}
 
-	return 0;
+out:
+	return ret;
 }
 
 static void
-- 
1.9.1



