Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3A80C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BBB2086B
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 03:04:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6BBB2086B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbeK1OER (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 28 Nov 2018 09:04:17 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:54216 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727115AbeK1OEQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Nov 2018 09:04:16 -0500
X-IronPort-AV: E=Sophos;i="5.56,289,1539619200"; 
   d="scan'208";a="48766237"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 28 Nov 2018 11:04:10 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 353C54B6AE19
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 11:04:09 +0800 (CST)
Received: from localhost.localdomain (10.167.226.22) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 28 Nov 2018 11:04:14 +0800
From:   Su Yue <suy.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     <suy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 03/17] btrfs: priority alloc: introduce compute_block_group_priority/usage
Date:   Wed, 28 Nov 2018 11:11:34 +0800
Message-ID: <20181128031148.357-4-suy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
References: <20181128031148.357-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.22]
X-yoursite-MailScanner-ID: 353C54B6AE19.AAEFA
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suy.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce compute_block_group_usage() and compute_block_group_usage().
And call the latter in btrfs_make_block_group() and
btrfs_read_block_groups().

compute_priority_level use ilog2(free) to compute priority level.

Signed-off-by: Su Yue <suy.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index d242a1174e50..0f4c5b1e0bcc 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -10091,6 +10091,7 @@ static int check_chunk_block_group_mappings(struct btrfs_fs_info *fs_info)
 	return ret;
 }
 
+static long compute_block_group_priority(struct btrfs_block_group_cache *bg);
 int btrfs_read_block_groups(struct btrfs_fs_info *info)
 {
 	struct btrfs_path *path;
@@ -10224,6 +10225,8 @@ int btrfs_read_block_groups(struct btrfs_fs_info *info)
 
 		link_block_group(cache);
 
+		cache->priority = compute_block_group_priority(cache);
+
 		set_avail_alloc_bits(info, cache->flags);
 		if (btrfs_chunk_readonly(info, cache->key.objectid)) {
 			inc_block_group_ro(cache, 1);
@@ -10373,6 +10376,8 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans, u64 bytes_used,
 
 	link_block_group(cache);
 
+	cache->priority = compute_block_group_priority(cache);
+
 	list_add_tail(&cache->bg_list, &trans->new_bgs);
 
 	set_avail_alloc_bits(fs_info, type);
@@ -11190,3 +11195,58 @@ void btrfs_mark_bg_unused(struct btrfs_block_group_cache *bg)
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);
 }
+
+enum btrfs_priority_shift {
+	PRIORITY_USAGE_SHIFT = 0
+};
+
+static inline u8
+compute_block_group_usage(struct btrfs_block_group_cache *cache)
+{
+	u64 num_bytes;
+	u8 usage;
+
+	num_bytes = cache->reserved + cache->bytes_super +
+		btrfs_block_group_used(&cache->item);
+
+	usage = div_u64(num_bytes, div_factor_fine(cache->key.offset, 1));
+
+	return usage;
+}
+
+static long compute_block_group_priority(struct btrfs_block_group_cache *bg)
+{
+	u8 usage;
+	long priority = 0;
+
+	if (btrfs_test_opt(bg->fs_info, PRIORITY_USAGE)) {
+		usage = compute_block_group_usage(bg);
+		priority |= usage << PRIORITY_USAGE_SHIFT;
+	}
+
+	return priority;
+}
+
+static int compute_priority_level(struct btrfs_fs_info *fs_info,
+				  long priority)
+{
+	int level = 0;
+
+	if (btrfs_test_opt(fs_info, PRIORITY_USAGE)) {
+		u8 free;
+
+		WARN_ON(priority < 0);
+		free = 100 - (priority >> PRIORITY_USAGE_SHIFT);
+
+		if (free == 0)
+			level = 0;
+		else if (free == 100)
+			level = ilog2(free) + 1;
+		else
+			level = ilog2(free);
+		/* log2(1) == 0, leave level 0 for unused block_groups */
+		level = ilog2(100) + 1 - level;
+	}
+
+	return level;
+}
-- 
2.19.1



