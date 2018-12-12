Return-Path: <SRS0=l3pb=OV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE6CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355BB2084E
	for <linux-btrfs@archiver.kernel.org>; Wed, 12 Dec 2018 07:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 355BB2084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbeLLHbV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 12 Dec 2018 02:31:21 -0500
Received: from mx2.suse.de ([195.135.220.15]:39666 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726603AbeLLHbV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Dec 2018 02:31:21 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6ECB9ADDD
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Dec 2018 07:31:19 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: [PATCH v2 2/8] btrfs: extent-tree: Open-code process_func in __btrfs_mod_ref
Date:   Wed, 12 Dec 2018 15:30:56 +0800
Message-Id: <20181212073102.7736-3-wqu@suse.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181212073102.7736-1-wqu@suse.com>
References: <20181212073102.7736-1-wqu@suse.com>
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
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/extent-tree.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 6cf4070fd45f..9fb922d2f8f6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3217,10 +3217,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 	int i;
 	int level;
 	int ret = 0;
-	int (*process_func)(struct btrfs_trans_handle *,
-			    struct btrfs_root *,
-			    u64, u64, u64, u64, u64, u64);
-
 
 	if (btrfs_is_testing(fs_info))
 		return 0;
@@ -3232,11 +3228,6 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
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
@@ -3258,16 +3249,27 @@ static int __btrfs_mod_ref(struct btrfs_trans_handle *trans,
 
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
2.19.2

