Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19FEC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2A520878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 06:59:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D2A520878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbeLFG7M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 01:59:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:59430 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbeLFG7M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 01:59:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E3C63AE98
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 06:59:10 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH 2/8] btrfs: extent-tree: Open-code process_func in __btrfs_mod_ref
Date:   Thu,  6 Dec 2018 14:58:57 +0800
Message-Id: <20181206065903.11343-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181206065903.11343-1-wqu@suse.com>
References: <20181206065903.11343-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

The process_func is never a function hook used anywhere else.

Open code it to make later delayed ref refactor easier, so we can
refactor btrfs_inc_extent_ref() and btrfs_free_extent() in different
patches.

Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 fs/btrfs/extent-tree.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index ea2c3d5220f0..ea68d288d761 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3220,10 +3220,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int i;
 	int level;
 	int ret = 0;
-	int (*process_func)(struct btrfs_trans_handle *,
-			    struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64, bool);
-
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
@@ -3235,11 +3231,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
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
@@ -3261,17 +3252,29 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 
 			num_bytes = btrfs_file_extent_disk_num_bytes(buf, fi);
 			key.offset -= btrfs_file_extent_offset(buf, fi);
-			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, key.objectid,
-					   key.offset, for_reloc);
+			if (inc)
+				ret = btrfs_inc_extent_ref(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						key.objectid, key.offset,
+						for_reloc);
+			else
+				ret = btrfs_free_extent(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						key.objectid, key.offset,
+						for_reloc);
 			if (ret)
 				goto fail;
 		} else {
 			bytenr = btrfs_node_blockptr(buf, i);
 			num_bytes = fs_info->nodesize;
-			ret = process_func(trans, root, bytenr, num_bytes,
-					   parent, ref_root, level - 1, 0,
-					   for_reloc);
+			if (inc)
+				ret = btrfs_inc_extent_ref(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						level - 1, 0, for_reloc);
+			else
+				ret = btrfs_free_extent(trans, root, bytenr,
+						num_bytes, parent, ref_root,
+						level - 1, 0, for_reloc);
 			if (ret)
 				goto fail;
 		}
-- 
2.19.2

