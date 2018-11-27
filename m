Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19A4C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FC98208E4
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 02:33:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FC98208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbeK0N3m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 08:29:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:58542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728009AbeK0N3m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 08:29:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11E85AF5A
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 02:33:23 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/5] btrfs-progs: image: Fix block group item flags when restoring multi-device image to single device
Date:   Tue, 27 Nov 2018 10:33:12 +0800
Message-Id: <20181127023315.28176-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181127023315.28176-1-wqu@suse.com>
References: <20181127023315.28176-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since btrfs-image is just restoring tree blocks without really check if
that tree block contents makes sense, for multi-device image, block
group items will keep that incorrect block group flags.

For example, for a metadata RAID1 data RAID0 btrfs recovered to a single
disk, its chunk tree will look like:

	item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096)
		length 8388608 owner 2 stripe_len 65536 type SYSTEM
	item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704)
		length 1073741824 owner 2 stripe_len 65536 type METADATA
	item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 1104150528)
		length 1073741824 owner 2 stripe_len 65536 type DATA

All chunks have correct type (SINGLE).

While its block group items will look like:

	item 1 key (22020096 BLOCK_GROUP_ITEM 8388608)
		block group used 16384 chunk_objectid 256 flags SYSTEM|RAID1
	item 3 key (30408704 BLOCK_GROUP_ITEM 1073741824)
		block group used 114688 chunk_objectid 256 flags METADATA|RAID1
	item 11 key (1104150528 BLOCK_GROUP_ITEM 1073741824)
		block group used 1572864 chunk_objectid 256 flags DATA|RAID0

All block group items still have the wrong profiles.

And btrfs check (lowmem mode for better output) will report error for such image:

  ERROR: chunk[22020096 30408704) related block group item flags mismatch, wanted: 2, have: 18
  ERROR: chunk[30408704 1104150528) related block group item flags mismatch, wanted: 4, have: 20
  ERROR: chunk[1104150528 2177892352) related block group item flags mismatch, wanted: 1, have: 9

This patch will do an extra repair for block group items to fix the
profile of them.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/image/main.c b/image/main.c
index 36b5c95ea146..9060f6b1b665 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2164,6 +2164,52 @@ again:
 	return 0;
 }
 
+static void fixup_block_groups(struct btrfs_trans_handle *trans,
+			      struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_block_group_cache *bg;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	u64 extra_flags;
+
+	for (ce = search_cache_extent(&map_tree->cache_tree, 0); ce;
+	     ce = next_cache_extent(ce)) {
+		map = container_of(ce, struct map_lookup, ce);
+
+		bg = btrfs_lookup_block_group(fs_info, ce->start);
+		if (!bg) {
+			warning(
+		"can't find block group %llu, result fs may not be mountable",
+				ce->start);
+			continue;
+		}
+		extra_flags = map->type & BTRFS_BLOCK_GROUP_PROFILE_MASK;
+
+		if (bg->flags == map->type)
+			continue;
+
+		/* Update the block group item and mark the bg dirty */
+		bg->flags = map->type;
+		btrfs_set_block_group_flags(&bg->item, bg->flags);
+		set_extent_bits(&fs_info->block_group_cache, ce->start,
+				ce->start + ce->size - 1, BLOCK_GROUP_DIRTY);
+
+		/*
+		 * Chunk and bg flags can be different, changing bg flags
+		 * without update avail_data/meta_alloc_bits will lead to
+		 * ENOSPC.
+		 * So here we set avail_*_alloc_bits to match chunk types.
+		 */
+		if (map->type & BTRFS_BLOCK_GROUP_DATA)
+			fs_info->avail_data_alloc_bits = extra_flags;
+		if (map->type & BTRFS_BLOCK_GROUP_METADATA)
+			fs_info->avail_metadata_alloc_bits = extra_flags;
+		if (map->type & BTRFS_BLOCK_GROUP_SYSTEM)
+			fs_info->avail_system_alloc_bits = extra_flags;
+	}
+}
+
 static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
 			 struct mdrestore_struct *mdres, off_t dev_size)
 {
@@ -2180,6 +2226,7 @@ static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
 		return PTR_ERR(trans);
 	}
 
+	fixup_block_groups(trans, fs_info);
 	ret = fixup_device_size(trans, fs_info, mdres, dev_size);
 	if (ret < 0)
 		goto error;
-- 
2.19.2

