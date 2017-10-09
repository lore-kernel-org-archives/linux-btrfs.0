Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51681 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752206AbdJIPWt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Oct 2017 11:22:49 -0400
From: David Sterba <dsterba@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: enadolski@suse.de, bo.li.liu@oracle.com, David Sterba <dsterba@suse.com>
Subject: [PATCH v2 1/3] btrfs: scrub: get rid of sector_t
Date: Mon,  9 Oct 2017 17:21:04 +0200
Message-Id: <a00bc109d714ac3c71145032da1e21d2b55fef35.1507562199.git.dsterba@suse.com>
In-Reply-To: <cover.1507562199.git.dsterba@suse.com>
References: <cover.1507562199.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The use of sector_t is not necessry, it's just for a warning.  Switch to
u64 and rename the variable and use byte units instead of 512b, ie.
dropping the >> 9 shifts.  The messages are adjusted as well.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
---
 fs/btrfs/scrub.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e3f6c49e5c4d..cd1b791d9706 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -231,7 +231,7 @@ struct scrub_warning {
 	struct btrfs_path	*path;
 	u64			extent_item_size;
 	const char		*errstr;
-	sector_t		sector;
+	u64			physical;
 	u64			logical;
 	struct btrfs_device	*dev;
 };
@@ -797,10 +797,10 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 	 */
 	for (i = 0; i < ipath->fspath->elem_cnt; ++i)
 		btrfs_warn_in_rcu(fs_info,
-				  "%s at logical %llu on dev %s, sector %llu, root %llu, inode %llu, offset %llu, length %llu, links %u (path: %s)",
+"%s at logical %llu on dev %s, physical %llu, root %llu, inode %llu, offset %llu, length %llu, links %u (path: %s)",
 				  swarn->errstr, swarn->logical,
 				  rcu_str_deref(swarn->dev->name),
-				  (unsigned long long)swarn->sector,
+				  swarn->physical,
 				  root, inum, offset,
 				  min(isize - offset, (u64)PAGE_SIZE), nlink,
 				  (char *)(unsigned long)ipath->fspath->val[i]);
@@ -810,10 +810,10 @@ static int scrub_print_warning_inode(u64 inum, u64 offset, u64 root,
 
 err:
 	btrfs_warn_in_rcu(fs_info,
-			  "%s at logical %llu on dev %s, sector %llu, root %llu, inode %llu, offset %llu: path resolving failed with ret=%d",
+			  "%s at logical %llu on dev %s, physical %llu, root %llu, inode %llu, offset %llu: path resolving failed with ret=%d",
 			  swarn->errstr, swarn->logical,
 			  rcu_str_deref(swarn->dev->name),
-			  (unsigned long long)swarn->sector,
+			  swarn->physical,
 			  root, inum, offset, ret);
 
 	free_ipath(ipath);
@@ -845,7 +845,7 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 	if (!path)
 		return;
 
-	swarn.sector = (sblock->pagev[0]->physical) >> 9;
+	swarn.physical = sblock->pagev[0]->physical;
 	swarn.logical = sblock->pagev[0]->logical;
 	swarn.errstr = errstr;
 	swarn.dev = NULL;
@@ -868,10 +868,10 @@ static void scrub_print_warning(const char *errstr, struct scrub_block *sblock)
 						      item_size, &ref_root,
 						      &ref_level);
 			btrfs_warn_in_rcu(fs_info,
-				"%s at logical %llu on dev %s, sector %llu: metadata %s (level %d) in tree %llu",
+"%s at logical %llu on dev %s, physical %llu: metadata %s (level %d) in tree %llu",
 				errstr, swarn.logical,
 				rcu_str_deref(dev->name),
-				(unsigned long long)swarn.sector,
+				swarn.physical,
 				ref_level ? "node" : "leaf",
 				ret < 0 ? -1 : ref_level,
 				ret < 0 ? -1 : ref_root);
-- 
2.14.0

