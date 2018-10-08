Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 562C8C676D2
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 276BE20858
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 12:30:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 276BE20858
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbeJHTmX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 15:42:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:60230 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbeJHTmX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 8 Oct 2018 15:42:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3D306AFDC
        for <linux-btrfs@vger.kernel.org>; Mon,  8 Oct 2018 12:30:52 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 1/6] btrfs-progs: image: Use correct device size when restoring
Date:   Mon,  8 Oct 2018 20:30:39 +0800
Message-Id: <20181008123044.13413-2-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181008123044.13413-1-wqu@suse.com>
References: <20181008123044.13413-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When restoring btrfs image, the total_bytes of device item is not
updated correctly. In fact total_bytes can be left 0 for restored image.

It doesn't trigger any error because btrfs check never checks
total_bytes of dev item.
However this is going to change.

Fix it by populating total_bytes of device item with the end position of
last dev extent to make later btrfs check happy.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 image/main.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/image/main.c b/image/main.c
index 351c5a256938..d5b89bc3149f 100644
--- a/image/main.c
+++ b/image/main.c
@@ -2082,15 +2082,17 @@ static void remap_overlapping_chunks(struct mdrestore_struct *mdres)
 }
 
 static int fixup_devices(struct btrfs_fs_info *fs_info,
-			 struct mdrestore_struct *mdres, off_t dev_size)
+			 struct mdrestore_struct *mdres, int out_fd)
 {
 	struct btrfs_trans_handle *trans;
 	struct btrfs_dev_item *dev_item;
+	struct btrfs_dev_extent *dev_ext;
 	struct btrfs_path path;
 	struct extent_buffer *leaf;
 	struct btrfs_root *root = fs_info->chunk_root;
 	struct btrfs_key key;
 	u64 devid, cur_devid;
+	u64 dev_size; /* Get from last dev extents */
 	int ret;
 
 	trans = btrfs_start_transaction(fs_info->tree_root, 1);
@@ -2101,16 +2103,56 @@ static int fixup_devices(struct btrfs_fs_info *fs_info,
 
 	dev_item = &fs_info->super_copy->dev_item;
 
+	btrfs_init_path(&path);
 	devid = btrfs_stack_device_id(dev_item);
 
+	key.objectid = devid;
+	key.type = BTRFS_DEV_EXTENT_KEY;
+	key.offset = (u64)-1;
+
+	ret = btrfs_search_slot(NULL, fs_info->dev_root, &key, &path, 0, 0);
+	if (ret < 0) {
+		error("failed to locate last dev extent of devid %llu: %s",
+			devid, strerror(-ret));
+		btrfs_release_path(&path);
+		return ret;
+	}
+	if (ret == 0) {
+		error("found invalid dev extent devid %llu offset -1",
+			devid);
+		btrfs_release_path(&path);
+		return -EUCLEAN;
+	}
+	ret = btrfs_previous_item(fs_info->dev_root, &path, devid,
+				  BTRFS_DEV_EXTENT_KEY);
+	if (ret > 0)
+		ret = -ENOENT;
+	if (ret < 0) {
+		error("failed to locate last dev extent of devid %llu: %s",
+			devid, strerror(-ret));
+		btrfs_release_path(&path);
+		return ret;
+	}
+
+	btrfs_item_key_to_cpu(path.nodes[0], &key, path.slots[0]);
+	dev_ext = btrfs_item_ptr(path.nodes[0], path.slots[0],
+				 struct btrfs_dev_extent);
+	dev_size = key.offset + btrfs_dev_extent_length(path.nodes[0], dev_ext);
+	btrfs_release_path(&path);
+
 	btrfs_set_stack_device_total_bytes(dev_item, dev_size);
 	btrfs_set_stack_device_bytes_used(dev_item, mdres->alloced_chunks);
+	/* Don't forget to enlarge the real file */
+	ret = ftruncate64(out_fd, dev_size);
+	if (ret < 0) {
+		error("failed to enlarge result image: %s", strerror(errno));
+		return -errno;
+	}
 
 	key.objectid = BTRFS_DEV_ITEMS_OBJECTID;
 	key.type = BTRFS_DEV_ITEM_KEY;
 	key.offset = 0;
 
-	btrfs_init_path(&path);
 
 again:
 	ret = btrfs_search_slot(trans, root, &key, &path, -1, 1);
@@ -2275,7 +2317,7 @@ static int restore_metadump(const char *input, FILE *out, int old_restore,
 			return 1;
 		}
 
-		ret = fixup_devices(info, &mdrestore, st.st_size);
+		ret = fixup_devices(info, &mdrestore, fileno(out));
 		close_ctree(info->chunk_root);
 		if (ret)
 			goto out;
-- 
2.19.1

