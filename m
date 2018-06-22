Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:60199 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934214AbeFVBqH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Jun 2018 21:46:07 -0400
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id DAA0F4B41EE5
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Jun 2018 09:46:03 +0800 (CST)
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
CC: <suy.fnst@cn.fujitsu.com>
Subject: [PATCH] btrfs: Add more details while checking tree block
Date: Fri, 22 Jun 2018 09:52:15 +0800
Message-ID: <20180622015215.31812-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For easier debug, print eb->start if level is invalid.
Also make print clear if bytenr found is not expected.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/disk-io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index c3504b4d281b..a90dab84f41b 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -615,8 +615,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
-			     found_start, eb->start);
+		btrfs_err_rl(fs_info, "bad tree block start want %llu have %llu",
+			     eb->start, found_start);
 		ret = -EIO;
 		goto err;
 	}
@@ -628,8 +628,8 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	}
 	found_level = btrfs_header_level(eb);
 	if (found_level >= BTRFS_MAX_LEVEL) {
-		btrfs_err(fs_info, "bad tree block level %d",
-			  (int)btrfs_header_level(eb));
+		btrfs_err(fs_info, "bad tree block level %d on %llu",
+			  (int)btrfs_header_level(eb), eb->start);
 		ret = -EIO;
 		goto err;
 	}
-- 
2.17.1



