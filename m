Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2111C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:16:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A003920672
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 16:16:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A003920672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436795AbeKWC5A (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 21:57:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:57928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730352AbeKWC47 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 21:56:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8CACEAD17
        for <linux-btrfs@vger.kernel.org>; Thu, 22 Nov 2018 16:16:56 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 48D7FDA829; Thu, 22 Nov 2018 17:16:42 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 1/4] btrfs: merge btrfs_submit_bio_done to its caller
Date:   Thu, 22 Nov 2018 17:16:42 +0100
Message-Id: <8a765283a6ba9c2eb3f2a61c41d5246a984e583b.1542902890.git.dsterba@suse.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1542902890.git.dsterba@suse.com>
References: <cover.1542902890.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There's one caller and its code is simple, we can open code it in
run_one_async_done. The errors are passed through bio.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c | 18 +++++++++++++++++-
 fs/btrfs/inode.c   | 23 -----------------------
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index feb67dfd663d..2f5c5442cf00 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -764,11 +764,22 @@ static void run_one_async_start(struct btrfs_work *work)
 		async->status = ret;
 }
 
+/*
+ * In order to insert checksums into the metadata in large chunks, we wait
+ * until bio submission time.   All the pages in the bio are checksummed and
+ * sums are attached onto the ordered extent record.
+ *
+ * At IO completion time the csums attached on the ordered extent record are
+ * inserted into the tree.
+ */
 static void run_one_async_done(struct btrfs_work *work)
 {
 	struct async_submit_bio *async;
+	struct inode *inode;
+	blk_status_t ret;
 
 	async = container_of(work, struct  async_submit_bio, work);
+	inode = async->private_data;
 
 	/* If an error occurred we just want to clean up the bio and move on */
 	if (async->status) {
@@ -777,7 +788,12 @@ static void run_one_async_done(struct btrfs_work *work)
 		return;
 	}
 
-	btrfs_submit_bio_done(async->private_data, async->bio, async->mirror_num);
+	ret = btrfs_map_bio(btrfs_sb(inode->i_sb), async->bio,
+			async->mirror_num, 1);
+	if (ret) {
+		async->bio->bi_status = ret;
+		bio_endio(async->bio);
+	}
 }
 
 static void run_one_async_free(struct btrfs_work *work)
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 9becf8543489..a88122b89f50 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1924,29 +1924,6 @@ static blk_status_t btrfs_submit_bio_start(void *private_data, struct bio *bio,
 	return 0;
 }
 
-/*
- * in order to insert checksums into the metadata in large chunks,
- * we wait until bio submission time.   All the pages in the bio are
- * checksummed and sums are attached onto the ordered extent record.
- *
- * At IO completion time the cums attached on the ordered extent record
- * are inserted into the btree
- */
-blk_status_t btrfs_submit_bio_done(void *private_data, struct bio *bio,
-			  int mirror_num)
-{
-	struct inode *inode = private_data;
-	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
-	blk_status_t ret;
-
-	ret = btrfs_map_bio(fs_info, bio, mirror_num, 1);
-	if (ret) {
-		bio->bi_status = ret;
-		bio_endio(bio);
-	}
-	return ret;
-}
-
 /*
  * extent_io.c submission hook. This does the right thing for csum calculation
  * on write, or reading the csums from the tree before a read.
-- 
2.19.1

