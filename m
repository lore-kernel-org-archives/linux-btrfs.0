Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C27AC65C20
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:30:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E66420858
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:30:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E66420858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbeJHTm1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 15:42:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:60254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbeJHTm1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 15:42:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E466AFDC
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 12:30:56 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/6] btrfs-progs: original check: Add ability to detect bad dev extents
Date:   Mon,  8 Oct 2018 20:30:41 +0800
Message-Id: <20181008123044.13413-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181008123044.13413-1-wqu@suse.com>
References: <20181008123044.13413-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Unlike lowmem mode check, we don't have good place for original mode to
check overlap dev extents.

So this patch introduces a new function, btrfs_check_dev_extents(), to
handle possible bad dev extents.

Reported-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/main.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/check/main.c b/check/main.c
index bc2ee22f7943..ff9a785ce555 100644
--- a/check/main.c
+++ b/check/main.c
@@ -8224,6 +8224,99 @@ out:
 	return ret;
 }
 
+/*
+ * Check if all dev extents are valid (not overlap nor beyond device
+ * boundary).
+ *
+ * Dev extents <-> chunk cross checking is already done in check_chunks().
+ */
+static int check_dev_extents(struct btrfs_fs_info *fs_info)
+{
+	struct btrfs_path path;
+	struct btrfs_key key;
+	struct btrfs_root *dev_root = fs_info->dev_root;
+	int ret;
+	u64 prev_devid = 0;
+	u64 prev_dev_ext_end = 0;
+
+	btrfs_init_path(&path);
+
+	key.objectid = 1;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = 0;
+
+	ret = btrfs_search_slot(NULL, dev_root, &key, &path, 0, 0);
+	if (ret < 0) {
+		error("failed to search device tree: %s", strerror(-ret));
+		goto out;
+	}
+	if (path.slots[0] >= btrfs_header_nritems(path.nodes[0])) {
+		ret = btrfs_next_leaf(dev_root, &path);
+		if (ret < 0) {
+			error("failed to find next leaf: %s", strerror(-ret));
+			goto out;
+		}
+		if (ret > 0) {
+			ret = 0;
+			goto out;
+		}
+	}
+
+	while (1) {
+		struct btrfs_dev_extent *dev_ext;
+		struct btrfs_device *dev;
+		u64 devid;
+		u64 physical_offset;
+		u64 physical_len;
+
+		btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+		if (key.type != BTRFS_DEV_EXTENT_KEY)
+			break;
+		dev_ext = btrfs_item_ptr(path.nodes[0], path.slots[0],
+					 struct btrfs_dev_extent);
+		devid = key.objectid;
+		physical_offset = key.offset;
+		physical_len = btrfs_dev_extent_length(path.nodes[0], dev_ext);
+
+		dev = btrfs_find_device(fs_info, devid, NULL, NULL);
+		if (!dev) {
+			error("failed to find device with devid %llu", devid);
+			ret = -EUCLEAN;
+			goto out;
+		}
+		if (prev_devid == devid && prev_dev_ext_end > physical_offset) {
+			error(
+"dev extent devid %llu physical offset %llu overlap with previous dev extent end %llu",
+			      devid, physical_offset, prev_dev_ext_end);
+			ret = -EUCLEAN;
+			goto out;
+		}
+		if (physical_offset + physical_len > dev->total_bytes) {
+			error(
+"dev extent devid %llu physical offset %llu len %llu is beyond device boudnary %llu",
+			      devid, physical_offset, physical_len,
+			      dev->total_bytes);
+			ret = -EUCLEAN;
+			goto out;
+		}
+		prev_devid = devid;
+		prev_dev_ext_end = physical_offset + physical_len;
+
+		ret = btrfs_next_item(dev_root, &path);
+		if (ret < 0) {
+			error("failed to find next leaf: %s", strerror(-ret));
+			goto out;
+		}
+		if (ret > 0) {
+			ret = 0;
+			break;
+		}
+	}
+out:
+	btrfs_release_path(&path);
+	return ret;
+}
+
 static int check_chunks_and_extents(struct btrfs_fs_info *fs_info)
 {
 	struct rb_root dev_cache;
@@ -8318,6 +8411,12 @@ again:
 		goto out;
 	}
 
+	ret = check_dev_extents(fs_info);
+	if (ret < 0) {
+		err = ret;
+		goto out;
+	}
+
 	ret = check_chunks(&chunk_cache, &block_group_cache,
 			   &dev_extent_cache, NULL, NULL, NULL, 0);
 	if (ret) {
-- 
2.19.1

