Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53128C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25D58208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25D58208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbeK0N3p (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 08:29:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:58564 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728272AbeK0N3p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 08:29:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8E548AF57
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 02:33:26 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 4/5] btrfs-progs: image: Rebuild dev extents using chunk tree
Date:   Tue, 27 Nov 2018 10:33:14 +0800
Message-Id: <20181127023315.28176-5-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181127023315.28176-1-wqu@suse.com>
References: <20181127023315.28176-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

With existing dev extents cleaned up, now we can rebuild dev extents
using the correct chunk tree.

Since new dev extents are all rebuild from scratch, even we're restoring
image from multi-device fs to single disk, we won't have any problem
reported by btrfs check.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 34 ++++++++++++++++++++++++++++++++++
 volumes.c    | 10 +++++-----
 volumes.h    |  4 ++++
 3 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/image/main.c b/image/main.c
index 707568f22e01..626eb933d5cc 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2265,12 +2265,46 @@ out:
 static int fixup_dev_extents(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info)
 {
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct btrfs_device *dev;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	u64 devid = btrfs_stack_device_id(&fs_info->super_copy->dev_item);
+	int i;
 	int ret;
 
 	ret = remove_all_dev_extents(trans, fs_info);
 	if (ret < 0)
 		error("failed to remove all existing dev extents: %s",
 			strerror(-ret));
+
+	dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+	if (!dev) {
+		error("faild to find devid %llu", devid);
+		return -ENODEV;
+	}
+
+	/* Rebuild all dev extents using chunk maps */
+	for (ce = search_cache_extent(&map_tree->cache_tree, 0); ce;
+	     ce = next_cache_extent(ce)) {
+		u64 stripe_len;
+
+		map = container_of(ce, struct map_lookup, ce);
+		stripe_len = calc_stripe_length(map->type, ce->size,
+						map->num_stripes);
+		for (i = 0; i < map->num_stripes; i++) {
+			ret = btrfs_alloc_dev_extent(trans, dev, ce->start,
+				stripe_len, &map->stripes[i].physical, 1);
+			if (ret < 0) {
+				error(
+				"failed to insert dev extent %llu %llu: %s",
+					devid, map->stripes[i].physical,
+					strerror(-ret));
+				goto out;
+			}
+		}
+	}
+out:
 	return ret;
 }
 
diff --git a/volumes.c b/volumes.c
index 30090ce5f8e8..73c9204fa7d1 100644
--- a/volumes.c
+++ b/volumes.c
@@ -530,10 +530,10 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
 }
 
-static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
-				  struct btrfs_device *device,
-				  u64 chunk_offset, u64 num_bytes, u64 *start,
-				  int convert)
+int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
+			   struct btrfs_device *device,
+			   u64 chunk_offset, u64 num_bytes, u64 *start,
+			   int insert_asis)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -550,7 +550,7 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	 * For convert case, just skip search free dev_extent, as caller
 	 * is responsible to make sure it's free.
 	 */
-	if (!convert) {
+	if (!insert_asis) {
 		ret = find_free_dev_extent(device, num_bytes, start, NULL);
 		if (ret)
 			goto err;
diff --git a/volumes.h b/volumes.h
index b4ea93f0bec3..5ca2779ebd45 100644
--- a/volumes.h
+++ b/volumes.h
@@ -271,6 +271,10 @@ void btrfs_close_all_devices(void);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_fs_info *fs_info,
 		     struct btrfs_device *device);
+int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
+			   struct btrfs_device *device,
+			   u64 chunk_offset, u64 num_bytes, u64 *start,
+			   int insert_asis);
 int btrfs_update_device(struct btrfs_trans_handle *trans,
 			struct btrfs_device *device);
 int btrfs_scan_one_device(int fd, const char *path,
-- 
2.19.2

