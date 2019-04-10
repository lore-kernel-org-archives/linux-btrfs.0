Return-Path: <SRS0=M5aM=SM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 527FFC10F14
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DEEB20850
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Apr 2019 14:24:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732729AbfDJOYw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Apr 2019 10:24:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:40182 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732673AbfDJOYs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Apr 2019 10:24:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4EB5FAFF2
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Apr 2019 14:24:47 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 6/6] btrfs: Remove bio_offset argument from submit_bio_hook
Date:   Wed, 10 Apr 2019 17:24:43 +0300
Message-Id: <20190410142443.6470-7-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190410142443.6470-1-nborisov@suse.com>
References: <20190410142443.6470-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

None of the implementers of the submit_bio_hook use the bio_offset
parameter, simply remove it. No functional changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/disk-io.c   | 4 ++--
 fs/btrfs/extent_io.c | 6 ++----
 fs/btrfs/extent_io.h | 3 +--
 fs/btrfs/inode.c     | 5 +++--
 4 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index ee9e03b8aae3..0a7897adc58f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -885,8 +885,8 @@ static int check_async_write(struct btrfs_inode *bi)
 }
 
 static blk_status_t btree_submit_bio_hook(struct inode *inode, struct bio *bio,
-					  int mirror_num, unsigned long bio_flags,
-					  u64 bio_offset)
+					  int mirror_num,
+					  unsigned long bio_flags)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	int async = check_async_write(BTRFS_I(inode));
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 048d6c6fe7b9..61191156ee2b 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -152,16 +152,14 @@ static int __must_check submit_one_bio(struct bio *bio, int mirror_num,
 	struct bio_vec *bvec = bio_last_bvec_all(bio);
 	struct bio_vec bv;
 	struct extent_io_tree *tree = bio->bi_private;
-	u64 start;
 
 	mp_bvec_last_segment(bvec, &bv);
-	start = page_offset(bv.bv_page) + bv.bv_offset;
 
 	bio->bi_private = NULL;
 
 	if (tree->ops)
 		ret = tree->ops->submit_bio_hook(tree->private_data, bio,
-					   mirror_num, bio_flags, start);
+						 mirror_num, bio_flags);
 	else
 		btrfsic_submit_bio(bio);
 
@@ -2546,7 +2544,7 @@ static int bio_readpage_error(struct bio *failed_bio, u64 phy_offset,
 		read_mode, failrec->this_mirror, failrec->in_validation);
 
 	status = tree->ops->submit_bio_hook(tree->private_data, bio, failrec->this_mirror,
-					 failrec->bio_flags, 0);
+					 failrec->bio_flags);
 	if (status) {
 		free_io_failure(failure_tree, tree, failrec);
 		bio_put(bio);
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 37240e03c4e3..aa18a16a6ed7 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -105,8 +105,7 @@ struct extent_io_ops {
 	 * pointer will be called unconditionally.
 	 */
 	blk_status_t (*submit_bio_hook)(struct inode *inode, struct bio *bio,
-					int mirror_num, unsigned long bio_flags,
-					u64 bio_offset);
+					int mirror_num, unsigned long bio_flags);
 	int (*readpage_end_io_hook)(struct btrfs_io_bio *io_bio, u64 phy_offset,
 				    struct page *page, u64 start, u64 end,
 				    int mirror);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6e5f1afa7407..476111d44021 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1954,8 +1954,9 @@ static blk_status_t btrfs_submit_bio_start(void *private_data, struct bio *bio,
  *    c-3) otherwise:			async submit
  */
 static blk_status_t btrfs_submit_bio_hook(struct inode *inode, struct bio *bio,
-				 int mirror_num, unsigned long bio_flags,
-				 u64 bio_offset)
+					  int mirror_num,
+					  unsigned long bio_flags)
+
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
-- 
2.17.1

