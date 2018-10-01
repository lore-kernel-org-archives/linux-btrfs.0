Return-Path: <SRS0=adn4=MN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C717CC43143
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9682420C0A
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Oct 2018 14:46:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9682420C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729570AbeJAVYp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Oct 2018 17:24:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42372 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729526AbeJAVYi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Oct 2018 17:24:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 37C57AF51
        for <linux-btrfs@vger.kernel.org>; Mon,  1 Oct 2018 14:46:27 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 06/10] btrfs-progs: Hook FST code in extent (de)alloc
Date:   Mon,  1 Oct 2018 17:46:17 +0300
Message-Id: <1538405181-25231-7-git-send-email-nborisov@suse.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1538405181-25231-1-git-send-email-nborisov@suse.com>
References: <1538405181-25231-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For now this doesn't change the functionality since FST code is not
yet enabled via the compat bits. But this will be needed when it's
enabled so that the FST is correctly modified during repair operations
that allocate/deallocate  extents.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 extent-tree.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/extent-tree.c b/extent-tree.c
index b9a30644720b..7adda557f8e6 100644
--- a/extent-tree.c
+++ b/extent-tree.c
@@ -29,6 +29,7 @@
 #include "crc32c.h"
 #include "volumes.h"
 #include "free-space-cache.h"
+#include "free-space-tree.h"
 #include "utils.h"
 
 #define PENDING_EXTENT_INSERT 0
@@ -2276,6 +2277,11 @@ static int __free_extent(struct btrfs_trans_handle *trans,
 			BUG_ON(ret);
 		}
 
+		ret = add_to_free_space_tree(trans, bytenr, num_bytes);
+		if (ret) {
+			goto fail;
+		}
+
 		update_block_group(trans->fs_info, bytenr, num_bytes, 0,
 				   mark_free);
 	}
@@ -2595,6 +2601,11 @@ static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
 	btrfs_mark_buffer_dirty(leaf);
 	btrfs_free_path(path);
 
+	ret = remove_from_free_space_tree(trans, ins.objectid,
+					  fs_info->nodesize);
+	if (ret)
+		return ret;
+
 	ret = update_block_group(fs_info, ins.objectid, fs_info->nodesize, 1,
 				 0);
 
-- 
2.7.4

