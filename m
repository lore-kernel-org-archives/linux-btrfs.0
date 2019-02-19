Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689EFC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 09:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F30D21902
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 09:02:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfBSJCN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 04:02:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:37988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725765AbfBSJCN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 04:02:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D261ACD2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Feb 2019 09:02:11 +0000 (UTC)
From:   Johannes Thumshirn <jthumshirn@suse.de>
To:     David Sterba <dsterba@suse.com>
Cc:     Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>,
        Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] btrfs: factor our read/write stage off csum_tree_block() into its callers
Date:   Tue, 19 Feb 2019 10:02:02 +0100
Message-Id: <20190219090202.9715-1-jthumshirn@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Currently csum_tree_block() does two things, first it as it's name
suggests it calculates the checksum for a tree-block. But it also writes
this checksum to disk or reads an extent_buffer from disk and compares the
checksum with the calculated checksum, depending on the verify argument.

Furthermore one of the two callers passes in '1' for the verify argument,
the other one passes in '0'.

For clarity and less layering violations, factor out the second stage in
csum_tree_block()'s callers.

Suggested-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/disk-io.c | 51 +++++++++++++++++++++++++++------------------------
 1 file changed, 27 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5216e7b3f9ad..5330123b0fe3 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -263,12 +263,9 @@ void btrfs_csum_final(u32 crc, u8 *result)
  * compute the csum for a btree block, and either verify it or write it
  * into the csum field of the block.
  */
-static int csum_tree_block(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *buf,
-			   int verify)
+static int csum_tree_block(struct extent_buffer *buf,
+			   u8 *result)
 {
-	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
-	char result[BTRFS_CSUM_SIZE];
 	unsigned long len;
 	unsigned long cur_len;
 	unsigned long offset = BTRFS_CSUM_SIZE;
@@ -300,23 +297,6 @@ static int csum_tree_block(struct btrfs_fs_info *fs_info,
 
 	btrfs_csum_final(crc, result);
 
-	if (verify) {
-		if (memcmp_extent_buffer(buf, result, 0, csum_size)) {
-			u32 val;
-			u32 found = 0;
-			memcpy(&found, result, csum_size);
-
-			read_extent_buffer(buf, &val, 0, csum_size);
-			btrfs_warn_rl(fs_info,
-				"%s checksum verify failed on %llu wanted %X found %X level %d",
-				fs_info->sb->s_id, buf->start,
-				val, found, btrfs_header_level(buf));
-			return -EUCLEAN;
-		}
-	} else {
-		write_extent_buffer(buf, result, 0, csum_size);
-	}
-
 	return 0;
 }
 
@@ -533,6 +513,8 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 {
 	u64 start = page_offset(page);
 	u64 found_start;
+	u8 result[BTRFS_CSUM_SIZE];
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	struct extent_buffer *eb;
 
 	eb = (struct extent_buffer *)page->private;
@@ -552,7 +534,11 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	ASSERT(memcmp_extent_buffer(eb, fs_info->fs_devices->metadata_uuid,
 			btrfs_header_fsid(), BTRFS_FSID_SIZE) == 0);
 
-	return csum_tree_block(fs_info, eb, 0);
+	if (WARN_ON(csum_tree_block(eb, result)))
+		return -EUCLEAN;
+
+	write_extent_buffer(eb, result, 0, csum_size);
+	return 0;
 }
 
 static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
@@ -595,7 +581,9 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	struct extent_buffer *eb;
 	struct btrfs_root *root = BTRFS_I(page->mapping->host)->root;
 	struct btrfs_fs_info *fs_info = root->fs_info;
+	u16 csum_size = btrfs_super_csum_size(fs_info->super_copy);
 	int ret = 0;
+	char result[BTRFS_CSUM_SIZE];
 	int reads_done;
 
 	if (!page->private)
@@ -642,10 +630,25 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	btrfs_set_buffer_lockdep_class(btrfs_header_owner(eb),
 				       eb, found_level);
 
-	ret = csum_tree_block(fs_info, eb, 1);
+	ret = csum_tree_block(eb, result);
 	if (ret)
 		goto err;
 
+	if (memcmp_extent_buffer(eb, result, 0, csum_size)) {
+		u32 val;
+		u32 found = 0;
+
+		memcpy(&found, result, csum_size);
+
+		read_extent_buffer(eb, &val, 0, csum_size);
+		btrfs_warn_rl(fs_info,
+			      "%s checksum verify failed on %llu wanted %x found %x level %d",
+			      fs_info->sb->s_id, eb->start,
+			      val, found, btrfs_header_level(eb));
+		ret = -EUCLEAN;
+		goto err;
+	}
+
 	/*
 	 * If this is a leaf block and it is corrupt, set the corrupt bit so
 	 * that we don't try and read the other copies of this block, just
-- 
2.16.4

