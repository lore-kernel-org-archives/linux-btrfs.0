Return-Path: <SRS0=Imwo=WB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19328C0650F
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Aug 2019 14:47:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E3C4D20644
	for <linux-btrfs@archiver.kernel.org>; Mon,  5 Aug 2019 14:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbfHEOrN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 5 Aug 2019 10:47:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:48270 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728764AbfHEOrM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Aug 2019 10:47:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC273AFBB
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Aug 2019 14:47:11 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH 3/6] btrfs: Simplify run_delalloc_nocow
Date:   Mon,  5 Aug 2019 17:47:05 +0300
Message-Id: <20190805144708.5432-4-nborisov@suse.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805144708.5432-1-nborisov@suse.com>
References: <20190805144708.5432-1-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

There is no point in checking the type of the extent again just to se
the 'type' variable, when this check has already been performed before.
Instead, extend the original if branch with an 'else' clause. This
allows to remove one local variable and make it obvious how the code
flow differs for prealloc/regular extents.

Signed-off-by: Nikolay Borisov <nborisov@suse.com>
---
 fs/btrfs/inode.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index aa5e017e31ab..49db8090e62f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1336,7 +1336,6 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 		u64 disk_bytenr = 0;
 		u64 num_bytes = 0;
 		u64 disk_num_bytes;
-		int type;
 		u64 ram_bytes;
 		int extent_type;
 		bool nocow = false;
@@ -1572,16 +1571,17 @@ static noinline int run_delalloc_nocow(struct inode *inode,
 				goto error;
 			}
 			free_extent_map(em);
-		}
-
-		if (extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
-			type = BTRFS_ORDERED_PREALLOC;
+			ret = btrfs_add_ordered_extent(inode, cur_offset,
+						       disk_bytenr, num_bytes,
+						       num_bytes,
+						       BTRFS_ORDERED_PREALLOC);
 		} else {
-			type = BTRFS_ORDERED_NOCOW;
+			ret = btrfs_add_ordered_extent(inode, cur_offset,
+						       disk_bytenr, num_bytes,
+						       num_bytes,
+						       BTRFS_ORDERED_NOCOW);
 		}
 
-		ret = btrfs_add_ordered_extent(inode, cur_offset, disk_bytenr,
-					       num_bytes, num_bytes,type);
 		if (nocow)
 			btrfs_dec_nocow_writers(fs_info, disk_bytenr);
 		BUG_ON(ret); /* -ENOMEM */
-- 
2.17.1

