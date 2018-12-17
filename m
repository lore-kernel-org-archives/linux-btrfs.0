Return-Path: <SRS0=1mW1=O2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D97C43444
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 644182086C
	for <linux-btrfs@archiver.kernel.org>; Mon, 17 Dec 2018 08:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbeLQIgJ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 17 Dec 2018 03:36:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:56830 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731833AbeLQIgI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 17 Dec 2018 03:36:08 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D4C4EAC3A
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2018 08:36:06 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/4] btrfs: Refactor retval handling of btrfs_lookup_file_extent in btrfs_get_extent
Date:   Mon, 17 Dec 2018 10:36:01 +0200
Message-Id: <20181217083602.10166-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20181217083602.10166-1-nborisov@suse.com>
References: <20181217083602.10166-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The code which executes if path->slots[0] points to an item not
belonging to the inode we are interested in or is not na extent at all
could really trigger if btrfs_lookup_file_extent returned > 0 and
subsequently path->slots[0] was decremented. Make this explicit by
moving the respective code in the correct if branch. No functional
changes.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 511d3b314af2..e8284cd0a122 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -6805,22 +6805,26 @@ struct extent_map *btrfs_get_extent(struct btrfs_inode *inode,
 		if (path->slots[0] == 0)
 			goto not_found;
 		path->slots[0]--;
-	}
-
-	leaf = path->nodes[0];
-	item = btrfs_item_ptr(leaf, path->slots[0],
-			      struct btrfs_file_extent_item);
-	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
-	if (found_key.objectid != objectid ||
-	    found_key.type != BTRFS_EXTENT_DATA_KEY) {
-		/*
-		 * If we backup past the first extent we want to move forward
-		 * and see if there is an extent in front of us, otherwise we'll
-		 * say there is a hole for our whole search range which can
-		 * cause problems.
-		 */
-		extent_end = start;
-		goto next;
+		leaf = path->nodes[0];
+		item = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_file_extent_item);
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
+		if (found_key.objectid != objectid ||
+		    found_key.type != BTRFS_EXTENT_DATA_KEY) {
+			/*
+			 * If we backup past the first extent we want to move
+			 * forward and see if there is an extent in front of us,
+			 * otherwise we'll say there is a hole for our whole
+			 * search range which can cause problems.
+			 */
+			extent_end = start;
+			goto next;
+		}
+	} else {
+		leaf = path->nodes[0];
+		item = btrfs_item_ptr(leaf, path->slots[0],
+				      struct btrfs_file_extent_item);
+		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
 	}
 
 	extent_type = btrfs_file_extent_type(leaf, item);
-- 
2.17.1

