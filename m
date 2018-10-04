Return-Path: <SRS0=cN6C=MQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CFEC64EBC
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3B2920854
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Oct 2018 21:31:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3B2920854
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=mendix.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbeJEE0O (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Oct 2018 00:26:14 -0400
Received: from smtp.dpl.mendix.net ([83.96.177.10]:45761 "EHLO
        smtp.dpl.mendix.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726113AbeJEE0K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Oct 2018 00:26:10 -0400
Received: from mekker.bofh.hq.mendix.net (mekker.bofh.hq.mendix.net [IPv6:2001:828:13c8:10b::21])
        by smtp.dpl.mendix.net (Postfix) with ESMTP id 0E182202EB
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Oct 2018 23:24:44 +0200 (CEST)
From:   Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/6] btrfs: alloc_chunk: improve chunk size variable name
Date:   Thu,  4 Oct 2018 23:24:39 +0200
Message-Id: <20181004212443.26519-3-hans.van.kranenburg@mendix.com>
X-Mailer: git-send-email 2.19.0.329.g76f2f5c1e3
In-Reply-To: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
References: <20181004212443.26519-1-hans.van.kranenburg@mendix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

num_bytes is really a way too generic name for a variable in this
function. There are a dozen other variables that hold a number of bytes
as value.

Give it a name that actually describes what it does, which is holding
the size of the chunk that we're allocating.

Signed-off-by: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
---
 fs/btrfs/volumes.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 9c9bb127eeee..40fa85e68b1f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -123,6 +123,8 @@ const char *get_raid_name(enum btrfs_raid_types type)
 	return btrfs_raid_array[type].raid_name;
 }
 
+
+
 static int init_first_rw_device(struct btrfs_trans_handle *trans,
 				struct btrfs_fs_info *fs_info);
 static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info);
@@ -4599,7 +4601,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	u64 max_stripe_size;
 	u64 max_chunk_size;
 	u64 stripe_size;
-	u64 num_bytes;
+	u64 chunk_size;
 	int ndevs;
 	int i;
 	int j;
@@ -4801,9 +4803,9 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	map->type = type;
 	map->sub_stripes = sub_stripes;
 
-	num_bytes = stripe_size * data_stripes;
+	chunk_size = stripe_size * data_stripes;
 
-	trace_btrfs_chunk_alloc(info, map, start, num_bytes);
+	trace_btrfs_chunk_alloc(info, map, start, chunk_size);
 
 	em = alloc_extent_map();
 	if (!em) {
@@ -4814,7 +4816,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	set_bit(EXTENT_FLAG_FS_MAPPING, &em->flags);
 	em->map_lookup = map;
 	em->start = start;
-	em->len = num_bytes;
+	em->len = chunk_size;
 	em->block_start = 0;
 	em->block_len = em->len;
 	em->orig_block_len = stripe_size;
@@ -4832,7 +4834,7 @@ static int __btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
 	refcount_inc(&em->refs);
 	write_unlock(&em_tree->lock);
 
-	ret = btrfs_make_block_group(trans, 0, type, start, num_bytes);
+	ret = btrfs_make_block_group(trans, 0, type, start, chunk_size);
 	if (ret)
 		goto error_del_extent;
 
-- 
2.19.0.329.g76f2f5c1e3

