Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55029 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751832AbdIRHVz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 03:21:55 -0400
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz
Subject: [PATCH v3 06/14] btrfs-progs: mkfs: Workaround BUG_ON caused by rootdir option
Date: Mon, 18 Sep 2017 16:21:31 +0900
Message-Id: <20170918072139.6300-7-quwenruo.btrfs@gmx.com>
In-Reply-To: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
References: <20170918072139.6300-1-quwenruo.btrfs@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--rootdir option will start a transaction to fill the fs, however if
something goes wrong, from ENOSPC to lack of permission, we won't commit
transaction and cause BUG_ON trigger by uncommitted transaction:

------
extent buffer leak: start 29392896 len 16384
extent_io.c:579: free_extent_buffer: BUG_ON `eb->flags & EXTENT_DIRTY` triggered, value 1
------

The root fix is to introduce btrfs_abort_transaction() in btrfs-progs,
however in this particular case, we can workaround it by force
committing the transaction.

Since during mkfs, the magic of btrfs is set to an invalid one, without
setting fs_info->finalize_on_close() the fs is never able to be mounted.
So even we force to commit wrong transaction we won't screw up things
worse.

Signed-off-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
---
 mkfs/main.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 6561ac52..f78c24ce 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1025,6 +1025,18 @@ static int make_image(const char *source_dir, struct btrfs_root *root)
 		printf("Making image is completed.\n");
 	return 0;
 fail:
+	/*
+	 * XXX:
+	 * To avoid BUG_ON() triggered by uncommitted transaction,
+	 * here we must commit transaction before we have proper
+	 * btrfs_abort_transaction() in btrfs-progs.
+	 *
+	 * Don't worry, the magic number is not valid so the fs can't be
+	 * mounted by kernel even we commit the trans.
+	 * And we don't want to pollute the original error, so we ignore
+	 * the return value from btrfs_commit_transaction().
+	 */
+	btrfs_commit_transaction(trans, root);
 	while (!list_empty(&dir_head.list)) {
 		dir_entry = list_entry(dir_head.list.next,
 				       struct directory_name_entry, list);
-- 
2.14.1

