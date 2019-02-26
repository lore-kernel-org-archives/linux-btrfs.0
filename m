Return-Path: <SRS0=RlhI=RB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF0FC43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 08:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04C292173C
	for <linux-btrfs@archiver.kernel.org>; Tue, 26 Feb 2019 08:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfBZIeD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Feb 2019 03:34:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:48960 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726551AbfBZIeD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Feb 2019 03:34:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6EA56AD8F
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2019 08:34:02 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2] btrfs: Don't panic when we can't find a root key
Date:   Tue, 26 Feb 2019 16:33:56 +0800
Message-Id: <20190226083356.18558-1-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

When we failed to find a root key in btrfs_update_root(), we just panic.

That's definitely not cool, fix it by outputting an unique error
message, aborting current transaction and return -EUCLEAN.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
changelog:
v2:
- Remove the tree leaf dump, as it doesn't help much.
- Change return value to -EUCLEAN to show it's a corruption.
---
 fs/btrfs/root-tree.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 65bda0682928..7f5c98afce25 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -137,11 +137,14 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		goto out;
 	}
 
-	if (ret != 0) {
-		btrfs_print_leaf(path->nodes[0]);
-		btrfs_crit(fs_info, "unable to update root key %llu %u %llu",
-			   key->objectid, key->type, key->offset);
-		BUG_ON(1);
+	if (ret > 0) {
+		btrfs_crit(fs_info,
+			"unable to find root key (%llu %u %llu) in tree %llu",
+			   key->objectid, key->type, key->offset,
+			   root->root_key.objectid);
+		ret = -EUCLEAN;
+		btrfs_abort_transaction(trans, ret);
+		goto out;
 	}
 
 	l = path->nodes[0];
-- 
2.21.0

