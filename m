Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4420 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758703AbaGXDfi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:35:38 -0400
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (localhost.localdomain [127.0.0.1])
	by edo.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id s6O3ZXXJ017394
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 11:35:33 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH 04/10] Btrfs: fix wrong generation check of super block on a seed device
Date: Thu, 24 Jul 2014 11:37:09 +0800
Message-ID: <1406173035-29478-4-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The super block generation of the seed devices is not the same as the
filesystem which sprouted from them because we don't update the super
block on the seed devices when we change that new filesystem. So we
should not use the generation of that new filesystem to check the super
block generation on the seed devices, Fix it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 fs/btrfs/scrub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 9a81874e..98b9f8e 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2835,7 +2835,11 @@ static noinline_for_stack int scrub_supers(struct scrub_ctx *sctx,
 	if (test_bit(BTRFS_FS_STATE_ERROR, &root->fs_info->fs_state))
 		return -EIO;
 
-	gen = root->fs_info->last_trans_committed;
+	/* Seed devices of a new filesystem has their own generation. */
+	if (scrub_dev->fs_devices != root->fs_info->fs_devices)
+		gen = scrub_dev->generation;
+	else
+		gen = root->fs_info->last_trans_committed;
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
 		bytenr = btrfs_sb_offset(i);
-- 
1.9.3

