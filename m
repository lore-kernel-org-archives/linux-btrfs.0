Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:6720 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab3LBCwv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 1 Dec 2013 21:52:51 -0500
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Cc: ochmann@informatik.uni-bonn.de
Subject: [PATCH] Btrfs: fix wrong superblock generation mismatch while scrubbing superblocks
Date: Mon, 2 Dec 2013 10:52:31 +0800
Message-Id: <1385952751-4251-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While scrubbing superblocks we will check every superblock's checksum
and generation. However, checking superblock's generation may cause
some problems, this is because tree log sync only flush first superblock
, while this will cause other superblocks' generation mismatch.

We only report superblock generation mismatch if it is first superblock
or we make sure we are not doing tree log.

Reported-by: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 2544805..b29a91f 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1794,8 +1794,15 @@ static int scrub_checksum_super(struct scrub_block *sblock)
 	if (sblock->pagev[0]->logical != btrfs_super_bytenr(s))
 		++fail_cor;
 
-	if (sblock->pagev[0]->generation != btrfs_super_generation(s))
-		++fail_gen;
+	if (sblock->pagev[0]->generation != btrfs_super_generation(s)) {
+		/*
+		 * we only report a generation mismatch if this is first
+		 * superblock or we can make sure we are not doing tree log.
+		 */
+		if (btrfs_super_bytenr(s) == btrfs_sb_offset(0) ||
+				!root->fs_info->log_root_tree)
+			++fail_gen;
+	}
 
 	if (memcmp(s->fsid, fs_info->fsid, BTRFS_UUID_SIZE))
 		++fail_cor;
-- 
1.8.3.1

