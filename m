Return-Path: <SRS0=H1hn=QQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B53BC282C4
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 05:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 569FB20857
	for <linux-btrfs@archiver.kernel.org>; Sat,  9 Feb 2019 05:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfBIFYo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 9 Feb 2019 00:24:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:60236 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbfBIFYo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Feb 2019 00:24:44 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7B1D0AF5B;
        Sat,  9 Feb 2019 05:24:43 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v2 1/2] btrfs: Don't search devid for every verify_one_dev_extent() call
Date:   Sat,  9 Feb 2019 13:24:36 +0800
Message-Id: <20190209052437.24020-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190209052437.24020-1-wqu@suse.com>
References: <20190209052437.24020-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

verify_one_dev_extent() will call btrfs_find_device() for each dev
extent, this waste some CPU time just searching the devices list.

Move the search one level up, into the btrfs_verify_dev_extents(), so
for each device we only call btrfs_find_device() once.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/volumes.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 03f223aa7194..bae03111273e 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7772,13 +7772,14 @@ static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripes)
 }
 
 static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
-				 u64 chunk_offset, u64 devid,
-				 u64 physical_offset, u64 physical_len)
+				 struct btrfs_device *dev,
+				 u64 chunk_offset, u64 physical_offset,
+				 u64 physical_len)
 {
 	struct extent_map_tree *em_tree = &fs_info->mapping_tree.map_tree;
 	struct extent_map *em;
 	struct map_lookup *map;
-	struct btrfs_device *dev;
+	u64 devid = dev->devid;
 	u64 stripe_len;
 	bool found = false;
 	int ret = 0;
@@ -7830,15 +7831,8 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Make sure no dev extent is beyond device bondary */
-	dev = btrfs_find_device(fs_info->fs_devices, devid, NULL, NULL, true);
-	if (!dev) {
-		btrfs_err(fs_info, "failed to find devid %llu", devid);
-		ret = -EUCLEAN;
-		goto out;
-	}
-
-	/* It's possible this device is a dummy for seed device */
 	if (dev->disk_total_bytes == 0) {
+		/* This device is a dummy for seed device */
 		dev = btrfs_find_device(fs_info->fs_devices->seed, devid, NULL,
 					NULL, false);
 		if (!dev) {
@@ -7898,6 +7892,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_path *path;
 	struct btrfs_root *root = fs_info->dev_root;
+	struct btrfs_device *device = NULL;
 	struct btrfs_key key;
 	u64 prev_devid = 0;
 	u64 prev_dev_ext_end = 0;
@@ -7941,6 +7936,17 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 		devid = key.objectid;
 		physical_offset = key.offset;
 
+		if (!device || devid != device->devid) {
+			device = btrfs_find_device(fs_info->fs_devices, devid,
+						   NULL, NULL, true);
+			if (!device) {
+				btrfs_err(fs_info, "failed to find devid %llu",
+					  devid);
+				ret = -EUCLEAN;
+				goto out;
+			}
+		}
+
 		dext = btrfs_item_ptr(leaf, slot, struct btrfs_dev_extent);
 		chunk_offset = btrfs_dev_extent_chunk_offset(leaf, dext);
 		physical_len = btrfs_dev_extent_length(leaf, dext);
@@ -7954,7 +7960,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 			goto out;
 		}
 
-		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
+		ret = verify_one_dev_extent(fs_info, device, chunk_offset,
 					    physical_offset, physical_len);
 		if (ret < 0)
 			goto out;
-- 
2.20.1

