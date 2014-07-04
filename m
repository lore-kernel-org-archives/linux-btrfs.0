Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62410 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759067AbaGDKDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jul 2014 06:03:35 -0400
Received: from G08CNEXCHPEKD02.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s64A3VNJ009514
	for <linux-btrfs@vger.kernel.org>; Fri, 4 Jul 2014 18:03:31 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: print btrfs specific info for some fatal error cases
Date: Fri, 4 Jul 2014 17:59:06 +0800
Message-ID: <1404467946-4429-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <53B645D4.1060003@cn.fujitsu.com>
References: <53B645D4.1060003@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc argued that if there are several btrfs filesystems mounted,
while users even don't know which filesystem hit the corrupted
errors something like generation verification failure.

Since @extent_buffer structure has a member @fs_info, let's output
btrfs device info.

Reported-by: Marc MERLIN <marc@merlins.org>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
Tell me if missed anything here...
---
 fs/btrfs/disk-io.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 08e65e9..bd52ca0 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -351,9 +351,9 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
 		ret = 0;
 		goto out;
 	}
-	printk_ratelimited("parent transid verify failed on %llu wanted %llu "
-		       "found %llu\n",
-		       eb->start, parent_transid, btrfs_header_generation(eb));
+	printk_ratelimited("BTRFS (device %s): parent transid verify failed on %llu wanted %llu found %llu\n",
+			eb->fs_info->sb->s_id, eb->start,
+			parent_transid, btrfs_header_generation(eb));
 	ret = 1;
 
 	/*
@@ -617,15 +617,15 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 
 	found_start = btrfs_header_bytenr(eb);
 	if (found_start != eb->start) {
-		printk_ratelimited(KERN_INFO "BTRFS: bad tree block start "
+		printk_ratelimited(KERN_INFO "BTRFS (device %s): bad tree block start "
 			       "%llu %llu\n",
-			       found_start, eb->start);
+			       eb->fs_info->sb->s_id, found_start, eb->start);
 		ret = -EIO;
 		goto err;
 	}
 	if (check_tree_block_fsid(root, eb)) {
-		printk_ratelimited(KERN_INFO "BTRFS: bad fsid on block %llu\n",
-			       eb->start);
+		printk_ratelimited(KERN_INFO "BTRFS (device %s): bad fsid on block %llu\n",
+			       eb->fs_info->sb->s_id, eb->start);
 		ret = -EIO;
 		goto err;
 	}
-- 
1.8.3.1

