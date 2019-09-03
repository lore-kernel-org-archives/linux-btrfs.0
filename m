Return-Path: <SRS0=cRuQ=W6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28DBC3A5A5
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 15:00:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B56F22377F
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Sep 2019 15:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729714AbfICPAv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Sep 2019 11:00:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:57440 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfICPAt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Sep 2019 11:00:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00D33AD4E;
        Tue,  3 Sep 2019 15:00:48 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v4 01/12] btrfs-progs: don't blindly assume crc32c in csum_tree_block_size()
Date:   Tue,  3 Sep 2019 17:00:35 +0200
Message-Id: <20190903150046.14926-2-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190903150046.14926-1-jthumshirn@suse.de>
References: <20190903150046.14926-1-jthumshirn@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The callers of csum_tree_block_size() blindly assume we're only having
crc32c as a possible checksum and thus pass in
btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32] for the size argument of
csum_tree_block_size().

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 mkfs/common.c | 14 +++++++-------
 mkfs/common.h |  2 ++
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/mkfs/common.c b/mkfs/common.c
index caca5e707233..b6e549b19272 100644
--- a/mkfs/common.c
+++ b/mkfs/common.c
@@ -101,7 +101,7 @@ static int btrfs_create_tree_root(int fd, struct btrfs_mkfs_config *cfg,
 	}
 
 	/* generate checksum */
-	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[cfg->csum_type], 0);
 
 	/* write back root tree */
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_ROOT_TREE]);
@@ -292,7 +292,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_EXTENT_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_EXTENT_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[cfg->csum_type], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_EXTENT_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -380,7 +380,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_CHUNK_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_CHUNK_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[cfg->csum_type], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_CHUNK_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -420,7 +420,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_DEV_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_DEV_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, nritems);
-	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[cfg->csum_type], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_DEV_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -433,7 +433,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_FS_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_FS_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[cfg->csum_type], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_FS_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -445,7 +445,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	btrfs_set_header_bytenr(buf, cfg->blocks[MKFS_CSUM_TREE]);
 	btrfs_set_header_owner(buf, BTRFS_CSUM_TREE_OBJECTID);
 	btrfs_set_header_nritems(buf, 0);
-	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[cfg->csum_type], 0);
 	ret = pwrite(fd, buf->data, cfg->nodesize, cfg->blocks[MKFS_CSUM_TREE]);
 	if (ret != cfg->nodesize) {
 		ret = (ret < 0 ? -errno : -EIO);
@@ -456,7 +456,7 @@ int make_btrfs(int fd, struct btrfs_mkfs_config *cfg)
 	memset(buf->data, 0, BTRFS_SUPER_INFO_SIZE);
 	memcpy(buf->data, &super, sizeof(super));
 	buf->len = BTRFS_SUPER_INFO_SIZE;
-	csum_tree_block_size(buf, btrfs_csum_sizes[BTRFS_CSUM_TYPE_CRC32], 0);
+	csum_tree_block_size(buf, btrfs_csum_sizes[cfg->csum_type], 0);
 	ret = pwrite(fd, buf->data, BTRFS_SUPER_INFO_SIZE,
 			cfg->blocks[MKFS_SUPER_BLOCK]);
 	if (ret != BTRFS_SUPER_INFO_SIZE) {
diff --git a/mkfs/common.h b/mkfs/common.h
index 28912906d0a9..1ca71a4fcce5 100644
--- a/mkfs/common.h
+++ b/mkfs/common.h
@@ -53,6 +53,8 @@ struct btrfs_mkfs_config {
 	u64 features;
 	/* Size of the filesystem in bytes */
 	u64 num_bytes;
+	/* checksum algorithm to use */
+	enum btrfs_csum_type csum_type;
 
 	/* Output fields, set during creation */
 
-- 
2.16.4

