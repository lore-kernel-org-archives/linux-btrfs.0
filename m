Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55764 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763552Ab3ECVAz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 17:00:55 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C6AAD7C042F
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 15:00:54 -0600 (MDT)
Received: from mail1.int.fusionio.com ([10.101.1.21]) by mx2.fusionio.com with ESMTP id iXGwj4jy5EpkKWSK (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Fri, 03 May 2013 15:00:54 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs-progs: init free space ctl with proper unit
Date: Fri, 3 May 2013 17:00:52 -0400
Message-ID: <1367614852-15466-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

btrfsck was blowing up when checking the free space cache when we ran xfstests
with -l 64k.  That is because I was init'ing the free space ctl to whatever the
leafsize was, which isn't right for data block groups.  With this patch btrfsck
no longer complains.  This also fixes a tiny little typo in free-space-cache.c I
noticed while figuring this problem out.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 cmds-check.c       |   11 +++++++++--
 free-space-cache.c |    2 --
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/cmds-check.c b/cmds-check.c
index 030ab77..02bfedd 100644
--- a/cmds-check.c
+++ b/cmds-check.c
@@ -3001,8 +3001,15 @@ static int check_space_cache(struct btrfs_root *root)
 
 		start = cache->key.objectid + cache->key.offset;
 		if (!cache->free_space_ctl) {
-			if (btrfs_init_free_space_ctl(cache,
-						      root->leafsize)) {
+			int sectorsize;
+
+			if (cache->flags & (BTRFS_BLOCK_GROUP_METADATA |
+					    BTRFS_BLOCK_GROUP_SYSTEM))
+				sectorsize = root->leafsize;
+			else
+				sectorsize = root->sectorsize;
+
+			if (btrfs_init_free_space_ctl(cache, sectorsize)) {
 				ret = -ENOMEM;
 				break;
 			}
diff --git a/free-space-cache.c b/free-space-cache.c
index 8a77a32..5fb8ece 100644
--- a/free-space-cache.c
+++ b/free-space-cache.c
@@ -808,8 +808,6 @@ int btrfs_add_free_space(struct btrfs_free_space_ctl *ctl, u64 offset,
 	try_merge_free_space(ctl, info);
 
 	ret = link_free_space(ctl, info);
-	if (ret)
-
 	if (ret) {
 		printk(KERN_CRIT "btrfs: unable to add free space :%d\n", ret);
 		BUG_ON(ret == -EEXIST);
-- 
1.7.7.6

