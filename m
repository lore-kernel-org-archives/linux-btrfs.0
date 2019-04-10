Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37CAC10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE34420850
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732710AbfDJOYs (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:24:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:40160 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732713AbfDJOYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5E4D3AF19
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:24:46 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/6] btrfs: Remove 'tree' argument from read_extent_buffer_pages
Date:   Wed, 10 Apr 2019 17:24:40 +0300
Message-Id: <20190410142443.6470-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190410142443.6470-1-nborisov@suse.com>
References: <20190410142443.6470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This function always uses the btree inode's io_tree. Stop taking the
tree as a function argument and instead access it internally from
read_extent_buffer_pages. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c   | 12 +++---------
 fs/btrfs/extent_io.c |  4 ++--
 fs/btrfs/extent_io.h |  3 +--
 3 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index b05adaf2bb80..2f535e9d816e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -465,8 +465,7 @@ static int btree_read_extent_buffer_pages(struct extent_buffer *eb,
 	io_tree = &BTRFS_I(fs_info->btree_inode)->io_tree;
 	while (1) {
 		clear_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
-		ret = read_extent_buffer_pages(io_tree, eb, WAIT_COMPLETE,
-					       mirror_num);
+		ret = read_extent_buffer_pages(eb, WAIT_COMPLETE, mirror_num);
 		if (!ret) {
 			if (verify_parent_transid(io_tree, eb,
 						   parent_transid, 0))
@@ -1034,15 +1033,13 @@ static const struct address_space_operations btree_aops = {
 void readahead_tree_block(struct btrfs_fs_info *fs_info, u64 bytenr)
 {
 	struct extent_buffer *buf = NULL;
-	struct inode *btree_inode = fs_info->btree_inode;
 	int ret;
 
 	buf = btrfs_find_create_tree_block(fs_info, bytenr);
 	if (IS_ERR(buf))
 		return;
 
-	ret = read_extent_buffer_pages(&BTRFS_I(btree_inode)->io_tree, buf,
-			WAIT_NONE, 0);
+	ret = read_extent_buffer_pages(buf, WAIT_NONE, 0);
 	if (ret < 0)
 		free_extent_buffer_stale(buf);
 	else
@@ -1053,8 +1050,6 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 			 int mirror_num, struct extent_buffer **eb)
 {
 	struct extent_buffer *buf = NULL;
-	struct inode *btree_inode = fs_info->btree_inode;
-	struct extent_io_tree *io_tree = &BTRFS_I(btree_inode)->io_tree;
 	int ret;
 
 	buf = btrfs_find_create_tree_block(fs_info, bytenr);
@@ -1063,8 +1058,7 @@ int reada_tree_block_flagged(struct btrfs_fs_info *fs_info, u64 bytenr,
 
 	set_bit(EXTENT_BUFFER_READAHEAD, &buf->bflags);
 
-	ret = read_extent_buffer_pages(io_tree, buf, WAIT_PAGE_LOCK,
-				       mirror_num);
+	ret = read_extent_buffer_pages(buf, WAIT_PAGE_LOCK, mirror_num);
 	if (ret) {
 		free_extent_buffer_stale(buf);
 		return ret;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 828708f6510c..048d6c6fe7b9 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5330,8 +5330,7 @@ void set_extent_buffer_uptodate(struct extent_buffer *eb)
 	}
 }
 
-int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, int wait, int mirror_num)
+int read_extent_buffer_pages(struct extent_buffer *eb, int wait, int mirror_num)
 {
 	int i;
 	struct page *page;
@@ -5343,6 +5342,7 @@ int read_extent_buffer_pages(struct extent_io_tree *tree,
 	unsigned long num_reads = 0;
 	struct bio *bio = NULL;
 	unsigned long bio_flags = 0;
+	struct extent_io_tree *tree = &BTRFS_I(eb->fs_info->btree_inode)->io_tree;
 
 	if (test_bit(EXTENT_BUFFER_UPTODATE, &eb->bflags))
 		return 0;
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index abafb48947ef..37240e03c4e3 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -433,8 +433,7 @@ void free_extent_buffer_stale(struct extent_buffer *eb);
 #define WAIT_NONE	0
 #define WAIT_COMPLETE	1
 #define WAIT_PAGE_LOCK	2
-int read_extent_buffer_pages(struct extent_io_tree *tree,
-			     struct extent_buffer *eb, int wait,
+int read_extent_buffer_pages(struct extent_buffer *eb, int wait,
 			     int mirror_num);
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb);
 
-- 
2.17.1

