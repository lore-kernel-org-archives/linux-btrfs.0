Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E36C67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECA4E20824
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ECA4E20824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbeJXUwP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 16:52:15 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:30356 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726812AbeJXUwO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 16:52:14 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46658920"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Oct 2018 20:24:15 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 63C6B4B714A7
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2018 20:24:12 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 24 Oct
 2018 20:24:17 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
Subject: [PATCH 2/3] btrfs: extent-tree: Detect bytes_pinned underflow earlier
Date:   Wed, 24 Oct 2018 20:24:02 +0800
Message-ID: <20181024122403.17418-3-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
References: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: 63C6B4B714A7.A81F9
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Introduce a new wrapper update_bytes_pinned to replace open coded
bytes_pinned modifiers.

Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
---
 fs/btrfs/extent-tree.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index c0147a1307e7..bb91db944d21 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -65,6 +65,7 @@ static inline void update_##name(struct btrfs_space_info *sinfo,	\
 }
 
 DECLARE_SPACE_INFO_UPDATE(bytes_may_use);
+DECLARE_SPACE_INFO_UPDATE(bytes_pinned);
 
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_ref_node *node, u64 parent,
@@ -6163,7 +6164,7 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			old_val -= num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			cache->pinned += num_bytes;
-			cache->space_info->bytes_pinned += num_bytes;
+			update_bytes_pinned(cache->space_info, num_bytes);
 			cache->space_info->bytes_used -= num_bytes;
 			cache->space_info->disk_used -= num_bytes * factor;
 			spin_unlock(&cache->lock);
@@ -6234,7 +6235,7 @@ static int pin_down_extent(struct btrfs_fs_info *fs_info,
 	spin_lock(&cache->space_info->lock);
 	spin_lock(&cache->lock);
 	cache->pinned += num_bytes;
-	cache->space_info->bytes_pinned += num_bytes;
+	update_bytes_pinned(cache->space_info, num_bytes);
 	if (reserved) {
 		cache->reserved -= num_bytes;
 		cache->space_info->bytes_reserved -= num_bytes;
@@ -6599,7 +6600,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 		spin_lock(&space_info->lock);
 		spin_lock(&cache->lock);
 		cache->pinned -= len;
-		space_info->bytes_pinned -= len;
+		update_bytes_pinned(space_info, -len);
 
 		trace_btrfs_space_reservation(fs_info, "pinned",
 					      space_info->flags, len, 0);
@@ -10710,7 +10711,7 @@ void btrfs_delete_unused_bgs(struct btrfs_fs_info *fs_info)
 		spin_lock(&space_info->lock);
 		spin_lock(&block_group->lock);
 
-		space_info->bytes_pinned -= block_group->pinned;
+		update_bytes_pinned(space_info, -block_group->pinned);
 		space_info->bytes_readonly += block_group->pinned;
 		percpu_counter_add_batch(&space_info->total_bytes_pinned,
 				   -block_group->pinned,
-- 
2.19.1



