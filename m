Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63371 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752096AbeB1KNd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 05:13:33 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 28BE148AE761
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 18:13:31 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs-progs: check/lowmem: Fix false alert of data extent backref lost for snapshot
Date: Wed, 28 Feb 2018 18:13:22 +0800
Message-ID: <20180228101323.25442-2-lufq.fnst@cn.fujitsu.com>
In-Reply-To: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
References: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Btrfs lowmem check reports the following false alert:
------
ERROR: file extent[267 2162688] root 256 owner 5 backref lost
------

The file extent is in the leaf which is shared by file tree 256 and fs
tree.
------
leaf 30605312 items 46 free space 4353 generation 7 owner 5
......
        item 45 key (267 EXTENT_DATA 2162688) itemoff 5503 itemsize 53
                generation 7 type 2 (prealloc)
                prealloc data disk byte 13631488 nr 65536
                prealloc data offset 32768 nr 32768
------

And there is the corresponding extent_data_ref item in the extent tree.
------
        item 1 key (13631488 EXTENT_DATA_REF 1007496934287921081) itemoff 15274 itemsize 28
                extent data backref root 5 objectid 267 offset 2129920 count 1
------

The offset of EXTENT_DATA_REF which is the hash of the owner root objectid,
the inode number and the calculated offset (file offset - extent offset).

What caused the false alert is the code mix up the owner root objectid and
the file tree objectid.

Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check data backref in extent tree")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index f37b1b2c1571..6f1ea8db341d 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2689,8 +2689,8 @@ static int check_extent_data_item(struct btrfs_root *root,
 		/* Didn't find inlined data backref, try EXTENT_DATA_REF_KEY */
 		dbref_key.objectid = btrfs_file_extent_disk_bytenr(eb, fi);
 		dbref_key.type = BTRFS_EXTENT_DATA_REF_KEY;
-		dbref_key.offset = hash_extent_data_ref(root->objectid,
-				fi_key.objectid, fi_key.offset - offset);
+		dbref_key.offset = hash_extent_data_ref(owner, fi_key.objectid,
+							fi_key.offset - offset);
 
 		ret = btrfs_search_slot(NULL, root->fs_info->extent_root,
 					&dbref_key, &path, 0, 0);
-- 
2.16.2



