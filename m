Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66A1C004D3
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E74720824
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 12:24:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E74720824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=cn.fujitsu.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbeJXUwR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 16:52:17 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:51970 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727411AbeJXUwQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 16:52:16 -0400
X-IronPort-AV: E=Sophos;i="5.43,368,1503331200"; 
   d="scan'208";a="46658921"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 24 Oct 2018 20:24:15 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id CA4114B714A5;
        Wed, 24 Oct 2018 20:24:11 +0800 (CST)
Received: from fnst.lan (10.167.226.155) by G08CNEXCHPEKD01.g08.fujitsu.local
 (10.167.33.89) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 24 Oct
 2018 20:24:16 +0800
From:   Lu Fengqi <lufq.fnst@cn.fujitsu.com>
To:     <linux-btrfs@vger.kernel.org>
CC:     Qu Wenruo <wqu@suse.com>
Subject: [PATCH 1/3] btrfs: extent-tree: Detect bytes_may_use underflow earlier
Date:   Wed, 24 Oct 2018 20:24:01 +0800
Message-ID: <20181024122403.17418-2-lufq.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
References: <20181024122403.17418-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.167.226.155]
X-yoursite-MailScanner-ID: CA4114B714A5.A78D2
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lufq.fnst@cn.fujitsu.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

Although we have space_info::bytes_may_use underflow detection in
btrfs_free_reserved_data_space_noquota(), we have more callers who are
subtracting number from space_info::bytes_may_use.

So instead of doing underflow detection for every caller, introduce a
new wrapper update_bytes_may_use() to replace open coded bytes_may_use
modifiers.

This also introduce a macro to declare more wrappers, but currently
space_info::bytes_may_use is the mostly interesting one.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 44 +++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index a1febf155747..c0147a1307e7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -51,6 +51,21 @@ enum {
 	CHUNK_ALLOC_FORCE = 2,
 };
 
+/* Helper function to detect various space info bytes underflow */
+#define DECLARE_SPACE_INFO_UPDATE(name)					\
+static inline void update_##name(struct btrfs_space_info *sinfo,	\
+				 s64 bytes)				\
+{									\
+	if (bytes < 0 && sinfo->name < -bytes) {			\
+		WARN_ON(1);						\
+		sinfo->name = 0;					\
+		return;							\
+	}								\
+	sinfo->name += bytes;						\
+}
+
+DECLARE_SPACE_INFO_UPDATE(bytes_may_use);
+
 static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
 			       struct btrfs_delayed_ref_node *node, u64 parent,
 			       u64 root_objectid, u64 owner_objectid,
@@ -4256,7 +4271,7 @@ int btrfs_alloc_data_chunk_ondemand(struct btrfs_inode *inode, u64 bytes)
 					      data_sinfo->flags, bytes, 1);
 		return -ENOSPC;
 	}
-	data_sinfo->bytes_may_use += bytes;
+	update_bytes_may_use(data_sinfo, bytes);
 	trace_btrfs_space_reservation(fs_info, "space_info",
 				      data_sinfo->flags, bytes, 1);
 	spin_unlock(&data_sinfo->lock);
@@ -4309,10 +4324,7 @@ void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
 
 	data_sinfo = fs_info->data_sinfo;
 	spin_lock(&data_sinfo->lock);
-	if (WARN_ON(data_sinfo->bytes_may_use < len))
-		data_sinfo->bytes_may_use = 0;
-	else
-		data_sinfo->bytes_may_use -= len;
+	update_bytes_may_use(data_sinfo, -len);
 	trace_btrfs_space_reservation(fs_info, "space_info",
 				      data_sinfo->flags, len, 0);
 	spin_unlock(&data_sinfo->lock);
