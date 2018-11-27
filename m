Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14F1EC43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB23C2086B
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 08:38:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB23C2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729572AbeK0Tfq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 14:35:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:38502 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729566AbeK0Tfq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 14:35:46 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 530F1ADED
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Nov 2018 08:38:36 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 3/5] btrfs-progs: volumes: Refactor btrfs_alloc_dev_extent() into two functions
Date:   Tue, 27 Nov 2018 16:38:26 +0800
Message-Id: <20181127083828.23861-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181127083828.23861-1-wqu@suse.com>
References: <20181127083828.23861-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We have btrfs_alloc_dev_extent() accepting @convert flag to toggle
special handling for convert.

However that @convert flag only determine whether we call
find_free_dev_extent(), and we may later need to insert dev extents
without searching dev tree.

So refactor btrfs_alloc_dev_extent() into 2 functions,
btrfs_alloc_dev_extent(), which will try to find free dev extent, and
btrfs_insert_dev_extent(), which will just insert a dev extent.

For implementation, btrfs_alloc_dev_extent() will call
btrfs_insert_dev_extent() anyway, so no duplicated code.

This removes the need of @convert parameter, and make
btrfs_insert_dev_extent() public for later usage.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 volumes.c | 48 ++++++++++++++++++++++++++++++------------------
 volumes.h |  3 +++
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/volumes.c b/volumes.c
index 30090ce5f8e8..0dd082cd1718 100644
--- a/volumes.c
+++ b/volumes.c
@@ -530,10 +530,12 @@ static int find_free_dev_extent(struct btrfs_device *device, u64 num_bytes,
 	return find_free_dev_extent_start(device, num_bytes, 0, start, len);
 }
 
-static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
-				  struct btrfs_device *device,
-				  u64 chunk_offset, u64 num_bytes, u64 *start,
-				  int convert)
+/*
+ * Insert one device extent into the fs.
+ */
+int btrfs_insert_dev_extent(struct btrfs_trans_handle *trans,
+			    struct btrfs_device *device,
+			    u64 chunk_offset, u64 num_bytes, u64 start)
 {
 	int ret;
 	struct btrfs_path *path;
@@ -546,18 +548,8 @@ static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
 	if (!path)
 		return -ENOMEM;
 
-	/*
-	 * For convert case, just skip search free dev_extent, as caller
-	 * is responsible to make sure it's free.
-	 */
-	if (!convert) {
-		ret = find_free_dev_extent(device, num_bytes, start, NULL);
-		if (ret)
-			goto err;
-	}
-
 	key.objectid = device->devid;
-	key.offset = *start;
+	key.offset = start;
 	key.type = BTRFS_DEV_EXTENT_KEY;
 	ret = btrfs_insert_empty_item(trans, root, path, &key,
 				      sizeof(*extent));
@@ -583,6 +575,22 @@ err:
 	return ret;
 }
 
+/*
+ * Allocate one free dev extent and insert it into the fs.
+ */
+static int btrfs_alloc_dev_extent(struct btrfs_trans_handle *trans,
+				  struct btrfs_device *device,
+				  u64 chunk_offset, u64 num_bytes, u64 *start)
+{
+	int ret;
+
+	ret = find_free_dev_extent(device, num_bytes, start, NULL);
+	if (ret)
+		return ret;
+	return btrfs_insert_dev_extent(trans, device, chunk_offset, num_bytes,
+					*start);
+}
+
 static int find_next_chunk(struct btrfs_fs_info *fs_info, u64 *offset)
 {
 	struct btrfs_root *root = fs_info->chunk_root;
@@ -1107,7 +1115,7 @@ again:
 			list_move_tail(&device->dev_list, dev_list);
 
 		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
-			     calc_size, &dev_offset, 0);
+			     calc_size, &dev_offset);
 		if (ret < 0)
 			goto out_chunk_map;
 
@@ -1241,8 +1249,12 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
 	while (index < num_stripes) {
 		struct btrfs_stripe *stripe;
 
-		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
-			     calc_size, &dev_offset, convert);
+		if (convert)
+			ret = btrfs_insert_dev_extent(trans, device, key.offset,
+					calc_size, dev_offset);
+		else
+			ret = btrfs_alloc_dev_extent(trans, device, key.offset,
+					calc_size, &dev_offset);
 		BUG_ON(ret);
 
 		device->bytes_used += calc_size;
diff --git a/volumes.h b/volumes.h
index b4ea93f0bec3..44284ee75adb 100644
--- a/volumes.h
+++ b/volumes.h
@@ -268,6 +268,9 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
 		       int flags);
 int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
 void btrfs_close_all_devices(void);
+int btrfs_insert_dev_extent(struct btrfs_trans_handle *trans,
+			    struct btrfs_device *device,
+			    u64 chunk_offset, u64 num_bytes, u64 start);
 int btrfs_add_device(struct btrfs_trans_handle *trans,
 		     struct btrfs_fs_info *fs_info,
 		     struct btrfs_device *device);
-- 
2.19.2

