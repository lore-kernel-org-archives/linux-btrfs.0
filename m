Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63371 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752085AbeB1KNc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 05:13:32 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id A912748AE762
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 18:13:30 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH v2 1/3] btrfs-progs: check/lowmem: Fix the incorrect error message of check_extent_data_item
Date: Wed, 28 Feb 2018 18:13:21 +0800
Message-ID: <20180228101323.25442-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of the disk_bytenr and disk_num_bytes of the extent_item which the
file extent references, we should output the objectid and offset of the
file extent. And the leaf may be shared by the file trees, we should print
the objectid of the root and the owner of the leaf.

Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check data backref in extent tree")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
V2: Output the objectid of the root and the owner of the leaf.

 check/mode-lowmem.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 62bcf3d2e126..f37b1b2c1571 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2631,9 +2631,9 @@ static int check_extent_data_item(struct btrfs_root *root,
 
 	if (!(extent_flags & BTRFS_EXTENT_FLAG_DATA)) {
 		error(
-		    "extent[%llu %llu] backref type mismatch, wanted bit: %llx",
-		    disk_bytenr, disk_num_bytes,
-		    BTRFS_EXTENT_FLAG_DATA);
+"file extent[%llu %llu] root %llu owner %llu backref type mismatch, wanted bit: %llx",
+			fi_key.objectid, fi_key.offset, root->objectid, owner,
+			BTRFS_EXTENT_FLAG_DATA);
 		err |= BACKREF_MISMATCH;
 	}
 
@@ -2722,8 +2722,9 @@ out:
 		err |= BACKREF_MISSING;
 	btrfs_release_path(&path);
 	if (err & BACKREF_MISSING) {
-		error("data extent[%llu %llu] backref lost",
-		      disk_bytenr, disk_num_bytes);
+		error(
+		"file extent[%llu %llu] root %llu owner %llu backref lost",
+			fi_key.objectid, fi_key.offset, root->objectid, owner);
 	}
 	return err;
 }
-- 
2.16.2