@@ -5108,7 +5120,7 @@ static int wait_reserve_ticket(struct btrfs_fs_info *fs_info,
 		list_del_init(&ticket->list);
 	if (ticket->bytes && ticket->bytes < orig_bytes) {
 		u64 num_bytes = orig_bytes - ticket->bytes;
-		space_info->bytes_may_use -= num_bytes;
+		update_bytes_may_use(space_info, -num_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, num_bytes, 0);
 	}
@@ -5154,13 +5166,13 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	 * If not things get more complicated.
 	 */
 	if (used + orig_bytes <= space_info->total_bytes) {
-		space_info->bytes_may_use += orig_bytes;
+		update_bytes_may_use(space_info, orig_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, orig_bytes, 1);
 		ret = 0;
 	} else if (can_overcommit(fs_info, space_info, orig_bytes, flush,
 				  system_chunk)) {
-		space_info->bytes_may_use += orig_bytes;
+		update_bytes_may_use(space_info, orig_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 					      space_info->flags, orig_bytes, 1);
 		ret = 0;
@@ -5223,7 +5235,7 @@ static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 	if (ticket.bytes) {
 		if (ticket.bytes < orig_bytes) {
 			u64 num_bytes = orig_bytes - ticket.bytes;
-			space_info->bytes_may_use -= num_bytes;
+			update_bytes_may_use(space_info, -num_bytes);
 			trace_btrfs_space_reservation(fs_info, "space_info",
 						      space_info->flags,
 						      num_bytes, 0);
@@ -5407,7 +5419,7 @@ static void space_info_add_old_bytes(struct btrfs_fs_info *fs_info,
 		flush = BTRFS_RESERVE_FLUSH_ALL;
 		goto again;
 	}
-	space_info->bytes_may_use -= num_bytes;
+	update_bytes_may_use(space_info, -num_bytes);
 	trace_btrfs_space_reservation(fs_info, "space_info",
 				      space_info->flags, num_bytes, 0);
 	spin_unlock(&space_info->lock);
@@ -5435,7 +5447,7 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 						      ticket->bytes, 1);
 			list_del_init(&ticket->list);
 			num_bytes -= ticket->bytes;
-			space_info->bytes_may_use += ticket->bytes;
+			update_bytes_may_use(space_info, ticket->bytes);
 			ticket->bytes = 0;
 			space_info->tickets_id++;
 			wake_up(&ticket->wait);
@@ -5443,7 +5455,7 @@ static void space_info_add_new_bytes(struct btrfs_fs_info *fs_info,
 			trace_btrfs_space_reservation(fs_info, "space_info",
 						      space_info->flags,
 						      num_bytes, 1);
-			space_info->bytes_may_use += num_bytes;
+			update_bytes_may_use(space_info, num_bytes);
 			ticket->bytes -= num_bytes;
 			num_bytes = 0;
 		}
@@ -5750,14 +5762,14 @@ static void update_global_block_rsv(struct btrfs_fs_info *fs_info)
 			num_bytes = min(num_bytes,
 					block_rsv->size - block_rsv->reserved);
 			block_rsv->reserved += num_bytes;
-			sinfo->bytes_may_use += num_bytes;
+			update_bytes_may_use(sinfo, num_bytes);
 			trace_btrfs_space_reservation(fs_info, "space_info",
 						      sinfo->flags, num_bytes,
 						      1);
 		}
 	} else if (block_rsv->reserved > block_rsv->size) {
 		num_bytes = block_rsv->reserved - block_rsv->size;
-		sinfo->bytes_may_use -= num_bytes;
+		update_bytes_may_use(sinfo, -num_bytes);
 		trace_btrfs_space_reservation(fs_info, "space_info",
 				      sinfo->flags, num_bytes, 0);
 		block_rsv->reserved = block_rsv->size;
@@ -6431,7 +6443,7 @@ static int btrfs_add_reserved_bytes(struct btrfs_block_group_cache *cache,
 	} else {
 		cache->reserved += num_bytes;
 		space_info->bytes_reserved += num_bytes;
-		space_info->bytes_may_use -= ram_bytes;
+		update_bytes_may_use(space_info, -ram_bytes);
 		if (delalloc)
 			cache->delalloc_bytes += num_bytes;
 	}
@@ -6608,7 +6620,7 @@ static int unpin_extent_range(struct btrfs_fs_info *fs_info,
 				to_add = min(len, global_rsv->size -
 					     global_rsv->reserved);
 				global_rsv->reserved += to_add;
-				space_info->bytes_may_use += to_add;
+				update_bytes_may_use(space_info, to_add);
 				if (global_rsv->reserved >= global_rsv->size)
 					global_rsv->full = 1;
 				trace_btrfs_space_reservation(fs_info,
-- 
2.19.1



