Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from prv3-mh.provo.novell.com ([137.65.250.26]:58204 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751466AbdJSFmA (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Thu, 19 Oct 2017 01:42:00 -0400
From: Qu Wenruo <wqu@suse.com>
To: linux-btrfs@vger.kernel.org
Cc: dsterba@suse.cz, nborisov@suse.com
Subject: [PATCH v2 4/6] btrfs-progs: mkfs: Error out gracefully for --rootdir
Date: Thu, 19 Oct 2017 13:41:36 +0800
Message-Id: <20171019054138.13965-5-wqu@suse.com>
In-Reply-To: <20171019054138.13965-1-wqu@suse.com>
References: <20171019054138.13965-1-wqu@suse.com>
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

Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
---
 mkfs/main.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mkfs/main.c b/mkfs/main.c
index 60250c011ac3..358a046f1cf2 100644
--- a/mkfs/main.c
+++ b/mkfs/main.c
@@ -1073,6 +1073,19 @@ static int make_image(const char *source_dir, struct btrfs_root *root)
 		printf("Making image is completed.\n");
 	return 0;
 fail:
+	/*
+	 * Since we don't have btrfs_abort_transaction() yet, uncommitted trans
+	 * will trigger a BUG_ON().
+	 *
+	 * However before mkfs is fully finished, the magic number is invalid,
+	 * so even we commit transaction here, the fs still can't be mounted.
+	 *
+	 * To do a graceful error out, here we commit transaction as a
+	 * workaround.
+	 * Since we have already hit some problem, the return value doesn't
+	 * matter now.
+	 */
+	btrfs_commit_transaction(trans, root);
 	while (!list_empty(&dir_head.list)) {
 		dir_entry = list_entry(dir_head.list.next,
 				       struct directory_name_entry, list);
-- 
2.14.2

