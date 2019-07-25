Return-Path: <SRS0=fwWV=VW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B54EC76194
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 09:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC3682084D
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Jul 2019 09:34:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403816AbfGYJeX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Jul 2019 05:34:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:52354 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403778AbfGYJeL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Jul 2019 05:34:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 59097AF1F
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Jul 2019 09:34:09 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC PATCH 09/17] progs: pass in a btrfs_mkfs_config to write_temp_extent_buffer
Date:   Thu, 25 Jul 2019 11:33:56 +0200
Message-Id: <042f116c565320bc134a6bca5b5d91b0754a19a8.1564046972.git.jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <cover.1564046812.git.jthumshirn@suse.de>
References: <cover.1564046812.git.jthumshirn@suse.de>
In-Reply-To: <cover.1564046812.git.jthumshirn@suse.de>
References: <cover.1564046812.git.jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Pass in a btrfs_mkfs_config to write_temp_extent_buffer(), this is needed
so we can grab the checksum type for checksum buffer verification in later
patches.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 convert/common.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/convert/common.c b/convert/common.c
index af4f8d372299..dea5f5b20d50 100644
--- a/convert/common.c
+++ b/convert/common.c
@@ -218,7 +218,8 @@ static void insert_temp_root_item(struct extent_buffer *buf,
  * Setup an extent buffer for tree block.
  */
 static inline int write_temp_extent_buffer(int fd, struct extent_buffer *buf,
-					   u64 bytenr)
+					   u64 bytenr,
+					   struct btrfs_mkfs_config *cfg)
 {
 	int ret;
 
@@ -281,7 +282,7 @@ static int setup_temp_root_tree(int fd, struct btrfs_mkfs_config *cfg,
 	insert_temp_root_item(buf, cfg, &slot, &itemoff,
 			      BTRFS_CSUM_TREE_OBJECTID, csum_bytenr);
 
-	ret = write_temp_extent_buffer(fd, buf, root_bytenr);
+	ret = write_temp_extent_buffer(fd, buf, root_bytenr, cfg);
 out:
 	free(buf);
 	return ret;
@@ -456,7 +457,7 @@ static int setup_temp_chunk_tree(int fd, struct btrfs_mkfs_config *cfg,
 				     BTRFS_BLOCK_GROUP_METADATA);
 	if (ret < 0)
 		goto out;
-	ret = write_temp_extent_buffer(fd, buf, chunk_bytenr);
+	ret = write_temp_extent_buffer(fd, buf, chunk_bytenr, cfg);
 
 out:
 	free(buf);
@@ -515,7 +516,7 @@ static int setup_temp_dev_tree(int fd, struct btrfs_mkfs_config *cfg,
 			       BTRFS_MKFS_SYSTEM_GROUP_SIZE);
 	insert_temp_dev_extent(buf, &slot, &itemoff, meta_chunk_start,
 			       BTRFS_CONVERT_META_GROUP_SIZE);
-	ret = write_temp_extent_buffer(fd, buf, dev_bytenr);
+	ret = write_temp_extent_buffer(fd, buf, dev_bytenr, cfg);
 out:
 	free(buf);
 	return ret;
@@ -537,7 +538,7 @@ static int setup_temp_fs_tree(int fd, struct btrfs_mkfs_config *cfg,
 	/*
 	 * Temporary fs tree is completely empty.
 	 */
-	ret = write_temp_extent_buffer(fd, buf, fs_bytenr);
+	ret = write_temp_extent_buffer(fd, buf, fs_bytenr, cfg);
 out:
 	free(buf);
 	return ret;
@@ -559,7 +560,7 @@ static int setup_temp_csum_tree(int fd, struct btrfs_mkfs_config *cfg,
 	/*
 	 * Temporary csum tree is completely empty.
 	 */
-	ret = write_temp_extent_buffer(fd, buf, csum_bytenr);
+	ret = write_temp_extent_buffer(fd, buf, csum_bytenr, cfg);
 out:
 	free(buf);
 	return ret;
@@ -765,7 +766,7 @@ static int setup_temp_extent_tree(int fd, struct btrfs_mkfs_config *cfg,
 	if (ret < 0)
 		goto out;
 
-	ret = write_temp_extent_buffer(fd, buf, extent_bytenr);
+	ret = write_temp_extent_buffer(fd, buf, extent_bytenr, cfg);
 out:
 	free(buf);
 	return ret;
-- 
2.16.4

