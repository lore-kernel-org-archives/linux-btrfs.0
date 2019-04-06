Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9B7C282CE
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 03:13:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD6C72173C
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 03:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbfDFDNw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Apr 2019 23:13:52 -0400
Received: from mx2.suse.de ([195.135.220.15]:58912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbfDFDNw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Apr 2019 23:13:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 683B9B001
        for <linux-btrfs@vger.kernel.org>; Sat,  6 Apr 2019 03:13:51 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: Record error in btree_csum_one_bio()
Date:   Sat,  6 Apr 2019 11:13:46 +0800
Message-Id: <20190406031346.22365-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Since commit 6dc4f100c175 ("block: allow bio_for_each_segment_all() to
iterate over multi-page bvec"), break will only break the inner loop of
bio_for_each_segment_all(), unable to break the outer loop.

So here we add a new variable @err to record the first error we hit, and
return the error, so that write time checker can work as designed.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/disk-io.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 6fe9197f6ee4..9e4d129bb649 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -832,18 +832,18 @@ static blk_status_t btree_csum_one_bio(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	struct btrfs_root *root;
-	int i, ret = 0;
+	int i, ret = 0, err = 0;
 	struct bvec_iter_all iter_all;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
 	bio_for_each_segment_all(bvec, bio, i, iter_all) {
 		root = BTRFS_I(bvec->bv_page->mapping->host)->root;
 		ret = csum_dirty_buffer(root->fs_info, bvec->bv_page);
-		if (ret)
-			break;
+		if (ret && !err)
+			err = ret;
 	}
 
-	return errno_to_blk_status(ret);
+	return errno_to_blk_status(err);
 }
 
 static blk_status_t btree_submit_bio_start(void *private_data, struct bio *bio,
-- 
2.21.0

