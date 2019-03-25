Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74175C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 536B220700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbfCYSpv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:39096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730267AbfCYSpu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 15C86AF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7EF34DA98F; Mon, 25 Mar 2019 19:47:02 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 21/30] btrfs: tree-checker: get fs_info from eb in check_leaf_item
Date:   Mon, 25 Mar 2019 19:47:02 +0100
Message-Id: <57db70df5bf21a416a57d0ec023611e7d1e9b710.1553539114.git.dsterba@suse.com>
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
 fs/btrfs/tree-checker.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index 12a02bc7717e..0330e2d27afb 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -450,8 +450,7 @@ static int check_block_group_item(struct extent_buffer *leaf,
 /*
  * Common point to switch the item-specific validation.
  */
-static int check_leaf_item(struct btrfs_fs_info *fs_info,
-			   struct extent_buffer *leaf,
+static int check_leaf_item(struct extent_buffer *leaf,
 			   struct btrfs_key *key, int slot)
 {
 	int ret = 0;
@@ -628,7 +627,7 @@ static int check_leaf(struct btrfs_fs_info *fs_info, struct extent_buffer *leaf,
 			 * Check if the item size and content meet other
 			 * criteria
 			 */
-			ret = check_leaf_item(fs_info, leaf, &key, slot);
+			ret = check_leaf_item(leaf, &key, slot);
 			if (ret < 0)
 				return ret;
 		}
-- 
2.21.0

