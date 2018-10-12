Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C9CC67869
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3624D2086A
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 06:18:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3624D2086A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbeJLNtX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 09:49:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:34696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbeJLNtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 09:49:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1C87AEB3
        for <linux-btrfs@vger.kernel.org>; Fri, 12 Oct 2018 06:18:28 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v3 3/4] btrfs: Refactor unclustered extent allocation into find_free_extent_unclustered()
Date:   Fri, 12 Oct 2018 14:18:18 +0800
Message-Id: <20181012061819.19482-4-wqu@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181012061819.19482-1-wqu@suse.com>
References: <20181012061819.19482-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This patch will extract unclsutered extent allocation code into
find_free_extent_unclustered().

And this helper function will use return value to indicate what to do
next.

This should make find_free_extent() a little easier to read.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 114 ++++++++++++++++++++++++-----------------
 1 file changed, 68 insertions(+), 46 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 896d54b3c554..e6bfa91af41c 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7370,6 +7370,69 @@ static int find_free_extent_clustered(struct btrfs_block_group_cache *bg,
 	return 1;
 }
 
+/*
+ * Return >0 to inform caller that we find nothing
+ * Return 0 when we found an free extent and set ffe_ctrl->found_offset
+ * Return -EAGAIN to inform caller that we need to re-search this block group
+ */
+static int find_free_extent_unclustered(struct btrfs_block_group_cache *bg,
+		struct btrfs_free_cluster *last_ptr,
+		struct find_free_extent_ctl *ffe_ctl)
+{
+	u64 offset;
+
+	/*
+	 * We are doing an unclustered alloc, set the fragmented flag so we
+	 * don't bother trying to setup a cluster again until we get more space.
+	 */
+	if (unlikely(last_ptr)) {
+		spin_lock(&last_ptr->lock);
+		last_ptr->fragmented = 1;
+		spin_unlock(&last_ptr->lock);
+	}
+	if (ffe_ctl->cached) {
+		struct btrfs_free_space_ctl *free_space_ctl;
+
+		free_space_ctl = bg->free_space_ctl;
+		spin_lock(&free_space_ctl->tree_lock);
+		if (free_space_ctl->free_space <
+		    ffe_ctl->num_bytes + ffe_ctl->empty_cluster +
+		    ffe_ctl->empty_size) {
+			ffe_ctl->max_extent_size = max_t(u64,
+					ffe_ctl->max_extent_size,
+					free_space_ctl->free_space);
+			spin_unlock(&free_space_ctl->tree_lock);
+			return 1;
+		}
+		spin_unlock(&free_space_ctl->tree_lock);
+	}
+
+	offset = btrfs_find_space_for_alloc(bg, ffe_ctl->search_start,
+			ffe_ctl->num_bytes, ffe_ctl->empty_size,
+			&ffe_ctl->max_extent_size);
+
+	/*
+	 * If we didn't find a chunk, and we haven't failed on this block group
+	 * before, and this block group is in the middle of caching and we are
+	 * ok with waiting, then go ahead and wait for progress to be made, and
+	 * set @retry_unclustered to true.
+	 *
+	 * If @retry_unclustered is true then we've already waited on this block
+	 * group once and should move on to the next block group.
+	 */
+	if (!offset && !ffe_ctl->retry_unclustered && !ffe_ctl->cached &&
+	    ffe_ctl->loop > LOOP_CACHING_NOWAIT) {
+		wait_block_group_cache_progress(bg, ffe_ctl->num_bytes +
+						ffe_ctl->empty_size);
+		ffe_ctl->retry_unclustered = true;
+		return -EAGAIN;
+	} else if (!offset) {
+		return 1;
+	}
+	ffe_ctl->found_offset = offset;
+	return 0;
+}
+
 /*
  * walks the btree of allocated extents and find a hole of a given size.
  * The key ins is changed to record the hole:
@@ -7572,54 +7635,13 @@ static noinline int find_free_extent(struct btrfs_fs_info *fs_info,
 			/* ret == -ENOENT case falls through */
 		}
 
-		/*
-		 * We are doing an unclustered alloc, set the fragmented flag so
-		 * we don't bother trying to setup a cluster again until we get
-		 * more space.
-		 */
-		if (unlikely(last_ptr)) {
-			spin_lock(&last_ptr->lock);
-			last_ptr->fragmented = 1;
-			spin_unlock(&last_ptr->lock);
-		}
-		if (ffe_ctl.cached) {
-			struct btrfs_free_space_ctl *ctl =
-				block_group->free_space_ctl;
-
-			spin_lock(&ctl->tree_lock);
-			if (ctl->free_space <
-			    num_bytes + ffe_ctl.empty_cluster + empty_size) {
-				if (ctl->free_space > ffe_ctl.max_extent_size)
-					ffe_ctl.max_extent_size = ctl->free_space;
-				spin_unlock(&ctl->tree_lock);
-				goto loop;
-			}
-			spin_unlock(&ctl->tree_lock);
-		}
-
-		ffe_ctl.found_offset = btrfs_find_space_for_alloc(block_group,
-				ffe_ctl.search_start, num_bytes, empty_size,
-				&ffe_ctl.max_extent_size);
-		/*
-		 * If we didn't find a chunk, and we haven't failed on this
-		 * block group before, and this block group is in the middle of
-		 * caching and we are ok with waiting, then go ahead and wait
-		 * for progress to be made, and set ffe_ctl.retry_unclustered to
-		 * true.
-		 *
-		 * If ffe_ctl.retry_unclustered is true then we've already
-		 * waited on this block group once and should move on to the
-		 * next block group.
-		 */
-		if (!ffe_ctl.found_offset && !ffe_ctl.retry_unclustered &&
-		    !ffe_ctl.cached && ffe_ctl.loop > LOOP_CACHING_NOWAIT) {
-			wait_block_group_cache_progress(block_group,
-						num_bytes + empty_size);
-			ffe_ctl.retry_unclustered = true;
+		ret = find_free_extent_unclustered(block_group, last_ptr,
+						   &ffe_ctl);
+		if (ret == -EAGAIN)
 			goto have_block_group;
-		} else if (!ffe_ctl.found_offset) {
+		else if (ret > 0)
 			goto loop;
-		}
+		/* ret == 0 case falls through */
 checks:
 		ffe_ctl.search_start = round_up(ffe_ctl.found_offset,
 					     fs_info->stripesize);
-- 
2.19.1

