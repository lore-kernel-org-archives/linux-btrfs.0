Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA9DFC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9145120700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbfCYSpg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:39030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730294AbfCYSpg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 009F4AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 69F6EDA98F; Mon, 25 Mar 2019 19:46:48 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 15/30] btrfs: tree-checker: get fs_info from eb in check_csum_item
Date:   Mon, 25 Mar 2019 19:46:48 +0100
Message-Id: <9aefab543bbdf58e08e734800905cb53bb35e252.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/tree-checker.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index c2a08491d0d1..8d6110fafcb4 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -188,10 +188,10 @@ static int check_extent_data_item(struct btrfs_fs_info *fs_info,
 	return 0;
 }
 
-static int check_csum_item(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *leaf, struct btrfs_key *key,
+static int check_csum_item(struct extent_buffer *leaf, struct btrfs_key *key,
 			   int slot)
 {
+	struct btrfs_fs_info *fs_info = leaf->fs_info;
 	u32 sectorsize = fs_info->sectorsize;
 	u32 csumsize = btrfs_super_csum_size(fs_info->super_copy);
 
@@ -462,7 +462,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 		ret = check_extent_data_item(fs_info, leaf, key, slot);
 		break;
 	case BTRFS_EXTENT_CSUM_KEY:
-		ret = check_csum_item(fs_info, leaf, key, slot);
+		ret = check_csum_item(leaf, key, slot);
 		break;
 	case BTRFS_DIR_ITEM_KEY:
 	case BTRFS_DIR_INDEX_KEY:
-- 
2.21.0

