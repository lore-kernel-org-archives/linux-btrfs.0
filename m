Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8172AC10F11
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 509DF20850
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbfDJOYu (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:24:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:40176 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732719AbfDJOYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 11B9DAEFF
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:24:47 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 2/6] btrfs: Change submit_bio_hook to taking an inode directly
Date:   Wed, 10 Apr 2019 17:24:39 +0300
Message-Id: <20190410142443.6470-3-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190410142443.6470-1-nborisov@suse.com>
References: <20190410142443.6470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The only possible 'private_data' that is passed to this function is
actually an inode. Make that explicit by changing the signature of the
call back. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c   | 5 ++---
 fs/btrfs/extent_io.h | 2 +-
 fs/btrfs/inode.c     | 3 +--
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 31bdedfb7490..b05adaf2bb80 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -885,11 +885,10 @@ static int check_async_write(struct btrfs_inode *bi)
 	return 1;
 }
 
-static blk_status_t btree_submit_bio_hook(void *private_data, struct bio *bio,
+static blk_status_t btree_submit_bio_hook(struct inode *inode, struct bio *bio,
 					  int mirror_num, unsigned long bio_flags,
 					  u64 bio_offset)
 {
-	struct inode *inode = private_data;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	int async = check_async_write(BTRFS_I(inode));
 	blk_status_t ret;
@@ -915,7 +914,7 @@ static blk_status_t btree_submit_bio_hook(void *private_data, struct bio *bio,
 		 * checksumming can happen in parallel across all CPUs
 		 */
 		ret = btrfs_wq_submit_bio(fs_info, bio, mirror_num, 0,
-					  bio_offset, private_data,
+					  bio_offset, inode,
 					  btree_submit_bio_start);
 	}
 
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 79bd20cf4226..abafb48947ef 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -104,7 +104,7 @@ struct extent_io_ops {
 	 * The following callbacks must be always defined, the function
 	 * pointer will be called unconditionally.
 	 */
-	blk_status_t (*submit_bio_hook)(void *private_data, struct bio *bio,
+	blk_status_t (*submit_bio_hook)(struct inode *inode, struct bio *bio,
 					int mirror_num, unsigned long bio_flags,
 					u64 bio_offset);
 	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 4e2f9f66bf59..07cf7050c99f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1953,11 +1953,10 @@ static blk_status_t btrfs_submit_bio_start(void *private_data, struct bio *bio,
  *
  *    c-3) otherwise:			async submit
  */
-static blk_status_t btrfs_submit_bio_hook(void *private_data, struct bio *bio,
+static blk_status_t btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
 				 int mirror_num, unsigned long bio_flags,
 				 u64 bio_offset)
 {
-	struct inode *inode = private_data;
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	enum btrfs_wq_endio_type metadata = BTRFS_WQ_ENDIO_DATA;
-- 
2.17.1

