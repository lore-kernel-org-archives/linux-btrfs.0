Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB5BBC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A85A2086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A85A2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbeK0Tfs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:35:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:38510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728823AbeK0Tfr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:35:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3B25EAC15
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 08:38:38 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 4/5] btrfs-progs: image: Remove all existing dev extents for later rebuild
Date:   Tue, 27 Nov 2018 16:38:27 +0800
Message-Id: <20181127083828.23861-5-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181127083828.23861-1-wqu@suse.com>
References: <20181127083828.23861-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For multi-disk btrfs image recovered to single disk, the dev tree would
look like:
        item 2 key (1 DEV_EXTENT 22020096)
                dev extent chunk_tree 3
                chunk_objectid 256 chunk_offset 22020096 length 8388608
        item 3 key (1 DEV_EXTENT 30408704)
                dev extent chunk_tree 3
                chunk_objectid 256 chunk_offset 30408704 length 1073741824
        item 4 key (1 DEV_EXTENT 1104150528)
                dev extent chunk_tree 3
                chunk_objectid 256 chunk_offset 1104150528 length 536870912
        item 5 key (2 DEV_EXTENT 1048576)
                dev extent chunk_tree 3
                chunk_objectid 256 chunk_offset 22020096 length 8388608
        item 6 key (2 DEV_EXTENT 9437184)
                dev extent chunk_tree 3
                chunk_objectid 256 chunk_offset 30408704 length 1073741824
        item 7 key (2 DEV_EXTENT 1083179008)
                dev extent chunk_tree 3
                chunk_objectid 256 chunk_offset 1104150528 length 536870912

However in chunk tree, we only use devid 2, thus devid 1 is completely
garbage:
        item 0 key (DEV_ITEMS DEV_ITEM 2)
        item 1 key (FIRST_CHUNK_TREE CHUNK_ITEM 22020096) itemoff 16105 itemsize 80
                length 8388608 owner 2 stripe_len 65536 type SYSTEM
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 2 offset 1048576
        item 2 key (FIRST_CHUNK_TREE CHUNK_ITEM 30408704) itemoff 16025 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type METADATA
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 2 offset 9437184
        item 3 key (FIRST_CHUNK_TREE CHUNK_ITEM 1104150528) itemoff 15945 itemsize 80
                length 1073741824 owner 2 stripe_len 65536 type DATA
                num_stripes 1 sub_stripes 0
                        stripe 0 devid 2 offset 1083179008

To fix the problem, the most straight-forward way is to remove all
existing dev extents, and then re-fill correct dev extents from chunk.

So this patch just follow the straight-forward way to fix it, causing
the final dev extents layout to match with chunk tree, and make btrfs
check happy.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 102 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/image/main.c b/image/main.c
index 9187de34f34a..8f756689a1fa 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2209,6 +2209,104 @@ static void fixup_block_groups(struct btrfs_fs_info *fs_info)
 	}
 }
 
+static int remove_all_dev_extents(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_root *root = fs_info->dev_root;
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct extent_buffer *leaf;
+	int slot;
+	int ret;
+
+	key.objectid = 1;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = 0;
+	btrfs_init_path(&path);
+
+	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
+	if (ret < 0) {
+		error("failed to search dev tree: %s", strerror(-ret));
+		return ret;
+	}
+
+	while (1) {
+		slot = path.slots[0];
+		leaf = path.nodes[0];
+		if (slot >= btrfs_header_nritems(leaf)) {
+			ret = btrfs_next_leaf(root, &path);
+			if (ret < 0) {
+				error("failed to search dev tree: %s",
+					strerror(-ret));
+				goto out;
+			}
+			if (ret > 0) {
+				ret = 0;
+				goto out;
+			}
+		}
+
+		btrfs_item_key_to_cpu(leaf, &key, slot);
+		if (key.type != BTRFS_DEV_EXTENT_KEY)
+			break;
+		ret = btrfs_del_item(trans, root, &path);
+		if (ret < 0) {
+			error("failed to delete dev extent %llu, %llu: %s",
+				key.objectid, key.offset, strerror(-ret));
+			goto out;
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
+static int fixup_dev_extents(struct btrfs_trans_handle *trans)
+{
+	struct btrfs_fs_info *fs_info = trans->fs_info;
+	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
+	struct btrfs_device *dev;
+	struct cache_extent *ce;
+	struct map_lookup *map;
+	u64 devid = btrfs_stack_device_id(&fs_info->super_copy->dev_item);
+	int i;
+	int ret;
+
+	ret = remove_all_dev_extents(trans);
+	if (ret < 0)
+		error("failed to remove all existing dev extents: %s",
+			strerror(-ret));
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
+			ret = btrfs_insert_dev_extent(trans, dev, ce->start,
+					stripe_len, map->stripes[i].physical);
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
+	return ret;
+}
+
 static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
 			 struct mdrestore_struct *mdres, off_t dev_size)
 {
@@ -2226,6 +2324,10 @@ static int fixup_chunks_and_devices(struct btrfs_fs_info *fs_info,
 	}
 
 	fixup_block_groups(fs_info);
+	ret = fixup_dev_extents(trans);
+	if (ret < 0)
+		goto error;
+
 	ret = fixup_device_size(trans, mdres, dev_size);
 	if (ret < 0)
 		goto error;
-- 
2.19.2

