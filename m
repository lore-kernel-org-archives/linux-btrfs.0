Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AF1C4360F
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49E9B20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730424AbfCYSp4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:39126 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730422AbfCYSpy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AB71BAF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 20BCADA98F; Mon, 25 Mar 2019 19:47:07 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 23/30] btrfs: get fs_info from eb in btrfs_check_leaf_full
Date:   Mon, 25 Mar 2019 19:47:07 +0100
Message-Id: <14eac2aa61ebaaf4962ae542d1dea4760de2388d.1553539114.git.dsterba@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1553539114.git.dsterba@suse.com>
References: <cover.1553539114.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

We can read fs_info from extent buffer and can drop it from the
parameters.

Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/disk-io.c      | 2 +-
 fs/btrfs/tree-checker.c | 3 +--
 fs/btrfs/tree-checker.h | 3 +--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 496b00a78a24..eb7323e40006 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -665,7 +665,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 	 * that we don't try and read the other copies of this block, just
 	 * return -EIO.
 	 */
-	if (found_level == 0 && btrfs_check_leaf_full(fs_info, eb)) {
+	if (found_level == 0 && btrfs_check_leaf_full(eb)) {
 		set_bit(EXTENT_BUFFER_CORRUPT, &eb->bflags);
 		ret = -EIO;
 	}
diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index dd37d23ae8ba..271694a479fd 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -641,8 +641,7 @@ static int check_leaf(struct extent_buffer *leaf, bool check_item_data,
 	return 0;
 }
 
-int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
-			  struct extent_buffer *leaf)
+int btrfs_check_leaf_full(struct extent_buffer *leaf)
 {
 	return check_leaf(leaf, true, true);
 }
diff --git a/fs/btrfs/tree-checker.h b/fs/btrfs/tree-checker.h
index d3216cf6c521..d190ada1a58d 100644
--- a/fs/btrfs/tree-checker.h
+++ b/fs/btrfs/tree-checker.h
@@ -14,8 +14,7 @@
  * Will check not only the item pointers, but also every possible member
  * in item data.
  */
-int btrfs_check_leaf_full(struct btrfs_fs_info *fs_info,
-			  struct extent_buffer *leaf);
+int btrfs_check_leaf_full(struct extent_buffer *leaf);
 
 /*
  * Less strict leaf checker.
-- 
2.21.0

