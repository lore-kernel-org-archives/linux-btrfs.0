Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF20C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B21220700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730137AbfCYSpQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:38928 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfCYSpP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3F348AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:14 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 85065DA98F; Mon, 25 Mar 2019 19:46:27 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 06/30] btrfs: get fs_info from eb in check_tree_block_fsid
Date:   Mon, 25 Mar 2019 19:46:27 +0100
Message-Id: <73dc46c869908d2ab73c95140e74e867d3bdc551.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/disk-io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index db0ed25999fd..b7d512e5f4a1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -552,9 +552,9 @@ static int csum_dirty_buffer(struct btrfs_fs_info *fs_info, struct page *page)
 	return 0;
 }
 
-static int check_tree_block_fsid(struct btrfs_fs_info *fs_info,
-				 struct extent_buffer *eb)
+static int check_tree_block_fsid(struct extent_buffer *eb)
 {
+	struct btrfs_fs_info *fs_info = eb->fs_info;
 	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
 	u8 fsid[BTRFS_FSID_SIZE];
 	int ret = 1;
@@ -624,7 +624,7 @@ static int btree_readpage_end_io_hook(struct btrfs_io_bio *io_bio,
 		ret = -EIO;
 		goto err;
 	}
-	if (check_tree_block_fsid(fs_info, eb)) {
+	if (check_tree_block_fsid(eb)) {
 		btrfs_err_rl(fs_info, "bad fsid on block %llu",
 			     eb->start);
 		ret = -EIO;
-- 
2.21.0

