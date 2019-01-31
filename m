Return-Path: <SRS0=M3t6=QH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B68C169C4
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F29622081B
	for <linux-btrfs@archiver.kernel.org>; Thu, 31 Jan 2019 15:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732584AbfAaPiv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 31 Jan 2019 10:38:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:50228 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731033AbfAaPiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Jan 2019 10:38:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A82BFAD5D
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jan 2019 15:38:49 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     dsterba@suse.cz, jeffm@suse.com,
        Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2] btrfs: Switch btrfs_trim_free_extents to find_first_clear_extent_bit
Date:   Thu, 31 Jan 2019 17:38:48 +0200
Message-Id: <20190131153848.9108-1-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190130145102.4708-16-nborisov@suse.com>
References: <20190130145102.4708-16-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Instead of always calling the allocator to search for a free extent,
that satisfies the input criteria, switch btrfs_trim_free_extents to
using find_first_clear_extent_bit. With this change it's no longer
necessary to read the device tree in order to figure out holes in
the devices.

Now the code always searches in-memory data structure to figure out the
space range which contains the requested which should result in speed
oups.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---

V2: 
 Explicitly ensure that the offset of the passed range is at least 1mb. This 
 mimics the behavior of the chunk allocator where the first megabyte of every 
 device is never touched. This ensures we are not screwing up with any bootloaders
 that might occupy the first megabyte. 

 fs/btrfs/extent-tree.c | 87 ++++++++++++------------------------------
 1 file changed, 24 insertions(+), 63 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f5005ef39f98..23bda5d58d9f 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11127,54 +11127,6 @@ int btrfs_error_unpin_extent_range(struct btrfs_fs_info *fs_info,
 	return unpin_extent_range(fs_info, start, end, false);
 }
 
-static bool should_skip_trim(struct btrfs_device *device, u64 *start, u64 *len)
-{
-	u64 trimmed_start = 0, trimmed_end = 0;
-	u64 end = *start + *len - 1;
-
-	if (!find_first_extent_bit(&device->alloc_state, *start, &trimmed_start,
-				   &trimmed_end, CHUNK_TRIMMED, NULL)) {
-		u64 trimmed_len = trimmed_end - trimmed_start + 1;
-
-		if (*start < trimmed_start) {
-			if (in_range(end, trimmed_start, trimmed_len) ||
-			    end > trimmed_end) {
-				/*
-				 * start|------|end
-				 *      ts|--|trimmed_len
-				 *      OR
-				 * start|-----|end
-				 *      ts|-----|trimmed_len
-				 */
-				*len = trimmed_start - *start;
-				return false;
-			} else if (end < trimmed_start) {
-				/*
-				 * start|------|end
-				 *             ts|--|trimmed_len
-				 */
-				return false;
-			}
-		} else if (in_range(*start, trimmed_start, trimmed_len)) {
-			if (in_range(end, trimmed_start, trimmed_len)) {
-				/*
-				 * start|------|end
-				 *  ts|----------|trimmed_len
-				 */
-				return true;
-			} else {
-				/*
-				 * start|-----------|end
-				 *  ts|----------|trimmed_len
-				 */
-				*start = trimmed_end + 1;
-				*len = end - *start + 1;
-				return false;
-			}
-		}
-	}
-	return false;
-}
 /*
  * It used to be that old block groups would be left around forever.
  * Iterating over them would be enough to trim unused space.  Since we
@@ -11198,7 +11150,7 @@ static bool should_skip_trim(struct btrfs_device *device, u64 *start, u64 *len)
 static int btrfs_trim_free_extents(struct btrfs_device *device,
 				   struct fstrim_range *range, u64 *trimmed)
 {
-	u64 start = range->start, len = 0;
+	u64 start = max(range->start, SZ_1M), len = 0, end = 0;
 	int ret;
 
 	*trimmed = 0;
@@ -11225,34 +11177,43 @@ static int btrfs_trim_free_extents(struct btrfs_device *device,
 		if (ret)
 			break;
 
-		ret = find_free_dev_extent_start(device, range->minlen, start,
-						 &start, &len);
-
+		ret = find_first_clear_extent_bit(&device->alloc_state, start,
+				&start, &end,
+				CHUNK_TRIMMED | CHUNK_ALLOCATED);
 		if (ret) {
 			mutex_unlock(&fs_info->chunk_mutex);
-			if (ret == -ENOSPC)
-				ret = 0;
+			ret = 0;
 			break;
 		}
+		/* If find_first_clear_extent_bit find a range that spans the
+		 * end of the device it will set end to -1, in this case it's up
+		 * to the caller to trim the value to the size of the device.
+		 */
+		end = min(end, device->total_bytes);
+		len = end - start + 1;
+
+		/* Keep going until we satisfy minlen or reach end of space */
+		if (len < range->minlen) {
+			mutex_unlock(&fs_info->chunk_mutex);
+			start += len;
+			continue;
+		}
 
 		/* If we are out of the passed range break */
 		if (start > range->start + range->len - 1) {
 			mutex_unlock(&fs_info->chunk_mutex);
-			ret = 0;
 			break;
 		}
 
 		start = max(range->start, start);
 		len = min(range->len, len);
 
-		if (!should_skip_trim(device, &start, &len)) {
-			ret = btrfs_issue_discard(device->bdev, start, len,
-						  &bytes);
-			if (!ret)
-				set_extent_bits(&device->alloc_state, start,
-						start + bytes - 1,
-						CHUNK_TRIMMED);
-		}
+		ret = btrfs_issue_discard(device->bdev, start, len,
+					  &bytes);
+		if (!ret)
+			set_extent_bits(&device->alloc_state, start,
+					start + bytes - 1,
+					CHUNK_TRIMMED);
 		mutex_unlock(&fs_info->chunk_mutex);
 
 		if (ret)
-- 
2.17.1

