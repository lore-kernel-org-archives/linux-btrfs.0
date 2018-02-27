Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:1684 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752390AbeB0KDH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Feb 2018 05:03:07 -0500
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id D5B8848AE761
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Feb 2018 18:03:04 +0800 (CST)
From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] btrfs-progs: check/lowmem: Fix the incorrect error message of check_extent_data_item
Date: Tue, 27 Feb 2018 18:02:57 +0800
Message-ID: <20180227100257.6774-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Instead of the disk_bytenr and disk_num_bytes of the extent_item which the
file extent references, we should output the objectid and offset of the
file extent.

Fixes: b0d360b541f0 ("btrfs-progs: check: introduce function to check data backref in extent tree")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 check/mode-lowmem.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index 62bcf3d2e126..07863a9312ce 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2631,9 +2631,8 @@ static int check_extent_data_item(struct btrfs_root *root,
 
 	if (!(extent_flags & BTRFS_EXTENT_FLAG_DATA)) {
 		error(
-		    "extent[%llu %llu] backref type mismatch, wanted bit: %llx",
-		    disk_bytenr, disk_num_bytes,
-		    BTRFS_EXTENT_FLAG_DATA);
+	"file extent[%llu %llu] backref type mismatch, wanted bit: %llx",
+			fi_key.objectid, fi_key.offset, BTRFS_EXTENT_FLAG_DATA);
 		err |= BACKREF_MISMATCH;
 	}
 
@@ -2722,8 +2721,8 @@ out:
 		err |= BACKREF_MISSING;
 	btrfs_release_path(&path);
 	if (err & BACKREF_MISSING) {
-		error("data extent[%llu %llu] backref lost",
-		      disk_bytenr, disk_num_bytes);
+		error("file extent[%llu %llu] backref lost",
+			fi_key.objectid, fi_key.offset);
 	}
 	return err;
 }
-- 
2.16.2



