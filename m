Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E823FC282CC
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C629920863
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 08:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfBKIfX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 03:35:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:41546 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727119AbfBKIfS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 03:35:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEDA9ADF3
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2019 08:35:16 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 10/12] btrfs: Optimize unallocated chunks discard
Date:   Mon, 11 Feb 2019 10:35:08 +0200
Message-Id: <20190211083510.27591-11-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190211083510.27591-1-nborisov@suse.com>
References: <20190211083510.27591-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently unallocated chunks are always trimmed. For example
2 consecutive trims on large storage would trim freespace twice
irrespective of whether the space was actually allocated or not between
those trims.

Optimise this behavior by exploiting the newly introduced alloc_state
tree of btrfs_device. A new CHUNK_TRIMMED bit is used to mark
those unallocated chunks which have been trimmed and have not been
allocated afterwards. On chunk allocation the respective underlying devices'
physical space will have its CHUNK_TRIMMED flag cleared. This avoids
submitting discards for space which hasn't been changed since the last
time discard was issued.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 57 +++++++++++++++++++++++++++++++++++++++++-
 fs/btrfs/extent_io.h   |  8 +++++-
 fs/btrfs/extent_map.c  |  4 ++-
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 188774ed7795..2d4d597c8ca4 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11198,6 +11198,54 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
 	return unpin_extent_range(fs_info, start, end, false);
 }
 
+static bool should_skip_trim(struct btrfs_device *device, u64 *start, u64 *len)
+{
+	u64 trimmed_start = 0, trimmed_end = 0;
+	u64 end = *start + *len - 1;
+
+	if (!find_first_extent_bit(&device->alloc_state, *start, &trimmed_start,
+				   &trimmed_end, CHUNK_TRIMMED, NULL)) {
+		u64 trimmed_len = trimmed_end - trimmed_start + 1;
+
+		if (*start < trimmed_start) {
+			if (in_range(end, trimmed_start, trimmed_len) ||
+			    end > trimmed_end) {
+				/*
+				 * start|------|end
+				 *      ts|--|trimmed_len
+				 *      OR
+				 * start|-----|end
+				 *      ts|-----|trimmed_len
+				 */
+				*len = trimmed_start - *start;
+				return false;
+			} else if (end < trimmed_start) {
+				/*
+				 * start|------|end
+				 *             ts|--|trimmed_len
+				 */
+				return false;
+			}
+		} else if (in_range(*start, trimmed_start, trimmed_len)) {
+			if (in_range(end, trimmed_start, trimmed_len)) {
+				/*
+				 * start|------|end
+				 *  ts|----------|trimmed_len
+				 */
+				return true;
+			} else {
+				/*
+				 * start|-----------|end
+				 *  ts|----------|trimmed_len
+				 */
+				*start = trimmed_end + 1;
+				*len = end - *start + 1;
+				return false;
+			}
+		}
+	}
+	return false;
+}
 /*
  * It used to be that old block groups would be left around forever.
  * Iterating over them would be enough to trim unused space.  Since we
@@ -11268,7 +11316,14 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		start = max(range->start, start);
 		len = min(range->len, len);
 
-		ret = btrfs_issue_discard(device->bdev, start, len, &bytes);
+		if (!should_skip_trim(device, &start, &len)) {
+			ret = btrfs_issue_discard(device->bdev, start, len,
+						  &bytes);
+			if (!ret)
+				set_extent_bits(&device->alloc_state, start,
+						start + bytes - 1,
+						CHUNK_TRIMMED);
+		}
 		mutex_unlock(&fs_info->chunk_mutex);
 
 		if (ret)
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index d4227e40c8ee..d238efd628cf 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -30,8 +30,14 @@
 #define EXTENT_CTLBITS		(EXTENT_DO_ACCOUNTING)
 
 
-/* Redefined bits above which are used only in the device allocation tree */
+/*
+ * Redefined bits above which are used only in the device allocation tree,
+ * shouldn't be using EXTENT_IOBITS(EXTENT_LOCKED/EXTENT_WRITEBACK) /
+ * EXTENT_BOUNDARY / EXTENT_CLEAR_META_RESV / EXTENT_CLEAR_DATA_RESV because
+ * they have special meaning to the bit manipulation functions
+ */
 #define CHUNK_ALLOCATED EXTENT_DIRTY
+#define CHUNK_TRIMMED   EXTENT_DEFRAG
 
 /*
  * flags for bio submission. The high bits indicate the compression
diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 0820f6fcf3a6..9e8c0904f623 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -389,8 +389,10 @@ int add_extent_mapping(struct extent_map_tree *tree,
 		goto out;
 
 	setup_extent_mapping(tree, em, modified);
-	if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags))
+	if (test_bit(EXTENT_FLAG_FS_MAPPING, &em->flags)) {
 		extent_map_device_set_bits(em, CHUNK_ALLOCATED);
+		extent_map_device_clear_bits(em, CHUNK_TRIMMED);
+	}
 out:
 	return ret;
 }
-- 
2.17.1

