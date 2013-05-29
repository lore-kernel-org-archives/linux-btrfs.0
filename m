Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38195 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965896Ab3E2NJ6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 09:09:58 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8781D7C041B
	for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 07:09:58 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id E5xo4VH5dtP9xsYu (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Wed, 29 May 2013 07:09:58 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: fix free space cache checks
Date: Wed, 29 May 2013 09:09:55 -0400
Message-ID: <1369832995-2935-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This fixes two bugs with the free space cache checker.  First is we apparently
always use root->sectorsize for our unit in the kernel so we have to do that in
progs otherwise bitmaps turn out to not look right if we have leafsize !=
sectorsize.  The second is a small issue if we had skinny metadata extents set,
we wouldn't advance last properly because we unconditionally use key.offset
instead of root->leafsize.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 7bb68ce..288b36e 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -2853,7 +2853,10 @@ static int verify_space_cache(struct btrfs_root *root,
 		}
 
 		if (last == key.objectid) {
-			last = key.objectid + key.offset;
+			if (key.type == BTRFS_EXTENT_ITEM_KEY)
+				last = key.objectid + key.offset;
+			else
+				last = key.objectid + root->leafsize;
 			path->slots[0]++;
 			continue;
 		}
@@ -2906,15 +2909,8 @@ static int check_space_cache(struct btrfs_root *root)
 
 		start = cache->key.objectid + cache->key.offset;
 		if (!cache->free_space_ctl) {
-			int sectorsize;
-
-			if (cache->flags & (BTRFS_BLOCK_GROUP_METADATA |
-					    BTRFS_BLOCK_GROUP_SYSTEM))
-				sectorsize = root->leafsize;
-			else
-				sectorsize = root->sectorsize;
-
-			if (btrfs_init_free_space_ctl(cache, sectorsize)) {
+			if (btrfs_init_free_space_ctl(cache,
+						      root->sectorsize)) {
 				ret = -ENOMEM;
 				break;
 			}
-- 
1.7.7.6

