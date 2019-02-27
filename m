Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E98C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFC4021852
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 06:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbfB0GGI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 01:06:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:33990 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbfB0GGH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 01:06:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CEBDAAC5F;
        Wed, 27 Feb 2019 06:06:06 +0000 (UTC)
From:   Qu Wenruo <wqu@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: [PATCH v1.1 01/14] btrfs-progs: lowmem: fix false alert about the existence of gaps in the check_file_extent
Date:   Wed, 27 Feb 2019 14:05:39 +0800
Message-Id: <20190227060552.3841-2-wqu@suse.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190227060552.3841-1-wqu@suse.com>
References: <20190227060552.3841-1-wqu@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

The 'end' parameter of check_file_extent tracks the ending offset of the
last checked extent. This is used to detect gaps between adjacent extents.

Currently such gaps are wrongly detected since for regular extents only
the size of the extent is added to the 'end' parameter. This results in
wrongly considering all extents of a file as having gaps between them
when only 2 of them really have a gap as seen in the example below.

Solution:
The extent_end variable should set to the sum of the offset and the
extent_num_bytes of the file extent.

Example:
Suppose that lowmem check the following file extent of inode 257.

        item 6 key (257 EXTENT_DATA 0) itemoff 15813 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 7 key (257 EXTENT_DATA 8192) itemoff 15760 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)
        item 8 key (257 EXTENT_DATA 12288) itemoff 15707 itemsize 53
                generation 6 type 1 (regular)
                extent data disk byte 13631488 nr 4096
                extent data offset 0 nr 4096 ram 4096
                extent compression 0 (none)

For inode 257, check_inode_item set extent_end to 0, then call
check_file_extent to check item {6,7,8}.
item 6)
	offset(0) == extent_end(0)
	extent_end = extent_end(0) + extent_num_bytes(4096)
item 7)
	offset(8192) != extent_end(4096)
	extent_end = extent_end(4096) + extent_num_bytes(4096)
			^^^
	The old extent_end should replace by offset(8192).
item 8)
	offset(12288) != extent_end(8192)
		^^^
	But there is no gap between item {7,8}.

Fixes: d88da10ddd42 ("btrfs-progs: check: introduce function to check file extent")
Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
[Move this patch as the 1st patch, since it's an independent fix]
Signed-off-by: Qu Wenruo <wqu@suse.com>
---
 check/mode-lowmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
index fc6228a05a1b..bbda2bb23c65 100644
--- a/check/mode-lowmem.c
+++ b/check/mode-lowmem.c
@@ -2039,7 +2039,7 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
 		}
 	}
 
-	*end += extent_num_bytes;
+	*end = fkey.offset + extent_num_bytes;
 	if (!is_hole)
 		*size += extent_num_bytes;
 
-- 
2.21.0

