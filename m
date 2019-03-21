Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF2FC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 19:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BA4E2175B
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 19:19:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfCUTTz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:19:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:42104 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728249AbfCUTTz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 15:19:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DAD3CAE7F
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 19:19:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CD21FDA83C; Thu, 21 Mar 2019 20:21:08 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH] btrfs: move tree block wait and write helpers to tree-log
Date:   Thu, 21 Mar 2019 20:21:05 +0100
Message-Id: <20190321192105.11288-1-dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The wrapper names better describe what's happening so they're not
deleted though they're trivial, but at least moved closer to their place
of use.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c  | 13 -------------
 fs/btrfs/disk-io.h  |  2 --
 fs/btrfs/tree-log.c | 11 +++++++++++
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5216e7b3f9ad..8329041e1c72 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1067,19 +1067,6 @@ struct extent_buffer *btrfs_find_create_tree_block(
 	return alloc_extent_buffer(fs_info, bytenr);
 }
 
-
-int btrfs_write_tree_block(struct extent_buffer *buf)
-{
-	return filemap_fdatawrite_range(buf->pages[0]->mapping, buf->start,
-					buf->start + buf->len - 1);
-}
-
-void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
-{
-	filemap_fdatawait_range(buf->pages[0]->mapping,
-			        buf->start, buf->start + buf->len - 1);
-}
-
 /*
  * Read tree block at logical address @bytenr and do variant basic but critical
  * verification.
diff --git a/fs/btrfs/disk-io.h b/fs/btrfs/disk-io.h
index 987a64bc0c66..0a893008d4f6 100644
--- a/fs/btrfs/disk-io.h
+++ b/fs/btrfs/disk-io.h
@@ -123,8 +123,6 @@ blk_status_t btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct bio *bio,
 			extent_submit_bio_start_t *submit_bio_start);
 blk_status_t btrfs_submit_bio_done(void *private_data, struct bio *bio,
 			  int mirror_num);
-int btrfs_write_tree_block(struct extent_buffer *buf);
-void btrfs_wait_tree_block_writeback(struct extent_buffer *buf);
 int btrfs_init_log_root_tree(struct btrfs_trans_handle *trans,
 			     struct btrfs_fs_info *fs_info);
 int btrfs_add_log_tree(struct btrfs_trans_handle *trans,
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index f06454a55e00..395f03db232d 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -225,6 +225,17 @@ void btrfs_end_log_trans(struct btrfs_root *root)
 	}
 }
 
+static int btrfs_write_tree_block(struct extent_buffer *buf)
+{
+	return filemap_fdatawrite_range(buf->pages[0]->mapping, buf->start,
+					buf->start + buf->len - 1);
+}
+
+static void btrfs_wait_tree_block_writeback(struct extent_buffer *buf)
+{
+	filemap_fdatawait_range(buf->pages[0]->mapping,
+			        buf->start, buf->start + buf->len - 1);
+}
 
 /*
  * the walk control struct is used to pass state down the chain when
-- 
2.21.0

