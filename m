Return-Path: <SRS0=iUkD=SG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11FA0C4360F
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4CF5206DF
	for <linux-btrfs@archiver.kernel.org>; Thu,  4 Apr 2019 06:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfDDGp6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:45:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:36414 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfDDGp5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 4 Apr 2019 02:45:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D9F34AE7D
        for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2019 06:45:56 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH v3.1 2/9] btrfs: extent-tree: Open-code process_func in __btrfs_mod_ref
Date:   Thu,  4 Apr 2019 14:45:30 +0800
Message-Id: <20190404064537.4031-3-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190404064537.4031-1-wqu@suse.com>
References: <20190404064537.4031-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The process_func function pointer is local to __btrfs_mod_ref() and
points to either btrfs_inc_extent_ref() or btrfs_free_extent().

Open code it to make later delayed ref refactor easier, so we can
refactor btrfs_inc_extent_ref() and btrfs_free_extent() in different
patches.

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 fs/btrfs/extent-tree.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 15770ae7ec15..b0a0c648151b 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3242,10 +3242,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int i;
 	int level;
 	int ret = 0;
-	int (*process_func)(struct btrfs_trans_handle *,
-			    struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64);
-
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
@@ -3257,11 +3253,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	if (!test_bit(BTRFS_ROOT_REF_COWS, &root->state) && level == 0)
 		return 0;
 
-	if (inc)
-		process_func = btrfs_inc_extent_ref;
-	else
-		process_func = btrfs_free_extent;
-
 	if (full_backref)
 		parent = buf->start;
 	else
@@ -3283,16 +3274,27 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
 			key.offset -= btrfs_file_extent_offset(buf, fi);
-			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, key.objectid,
-					   key.offset);
+			if (inc)
+				ret = btrfs_inc_extent_ref(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						key.objectid, key.offset);
+			else
+				ret = btrfs_free_extent(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						key.objectid, key.offset);
 			if (ret)
 				goto fail;
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = fs_info->nodesize;
-			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, level - 1, 0);
+			if (inc)
+				ret = btrfs_inc_extent_ref(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						level - 1, 0);
+			else
+				ret = btrfs_free_extent(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						level - 1, 0);
 			if (ret)
 				goto fail;
 		}
-- 
2.21.0

