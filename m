Return-Path: <SRS0=cBAG=QG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07100C282D4
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 07:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D65F22087F
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jan 2019 07:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbfA3HkG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jan 2019 02:40:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:44158 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725819AbfA3HkG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jan 2019 02:40:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82F13B013
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2019 07:40:05 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 1/2] btrfs: Don't search devid for every verify_one_dev_extent() call
Date:   Wed, 30 Jan 2019 15:39:59 +0800
Message-Id: <20190130074000.16638-2-wqu@suse.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190130074000.16638-1-wqu@suse.com>
References: <20190130074000.16638-1-wqu@suse.com>
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
---
 fs/btrfs/volumes.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2576b1a379c9..8e932d7d2fe6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7761,13 +7761,14 @@ static u64 calc_stripe_length(u64 type, u64 chunk_len, int num_stripes)
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
@@ -7819,12 +7820,6 @@ static int verify_one_dev_extent(struct btrfs_fs_info *fs_info,
 	}
 
 	/* Make sure no dev extent is beyond device bondary */
-	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
-	if (!dev) {
-		btrfs_err(fs_info, "failed to find devid %llu", devid);
-		ret = -EUCLEAN;
-		goto out;
-	}
 	if (physical_offset + physical_len > dev->disk_total_bytes) {
 		btrfs_err(fs_info,
 "dev extent devid %llu physical offset %llu len %llu is beyond device boundary %llu",
@@ -7874,6 +7869,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 {
 	struct btrfs_path *path;
 	struct btrfs_root *root = fs_info->dev_root;
+	struct btrfs_device *device = NULL;
 	struct btrfs_key key;
 	u64 prev_devid = 0;
 	u64 prev_dev_ext_end = 0;
@@ -7917,6 +7913,16 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 		devid = key.objectid;
 		physical_offset = key.offset;
 
+		if (!device || devid != device->devid) {
+			device = btrfs_find_device(fs_info, devid, NULL, NULL);
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
@@ -7930,7 +7936,7 @@ int btrfs_verify_dev_extents(struct btrfs_fs_info *fs_info)
 			goto out;
 		}
 
-		ret = verify_one_dev_extent(fs_info, chunk_offset, devid,
+		ret = verify_one_dev_extent(fs_info, device, chunk_offset,
 					    physical_offset, physical_len);
 		if (ret < 0)
 			goto out;
-- 
2.20.1

