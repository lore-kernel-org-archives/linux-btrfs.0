Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:45597 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965608Ab3FTQdu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 12:33:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id EAF0D9A06B8
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 10:33:49 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx2.fusionio.com with ESMTP id 65DtDGzFMVyesRi1 (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 10:33:49 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
To: <linux-btrfs@vger.kernel.org>
Subject: [PATCH] Btrfs: stop using try_to_writeback_inodes_sb_nr to flush delalloc
Date: Thu, 20 Jun 2013 12:33:46 -0400
Message-ID: <1371746026-10816-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

try_to_writeback_inodes_sb_nr returns 1 if writeback is already underway, which
is completely fraking useless for us as we need to make sure pages are actually
written before we go and check if there are ordered extents.  So replace this
with an open coding of try_to_writeback_inodes_sb_nr minus the writeback
underway check so that we are sure to actually have flushed some dirty pages out
and will have ordered extents to use.  With this patch xfstests generic/273 now
passes.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
 fs/btrfs/extent-tree.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 806801a..16da187 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3941,12 +3941,11 @@ static void btrfs_writeback_inodes_sb_nr(struct btrfs_root *root,
 					 unsigned long nr_pages)
 {
 	struct super_block *sb = root->fs_info->sb;
-	int started;
 
-	/* If we can not start writeback, just sync all the delalloc file. */
-	started = try_to_writeback_inodes_sb_nr(sb, nr_pages,
-						      WB_REASON_FS_FREE_SPACE);
-	if (!started) {
+	if (down_read_trylock(&sb->s_umount)) {
+		writeback_inodes_sb_nr(sb, nr_pages, WB_REASON_FS_FREE_SPACE);
+		up_read(&sb->s_umount);
+	} else {
 		/*
 		 * We needn't worry the filesystem going from r/w to r/o though
 		 * we don't acquire ->s_umount mutex, because the filesystem
-- 
1.7.7.6

