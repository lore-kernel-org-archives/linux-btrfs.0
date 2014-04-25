Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nbl-ex10-fe02.nebula.fi ([188.117.32.122]:31250 "EHLO
	ex10.nebula.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753303AbaDYXFf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 19:05:35 -0400
Date: Sat, 26 Apr 2014 02:05:31 +0300
From: Rakesh Pandit <rakesh@tuxera.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: mkfs: remove ununsed parameters
Message-ID: <20140425230530.GA26003@hercules.tuxera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Remove ununsed parameters since 71d6bd3c in create_raid_groups.

Signed-off-by: Rakesh Pandit <rakesh@tuxera.com>
---
 mkfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mkfs.c b/mkfs.c
index dbd83f5..35917f1 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -210,7 +210,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
 static int create_raid_groups(struct btrfs_trans_handle *trans,
 			      struct btrfs_root *root, u64 data_profile,
 			      int data_profile_opt, u64 metadata_profile,
-			      int metadata_profile_opt, int mixed, int ssd)
+			      int mixed)
 {
 	u64 num_devices = btrfs_super_num_devices(root->fs_info->super_copy);
 	int ret;
@@ -1586,7 +1586,7 @@ raid_groups:
 	if (!source_dir_set) {
 		ret = create_raid_groups(trans, root, data_profile,
 				 data_profile_opt, metadata_profile,
-				 metadata_profile_opt, mixed, ssd);
+				 mixed);
 		BUG_ON(ret);
 	}
 
-- 
1.8.5.3

