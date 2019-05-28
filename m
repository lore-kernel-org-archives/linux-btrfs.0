Return-Path: <SRS0=Wt7H=T4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB763C04AB6
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 08:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E5A920883
	for <linux-btrfs@archiver.kernel.org>; Tue, 28 May 2019 08:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfE1IWH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 28 May 2019 04:22:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:37208 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725943AbfE1IWH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 May 2019 04:22:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6FC4DAE24
        for <linux-btrfs@vger.kernel.org>; Tue, 28 May 2019 08:22:06 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: trim: Check the range passed into to prevent overflow
Date:   Tue, 28 May 2019 16:21:54 +0800
Message-Id: <20190528082154.6450-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Normally the range->len is set to default value (U64_MAX), but when it's
not default value, we should check if the range overflows.

And if overflows, return -EINVAL before doing anything.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index f79e477a378e..62bfba6d3c07 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -11245,6 +11245,7 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	struct btrfs_device *device;
 	struct list_head *devices;
 	u64 group_trimmed;
+	u64 range_end = U64_MAX;
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
@@ -11254,16 +11255,23 @@ int btrfs_trim_fs(struct btrfs_fs_info *fs_info, struct fstrim_range *range)
 	int dev_ret = 0;
 	int ret = 0;
 
+	/*
+	 * Check range overflow if range->len is set.
+	 * The default range->len is U64_MAX.
+	 */
+	if (range->len != U64_MAX && check_add_overflow(range->start,
+				range->len, &range_end))
+		return -EINVAL;
+
 	cache = btrfs_lookup_first_block_group(fs_info, range->start);
 	for (; cache; cache = next_block_group(cache)) {
-		if (cache->key.objectid >= (range->start + range->len)) {
+		if (cache->key.objectid >= range_end) {
 			btrfs_put_block_group(cache);
 			break;
 		}
 
 		start = max(range->start, cache->key.objectid);
-		end = min(range->start + range->len,
-				cache->key.objectid + cache->key.offset);
+		end = min(range_end, cache->key.objectid + cache->key.offset);
 
 		if (end - start >= range->minlen) {
 			if (!block_group_cache_done(cache)) {
-- 
2.21.0

