Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBC2C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAAEE20700
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 18:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfCYSpq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 14:45:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:39074 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730267AbfCYSpp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 14:45:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 686ABAF94
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Mar 2019 18:45:44 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CEAABDA98F; Mon, 25 Mar 2019 19:46:57 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>
Subject: [PATCH 19/30] btrfs: tree-checker: get fs_info from eb in check_block_group_item
Date:   Mon, 25 Mar 2019 19:46:57 +0100
Message-Id: <b698df069488ea692b29fc28f92858dfab5636ea.1553539114.git.dsterba@suse.com>
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
index 1bf8b67dbf57..352d7ccf46aa 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -378,8 +378,7 @@ static void block_group_err(const struct extent_buffer *eb, int slot,
 	va_end(args);
 }
 
-static int check_block_group_item(struct btrfs_fs_info *fs_info,
-				  struct extent_buffer *leaf,
+static int check_block_group_item(struct extent_buffer *leaf,
 				  struct btrfs_key *key, int slot)
 {
 	struct btrfs_block_group_item bgi;
@@ -470,7 +469,7 @@ static int check_leaf_item(struct btrfs_fs_info *fs_info,
 		ret = check_dir_item(leaf, key, slot);
 		break;
 	case BTRFS_BLOCK_GROUP_ITEM_KEY:
-		ret = check_block_group_item(fs_info, leaf, key, slot);
+		ret = check_block_group_item(leaf, key, slot);
 		break;
 	}
 	return ret;
-- 
2.21.0

