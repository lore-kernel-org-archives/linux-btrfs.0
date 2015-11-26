Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11502 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752222AbbKZISJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 03:18:09 -0500
Received: from localhost.localdomain (unknown [10.167.226.34])
	by cn.fujitsu.com (Postfix) with ESMTP id 376894043CE5
	for <linux-btrfs@vger.kernel.org>; Thu, 26 Nov 2015 16:17:59 +0800 (CST)
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs-progs: mkfs: Fix a wrong extent buffer size causing wrong superblock csum
Date: Thu, 26 Nov 2015 16:15:55 +0800
Message-Id: <1448525755-1192-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For make_btrfs(), it's setting wrong buf size for last super block write
out.
The superblock size is always BTRFS_SUPER_INFO_SIZE, not
cfg->sectorsize.

And this makes mkfs.btrfs -f -s 8K fails.

Fix it to BTRFS_SUPER_INFO_SIZE.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
---
Thanks goodness, this time it's not my super block checksum patches
causing bugs.
---
 utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/utils.c b/utils.c
index 60235d8..00355a2 100644
--- a/utils.c
+++ b/utils.c
@@ -554,7 +554,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	BUG_ON(sizeof(super) > cfg->sectorsize);
 	memset(buf->data, 0, cfg->sectorsize);
 	memcpy(buf->data, &super, sizeof(super));
-	buf->len = cfg->sectorsize;
+	buf->len = BTRFS_SUPER_INFO_SIZE;
 	csum_tree_block_size(buf, BTRFS_CRC32_SIZE, 0);
 	ret = pwrite(fd, buf->data, cfg->sectorsize, cfg->blocks[0]);
 	if (ret != cfg->sectorsize) {
-- 
2.6.2



